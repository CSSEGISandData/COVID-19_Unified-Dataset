#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
ERA5 reanalysis downloaded via a CDS request with script downloadERA5.py down-
loads large, yearly files (or, in the case of the current year, a file with 
data up to five days prior to the current date). This script creates individual 
files for each variable and each calendar day comprised of daily mean values 
for all variables besides temperature; for temperature, daily maximum, mean, 
and minimum values are calculated. Daily summed precipitation is calculated. 

Reanalysis data from the current year are handled differently, as data from 
the current year are a mixture of ERA5 and ERA5T data (see 
https://confluence.ecmwf.int/display/CUSF/ERA5+CDS+requests+which+return+a+
mixture+of+ERA5+and+ERA5T+data)

:Authors:
    Gaige Hunter Kerr, <gaigekerr@gwu.edu>
"""
import numpy as np
import pandas as pd
from netCDF4 import Dataset, date2num
import cftime
from datetime import datetime
from scipy import stats
# Note that if the year is given as "2020a", this will process the static
# Jan-Aug unchanging part of the data record, while "2020" will process
# the latest months. 
year = 2022

# ERA5 variables (n.b., each individual .nc file should contain hourly data 
# corresponding to individual variables in list VARS)
DDIR = '/mnt/local_drive/gaige/'
DDIR_OUT = '/mnt/local_drive/gaige/era5-parsed/%d/'%year

# Variables as they appear in file names
FSTR = ['10m_u_component_of_wind',
    '10m_v_component_of_wind',
    '2m_dewpoint_temperature', 
    '2m_temperature',
    'potential_evaporation',
    'surface_pressure',
    'surface_solar_radiation_downwards',
    'total_precipitation',
    'volumetric_soil_water_layer_1',
    'volumetric_soil_water_layer_2',
    'volumetric_soil_water_layer_3',
    'volumetric_soil_water_layer_4',
    'surface_latent_heat_flux']

# Variables as they appear as netCDF variable names. Note: the order must 
# exactly match order in FSTR
VAR = ['u10', 
    'v10',
    'd2m',
    't2m',
    'pev',
    'sp',
    'ssrd',
    'tp',
    'swvl1',
    'swvl2',
    'swvl3',
    'swvl4',
    'slhf']
# Loop through variables/files
for fstri in FSTR:
    var = VAR[np.where(np.array(FSTR)==fstri)[0][0]]
    infile = Dataset(DDIR+'era5-hourly-%s-%d.nc'%(fstri,year), 'r')
    tname = 'time'
    nctime = infile.variables[tname][:] # get values
    t_unit = infile.variables[tname].units # get unit (i.e., hours since...)
    try:
        t_cal = infile.variables[tname].calendar
    except AttributeError: # Attribute doesn't exist
        t_cal = u'gregorian' # or standard
    datevar = []
    datevar.append(cftime.num2pydate(nctime, units=t_unit, calendar=t_cal))
    datevar = np.array(datevar)[0]
    # Create date range that spans the time dimension
    dayrange = pd.date_range(datevar[0], datevar[-1])
    datevar = [x.date() for x in datevar]
    # Loop through days and find indices corresponding to each day
    for day in dayrange:
        day = day.date()
        print(var, day)
        whereday = np.where(np.array(datevar)==day)[0]
        # Only form daily average/min or max files when all 24 hourly 
        # timesteps are available - note that this should only trip on 
        # the final day of the current year, depending on when data from CDS
        # was pulled
        if whereday.shape[0] != 24:
            print('Only %d timesteps for %s available...skipping!'%(
                whereday.shape[0],day))
            continue
        # Select variable of interest and hours in day 
        try:
            vararr = infile.variables[var][whereday]
            vararr = vararr.filled(np.nan)
            # This is kludgey, but if expver is present as a dimension (rather
            # than the variable name suffix that the except KeyError lines 
            # address, then figure out where the array is equal to the offset
            # and replace with NaNs). Note that this method is preferred to 
            # doing a global "search-and-find" for the offset value, because
            # there are some values of the array that equal the offset value 
            # that represent real values of the variable
            if vararr.shape[1] == 2:
                # Loop through every timestamp
                for x in np.arange(0,len(vararr),1):
                    # Find which dimension only has one unique value (i.e., 
                    # only the offset)
                    dim1 = vararr[x][0]
                    dim2 = vararr[x][1]
                    nunique1 = np.unique(dim1)
                    nunique2 = np.unique(dim2)
                    # Replace with NaN
                    if nunique1.shape[0]==1:
                        vararr[x][0] = np.nan
                    if nunique2.shape[0]==1: 
                        vararr[x][1] = np.nan
                vararr = np.nanmean(vararr, axis=1)
        except KeyError:
            vararr_0001 = infile.variables[var+'_0001'][whereday]
            vararr_0005 = infile.variables[var+'_0005'][whereday]
            # Fill fill values with np.nan
            vararr_0001 = vararr_0001.filled(np.nan)
            vararr_0005 = vararr_0005.filled(np.nan)            
            # Stack exper arrays and take mean along exper axis
            vararr = np.stack([vararr_0001, vararr_0005])
            vararr = np.nanmean(vararr, axis=0)
        # # # # Temperature
        if var == 't2m':
            # For daily mean temperature
            vararr_avg = np.nanmean(vararr,axis=0)
            with Dataset(DDIR+'era5-hourly-%s-%d.nc'%(fstri,year), 'r') as \
                src, Dataset(DDIR_OUT+'ERA5_%s_%savg.nc'%(
                day.strftime('%Y%m%d'),var), 'w') as dst:
                for name, dimension in src.dimensions.items():
                    if (name=='time') or (name=='expver'):
                        continue
                    dst.createDimension(name, len(dimension) if not 
                        dimension.isunlimited() else None)
                dst.createDimension('time', 1)
                for name, variable in src.variables.items():
                    if (var in name) or (name=='expver') or (name=='time'):
                        continue
                    x = dst.createVariable(name, variable.datatype, 
                        variable.dimensions)
                    dst.variables[name][:] = src.variables[name][:]
                dst.createVariable(var+'avg', np.float32, 
                    ('time','latitude','longitude'))        
                dst.variables[var+'avg'][:] = vararr_avg
                time_unit_out = 'seconds since %s 00:00:00'%day.strftime('%Y-%m-%d')
                dateo = dst.createVariable('time', np.float64, ('time',))
                dateo[:] = date2num(datetime.combine(day, datetime.min.time()), 
                    units=time_unit_out)
                dateo.setncattr('unit',time_unit_out)                    
            # For daily maximum temperature 
            vararr_max = np.nanmax(vararr,axis=0)
            with Dataset(DDIR+'era5-hourly-%s-%d.nc'%(fstri,year), 'r') as \
                src, Dataset(DDIR_OUT+'ERA5_%s_%smax.nc'%(
                day.strftime('%Y%m%d'),var), 'w') as dst:
                for name, dimension in src.dimensions.items():
                    if (name=='time') or (name=='expver'):
                        continue
                    dst.createDimension(name, len(dimension) if not 
                        dimension.isunlimited() else None)
                dst.createDimension('time', 1)
                for name, variable in src.variables.items():
                    if (var in name) or (name=='expver') or (name=='time'):
                        continue
                    x = dst.createVariable(name, variable.datatype, 
                        variable.dimensions)
                    dst.variables[name][:] = src.variables[name][:]
                dst.createVariable(var+'max', np.float32, 
                    ('time','latitude','longitude'))        
                dst.variables[var+'max'][:] = vararr_max
                time_unit_out = 'seconds since %s 00:00:00'%day.strftime('%Y-%m-%d')
                dateo = dst.createVariable('time', np.float64, ('time',))
                dateo[:] = date2num(datetime.combine(day, datetime.min.time()), 
                    units=time_unit_out)
                dateo.setncattr('unit',time_unit_out)                
            # For daily minimum temperature       
            vararr_min = np.nanmin(vararr,axis=0)                      
            with Dataset(DDIR+'era5-hourly-%s-%d.nc'%(fstri,year), 'r') as \
                src, Dataset(DDIR_OUT+'ERA5_%s_%smin.nc'%(
                day.strftime('%Y%m%d'),var), 'w') as dst:
                for name, dimension in src.dimensions.items():
                    if (name=='time') or (name=='expver'):
                        continue
                    dst.createDimension(name, len(dimension) if not 
                        dimension.isunlimited() else None)
                dst.createDimension('time', 1)
                for name, variable in src.variables.items():
                    if (var in name) or (name=='expver') or (name=='time'):
                        continue
                    x = dst.createVariable(name, variable.datatype, 
                        variable.dimensions)
                    dst.variables[name][:] = src.variables[name][:]
                dst.createVariable(var+'min', np.float32, 
                    ('time','latitude','longitude'))        
                dst.variables[var+'min'][:] = vararr_min
                time_unit_out = 'seconds since %s 00:00:00'%day.strftime('%Y-%m-%d')
                dateo = dst.createVariable('time', np.float64, ('time',))
                dateo[:] = date2num(datetime.combine(day, datetime.min.time()), 
                    units=time_unit_out)
                dateo.setncattr('unit',time_unit_out)
        # # # # Precipitation
        if var == 'tp':       
            # For daily total precipitation
            vararr_sum = np.nansum(vararr,axis=0)
            with Dataset(DDIR+'era5-hourly-%s-%d.nc'%(fstri,year), 'r') as \
                src, Dataset(DDIR_OUT+'ERA5_%s_%s.nc'%(
                day.strftime('%Y%m%d'),var), 'w') as dst:
                for name, dimension in src.dimensions.items():
                    if (name=='time') or (name=='expver'):
                        continue
                    dst.createDimension(name, len(dimension) if not 
                        dimension.isunlimited() else None)
                dst.createDimension('time', 1)
                for name, variable in src.variables.items():
                    if (var in name) or (name=='expver') or (name=='time'):
                        continue
                    x = dst.createVariable(name, variable.datatype, 
                        variable.dimensions)
                    dst.variables[name][:] = src.variables[name][:]
                dst.createVariable(var, np.float32, 
                    ('time','latitude','longitude'))        
                dst.variables[var][:] = vararr_sum
                time_unit_out = 'seconds since %s 00:00:00'%day.strftime('%Y-%m-%d')
                dateo = dst.createVariable('time', np.float64, ('time',))
                dateo[:] = date2num(datetime.combine(day, datetime.min.time()), 
                    units=time_unit_out)
                dateo.setncattr('unit',time_unit_out)  
        # # # # For variables OTHER THAN temperature and precipitation, 
        # calculate simple means of hourly values
        else: 
            vararr = np.nanmean(vararr,axis=0)
            with Dataset(DDIR+'era5-hourly-%s-%d.nc'%(fstri,year), 'r') as \
                src, Dataset(DDIR_OUT+'ERA5_%s_%s.nc'%(
                day.strftime('%Y%m%d'),var), 'w') as dst:
                for name, dimension in src.dimensions.items():
                    if (name=='time') or (name=='expver'):
                        continue
                    dst.createDimension(name, len(dimension) if not 
                        dimension.isunlimited() else None)
                dst.createDimension('time', 1)
                for name, variable in src.variables.items():
                    if (var in name) or (name=='expver') or (name=='time'):
                        continue
                    x = dst.createVariable(name, variable.datatype, 
                        variable.dimensions)
                    dst.variables[name][:] = src.variables[name][:]
                dst.createVariable(var, np.float32, ('time', 'latitude', 'longitude'))        
                dst.variables[var][:] = vararr
                # Write timestamps to netCDF file
                time_unit_out = 'seconds since %s 00:00:00'%day.strftime('%Y-%m-%d')
                dateo = dst.createVariable('time', np.float64, ('time',))
                dateo[:] = date2num(datetime.combine(day, datetime.min.time()), 
                    units=time_unit_out)
                dateo.setncattr('unit',time_unit_out)