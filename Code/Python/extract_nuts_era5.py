#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
This module reads in daily average (or min/max) of a particular ERA5 variable
and conducts a simple spatial averaging over all grid cells within polygons
corresponding to NUTS units or an administrative unit in Brazil. Timeseries of 
polygon-averages values for each variable of interest are output to individual
CSV files. 

:Authors:
    Gaige Hunter Kerr, <gaigekerr@gwu.edu>
"""

def extract_admin_era5(year, vnuts, domain):
    """Function loops through polygons corresponding to NUTS' units of EU 
    countries/IBGE units in Brazil and finds ERA5 grid cells in each 
    subdivision. A simple arithmetic average is conducted over grid cells in 
    each unit as well as a population-weighted value for each variable/year of
    interest. Timeseries of that variable within the unit are written to an 
    output .csv file
    
    Parameters
    ----------
    year : int
        Year of interest
    vnuts : int
        NUTS division; either 1, 2, or 3
    domain : str
        Either NUTS or IBGE
        
    Returns
    -------
    None              
    """
    import numpy as np
    import warnings
    import sys
    import os, fnmatch
    import pandas as pd
    from netCDF4 import num2date, Dataset
    import shapefile
    from shapely.geometry import shape, Point

    # Relevant directories
    DIR_ROOT = '/mnt/redwood/sahara/data1/COVID/' 
    DIR_ROOT = '/mnt/redwood/local_drive/gaige/'
    DIR_ROOT = '/mnt/local_drive/gaige/'
    DIR_ERA = DIR_ROOT+'era5-parsed/%d/'%year
    DIR_GPW = DIR_ROOT+'geography/GPW/'    
    DIR_OUT = DIR_ROOT+'ERA5tables/'
    if domain=='NUTS':
        DIR_SHAPE = DIR_ROOT+'geography/NUTS_shapefiles/'+\
            'NUTS_RG_10M_2016_4326_LEVL_%s/'%vnuts
    if domain == 'IBGE':
        DIR_SHAPE = DIR_ROOT+'geography/BR/'
    
    # As per Hamada's unified conventions, the second position should be
    # letter codes corresponding to the state/district. IBGE conventions 
    # for numerical representation of each current federation unit are found
    # at https://en.wikipedia.org/wiki/ISO_3166-2:BR
    code_to_abbrev = {11:'RO',12:'AC',13:'AM',14:'RR',15:'PA',16:'AP',
        17:'TO',21:'MA',22:'PI',23:'CE',24:'RN',25:'PB',26:'PE',27:'AL',
        28:'SE',29:'BA',31:'MG',32:'ES',33:'RJ',35:'SP',41:'PR',42:'SC',
        43:'RS',50:'MS',51:'MT',52:'GO',53:'DF'}
    
    # Search ERA5 directory for all daily files of variables
    d2m = fnmatch.filter(os.listdir(DIR_ERA), 'ERA5_*_d2m.nc')
    d2m = [DIR_ERA+x for x in d2m]
    d2m.sort()
    pev = fnmatch.filter(os.listdir(DIR_ERA), 'ERA5_*_pev.nc')
    pev = [DIR_ERA+x for x in pev]
    pev.sort()
    sp = fnmatch.filter(os.listdir(DIR_ERA), 'ERA5_*_sp.nc')
    sp = [DIR_ERA+x for x in sp]
    sp.sort()
    ssrd = fnmatch.filter(os.listdir(DIR_ERA), 'ERA5_*_ssrd.nc')
    ssrd = [DIR_ERA+x for x in ssrd]
    ssrd.sort()
    swvl1 = fnmatch.filter(os.listdir(DIR_ERA), 'ERA5_*_swvl1.nc')
    swvl1 = [DIR_ERA+x for x in swvl1]
    swvl1.sort()    
    swvl2 = fnmatch.filter(os.listdir(DIR_ERA), 'ERA5_*_swvl2.nc')
    swvl2 = [DIR_ERA+x for x in swvl2]
    swvl2.sort()    
    swvl3 = fnmatch.filter(os.listdir(DIR_ERA), 'ERA5_*_swvl3.nc')
    swvl3 = [DIR_ERA+x for x in swvl3]
    swvl3.sort()    
    swvl4 = fnmatch.filter(os.listdir(DIR_ERA), 'ERA5_*_swvl4.nc')
    swvl4 = [DIR_ERA+x for x in swvl4]
    swvl4.sort()    
    t2mmax = fnmatch.filter(os.listdir(DIR_ERA), 'ERA5_*_t2mmax.nc')
    t2mmax = [DIR_ERA+x for x in t2mmax]
    t2mmax.sort()    
    t2mmin = fnmatch.filter(os.listdir(DIR_ERA), 'ERA5_*_t2mmin.nc')
    t2mmin = [DIR_ERA+x for x in t2mmin]
    t2mmin.sort()
    t2mavg = fnmatch.filter(os.listdir(DIR_ERA), 'ERA5_*_t2mavg.nc')
    t2mavg = [DIR_ERA+x for x in t2mavg]
    t2mavg.sort()    
    tp = fnmatch.filter(os.listdir(DIR_ERA), 'ERA5_*_tp.nc')
    tp = [DIR_ERA+x for x in tp]
    tp.sort()        
    u10 = fnmatch.filter(os.listdir(DIR_ERA), 'ERA5_*_u10.nc')
    u10 = [DIR_ERA+x for x in u10]
    u10.sort()
    v10 = fnmatch.filter(os.listdir(DIR_ERA), 'ERA5_*_v10.nc')
    v10 = [DIR_ERA+x for x in v10]
    v10.sort() 
    slhf = fnmatch.filter(os.listdir(DIR_ERA), 'ERA5_*_slhf.nc')
    slhf = [DIR_ERA+x for x in slhf]
    slhf.sort()     
       
    # Open files and extract variable of interest and dimensional information
    d2ml_dates, pevl_dates, spl_dates, ssrdl_dates = [], [], [], []
    swvl1l_dates, swvl2l_dates, swvl3l_dates, swvl4l_dates = [], [], [], []
    t2mmaxl_dates, t2mminl_dates, t2mavgl_dates, tpl_dates = [], [], [], []
    u10l_dates, v10l_dates, slhfl_dates = [], [], []
    d2ml, pevl, spl, ssrdl, swvl1l, swvl2l = [], [], [], [], [], []
    swvl3l, swvl4l, t2mmaxl, t2mminl, t2mavgl, tpl = [], [], [], [], [], []
    u10l, v10l, slhfl = [], [], []
    
    for filen in d2m: 
        infile = Dataset(filen, 'r')
        # On first iteration extract lat/lon
        if filen == d2m[0]:
            lat = infile.variables['latitude'][:].data # degrees north 
            lng = infile.variables['longitude'][:].data # degrees east
        date = infile.variables['time']
        date = num2date(date[:], date.unit)
        d2ml_dates.append(str(date[0]))
        d2ml.append(infile.variables['d2m'][:])
    d2ml = np.array(d2ml)
    for filen in pev: 
        infile = Dataset(filen, 'r')
        pevl.append(infile.variables['pev'][:])
        date = infile.variables['time']
        date = num2date(date[:], date.unit)
        pevl_dates.append(str(date[0]))        
    pevl = np.array(pevl)
    for filen in sp: 
        infile = Dataset(filen, 'r')
        spl.append(infile.variables['sp'][:])
        date = infile.variables['time']
        date = num2date(date[:], date.unit)
        spl_dates.append(str(date[0]))
    spl = np.array(spl)
    for filen in ssrd: 
        infile = Dataset(filen, 'r')
        ssrdl.append(infile.variables['ssrd'][:])
        date = infile.variables['time']
        date = num2date(date[:], date.unit)
        ssrdl_dates.append(str(date[0]))
    ssrdl = np.array(ssrdl)    
    for filen in swvl1: 
        infile = Dataset(filen, 'r')
        swvl1l.append(infile.variables['swvl1'][:])
        date = infile.variables['time']
        date = num2date(date[:], date.unit)
        swvl1l_dates.append(str(date[0]))     
    swvl1l = np.array(swvl1l)    
    for filen in swvl2: 
        infile = Dataset(filen, 'r')
        swvl2l.append(infile.variables['swvl2'][:])
        date = infile.variables['time']
        date = num2date(date[:], date.unit)
        swvl2l_dates.append(str(date[0]))        
    swvl2l = np.array(swvl2l)    
    for filen in swvl3: 
        infile = Dataset(filen, 'r')
        swvl3l.append(infile.variables['swvl3'][:])
        date = infile.variables['time']
        date = num2date(date[:], date.unit)
        swvl3l_dates.append(str(date[0]))        
    swvl3l = np.array(swvl3l)    
    for filen in swvl4: 
        infile = Dataset(filen, 'r')
        swvl4l.append(infile.variables['swvl4'][:])
        date = infile.variables['time']
        date = num2date(date[:], date.unit)
        swvl4l_dates.append(str(date[0]))        
    swvl4l = np.array(swvl4l)    
    for filen in t2mmax: 
        infile = Dataset(filen, 'r')
        t2mmaxl.append(infile.variables['t2mmax'][:])
        date = infile.variables['time']
        date = num2date(date[:], date.unit)
        t2mmaxl_dates.append(str(date[0]))        
    t2mmaxl = np.array(t2mmaxl)    
    for filen in t2mmin: 
        infile = Dataset(filen, 'r')
        t2mminl.append(infile.variables['t2mmin'][:])
        date = infile.variables['time']
        date = num2date(date[:], date.unit)
        t2mminl_dates.append(str(date[0]))                
    t2mminl = np.array(t2mminl) 
    for filen in t2mavg: 
        infile = Dataset(filen, 'r')
        t2mavgl.append(infile.variables['t2mavg'][:])
        date = infile.variables['time']
        date = num2date(date[:], date.unit)
        t2mavgl_dates.append(str(date[0]))                
    t2mavgl = np.array(t2mavgl) 
    for filen in tp: 
        infile = Dataset(filen, 'r')
        tpl.append(infile.variables['tp'][:])
        date = infile.variables['time']
        date = num2date(date[:], date.unit)
        tpl_dates.append(str(date[0]))                
    tpl = np.array(tpl)
    for filen in u10: 
        infile = Dataset(filen, 'r')
        u10l.append(infile.variables['u10'][:])
        date = infile.variables['time']
        date = num2date(date[:], date.unit)
        u10l_dates.append(str(date[0]))             
    u10l = np.array(u10l) 
    for filen in v10: 
        infile = Dataset(filen, 'r')
        v10l.append(infile.variables['v10'][:])
        date = infile.variables['time']
        date = num2date(date[:], date.unit)
        v10l_dates.append(str(date[0]))        
    v10l = np.array(v10l)
    for filen in slhf: 
        infile = Dataset(filen, 'r')
        slhfl.append(infile.variables['slhf'][:])
        date = infile.variables['time']
        date = num2date(date[:], date.unit)
        slhfl_dates.append(str(date[0]))        
    slhfl = np.array(slhfl)    
        
    # Apply land-ocean mask; the documentation from ERA5 states tha t
    # grid boxes with a value of 0.5 and below can only be comprised of a 
    # water surface, so we set values less than this to 0 
    lsm = DIR_ROOT+'geography/era5-land_sea_mask.nc'
    lsm = Dataset(lsm, 'r')
    lsm = lsm.variables['lsm'][0].data
    mask = np.where(lsm<0.5, np.nan, 0)
    # Add mask to variable 
    d2ml = d2ml+mask
    pevl = pevl+mask
    spl = spl+mask
    ssrdl = ssrdl+mask
    swvl1l = swvl1l+mask
    swvl2l = swvl2l+mask
    swvl3l = swvl3l+mask
    swvl4l = swvl4l+mask
    t2mmaxl = t2mmaxl+mask
    t2mminl = t2mminl+mask
    t2mavgl = t2mavgl+mask
    tpl = tpl+mask  
    u10l = u10l+mask  
    v10l = v10l+mask  
    slhfl = slhfl+mask      
            
    # Convert longitude from 0-360 deg to -180-180 deg. NUTS polygons appear
    # to be in these units
    lng = (lng+180)%360-180
    # Clip domain to Europe or Brazil 
    if domain=='NUTS':
        equator = np.where(lat==0.)[0][0]
        europe_east = np.where(lng==50.)[0][0]
        europe_west = np.where(lng==-70.)[0][0]
        lat = lat[:equator+1]
        lng_relevant = np.r_[europe_west:len(lng), 0:europe_east]
        lng = lng[lng_relevant]
        d2ml = d2ml[:,:,:equator+1,lng_relevant]
        pevl = pevl[:,:,:equator+1,lng_relevant]  
        spl = spl[:,:,:equator+1,lng_relevant]  
        ssrdl = ssrdl[:,:,:equator+1,lng_relevant]  
        swvl1l = swvl1l[:,:,:equator+1,lng_relevant]  
        swvl2l = swvl2l[:,:,:equator+1,lng_relevant]  
        swvl3l = swvl3l[:,:,:equator+1,lng_relevant]  
        swvl4l = swvl4l[:,:,:equator+1,lng_relevant]  
        t2mmaxl = t2mmaxl[:,:,:equator+1,lng_relevant]  
        t2mminl = t2mminl[:,:,:equator+1,lng_relevant]  
        t2mavgl = t2mavgl[:,:,:equator+1,lng_relevant]  
        tpl = tpl[:,:,:equator+1,lng_relevant]  
        u10l = u10l[:,:,:equator+1,lng_relevant]  
        v10l = v10l[:,:,:equator+1,lng_relevant]  
        slhfl = slhfl[:,:,:equator+1,lng_relevant]  
    if domain=='IBGE':
        brazil_east = np.where(lng==-30.)[0][0]
        brazil_west = np.where(lng==-76.)[0][0]
        brazil_north = np.where(lat==7.)[0][0]
        brazil_south = np.where(lat==-34.)[0][0]
        lat = lat[brazil_north:brazil_south+1]
        lng = lng[brazil_west:brazil_east+1]
        d2ml = d2ml[:,:,brazil_north:brazil_south+1,brazil_west:brazil_east+1]
        pevl = pevl[:,:,brazil_north:brazil_south+1,brazil_west:brazil_east+1]
        spl = spl[:,:,brazil_north:brazil_south+1,brazil_west:brazil_east+1]
        ssrdl = ssrdl[:,:,brazil_north:brazil_south+1,brazil_west:brazil_east+1]
        swvl1l = swvl1l[:,:,brazil_north:brazil_south+1,brazil_west:brazil_east+1]
        swvl2l = swvl2l[:,:,brazil_north:brazil_south+1,brazil_west:brazil_east+1]
        swvl3l = swvl3l[:,:,brazil_north:brazil_south+1,brazil_west:brazil_east+1]
        swvl4l = swvl4l[:,:,brazil_north:brazil_south+1,brazil_west:brazil_east+1]
        t2mmaxl = t2mmaxl[:,:,brazil_north:brazil_south+1,brazil_west:brazil_east+1]
        t2mminl = t2mminl[:,:,brazil_north:brazil_south+1,brazil_west:brazil_east+1]
        t2mavgl = t2mavgl[:,:,brazil_north:brazil_south+1,brazil_west:brazil_east+1]
        tpl = tpl[:,:,brazil_north:brazil_south+1,brazil_west:brazil_east+1]
        u10l = u10l[:,:,brazil_north:brazil_south+1,brazil_west:brazil_east+1]
        v10l = v10l[:,:,brazil_north:brazil_south+1,brazil_west:brazil_east+1]
        slhfl = slhfl[:,:,brazil_north:brazil_south+1,brazil_west:brazil_east+1]
    print('ERA5 data loaded!')
        
    # Open Columbia GPW population estimates regridded to the native resolution
    # of ERA5
    gpw = Dataset(DIR_GPW+'gpw_v4_pop2020_adj_align.nc')
    lat_gpw = gpw.variables['lat'][:]
    lng_gpw = gpw.variables['lon'][:]
    gpw = gpw.variables['population'][:]
    
    # Shifting the GPW grid such that it spans 0-180 to -180-0 (i.e., 
    # compatiable with the ERA5 grid)
    lng_gpw = np.hstack([lng_gpw[720:],lng_gpw[:720]])
    gpw = np.hstack([gpw[:,720:], gpw[:,:720]])
    gpw = gpw+mask 
    # Restrict to the European or Brazilian domain (similar to above)
    if domain=='NUTS':
        lat_gpw = lat_gpw[:equator+1]
        lng_gpw = lng_gpw[lng_relevant]
        gpw = gpw[:equator+1,lng_relevant]
    if domain=='IBGE':
        lat_gpw = lat_gpw[brazil_north:brazil_south+1]
        lng_gpw = lng_gpw[brazil_west:brazil_east+1]
        gpw = gpw[brazil_north:brazil_south+1,brazil_west:brazil_east+1]        
    print('CIESIN population read!')
        
    # Read shapefiles
    if domain=='NUTS':
        # Read NUTS for appropriate division; note that the "RG" files should 
        # be used...the release-notes.txt file indicates that these are the 
        # RG: regions (multipolygons), which are appropriate for 
        r = shapefile.Reader(DIR_SHAPE+'NUTS_RG_10M_2016_4326_LEVL_%d.shp'%(
            vnuts))
        # Get shapes, records
        shapes = r.shapes()
        records = r.records()    
    if domain=='IBGE':
        # I couldn't get the damn geobr package to work so I downloaded state, 
        # local, and municipal files from https://www.ibge.gov.br/en/geosciences/
        # territorial-organization/territorial-organization/
        # 18890-municipal-mesh.html?=&t=downloads.
        # From this page go to municipio_2018 -> Brasil -> BR -> BR.zip
        # Admin 1 are states/federal district
        if vnuts==1:
            # Admin 1 are states/federal district, "unidades de federacao"
            r = shapefile.Reader(DIR_SHAPE+'BRUFE250GC_SIR.shp')
            # Get shapes, records
            shapes = r.shapes()
            records = r.records()
        # Admin 2 are municipalities 
        if vnuts==2:
            r = shapefile.Reader(DIR_SHAPE+'BRMUE250GC_SIR.shp')
            shapes = r.shapes()
            records = r.records()
    print('Shapefile read!')
    # Create empty pandas DataFrames with columns corresponding to the dates
    # for each variable. These DataFrame will be filled in the for loop 
    # below, and each row will corresponding to a different terroritial unit
    # in the EU for the weighted and unweighted cases
    d2ml_df = pd.DataFrame(columns=[x[:-9] for x in d2ml_dates])
    d2ml_df_wt = pd.DataFrame(columns=[x[:-9] for x in d2ml_dates])
    pevl_df = pd.DataFrame(columns=[x[:-9] for x in pevl_dates])
    pevl_df_wt = pd.DataFrame(columns=[x[:-9] for x in pevl_dates])
    spl_df = pd.DataFrame(columns=[x[:-9] for x in spl_dates])
    spl_df_wt = pd.DataFrame(columns=[x[:-9] for x in spl_dates])
    ssrdl_df = pd.DataFrame(columns=[x[:-9] for x in ssrdl_dates])
    ssrdl_df_wt = pd.DataFrame(columns=[x[:-9] for x in ssrdl_dates])
    swvl1l_df = pd.DataFrame(columns=[x[:-9] for x in swvl1l_dates])
    swvl1l_df_wt = pd.DataFrame(columns=[x[:-9] for x in swvl1l_dates])
    swvl2l_df = pd.DataFrame(columns=[x[:-9] for x in swvl2l_dates])
    swvl2l_df_wt = pd.DataFrame(columns=[x[:-9] for x in swvl2l_dates])
    swvl3l_df = pd.DataFrame(columns=[x[:-9] for x in swvl3l_dates])
    swvl3l_df_wt = pd.DataFrame(columns=[x[:-9] for x in swvl3l_dates])
    swvl4l_df = pd.DataFrame(columns=[x[:-9] for x in swvl4l_dates])
    swvl4l_df_wt = pd.DataFrame(columns=[x[:-9] for x in swvl4l_dates])
    t2mmaxl_df = pd.DataFrame(columns=[x[:-9] for x in t2mmaxl_dates])
    t2mmaxl_df_wt = pd.DataFrame(columns=[x[:-9] for x in t2mmaxl_dates])
    t2mminl_df = pd.DataFrame(columns=[x[:-9] for x in t2mminl_dates])
    t2mminl_df_wt = pd.DataFrame(columns=[x[:-9] for x in t2mminl_dates])
    t2mavgl_df = pd.DataFrame(columns=[x[:-9] for x in t2mavgl_dates])
    t2mavgl_df_wt = pd.DataFrame(columns=[x[:-9] for x in t2mavgl_dates])
    tpl_df = pd.DataFrame(columns=[x[:-9] for x in tpl_dates])
    tpl_df_wt = pd.DataFrame(columns=[x[:-9] for x in tpl_dates])
    u10l_df = pd.DataFrame(columns=[x[:-9] for x in u10l_dates])
    u10l_df_wt = pd.DataFrame(columns=[x[:-9] for x in u10l_dates])
    v10l_df = pd.DataFrame(columns=[x[:-9] for x in v10l_dates])
    v10l_df_wt = pd.DataFrame(columns=[x[:-9] for x in v10l_dates])
    slhfl_df = pd.DataFrame(columns=[x[:-9] for x in slhfl_dates])
    slhfl_df_wt = pd.DataFrame(columns=[x[:-9] for x in slhfl_dates])
    
    # Variables for bar to indiciate progress iterating over shapes
    total = len(shapes)  # total number to reach
    bar_length = 30  # should be less than 100
    # Loop through shapes; each shapes corresponds to NUTS code
    for ishape in np.arange(0, len(shapes), 1):
        # Build a shapely polygon from shape
        polygon = shape(shapes[ishape]) 
        # Read a single record call the record() method with the record's index
        record = records[ishape]
        # Build unified geospatial ID (from 
        # https://github.com/hsbadr/COVID-19)
        if domain=='NUTS':
            ifid = record['FID']
        if domain=='IBGE':    
            if vnuts==1:
                ifid = ('BR'+code_to_abbrev[int(record['CD_GEOCUF'])])
            if vnuts==2:
                ifid = ('BR'+code_to_abbrev[int(record['CD_GEOCMU'][:2])]+
                    record['CD_GEOCMU'])     
        # For each polygon, loop through model grid and check if grid cells
        # are in polygon (semi-slow and a little kludgey); see 
        # stackoverflow.com/questions/7861196/check-if-a-geopoint-with-
        # latitude-and-longitude-is-within-a-shapefile
        # for additional information
        i_inside, j_inside = [], []
        for i, ilat in enumerate(lat):
            for j, jlng in enumerate(lng): 
                point = Point(jlng, ilat)
                if polygon.contains(point) is True:
                    # Fill lists with indices of reanalysis in grid 
                    i_inside.append(i)
                    j_inside.append(j)
        # If the NUTS unit is too small to not intersect with the ERA5 grid
        # pick off and average the nearest 9 point. Note that this SHOULDN'T pick 
        # out oversees territories (e.g., La Reunion; FRY4), so deal with this
        if (len(i_inside)==0) and ((lng.min() <= polygon.centroid.x <= lng.max()) 
            and (lat.min() <= polygon.centroid.y <= lat.max())):
            lat_centroid = polygon.centroid.xy[1][0]
            lng_centroid = polygon.centroid.xy[0][0]
            lat_close = lat.flat[np.abs(lat-lat_centroid).argmin()]
            lng_close = lng.flat[np.abs(lng-lng_centroid).argmin()]            
            lat_close = np.where(lat==lat_close)[0][0]
            lng_close = np.where(lng==lng_close)[0][0]
            # Select nearest six points
            # (lat_close+1, lng_close-1) (lat_close+1, lng_close)  (lat_close+1, lng_close+1)
            # (lat_close, lng_close-1)  (lat_close, lng_close)  (lat_close, lng_close+1)
            # (lat_close-1, lng_close-1) (lat_close-1, lng_close)  (lat_close-1, lng_close+1)
            i_inside.extend([lat_close+1, lat_close+1, lat_close+1, lat_close, 
                lat_close, lat_close, lat_close-1, lat_close-1, lat_close-1])
            j_inside.extend([lng_close-1, lng_close, lng_close+1, lng_close-1, 
                lng_close, lng_close+1, lng_close-1, lng_close, lng_close+1])
        # Select variable from reanalysis at grid cells 
        if len(i_inside)!=0:
            d2ml_nuts = d2ml[:, 0, i_inside, j_inside]
            pevl_nuts = pevl[:, 0, i_inside, j_inside]
            spl_nuts = spl[:, 0, i_inside, j_inside]
            ssrdl_nuts = ssrdl[:, 0, i_inside, j_inside]
            swvl1l_nuts = swvl1l[:, 0, i_inside, j_inside]
            swvl2l_nuts = swvl2l[:, 0, i_inside, j_inside]
            swvl3l_nuts = swvl3l[:, 0, i_inside, j_inside]
            swvl4l_nuts = swvl4l[:, 0, i_inside, j_inside]
            t2mmaxl_nuts = t2mmaxl[:, 0, i_inside, j_inside]
            t2mminl_nuts = t2mminl[:, 0, i_inside, j_inside]
            t2mavgl_nuts = t2mavgl[:, 0, i_inside, j_inside]
            tpl_nuts = tpl[:, 0, i_inside, j_inside]
            u10l_nuts = u10l[:, 0, i_inside, j_inside]
            v10l_nuts = v10l[:, 0, i_inside, j_inside]
            slhfl_nuts = slhfl[:, 0, i_inside, j_inside]
            gpw_nuts = gpw[i_inside, j_inside]
            with warnings.catch_warnings():
                warnings.simplefilter('ignore')
                # Conduct population weighted averages. The following code is 
                # adapted from Ben's code (below)
                # --------------------------------------------
                # maskedvar = var.where(var.GADM_0 == thisGADM)
                # maskedpop = pop.where(var.GADM_0 == thisGADM)
                # maskedpop = maskedpop.where(maskedpop > -1.0)
                # maskedpop = maskedpop.where(maskedvar[1,:,:] > -750.0)
                # sumpop = np.nansum(maskedpop)
                # wtmaskedvar = maskedvar * np.broadcast_to(maskedpop,(ndays,dimy,dimx)) / sumpop
                # if sumpop > 0.0:
                #   gadmseries[c,:] = np.nansum(wtmaskedvar,axis=(1,2))
                # gadmnotwtd[c,:] = np.nanmean(maskedvar,axis=(1,2))      
                # Find where population and ERA5 values exist (note that (1))
                # the GPW dataset doesn't have NaNs but large negative values, 
                # so filter out based on this and (2) this mask assumes that 
                # NaN values in ERA don't change from day to day)
                d2ml_mask = np.where((gpw_nuts >= 0.0) & (
                    np.isreal(d2ml_nuts[0,:]) == True))[0]
                pevl_mask = np.where((gpw_nuts >= 0.0) & (
                    np.isreal(pevl_nuts[0,:]) == True))[0]
                spl_mask = np.where((gpw_nuts >= 0.0) & (
                    np.isreal(spl_nuts[0,:]) == True))[0]
                ssrdl_mask = np.where((gpw_nuts >= 0.0) & (
                    np.isreal(ssrdl_nuts[0,:]) == True))[0]
                swvl1l_mask = np.where((gpw_nuts >= 0.0) & (
                    np.isreal(swvl1l_nuts[0,:]) == True))[0]
                swvl2l_mask = np.where((gpw_nuts >= 0.0) & (
                    np.isreal(swvl2l_nuts[0,:]) == True))[0]
                swvl3l_mask = np.where((gpw_nuts >= 0.0) & (
                    np.isreal(swvl3l_nuts[0,:]) == True))[0]
                swvl4l_mask = np.where((gpw_nuts >= 0.0) & (
                    np.isreal(swvl4l_nuts[0,:]) == True))[0]
                t2mmaxl_mask = np.where((gpw_nuts >= 0.0) & (
                    np.isreal(t2mmaxl_nuts[0,:]) == True))[0]
                t2mminl_mask = np.where((gpw_nuts >= 0.0) & (
                    np.isreal(t2mminl_nuts[0,:]) == True))[0]
                t2mavgl_mask = np.where((gpw_nuts >= 0.0) & (
                    np.isreal(t2mavgl_nuts[0,:]) == True))[0]
                tpl_mask = np.where((gpw_nuts >= 0.0) & (
                    np.isreal(tpl_nuts[0,:]) == True))[0]
                u10l_mask = np.where((gpw_nuts >= 0.0) & (
                    np.isreal(u10l_nuts[0,:]) == True))[0]
                v10l_mask = np.where((gpw_nuts >= 0.0) & (
                    np.isreal(v10l_nuts[0,:]) == True))[0]
                slhfl_mask = np.where((gpw_nuts >= 0.0) & (
                    np.isreal(slhfl_nuts[0,:]) == True))[0]
                # d2m
                # Total population in unit 
                sumpop = np.nansum(gpw_nuts[d2ml_mask])
                d2ml_nuts_wt = d2ml_nuts[:,d2ml_mask]*np.broadcast_to(
                    gpw_nuts[d2ml_mask],(np.shape(d2ml_nuts[:,d2ml_mask])))/sumpop
                # Conduct population-weighted spatial average over region
                if sumpop > 0.0:
                    d2ml_nuts_wt = np.nansum(d2ml_nuts_wt, axis=1)
                else: 
                    d2ml_nuts_wt = np.empty((len(d2ml)))
                    d2ml_nuts_wt[:] = np.nan                    
                # Conduct simple spatial average over region (i.e., no population
                # weighting)
                d2ml_nuts = np.nanmean(d2ml_nuts, axis=1)
                # pev
                sumpop = np.nansum(gpw_nuts[pevl_mask])
                pevl_nuts_wt = pevl_nuts[:,pevl_mask]*np.broadcast_to(
                    gpw_nuts[pevl_mask],(np.shape(pevl_nuts[:,pevl_mask])))/sumpop
                if sumpop > 0.0:
                    pevl_nuts_wt = np.nansum(pevl_nuts_wt, axis=1)
                else: 
                    pevl_nuts_wt = np.empty((len(pevl)))
                    pevl_nuts_wt[:] = np.nan                    
                pevl_nuts = np.nanmean(pevl_nuts, axis=1)
                # sp
                sumpop = np.nansum(gpw_nuts[spl_mask])
                spl_nuts_wt = spl_nuts[:,spl_mask]*np.broadcast_to(
                    gpw_nuts[spl_mask],(np.shape(spl_nuts[:,spl_mask])))/sumpop
                if sumpop > 0.0:
                    spl_nuts_wt = np.nansum(spl_nuts_wt, axis=1)
                else: 
                    spl_nuts_wt = np.empty((len(spl)))
                    spl_nuts_wt[:] = np.nan                    
                spl_nuts = np.nanmean(spl_nuts, axis=1) 
                # ssrd
                sumpop = np.nansum(gpw_nuts[ssrdl_mask])
                ssrdl_nuts_wt = ssrdl_nuts[:,ssrdl_mask]*np.broadcast_to(
                    gpw_nuts[ssrdl_mask],(np.shape(ssrdl_nuts[:,ssrdl_mask])))/sumpop
                if sumpop > 0.0:
                    ssrdl_nuts_wt = np.nansum(ssrdl_nuts_wt, axis=1)
                else: 
                    ssrdl_nuts_wt = np.empty((len(ssrdl)))
                    ssrdl_nuts_wt[:] = np.nan                    
                ssrdl_nuts = np.nanmean(ssrdl_nuts, axis=1)
                # swvl1
                sumpop = np.nansum(gpw_nuts[swvl1l_mask])
                swvl1l_nuts_wt = swvl1l_nuts[:,swvl1l_mask]*np.broadcast_to(
                    gpw_nuts[swvl1l_mask],(np.shape(swvl1l_nuts[:,swvl1l_mask])))/sumpop
                if sumpop > 0.0:
                    swvl1l_nuts_wt = np.nansum(swvl1l_nuts_wt, axis=1)
                else: 
                    swvl1l_nuts_wt = np.empty((len(swvl1l)))
                    swvl1l_nuts_wt[:] = np.nan                    
                swvl1l_nuts = np.nanmean(swvl1l_nuts, axis=1)           
                # swvl2
                sumpop = np.nansum(gpw_nuts[swvl2l_mask])
                swvl2l_nuts_wt = swvl2l_nuts[:,swvl2l_mask]*np.broadcast_to(
                    gpw_nuts[swvl2l_mask],(np.shape(swvl2l_nuts[:,swvl2l_mask])))/sumpop
                if sumpop > 0.0:
                    swvl2l_nuts_wt = np.nansum(swvl2l_nuts_wt, axis=1)
                else: 
                    swvl2l_nuts_wt = np.empty((len(swvl2l)))
                    swvl2l_nuts_wt[:] = np.nan                    
                swvl2l_nuts = np.nanmean(swvl2l_nuts, axis=1)
                # swvl3
                sumpop = np.nansum(gpw_nuts[swvl3l_mask])
                swvl3l_nuts_wt = swvl3l_nuts[:,swvl3l_mask]*np.broadcast_to(
                    gpw_nuts[swvl3l_mask],(np.shape(swvl3l_nuts[:,swvl3l_mask])))/sumpop
                if sumpop > 0.0:
                    swvl3l_nuts_wt = np.nansum(swvl3l_nuts_wt, axis=1)
                else: 
                    swvl3l_nuts_wt = np.empty((len(swvl3l)))
                    swvl3l_nuts_wt[:] = np.nan                    
                swvl3l_nuts = np.nanmean(swvl3l_nuts, axis=1)
                # swvl4
                sumpop = np.nansum(gpw_nuts[swvl4l_mask])
                swvl4l_nuts_wt = swvl4l_nuts[:,swvl4l_mask]*np.broadcast_to(
                    gpw_nuts[swvl4l_mask],(np.shape(swvl4l_nuts[:,swvl4l_mask])))/sumpop
                if sumpop > 0.0:
                    swvl4l_nuts_wt = np.nansum(swvl4l_nuts_wt, axis=1)
                else: 
                    swvl4l_nuts_wt = np.empty((len(swvl4l)))
                    swvl4l_nuts_wt[:] = np.nan                    
                swvl4l_nuts = np.nanmean(swvl4l_nuts, axis=1)
                # t2mmax
                sumpop = np.nansum(gpw_nuts[t2mmaxl_mask])
                t2mmaxl_nuts_wt = t2mmaxl_nuts[:,t2mmaxl_mask]*np.broadcast_to(
                    gpw_nuts[t2mmaxl_mask],(np.shape(t2mmaxl_nuts[:,t2mmaxl_mask])))/sumpop
                if sumpop > 0.0:
                    t2mmaxl_nuts_wt = np.nansum(t2mmaxl_nuts_wt, axis=1)
                else: 
                    t2mmaxl_nuts_wt = np.empty((len(t2mmaxl)))
                    t2mmaxl_nuts_wt[:] = np.nan                    
                t2mmaxl_nuts = np.nanmean(t2mmaxl_nuts, axis=1)             
                # t2mmin
                sumpop = np.nansum(gpw_nuts[t2mminl_mask])
                t2mminl_nuts_wt = t2mminl_nuts[:,t2mminl_mask]*np.broadcast_to(
                    gpw_nuts[t2mminl_mask],(np.shape(t2mminl_nuts[:,t2mminl_mask])))/sumpop
                if sumpop > 0.0:
                    t2mminl_nuts_wt = np.nansum(t2mminl_nuts_wt, axis=1)
                else: 
                    t2mminl_nuts_wt = np.empty((len(t2mminl)))
                    t2mminl_nuts_wt[:] = np.nan                    
                t2mminl_nuts = np.nanmean(t2mminl_nuts, axis=1)
                # t2mavg
                sumpop = np.nansum(gpw_nuts[t2mavgl_mask])
                t2mavgl_nuts_wt = t2mavgl_nuts[:,t2mavgl_mask]*np.broadcast_to(
                    gpw_nuts[t2mavgl_mask],(np.shape(t2mavgl_nuts[:,t2mavgl_mask])))/sumpop
                if sumpop > 0.0:
                    t2mavgl_nuts_wt = np.nansum(t2mavgl_nuts_wt, axis=1)
                else: 
                    t2mavgl_nuts_wt = np.empty((len(t2mavgl)))
                    t2mavgl_nuts_wt[:] = np.nan                    
                t2mavgl_nuts = np.nanmean(t2mavgl_nuts, axis=1)
                # tp
                sumpop = np.nansum(gpw_nuts[tpl_mask])
                tpl_nuts_wt = tpl_nuts[:,tpl_mask]*np.broadcast_to(
                    gpw_nuts[tpl_mask],(np.shape(tpl_nuts[:,tpl_mask])))/sumpop
                if sumpop > 0.0:
                    tpl_nuts_wt = np.nansum(tpl_nuts_wt, axis=1)
                else: 
                    tpl_nuts_wt = np.empty((len(tpl)))
                    tpl_nuts_wt[:] = np.nan                    
                tpl_nuts = np.nanmean(tpl_nuts, axis=1)
                # u10
                sumpop = np.nansum(gpw_nuts[u10l_mask])
                u10l_nuts_wt = u10l_nuts[:,u10l_mask]*np.broadcast_to(
                    gpw_nuts[u10l_mask],(np.shape(u10l_nuts[:,u10l_mask])))/sumpop
                if sumpop > 0.0:
                    u10l_nuts_wt = np.nansum(u10l_nuts_wt, axis=1)
                else: 
                    u10l_nuts_wt = np.empty((len(u10l)))
                    u10l_nuts_wt[:] = np.nan                    
                u10l_nuts = np.nanmean(u10l_nuts, axis=1)
                # v10
                sumpop = np.nansum(gpw_nuts[v10l_mask])
                v10l_nuts_wt = v10l_nuts[:,v10l_mask]*np.broadcast_to(
                    gpw_nuts[v10l_mask],(np.shape(v10l_nuts[:,v10l_mask])))/sumpop
                if sumpop > 0.0:
                    v10l_nuts_wt = np.nansum(v10l_nuts_wt, axis=1)
                else: 
                    v10l_nuts_wt = np.empty((len(v10l)))
                    v10l_nuts_wt[:] = np.nan                    
                v10l_nuts = np.nanmean(v10l_nuts, axis=1)
                # slhf
                sumpop = np.nansum(gpw_nuts[slhfl_mask])
                slhfl_nuts_wt = slhfl_nuts[:,slhfl_mask]*np.broadcast_to(
                    gpw_nuts[slhfl_mask],(np.shape(slhfl_nuts[:,slhfl_mask])))/sumpop
                if sumpop > 0.0:
                    slhfl_nuts_wt = np.nansum(slhfl_nuts_wt, axis=1)
                else: 
                    slhfl_nuts_wt = np.empty((len(slhfl)))
                    slhfl_nuts_wt[:] = np.nan                    
                slhfl_nuts = np.nanmean(slhfl_nuts, axis=1)                

        # For the case of territories/units outside bounds (e.g., Reunion)
        else: 
            # d2m
            d2ml_nuts = np.empty((len(d2ml)))
            d2ml_nuts_wt = np.empty((len(d2ml)))
            d2ml_nuts[:] = np.nan
            d2ml_nuts_wt[:] = np.nan
            # pev
            pevl_nuts = np.empty((len(pevl)))
            pevl_nuts_wt = np.empty((len(pevl)))
            pevl_nuts[:] = np.nan
            pevl_nuts_wt[:] = np.nan
            # sp
            spl_nuts = np.empty((len(spl)))
            spl_nuts_wt = np.empty((len(spl)))
            spl_nuts[:] = np.nan
            spl_nuts_wt[:] = np.nan
            # ssrd
            ssrdl_nuts = np.empty((len(ssrdl)))
            ssrdl_nuts_wt = np.empty((len(ssrdl)))
            ssrdl_nuts[:] = np.nan
            ssrdl_nuts_wt[:] = np.nan
            # swvl1
            swvl1l_nuts = np.empty((len(swvl1l)))
            swvl1l_nuts_wt = np.empty((len(swvl1l)))
            swvl1l_nuts[:] = np.nan
            swvl1l_nuts_wt[:] = np.nan
            # swvl2
            swvl2l_nuts = np.empty((len(swvl2l)))
            swvl2l_nuts_wt = np.empty((len(swvl2l)))
            swvl2l_nuts[:] = np.nan
            swvl2l_nuts_wt[:] = np.nan
            # swvl3
            swvl3l_nuts = np.empty((len(swvl3l)))
            swvl3l_nuts_wt = np.empty((len(swvl3l)))
            swvl3l_nuts[:] = np.nan
            swvl3l_nuts_wt[:] = np.nan
            # swvl4
            swvl4l_nuts = np.empty((len(swvl4l)))
            swvl4l_nuts_wt = np.empty((len(swvl4l)))
            swvl4l_nuts[:] = np.nan
            swvl4l_nuts_wt[:] = np.nan
            # t2mmax
            t2mmaxl_nuts = np.empty((len(t2mmaxl)))
            t2mmaxl_nuts_wt = np.empty((len(t2mmaxl)))
            t2mmaxl_nuts[:] = np.nan
            t2mmaxl_nuts_wt[:] = np.nan
            # t2mmin
            t2mminl_nuts = np.empty((len(t2mminl)))
            t2mminl_nuts_wt = np.empty((len(t2mminl)))
            t2mminl_nuts[:] = np.nan
            t2mminl_nuts_wt[:] = np.nan
            # t2mavg
            t2mavgl_nuts = np.empty((len(t2mavgl)))
            t2mavgl_nuts_wt = np.empty((len(t2mavgl)))
            t2mavgl_nuts[:] = np.nan
            t2mavgl_nuts_wt[:] = np.nan
            # tp
            tpl_nuts = np.empty((len(tpl)))
            tpl_nuts_wt = np.empty((len(tpl)))
            tpl_nuts[:] = np.nan
            tpl_nuts_wt[:] = np.nan
            # u10
            u10l_nuts = np.empty((len(u10l)))
            u10l_nuts_wt = np.empty((len(u10l)))
            u10l_nuts[:] = np.nan
            u10l_nuts_wt[:] = np.nan
            # v10
            v10l_nuts = np.empty((len(v10l)))
            v10l_nuts_wt = np.empty((len(v10l)))
            v10l_nuts[:] = np.nan
            v10l_nuts_wt[:] = np.nan
            # slhf
            slhfl_nuts = np.empty((len(slhfl)))
            slhfl_nuts_wt = np.empty((len(slhfl)))
            slhfl_nuts[:] = np.nan
            slhfl_nuts_wt[:] = np.nan

        # Add row corresponding to individual territory for unweighted and
        # weighted cases
        # d2m
        row_df = pd.DataFrame([d2ml_nuts], index=[ifid], 
            columns=[x[:-9] for x in d2ml_dates])
        d2ml_df = pd.concat([row_df, d2ml_df])
        row_df_wt = pd.DataFrame([d2ml_nuts_wt], index=[ifid], 
            columns=[x[:-9] for x in d2ml_dates])
        d2ml_df_wt = pd.concat([row_df_wt, d2ml_df_wt])
        # pev
        row_df = pd.DataFrame([pevl_nuts], index=[ifid], 
            columns=[x[:-9] for x in pevl_dates])
        pevl_df = pd.concat([row_df, pevl_df])
        row_df_wt = pd.DataFrame([pevl_nuts_wt], index=[ifid], 
            columns=[x[:-9] for x in pevl_dates])
        pevl_df_wt = pd.concat([row_df_wt, pevl_df_wt]) 
        # sp
        row_df = pd.DataFrame([spl_nuts], index=[ifid], 
            columns=[x[:-9] for x in spl_dates])
        spl_df = pd.concat([row_df, spl_df])
        row_df_wt = pd.DataFrame([spl_nuts_wt], index=[ifid], 
            columns=[x[:-9] for x in spl_dates])
        spl_df_wt = pd.concat([row_df_wt, spl_df_wt]) 
        # ssrd
        row_df = pd.DataFrame([ssrdl_nuts], index=[ifid], 
            columns=[x[:-9] for x in ssrdl_dates])
        ssrdl_df = pd.concat([row_df, ssrdl_df])
        row_df_wt = pd.DataFrame([ssrdl_nuts_wt], index=[ifid], 
            columns=[x[:-9] for x in ssrdl_dates])
        ssrdl_df_wt = pd.concat([row_df_wt, ssrdl_df_wt]) 
        # swvl1
        row_df = pd.DataFrame([swvl1l_nuts], index=[ifid], 
            columns=[x[:-9] for x in swvl1l_dates])
        swvl1l_df = pd.concat([row_df, swvl1l_df])
        row_df_wt = pd.DataFrame([swvl1l_nuts_wt], index=[ifid], 
            columns=[x[:-9] for x in swvl1l_dates])
        swvl1l_df_wt = pd.concat([row_df_wt, swvl1l_df_wt]) 
        # swvl2
        row_df = pd.DataFrame([swvl2l_nuts], index=[ifid], 
            columns=[x[:-9] for x in swvl2l_dates])
        swvl2l_df = pd.concat([row_df, swvl2l_df])
        row_df_wt = pd.DataFrame([swvl2l_nuts_wt], index=[ifid], 
            columns=[x[:-9] for x in swvl2l_dates])
        swvl2l_df_wt = pd.concat([row_df_wt, swvl2l_df_wt]) 
        # swvl3
        row_df = pd.DataFrame([swvl3l_nuts], index=[ifid], 
            columns=[x[:-9] for x in swvl3l_dates])
        swvl3l_df = pd.concat([row_df, swvl3l_df])
        row_df_wt = pd.DataFrame([swvl3l_nuts_wt], index=[ifid], 
            columns=[x[:-9] for x in swvl3l_dates])
        swvl3l_df_wt = pd.concat([row_df_wt, swvl3l_df_wt]) 
        # swvl4
        row_df = pd.DataFrame([swvl4l_nuts], index=[ifid], 
            columns=[x[:-9] for x in swvl4l_dates])
        swvl4l_df = pd.concat([row_df, swvl4l_df])
        row_df_wt = pd.DataFrame([swvl4l_nuts_wt], index=[ifid], 
            columns=[x[:-9] for x in swvl4l_dates])
        swvl4l_df_wt = pd.concat([row_df_wt, swvl4l_df_wt]) 
        # t2mmax
        row_df = pd.DataFrame([t2mmaxl_nuts], index=[ifid], 
            columns=[x[:-9] for x in t2mmaxl_dates])
        t2mmaxl_df = pd.concat([row_df, t2mmaxl_df])
        row_df_wt = pd.DataFrame([t2mmaxl_nuts_wt], index=[ifid], 
            columns=[x[:-9] for x in t2mmaxl_dates])
        t2mmaxl_df_wt = pd.concat([row_df_wt, t2mmaxl_df_wt]) 
        # t2mmin
        row_df = pd.DataFrame([t2mminl_nuts], index=[ifid], 
            columns=[x[:-9] for x in t2mminl_dates])
        t2mminl_df = pd.concat([row_df, t2mminl_df])
        row_df_wt = pd.DataFrame([t2mminl_nuts_wt], index=[ifid], 
            columns=[x[:-9] for x in t2mminl_dates])
        t2mminl_df_wt = pd.concat([row_df_wt, t2mminl_df_wt]) 
        # t2mavg
        row_df = pd.DataFrame([t2mavgl_nuts], index=[ifid], 
            columns=[x[:-9] for x in t2mavgl_dates])
        t2mavgl_df = pd.concat([row_df, t2mavgl_df])
        row_df_wt = pd.DataFrame([t2mavgl_nuts_wt], index=[ifid], 
            columns=[x[:-9] for x in t2mavgl_dates])
        t2mavgl_df_wt = pd.concat([row_df_wt, t2mavgl_df_wt]) 
        # tp
        row_df = pd.DataFrame([tpl_nuts], index=[ifid], 
            columns=[x[:-9] for x in tpl_dates])
        tpl_df = pd.concat([row_df, tpl_df])
        row_df_wt = pd.DataFrame([tpl_nuts_wt], index=[ifid], 
            columns=[x[:-9] for x in tpl_dates])
        tpl_df_wt = pd.concat([row_df_wt, tpl_df_wt]) 
        # u10
        row_df = pd.DataFrame([u10l_nuts], index=[ifid], 
            columns=[x[:-9] for x in u10l_dates])
        u10l_df = pd.concat([row_df, u10l_df])
        row_df_wt = pd.DataFrame([u10l_nuts_wt], index=[ifid], 
            columns=[x[:-9] for x in u10l_dates])
        u10l_df_wt = pd.concat([row_df_wt, u10l_df_wt]) 
        # v10
        row_df = pd.DataFrame([v10l_nuts], index=[ifid], 
            columns=[x[:-9] for x in v10l_dates])
        v10l_df = pd.concat([row_df, v10l_df])
        row_df_wt = pd.DataFrame([v10l_nuts_wt], index=[ifid], 
            columns=[x[:-9] for x in v10l_dates])
        v10l_df_wt = pd.concat([row_df_wt, v10l_df_wt]) 
        # slhf
        row_df = pd.DataFrame([slhfl_nuts], index=[ifid], 
            columns=[x[:-9] for x in slhfl_dates])
        slhfl_df = pd.concat([row_df, slhfl_df])
        row_df_wt = pd.DataFrame([slhfl_nuts_wt], index=[ifid], 
            columns=[x[:-9] for x in slhfl_dates])
        slhfl_df_wt = pd.concat([row_df_wt, slhfl_df_wt]) 
        
        # Update progress bar
        percent = 100.0*ishape/total  
        sys.stdout.write('\r')
        sys.stdout.write("Completed: [{:{}}] {:>3}%".format('='*int(
            percent/(100.0/bar_length)), bar_length, int(percent)))
        sys.stdout.flush()
    # Add index name and write, filename indicates NUTS division level, 
    # variable included in .csv file, and start/end dates of data
    # d2m
    d2ml_df.index.name = domain
    d2ml_df.to_csv(DIR_OUT+'ERA5_%s%d_d2m_%s_%s.csv'
        %(domain,vnuts,pd.to_datetime(d2ml_dates[0]).strftime('%Y%m%d'),
          pd.to_datetime(d2ml_dates[-1]).strftime('%Y%m%d')), sep=',')
    d2ml_df_wt.index.name = domain
    d2ml_df_wt.to_csv(DIR_OUT+'ERA5_%s%d_d2m_%s_%s_popwtd.csv'
        %(domain,vnuts,pd.to_datetime(d2ml_dates[0]).strftime('%Y%m%d'),
          pd.to_datetime(d2ml_dates[-1]).strftime('%Y%m%d')), sep=',')
    # pev
    pevl_df.index.name = domain
    pevl_df.to_csv(DIR_OUT+'ERA5_%s%d_pev_%s_%s.csv'
        %(domain,vnuts,pd.to_datetime(pevl_dates[0]).strftime('%Y%m%d'),
          pd.to_datetime(pevl_dates[-1]).strftime('%Y%m%d')), sep=',')
    pevl_df_wt.index.name = domain
    pevl_df_wt.to_csv(DIR_OUT+'ERA5_%s%d_pev_%s_%s_popwtd.csv'
        %(domain,vnuts,pd.to_datetime(pevl_dates[0]).strftime('%Y%m%d'),
          pd.to_datetime(pevl_dates[-1]).strftime('%Y%m%d')), sep=',')
    # sp
    spl_df.index.name = domain
    spl_df.to_csv(DIR_OUT+'ERA5_%s%d_sp_%s_%s.csv'
        %(domain,vnuts,pd.to_datetime(spl_dates[0]).strftime('%Y%m%d'),
          pd.to_datetime(spl_dates[-1]).strftime('%Y%m%d')), sep=',')
    spl_df_wt.index.name = domain
    spl_df_wt.to_csv(DIR_OUT+'ERA5_%s%d_sp_%s_%s_popwtd.csv'
        %(domain,vnuts,pd.to_datetime(spl_dates[0]).strftime('%Y%m%d'),
          pd.to_datetime(spl_dates[-1]).strftime('%Y%m%d')), sep=',')
    # ssrd
    ssrdl_df.index.name = domain
    ssrdl_df.to_csv(DIR_OUT+'ERA5_%s%d_ssrd_%s_%s.csv'
        %(domain,vnuts,pd.to_datetime(ssrdl_dates[0]).strftime('%Y%m%d'),
          pd.to_datetime(ssrdl_dates[-1]).strftime('%Y%m%d')), sep=',')
    ssrdl_df_wt.index.name = domain
    ssrdl_df_wt.to_csv(DIR_OUT+'ERA5_%s%d_ssrd_%s_%s_popwtd.csv'
        %(domain,vnuts,pd.to_datetime(ssrdl_dates[0]).strftime('%Y%m%d'),
          pd.to_datetime(ssrdl_dates[-1]).strftime('%Y%m%d')), sep=',')
    # swvl1
    swvl1l_df.index.name = domain
    swvl1l_df.to_csv(DIR_OUT+'ERA5_%s%d_swvl1_%s_%s.csv'
        %(domain,vnuts,pd.to_datetime(swvl1l_dates[0]).strftime('%Y%m%d'),
          pd.to_datetime(swvl1l_dates[-1]).strftime('%Y%m%d')), sep=',')
    swvl1l_df_wt.index.name = domain
    swvl1l_df_wt.to_csv(DIR_OUT+'ERA5_%s%d_swvl1_%s_%s_popwtd.csv'
        %(domain,vnuts,pd.to_datetime(swvl1l_dates[0]).strftime('%Y%m%d'),
          pd.to_datetime(swvl1l_dates[-1]).strftime('%Y%m%d')), sep=',')
    # swvl2
    swvl2l_df.index.name = domain
    swvl2l_df.to_csv(DIR_OUT+'ERA5_%s%d_swvl2_%s_%s.csv'
        %(domain,vnuts,pd.to_datetime(swvl2l_dates[0]).strftime('%Y%m%d'),
          pd.to_datetime(swvl2l_dates[-1]).strftime('%Y%m%d')), sep=',')
    swvl2l_df_wt.index.name = domain
    swvl2l_df_wt.to_csv(DIR_OUT+'ERA5_%s%d_swvl2_%s_%s_popwtd.csv'
        %(domain,vnuts,pd.to_datetime(swvl2l_dates[0]).strftime('%Y%m%d'),
          pd.to_datetime(swvl2l_dates[-1]).strftime('%Y%m%d')), sep=',')    
    # swvl3
    swvl3l_df.index.name = domain
    swvl3l_df.to_csv(DIR_OUT+'ERA5_%s%d_swvl3_%s_%s.csv'
        %(domain,vnuts,pd.to_datetime(swvl3l_dates[0]).strftime('%Y%m%d'),
          pd.to_datetime(swvl3l_dates[-1]).strftime('%Y%m%d')), sep=',')
    swvl3l_df_wt.index.name = domain
    swvl3l_df_wt.to_csv(DIR_OUT+'ERA5_%s%d_swvl3_%s_%s_popwtd.csv'
        %(domain,vnuts,pd.to_datetime(swvl3l_dates[0]).strftime('%Y%m%d'),
          pd.to_datetime(swvl3l_dates[-1]).strftime('%Y%m%d')), sep=',')
    # swvl4
    swvl4l_df.index.name = domain
    swvl4l_df.to_csv(DIR_OUT+'ERA5_%s%d_swvl4_%s_%s.csv'
        %(domain,vnuts,pd.to_datetime(swvl4l_dates[0]).strftime('%Y%m%d'),
          pd.to_datetime(swvl4l_dates[-1]).strftime('%Y%m%d')), sep=',')
    swvl4l_df_wt.index.name = domain
    swvl4l_df_wt.to_csv(DIR_OUT+'ERA5_%s%d_swvl4_%s_%s_popwtd.csv'
        %(domain,vnuts,pd.to_datetime(swvl4l_dates[0]).strftime('%Y%m%d'),
          pd.to_datetime(swvl4l_dates[-1]).strftime('%Y%m%d')), sep=',')
    # t2mmax
    t2mmaxl_df.index.name = domain
    t2mmaxl_df.to_csv(DIR_OUT+'ERA5_%s%d_t2mmax_%s_%s.csv'
        %(domain,vnuts,pd.to_datetime(t2mmaxl_dates[0]).strftime('%Y%m%d'),
          pd.to_datetime(t2mmaxl_dates[-1]).strftime('%Y%m%d')), sep=',')
    t2mmaxl_df_wt.index.name = domain
    t2mmaxl_df_wt.to_csv(DIR_OUT+'ERA5_%s%d_t2mmax_%s_%s_popwtd.csv'
        %(domain,vnuts,pd.to_datetime(t2mmaxl_dates[0]).strftime('%Y%m%d'),
          pd.to_datetime(t2mmaxl_dates[-1]).strftime('%Y%m%d')), sep=',')
    # t2mmin
    t2mminl_df.index.name = domain
    t2mminl_df.to_csv(DIR_OUT+'ERA5_%s%d_t2mmin_%s_%s.csv'
        %(domain,vnuts,pd.to_datetime(t2mminl_dates[0]).strftime('%Y%m%d'),
          pd.to_datetime(t2mminl_dates[-1]).strftime('%Y%m%d')), sep=',')
    t2mminl_df_wt.index.name = domain
    t2mminl_df_wt.to_csv(DIR_OUT+'ERA5_%s%d_t2mmin_%s_%s_popwtd.csv'
        %(domain,vnuts,pd.to_datetime(t2mminl_dates[0]).strftime('%Y%m%d'),
          pd.to_datetime(t2mminl_dates[-1]).strftime('%Y%m%d')), sep=',')
    # t2mavg
    t2mavgl_df.index.name = domain
    t2mavgl_df.to_csv(DIR_OUT+'ERA5_%s%d_t2mavg_%s_%s.csv'
        %(domain,vnuts,pd.to_datetime(t2mavgl_dates[0]).strftime('%Y%m%d'),
          pd.to_datetime(t2mavgl_dates[-1]).strftime('%Y%m%d')), sep=',')
    t2mavgl_df_wt.index.name = domain
    t2mavgl_df_wt.to_csv(DIR_OUT+'ERA5_%s%d_t2mavg_%s_%s_popwtd.csv'
        %(domain,vnuts,pd.to_datetime(t2mavgl_dates[0]).strftime('%Y%m%d'),
          pd.to_datetime(t2mavgl_dates[-1]).strftime('%Y%m%d')), sep=',')
    # tp
    tpl_df.index.name = domain
    tpl_df.to_csv(DIR_OUT+'ERA5_%s%d_tp_%s_%s.csv'
        %(domain,vnuts,pd.to_datetime(tpl_dates[0]).strftime('%Y%m%d'),
          pd.to_datetime(tpl_dates[-1]).strftime('%Y%m%d')), sep=',')
    tpl_df_wt.index.name = domain
    tpl_df_wt.to_csv(DIR_OUT+'ERA5_%s%d_tp_%s_%s_popwtd.csv'
        %(domain,vnuts,pd.to_datetime(tpl_dates[0]).strftime('%Y%m%d'),
          pd.to_datetime(tpl_dates[-1]).strftime('%Y%m%d')), sep=',')    
    # u10
    u10l_df.index.name = domain
    u10l_df.to_csv(DIR_OUT+'ERA5_%s%d_u10_%s_%s.csv'
        %(domain,vnuts,pd.to_datetime(u10l_dates[0]).strftime('%Y%m%d'),
          pd.to_datetime(u10l_dates[-1]).strftime('%Y%m%d')), sep=',')
    u10l_df_wt.index.name = domain
    u10l_df_wt.to_csv(DIR_OUT+'ERA5_%s%d_u10_%s_%s_popwtd.csv'
        %(domain,vnuts,pd.to_datetime(u10l_dates[0]).strftime('%Y%m%d'),
          pd.to_datetime(u10l_dates[-1]).strftime('%Y%m%d')), sep=',')
    # v10
    v10l_df.index.name = domain
    v10l_df.to_csv(DIR_OUT+'ERA5_%s%d_v10_%s_%s.csv'
        %(domain,vnuts,pd.to_datetime(v10l_dates[0]).strftime('%Y%m%d'),
          pd.to_datetime(v10l_dates[-1]).strftime('%Y%m%d')), sep=',')
    v10l_df_wt.index.name = domain
    v10l_df_wt.to_csv(DIR_OUT+'ERA5_%s%d_v10_%s_%s_popwtd.csv'
        %(domain,vnuts,pd.to_datetime(v10l_dates[0]).strftime('%Y%m%d'),
          pd.to_datetime(v10l_dates[-1]).strftime('%Y%m%d')), sep=',')
    # slhf
    slhfl_df.index.name = domain
    slhfl_df.to_csv(DIR_OUT+'ERA5_%s%d_slhf_%s_%s.csv'
        %(domain,vnuts,pd.to_datetime(slhfl_dates[0]).strftime('%Y%m%d'),
          pd.to_datetime(slhfl_dates[-1]).strftime('%Y%m%d')), sep=',')
    slhfl_df_wt.index.name = domain
    slhfl_df_wt.to_csv(DIR_OUT+'ERA5_%s%d_slhf_%s_%s_popwtd.csv'
        %(domain,vnuts,pd.to_datetime(slhfl_dates[0]).strftime('%Y%m%d'),
          pd.to_datetime(slhfl_dates[-1]).strftime('%Y%m%d')), sep=',')    
    return 

import numpy as np
from datetime import datetime 
for year in np.arange(2022, 2023, 1):
    # For Europe
    for vnuts in [1,2,3]:
        start = datetime.now()
        print('Extracting NUTS%d subdivisions!'%(vnuts))
        extract_admin_era5(year, vnuts, 'NUTS')
        diff = datetime.now() - start
        print('\n')
        print('Finished in %d seconds!'%diff.seconds)
        print('\n')
    # For Brazil
    for adminlev in [1,2]:
        start = datetime.now()
        print('Extracting IBGE%d subdivisions!'%(adminlev))
        extract_admin_era5(year, adminlev, 'IBGE')
        diff = datetime.now() - start
        print('\n')
        print('Finished in %d seconds!'%diff.seconds)
        print('\n')
