'''
Obtain the hourly NLDAS variables of interest using wget
Note: preprocess NLDAS data to get daily averages (or min and max for TMP) and stack them. I use cdo commands for this, but any approach that
yields a standard netcdf file with time, latitude, and longitude dimensions should work. Preprocessing steps:
Obtain the hourly NLDAS variables of interest using wget
'''

import numpy as np
import xarray as xr
import pandas as pd
import os
import Nio
import Ngl
import math
from datetime import date,timedelta
from multiprocessing import Pool

# Input information

syr = 2022
smon = 1
sday = 1

eyr =2022
emon = 7
eday = 31

vars = ["RH","TMP","TMP_max","TMP_min","SPFH","PRES","UGRD","VGRD","DLWRF",
                     "APCP","DSWRF","LHTFL","SOILM","RZSM","MSTAV","PEVPR"]

nvar = len(vars)
FIPS = pd.read_csv("newFIPSlist.csv")  # this is the list from Lauren's group, so we want to match it exactly
nFIPS = len(FIPS)

diri ="/mnt/redwood/local_drive/COVID/NLDAS/daily/"
geodir = "./"           	     # directory that contains FIPS netcdf file
diro = "./NLDAStables/"	             # output directory

resol = 0.125			     # resolution and extent of FIPS map (could be read from netcdf file,
minlat = 25.0625		     # but is here for reference and ease.
maxlat = 52.9375
minlon = -124.9375
maxlon = -67.0625

dimy = int(math.ceil((maxlat - minlat) / resol + 1))  
dimx = int(math.ceil((maxlon - minlon) / resol + 1))   

lats = np.linspace(minlat,maxlat,dimy)		# creating arrays; could be read from FIPS map if preferred.
lons = np.linspace(minlon,maxlon,dimx)
print(dimy)
print(dimx)

# add FIPS mask file

fipsfile = Nio.open_file(os.path.join(geodir,"countyFIPS_125.nc"),"r")
cmaskf = fipsfile.variables["FIPS"]
cmaskf = cmaskf[::-1,:]                   # flipping on lat b/c of inconsistent coordinate conventions
cmask = cmaskf.astype(int)

print(np.min(cmask))
print(np.max(cmask))

# add population raster

popfile = Nio.open_file(os.path.join(geodir,"GPW/NLDASpopulation_2015UN.nc"),"r")
popdata = popfile.variables["population"]
popdata = popdata[::-1,:]
pop = xr.DataArray(popdata,coords=[lats,lons],dims=['lat','lon'])

print(fipsfile.variables.keys())

# get centroid lat and lon for small counties not resolved at NLDAS scale
# NOTE: this is a workaround for a computational efficiency in this approach; by resampling the FIPS map
# to create a raster at NLDAS resolution, I have lost small counties, and they need to be captured as points.
			      
FIPScoords = pd.read_csv("newFIPS_lat_lon.csv") # from the CSSE database for the COVID dashboard
##########

# number of days

ndaysx = date(eyr,emon,eday)-date(syr,smon,sday)
ndays = ndaysx.days+1
print(ndays)
dates = pd.date_range(date(syr,smon,sday),date(eyr,emon,eday)).strftime('%Y-%m-%d').tolist()
print(dates)

# perform analysis

countyseries = np.empty((nFIPS,ndays),dtype=float) 
countyseries[:] = np.NaN
countyserieswtd = np.empty((nFIPS,ndays),dtype=float) 
countyserieswtd[:] = np.NaN   

fname = os.path.join(diri,"NLDASALL.nc4")  # just did a cdo -mergetime on all NLDAS files in months of interest to create this file
f = Nio.open_file(fname,"r")


# calculate relative humidity
spfh = np.array(f.variables["SPFH"])
pres = np.array(f.variables["PRES"])
tmp = np.array(f.variables["TMP"])

esat = 611*np.exp(17.67*(tmp[:,0,:,:]-273.16)/(tmp[:,0,:,:]-29.65))
wsat = 0.622*esat/pres
RHall = 100*spfh[:,0,:,:]/wsat
RH = np.clip(RHall,a_min=0.0,a_max=100.0) 
    
