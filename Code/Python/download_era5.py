#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Code adapted from https://gist.github.com/matteodefelice/8f7ce920296b7d5199f09661c233f826
To run, 
1. Install the CDS API in the suitable conda environment 
    (https://anaconda.org/conda-forge/cdsapi)
2. Create CDS API key in home directory using API key from online account 
    (https://cds.climate.copernicus.eu/api-how-to#install-the-cds-api-key)
3. Ensure that the conda environment with cdsapi is activated
4. Change below variables appropriately
"""
def download_era5(year):
    """Download hourly ERA5 datasets for the specified variables for the year 
    supplied to function 

    Parameters
    ----------
    year : int
        Year for which ERA5 dataset will be downloaded

    Returns
    -------    
    None
    """
    import cdsapi
    import os
    c = cdsapi.Client()
    # Variable names in CDS can be found at 
    # https://confluence.ecmwf.int/display/CKB/ERA5%3A+data+documentation
    VARS = ['surface_pressure','surface_solar_radiation_downwards', 
         'potential_evaporation', '2m_temperature', 
         'surface_latent_heat_flux', '2m_dewpoint_temperature', 
         'volumetric_soil_water_layer_1', 'volumetric_soil_water_layer_2',
         'volumetric_soil_water_layer_3', 'volumetric_soil_water_layer_4',
         '10m_v_component_of_wind', '10m_u_component_of_wind', 'total_precipitation']
    YEARS = [x for x in map(str, range(year, year+1))]
    for V in VARS:
        for Y in YEARS:
            target_filename = 'era5-hourly-'+V+'-'+Y+'.nc'
            if not os.path.isfile(target_filename):
     	        c.retrieve(
     	            'reanalysis-era5-single-levels', {
 	                'variable':V,
                     'product_type':'reanalysis',
                     'year': Y,
                     # If months in the latter part of the year are selected
                     # the target_filename SHOULD NOT end with "a". The "a" 
                     # suffix denotes the beginning of the year. 
                'month':['01','02','03','04','05','06','07','08','09','10',
                    '11','12'],
     		     'day':['01','02','03','04','05','06','07','08','09',
                     '10','11','12','13','14','15','16','17','18','19',
                     '20','21','22','23','24','25','26','27','28','29',
                     '30','31'],
                'time':['00:00','01:00','02:00','03:00','04:00','05:00',
                    '06:00','07:00','08:00','09:00','10:00','11:00',
                    '12:00','13:00','14:00','15:00','16:00','17:00',
                    '18:00','19:00','20:00','21:00','22:00','23:00'],
                'format':'netcdf'},target_filename)
    # Repeat the above but for variables available on pressure levels rather 
    # than on single levels; see 
    # https://confluence.ecmwf.int/display/WEBAPI/ERA5+monthly+means+of+daily+means+retrieval+efficiency
    #VARS_PRESSURE = ['specific_humidity']
    #for V in VARS_PRESSURE:
    #    for Y in YEARS: 
    #    	target_filename = 'era5-hourly-'+V+'-'+Y+'.nc'
    #    	if not os.path.isfile(target_filename):
    #            # See # https://confluence.ecmwf.int/display/CKB/How+to+download+ERA5
    #		    c.retrieve(                
    #                'reanalysis-era5-complete', {
    #                # Requests follow MARS syntax
    #                # Keywords 'expver' and 'class' can be dropped. They are 
    #                # obsolete since their values are imposed by 
    #                # 'reanalysis-era5-complete'
    #                # 1 is top level, 137 the lowest model level in ERA5. Use 
    #                # '/' to separate values.
    #                'date': '%s-01-01/to/%s-07-31'%(Y,Y),
    #                'levelist': '137',          
    #                'levtype' : 'ml',
    #                # Full information at 
    #                # https://apps.ecmwf.int/codes/grib/param-db/; n.b. param
    #                # 133 is specific humidity
    #                'param'   : '133',
    #                # Denotes ERA5. Ensemble members are selected by 'enda'
    #                'stream'  : 'oper',
    #                # You can drop :00:00 and use MARS short-hand notation, 
    #                # instead of '00/06/12/18'
    #                'time'    : '00/to/23/by/1',         
    #                'type'    : 'an',
    #                # Optional for GRIB, required for NetCDF. The horizontal 
    #                # resolution in decimal degrees. If not set, the archived 
    #                # grid as specified in the data documentation is used.
    #                "grid": "0.25/0.25",        
    #                'format': 'netcdf',  
    #                # Output file; in this example containing fields in grib 
    #                # format. Adapt as you wish.
    #                }, target_filename)                             
    return

import numpy as np
for year in np.arange(2022, 2023):
    print(year)
    download_era5(year)