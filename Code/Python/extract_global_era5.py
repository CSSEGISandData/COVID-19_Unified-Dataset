'''
Note: Use daily ERA5 files processed by Gaige Kerr
'''

import numpy as np
import xarray as xr
import pandas as pd
import os, fnmatch
import Nio
import Ngl
import math
from datetime import date,timedelta
from multiprocessing import Pool

# Input information

yr = 2022
smon = 6 #1
sday = 1

emon = 6
eday = 30

vars = ['d2m','pev','sp','ssrd','swvl1','swvl2','swvl3','swvl4','t2mmax','t2mmin','t2mavg','tp','u10','v10','slhf']
# dewpoint temp, evap, potent evap, surf pres, surface solar down, vol soil wat content, tmax, tmin, tavg, tot prec, uwind, vwind, latent heat flux 

nvar = len(vars)
LUT = pd.read_csv("COVID-19_LUT.csv")
A0 = LUT.loc[LUT['Admin1'].isnull()]
#nGADM = A0.shape[0]
A0codes = A0['ISO1_3C']
A0lats = A0['Latitude']
A0lons = A0['Longitude']

# info from the mask
GADMinfo = pd.read_csv("GPW/GPW_countrycodes.csv")  
GADMvals = GADMinfo['CIESINCODE']
GADMcodes = GADMinfo['ISOCODE']
nGADM = len(GADMvals)

droot ="/mnt/redwood/local_drive/gaige/era5-parsed/"
geodir = "./"           	     # directory that contains FIPS netcdf file
diro = "./ERA5tables/CIESIN/"	             # output directory

resol = 0.25			     # resolution and extent of FIPS map (could be read from netcdf file,
minlat = -90		             # but is here for reference and ease.
maxlat = 90
minlon = -180
maxlon =179.75

dimy = int(math.ceil((maxlat - minlat) / resol + 1))  
dimx = int(math.ceil((maxlon - minlon) / resol + 1))   

lats = np.linspace(maxlat,minlat,dimy)		# creating arrays; could be read from FIPS map if preferred.
lons = np.linspace(minlon,maxlon,dimx)
print(dimy)
print(dimx)

# add land mask

landmaskfile = Nio.open_file(os.path.join(geodir,"land_binary_mask.nc"),"r")
lsm = np.array(landmaskfile.variables["lsm"])
landsea = np.where(lsm <= 0.5, np.nan, 1)


# add GADM mask file

gadmfile = Nio.open_file(os.path.join(geodir,"GPW/gpw_v4_nat_id_CIESINCODE.nc"),"r")
cmaskf = gadmfile.variables["CIESINCODE"]
cmaskf = cmaskf[:,:]                  
cmask = cmaskf.astype(int)

# add population raster

popfile = Nio.open_file(os.path.join(geodir,"GPW/gpw_v4_pop2020_adj_align.nc"),"r")
popdata = popfile.variables["population"]
pop = xr.DataArray(popdata,coords=[lats,lons],dims=['lat','lon'])

print(np.min(popdata))
print(np.max(popdata))

print(gadmfile.variables.keys())

##########

# number of days

ndaysx = date(yr,emon,eday)-date(yr,smon,sday)
ndays = ndaysx.days+1
print(ndays)
dates = pd.date_range(date(yr,smon,sday),date(yr,emon,eday)).strftime('%Y-%m-%d').tolist()
print(dates)

#----plot resources-----
# I just have this to check that the mask looks right.

res = Ngl.Resources()
wks = Ngl.open_wks("ncgm",diro+"CIESINmap",res)
res.cnFillPalette         = "BlGrYeOrReVi200"

res.nglFrame = True
res.nglDraw = True

res.mpLimitMode = "LatLon"
res.mpMinLatF = np.min(lats)
res.mpMaxLatF = np.max(lats)
res.mpMinLonF = np.min(lons)
res.mpMaxLonF = np.max(lons)
res.mpGridAndLimbOn = False

res.cnFillOn = True
res.cnLinesOn = False
res.cnLineLabelsOn = False
res.cnInfoLabelOn = False
res.cnRasterModeOn = True

