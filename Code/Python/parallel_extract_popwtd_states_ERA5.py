'''
Note: Use daily ERA5 files processed using Gaige Kerr's script
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
smon = 6
sday = 1

emon = 6
eday = 30

vars = ['d2m','pev','sp','ssrd','swvl1','swvl2','swvl3','swvl4','t2mmax','t2mmin','t2mavg','tp','u10','v10','slhf']
# dewpoint temp, evap, potent evap, surf pres, surface solar down, vol soil wat content, tmax, tmin, tavg, tot prec, uwind, vwind, latent heat flux 

nvar = len(vars)
STATE = pd.read_csv("ERA5_Statecodes.csv")  
nSTATE = len(STATE)

droot ="/mnt/redwood/local_drive/gaige/era5-parsed/"
geodir = "./"           	     # directory that contains STATE netcdf file
diro = "./ERA5tables/STATES/"	             # output directory
diro1 = diro+"/popwtd/"+str(yr)+"/"
diro2 = diro+"/notpopwtd/"+str(yr)+"/"

resol = 0.25			     # resolution and extent of STATE map (could be read from netcdf file,
minlat = -90		     # but is here for reference and ease.
maxlat = 90
minlon = -180
maxlon =179.75

dimy = int(math.ceil((maxlat - minlat) / resol + 1))  
dimx = int(math.ceil((maxlon - minlon) / resol + 1))   

lats = np.linspace(maxlat,minlat,dimy)		# creating arrays; could be read from STATE map if preferred.
lons = np.linspace(minlon,maxlon,dimx)
print(dimy)
print(dimx)

# add land mask

landmaskfile = Nio.open_file(os.path.join(geodir,"land_binary_mask.nc"),"r")
lsm = np.array(landmaskfile.variables["lsm"])
landsea = np.where(lsm <= 0.5, np.nan, 1)

# add STATE mask file

STATEfile = Nio.open_file(os.path.join(geodir,"US_STATES_qdeg_ERA5.nc"),"r")
cmaskf = STATEfile.variables["state"]
cmaskf = cmaskf[:,:]                   # no flip for ERA5
cmask = cmaskf.astype(int)

# add population raster

popfile = Nio.open_file(os.path.join(geodir,"GPW/gpw_v4_pop2020_adj_align.nc"),"r")
popdata = popfile.variables["population"]
pop = xr.DataArray(popdata,coords=[lats,lons],dims=['lat','lon'])

#  cmask@_FillValue = -9999
print(np.min(cmask))
print(np.max(cmask))

print(STATEfile.variables.keys())

# number of days

ndaysx = date(yr,emon,eday)-date(yr,smon,sday)
ndays = ndaysx.days+1
print(ndays)
dates = pd.date_range(date(yr,smon,sday),date(yr,emon,eday)).strftime('%Y-%m-%d').tolist()
print(dates)
readdates = pd.date_range(date(yr,smon,sday),date(yr,emon,eday)).strftime('%Y%m%d').tolist()

def hydromet(met):

#  for v in range(0,nvar):
      vardata = np.empty((ndays,dimy,dimx),dtype=float)
      vardata[:] = np.NaN
      var = xr.DataArray(vardata,coords=[dates,lats,lons],dims=['date','lat','lon'])
      var.coords['county'] = (('lat','lon'),cmask)
      countyseries = np.empty((nSTATE,ndays),dtype=float)    
      countyseries[:] = np.NaN
      countyserieswtd = np.empty((nSTATE,ndays),dtype=float)    
      countyserieswtd[:] = np.NaN

      diri=droot+"/"+str(yr)+"/"
      diri2 = diri+"latest/"
      for d in range(0,ndays): 
        fname = diri+"ERA5_"+readdates[d]+"_"+met+".nc"
        fname2 = diri2+"ERA5_"+readdates[d]+"_"+met+".nc"	
        if(os.path.isfile(fname)): 
            f = Nio.open_file(fname,"r") 
            tmpvar = np.array(f.variables[met])*landsea
            var[d,:,0:719] = tmpvar[0,:,720:1439]
            var[d,:,720:1439] = tmpvar[0,:,0:719]
            del tmpvar    
        if(os.path.isfile(fname2)): 
            f = Nio.open_file(fname2,"r")
            tmpvar = np.array(f.variables[met])*landsea
            var[d,:,0:719] = tmpvar[0,:,720:1439]
            var[d,:,720:1439] = tmpvar[0,:,0:719]
            del tmpvar    

      for c in range(0,nSTATE): 
          thisSTATE = STATE.iloc[c,0]
          maskedvar = var.where(var.county == thisSTATE)
          print(thisSTATE)
          countyseries[c,:] = np.nanmean(maskedvar,axis=(1,2))
          maskedpop = pop.where(var.county == thisSTATE)
          maskedpop = maskedpop.where(maskedpop > -1.0)	 
          maskedpop = np.ma.array(maskedpop,mask=np.isnan(maskedvar[1,:,:]))
          sumpop = np.nansum(maskedpop)	   
          wtmaskedvar = maskedvar * np.broadcast_to(maskedpop,(ndays,dimy,dimx)) / sumpop 	
          if sumpop > 0.0:
            countyserieswtd[c,:] = np.nansum(wtmaskedvar,axis=(1,2))
            print("weighting")    
          print(STATE.iloc[c,0])
          #print(np.nanmean(maskedvar))	      

      notwtd= pd.DataFrame(data=countyseries,columns=dates)
      popwtd= pd.DataFrame(data=countyserieswtd,columns=dates)
      # UNCOMMENT the next two lines if this is the beginning of a new record, so that row labels are included
      #notwtd.insert(0,"STATE",STATE,True)
      #popwtd.insert(0,"STATE",STATE,True)

      sdatename = date(yr,smon,sday).strftime('%Y%m%d')
      edatename = date(yr,emon,eday).strftime('%Y%m%d')

      popwtd.to_csv(os.path.join(diro1,"ERA5_US_STATE_popwtd_"+met+"_"+sdatename+"_"+edatename+".csv"),index=False)#,float_format=outformat)
      notwtd.to_csv(os.path.join(diro2,"ERA5_US_STATE_notpopwtd_"+met+"_"+sdatename+"_"+edatename+".csv"),index=False)
      # UNCOMMENT the next two lines if this is the beginning of a new record, so that row labels are included
     # popwtd.to_csv(os.path.join(diro1,"ERA5_US_STATE_popwtd_"+met+"_"+str(yr)+".csv"),index=False)#,float_format=outformat)
     # notwtd.to_csv(os.path.join(diro2,"ERA5_US_STATE_notpopwtd_"+met+"_"+str(yr)+".csv"),index=False) 
      del vardata
      del var
      del countyseries
      del countyserieswtd      

if __name__ == '__main__':
    with Pool(processes=5) as pool:
        pool.map(hydromet, vars)
