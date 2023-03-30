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
STATE = pd.read_csv("Statecodes.csv")  # this is the list of units from the COVID dashboard database
nSTATE = len(STATE)

diri ="/mnt/redwood/local_drive/COVID/NLDAS/daily/"
geodir = "./"           	     # directory that contains STATE netcdf file
diro = "./NLDAStables/"	             # output directory

resol = 0.125			     # resolution and extent of STATE map (could be read from netcdf file,
minlat = 25.0625		     # but is here for reference and ease.
maxlat = 52.9375
minlon = -124.9375
maxlon = -67.0625

dimy = int(math.ceil((maxlat - minlat) / resol + 1))  
dimx = int(math.ceil((maxlon - minlon) / resol + 1))   

lats = np.linspace(minlat,maxlat,dimy)		# creating arrays; could be read from STATE map if preferred.
lons = np.linspace(minlon,maxlon,dimx)
print(dimy)
print(dimx)

# add STATE mask file


STATEfile = Nio.open_file(os.path.join(geodir,"US_STATES_125.nc"),"r")
smaskf = STATEfile.variables["state"]
smaskf = smaskf[::-1,:]                   # flipping on lat b/c of inconsistent coordinate conventions
smask = smaskf.astype(int)

#  smask@_FillValue = -9999
print(np.min(smask))
print(np.max(smask))

# add population raster

popfile = Nio.open_file(os.path.join(geodir,"GPW/NLDASpopulation_2015UN.nc"),"r")
popdata = popfile.variables["population"]
popdata = popdata[::-1,:]
pop = xr.DataArray(popdata,coords=[lats,lons],dims=['lat','lon'])

print(STATEfile.variables.keys())

# number of days

ndaysx = date(eyr,emon,eday)-date(syr,smon,sday)
ndays = ndaysx.days+1
print(ndays)
dates = pd.date_range(date(syr,smon,sday),date(eyr,emon,eday)).strftime('%Y-%m-%d').tolist()
print(dates)

# perform analysis

stateseries = np.empty((nSTATE,ndays),dtype=float)   
stateseries[:] = np.NaN 
stateserieswtd = np.empty((nSTATE,ndays),dtype=float) 
stateserieswtd[:] = np.NaN

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
    var.coords['state'] = (('lat','lon'),smask)
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

    if met == "LHTFL" or met == "SOILM" or met == "RZSM" or met == "MSTAV" or met == "PEVPR":  #only do this for the Noah variables; there's a missing value confict and I haven't figured out the more efficient solution for this data type
       for i in range(0,224):
          for j in range(0,464):
             checkvar = var[:,i,j]
             if np.nanmax(checkvar) > 10000000.:
                checkvar = np.nan
                var[:,i,j] = checkvar
    
    for c in range(0,nSTATE):
        thisSTATE = STATE.iloc[c,0]
        maskedvar = var.where(var.state == thisSTATE)
        print(STATE.iloc[c,0])
        #print(np.nanmean(maskedvar))
        stateseries[c,:] = np.nanmean(maskedvar,axis=(1,2))
        maskedpop = pop.where(var.state == thisSTATE)
        print(np.nanmax(maskedpop))
        maskedpop = maskedpop.where(maskedpop > -1.0)	 
        maskedpop = np.ma.array(maskedpop,mask=np.isnan(maskedvar[1,:,:]))
        sumpop = np.nansum(maskedpop)	  
        print(sumpop)	 
        wtmaskedvar = maskedvar * np.broadcast_to(maskedpop,(ndays,dimy,dimx)) / sumpop 	
        if sumpop > 0.0:
          stateserieswtd[c,:] = np.nansum(wtmaskedvar,axis=(1,2))
          print("weighting")  
                  
    notwtd= pd.DataFrame(data=stateseries,columns=dates)
    notwtd.insert(0,"STATE",STATE,True)
    popwtd= pd.DataFrame(data=stateserieswtd,columns=dates)
    popwtd.insert(0,"STATE",STATE,True)
    
    outformat = '%.6f'       
    
    notwtd.to_csv(os.path.join(diro,met+"_"+str(syr)+"_NLDAS2_notpopwtd_STATES_US.csv"),index=False,float_format=outformat)
    popwtd.to_csv(os.path.join(diro,met+"_"+str(syr)+"_NLDAS2_popwtd_STATES_US.csv"),index=False,float_format=outformat)

if __name__ == '__main__':
    with Pool(processes=4) as pool:
        pool.map(hydromet, vars)
