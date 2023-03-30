import cdsapi
# Open a new Client instance
c = cdsapi.Client()



# Send your request (download data)
c.retrieve('reanalysis-era5-single-levels', {
    'product_type':'reanalysis',
    'variable':'land_sea_mask',
    'year':'2020',
    'month':'01',
    'day':'01',
    'time':'00:00',
    'format':'netcdf'},
    'era5-land_sea_mask.nc'
    )
