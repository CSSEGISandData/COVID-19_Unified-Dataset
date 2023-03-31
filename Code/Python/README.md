# Unified COVID-19 Dataset

## Hydromet Scripts

`download_era5.py`: Download global [ERA5](https://www.ecmwf.int/en/forecasts/dataset/ecmwf-reanalysis-v5) data at hourly resolution.

`disaggregate_era5.py`: Transform global hourly ERA5 files to daily sums, averages, or extremes.

`extract_aq.py`: Average annual average PM2.5 and NO2 concentrations to administrative units in Europe, Brazil, and the United States.

The following scripts use [CIESIN](http://www.ciesin.columbia.edu) boundary maps to extract area-averaged daily meteorological variables from [ERA5](https://www.ecmwf.int/en/forecasts/dataset/ecmwf-reanalysis-v5) or [NLDAS](https://ldas.gsfc.nasa.gov/nldas) reanalysis, as pre-processed by `download_era5.py` and`disaggregate_era5.py`. Results are presented for flat averages and population-weighted daily values, using Gridded Population of the World v4 population maps:

### [ERA5](https://www.ecmwf.int/en/forecasts/dataset/ecmwf-reanalysis-v5)

`extract_global_era5.py`: Extract daily hydromet data globally at the country level (Admin0) from [ERA5](https://www.ecmwf.int/en/forecasts/dataset/ecmwf-reanalysis-v5) reanalysis.

`extract_nuts_era5.py`: Extract daily hydromet data for Europe and Brazil (all administrative units) from [ERA5](https://www.ecmwf.int/en/forecasts/dataset/ecmwf-reanalysis-v5) reanalysis.

`extract_sa_era5.py`: Extract daily hydromet data for South America (Admin1) from [ERA5](https://www.ecmwf.int/en/forecasts/dataset/ecmwf-reanalysis-v5) reanalysis.

`extract_us_states_era5.py`: Extract daily hydromet data for US States (Admin1) from [ERA5](https://www.ecmwf.int/en/forecasts/dataset/ecmwf-reanalysis-v5) reanalysis.

`extract_us_counties_era5.py`: Extract daily hydromet data for US Counties (Admin2) from [ERA5](https://www.ecmwf.int/en/forecasts/dataset/ecmwf-reanalysis-v5) reanalysis.

### [NLDAS](https://ldas.gsfc.nasa.gov/nldas)

`extract_us_states_nldas.py`: Extract daily hydromet data for US States (Admin1) from [NLDAS](https://ldas.gsfc.nasa.gov/nldas) reanalysis.

`extract_us_counties_nldas.py`: Extract daily hydromet data for US Counties (Admin2) from [NLDAS](https://ldas.gsfc.nasa.gov/nldas) reanalysis.