def hydromet(met):

    vardata = np.zeros((ndays,dimy,dimx),dtype=float)
    var = xr.DataArray(vardata,coords=[dates,lats,lons],dims=['date','lat','lon'])
    var.coords['county'] = (('lat','lon'),cmask)
    if met =="RH":
      tmpvar = RH
    else:  
      tmpvar = f.variables[met]
    
    dimsize = tmpvar.shape
    dimnum = len(dimsize)
    print(met)
    #print(dimnum)
    
    if dimnum == 3:
       var[:,:,:] = tmpvar       
    elif met == "MSTAV":
       var[:,:,:] = tmpvar[:,1,:,:] # top 50 cm
    elif met == "SOILM":
       var[:,:,:] = tmpvar[:,3,:,:] # top 25 cm
    else:
       var[:,:,:] = tmpvar[:,0,:,:]   # simply take top level of the multilayer variables
    
    if(met) == "APCP":
       var = var*24             # convert precip from mm/hr to mm/day

    if met == "LHTFL" or met == "SOILM" or met == "RZSM" or met == "MSTAV" or met == "PEVPR":  #only do this for the Noah variables; there's a missing value confict and this was the fastest workaround
       for i in range(0,224):
          for j in range(0,464):
             checkvar = var[:,i,j]
             if np.nanmax(checkvar) > 10000000.:
                checkvar = np.nan
                var[:,i,j] = checkvar
    
    for c in range(0,nFIPS):
        thisfips = FIPS.iloc[c,0]
        maskedvar = var.where(var.county == FIPS.iloc[c,0])
        #print(FIPS.iloc[c,0])
        #print(np.nanmean(maskedvar))
        countyseries[c,:] = np.nanmean(maskedvar,axis=(1,2))
        maskedpop = pop.where(var.county == thisfips)
        maskedpop = maskedpop.where(maskedpop > -1.0)	 
        maskedpop = np.ma.array(maskedpop,mask=np.isnan(maskedvar[1,:,:]))
        sumpop = np.nansum(maskedpop)	   
        wtmaskedvar = maskedvar * np.broadcast_to(maskedpop,(ndays,dimy,dimx)) / sumpop 	
        if sumpop > 0.0:
          countyserieswtd[c,:] = np.nansum(wtmaskedvar,axis=(1,2))
          print("weighting")	
	# next, deal with the small counties
	
        if np.isnan(countyseries[c,1]):
            lt = (FIPScoords.loc[FIPScoords['FIPSval']==thisfips,'LAT'])
            ltv = lt.values
            print(ltv)
            ln = pd.to_numeric(FIPScoords.loc[FIPScoords['FIPSval']==thisfips,'LON'])
            lnv = ln.values
            if(pd.notna(ltv)):
                print(FIPScoords.loc[FIPScoords['FIPSval']==thisfips])
                latdiff = (abs(var['lat'] - ltv[0])).min()
                londiff = (abs(var['lon'] - lnv[0])).min()
                ltdv = latdiff.values
                lndv = londiff.values
                print(ltdv)
		
                if (abs(ltdv) < 1.0 and abs(lndv) < 1.0):    # don't let this grab distant points
                    latindex = (abs(var['lat'] - ltv)).argmin()
                    lonindex = (abs(var['lon'] - lnv)).argmin()
                    print("pointwise fill")
                    countyseries[c,:] = var[:,latindex,lonindex]
                    countyserieswtd[c,:] = var[:,latindex,lonindex]		    
                  
    notwtd= pd.DataFrame(data=countyseries,columns=dates)
    notwtd.insert(0,"FIPS",FIPS,True)
    popwtd= pd.DataFrame(data=countyserieswtd,columns=dates)
    popwtd.insert(0,"FIPS",FIPS,True)

    outformat = '%.6f'       
    
    notwtd.to_csv(os.path.join(diro,met+"_"+str(syr)+"_NLDAS2_notpopwtd_COUNTIES_US.csv"),index=False,float_format=outformat)
    popwtd.to_csv(os.path.join(diro,met+"_"+str(syr)+"_NLDAS2_popwtd_COUNTIES_US.csv"),index=False,float_format=outformat)

if __name__ == '__main__':
    with Pool(processes=4) as pool:
        pool.map(hydromet, vars)