res.sfXArray        =  lons
res.sfYArray        =  lats

plot = Ngl.contour_map(wks,cmask,res)

# perform analysis

def hydromet(met):
    vardata = np.empty((ndays,dimy,dimx),dtype=float)
    vardata[:] = np.NaN
    var = xr.DataArray(vardata,coords=[dates,lats,lons],dims=['date','lat','lon'])
    var.coords['GADM_0'] = (('lat','lon'),cmask)
    gadmseries = np.empty((nGADM,ndays),dtype=float)    
    gadmseries[:] = np.NaN
    gadmnotwtd = np.empty((nGADM,ndays),dtype=float)    
    gadmnotwtd[:] = np.NaN
    
    diri=droot+"/"+str(yr)+"/"
    flist = fnmatch.filter(os.listdir(diri), 'ERA5_*_%s.nc'%met)
    flist = [diri+x for x in flist]
    flist.sort()    
    nfile = len(flist) # assumes that missing files are at the end of the record
    for d in range(0,ndays):
      if d < nfile:	  # assumes that missing files are at the end of the record
          f = Nio.open_file(flist[d],"r")
          tmpvar = np.array(f.variables[met])*landsea
          var[d,:,0:720] = tmpvar[0,:,720:1440]
          var[d,:,720:1440] = tmpvar[0,:,0:720]
          del tmpvar

    for c in range(0,nGADM):

        thisGADM = GADMvals.iloc[c]
        print(thisGADM)
        maskedvar = var.where(var.GADM_0 == thisGADM)
        maskedpop = pop.where(var.GADM_0 == thisGADM)
        maskedpop = maskedpop.where(maskedpop > -1.0)
#        maskedpop = maskedpop.where(maskedvar[1,:,:] > -750.0)
        maskedpop = np.ma.array(maskedpop,mask=np.isnan(maskedvar[1,:,:]))
        sumpop = np.nansum(maskedpop)
        wtmaskedvar = maskedvar * np.broadcast_to(maskedpop,(ndays,dimy,dimx)) / sumpop 	
        if sumpop > 0.0:
          gadmseries[c,:] = np.nansum(wtmaskedvar,axis=(1,2))
        gadmnotwtd[c,:] = np.nanmean(maskedvar,axis=(1,2))

    wtd = pd.DataFrame(data=gadmseries,columns=dates)
    notwtd = pd.DataFrame(data=gadmnotwtd,columns=dates)
    # UNCOMMENT the next two lines if this is the beginning of a new record, so that row labels are included
    #wtd.insert(0,"NUTS",GADMcodes,True)
    #notwtd.insert(0,"NUTS",GADMcodes,True)
    if emon < 10:
        monname = "0"+str(emon)
    else:
        monname = str(emon)
    if eday < 10:
        dayname = "0"+str(eday)
    else:	      
        dayname = str(eday)

    sdatename = date(yr,smon,sday).strftime('%Y%m%d')
    edatename = date(yr,emon,eday).strftime('%Y%m%d')
          		
    wtd.to_csv(os.path.join(diro,"ERA5_CIESIN_national_popwtd_"+met+"_"+sdatename+"_"+edatename+".csv"),index=False)#,float_format=outformat)
    notwtd.to_csv(os.path.join(diro,"ERA5_CIESIN_national_notpopwtd_"+met+"_"+sdatename+"_"+edatename+".csv"),index=False)#,float_format=outformat)
    # UNCOMMENT the next two lines if this is the beginning of a new record, so that row labels are included
  #  wtd.to_csv(os.path.join(diro,"ERA5_CIESIN_national_popwtd_"+met+"_"+str(yr)+".csv"),index=False)#,float_format=outformat)
  #  notwtd.to_csv(os.path.join(diro,"ERA5_CIESIN_national_notpopwtd_"+met+"_"+str(yr)+".csv"),index=False)#,float_format=outformat)
    del vardata
    del var
    del gadmseries
    del gadmnotwtd

if __name__ == '__main__':
    with Pool(processes=5) as pool:  
        pool.map(hydromet, vars)
