# Unified COVID-19 Dataset

## Air Quality Data Structure

|       Column       |    Type   |       Unit       | Description                                                                                    |
| :----------------: | :-------: | :--------------: | :--------------------------------------------------------------------------------------------- |
|       **ID**       | Character |                  | Geospatial ID, unique identifier                                                               |
|      **PM2.5**     |  double   | µg/m<sup>3</sup> | Fine particulate matter (PM<sub>2.5</sub>) concentration (2014-2018 mean)                      |
|  **PM2.5_PopWtd**  |  double   | µg/m<sup>3</sup> | Fine particulate matter (PM<sub>2.5</sub>) concentration (2014-2018 mean, population weighted) |
|       **NO2**      |  double   |       ppbv       | Nitrogen dioxide (NO<sub>2</sub>) concentration (2014-2018 mean)                               |
|   **NO2_PopWtd**   |  double   |       ppbv       | Nitrogen dioxide (NO<sub>2</sub>) concentration (2014-2018 mean, population weighted)          |

## Hydromet Data Structure

|       Column       |   Type    |            Unit             | Description                                                                                                                                                                       |
| :----------------: | :-------: | :-------------------------: | :-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
|       **ID**       | Character |                             | Geospatial ID, unique identifier                                                                                                                                                  |
|      **Date**      |   Date    |                             | Date of data record                                                                                                                                                               |
|       **T**        |  Double   |             °C              | Daily average near-surface air temperature                                                                                                                                        |
|      **Tmax**      |  Double   |             °C              | Daily maximum near-surface air temperature                                                                                                                                        |
|      **Tmin**      |  Double   |             °C              | Daily minimum near-surface air temperature                                                                                                                                        |
|       **Td**       |  Double   |             °C              | Daily average near-surface dew point temperature                                                                                                                                  |
|      **Tdd**       |  Double   |             °C              | Daily average near-surface dew point depression                                                                                                                                   |
|       **RH**       |  Double   |              %              | Daily average near-surface relative humidity                                                                                                                                      |
|       **SH**       |  Double   |            kg/kg            | Daily average near-surface specific humidity                                                                                                                                      |
|       **MA**       |  Double   |              %              | Daily average moisture availability ([NLDAS](https://ldas.gsfc.nasa.gov/nldas))                                                                                                   |
|      **RZSM**      |  Double   |      kg/m<sup>2</sup>       | Daily average root zone soil moisture content ([NLDAS](https://ldas.gsfc.nasa.gov/nldas))                                                                                         |
|       **SM**       |  Double   |      kg/m<sup>2</sup>       | Daily average soil moisture content ([NLDAS](https://ldas.gsfc.nasa.gov/nldas))                                                                                                   |
|      **SM1**       |  Double   | m<sup>3</sup>/m<sup>3</sup> | Daily average volumetric soil water layer 1 ([ERA5](https://www.ecmwf.int/en/forecasts/datasets/reanalysis-datasets/era5))                                                        |
|      **SM2**       |  Double   | m<sup>3</sup>/m<sup>3</sup> | Daily average volumetric soil water layer 2 ([ERA5](https://www.ecmwf.int/en/forecasts/datasets/reanalysis-datasets/era5))                                                        |
|      **SM3**       |  Double   | m<sup>3</sup>/m<sup>3</sup> | Daily average volumetric soil water layer 3 ([ERA5](https://www.ecmwf.int/en/forecasts/datasets/reanalysis-datasets/era5))                                                        |
|      **SM4**       |  Double   | m<sup>3</sup>/m<sup>3</sup> | Daily average volumetric soil water layer 4 ([ERA5](https://www.ecmwf.int/en/forecasts/datasets/reanalysis-datasets/era5))                                                        |
|       **SP**       |  Double   |             Pa              | Daily average surface pressure                                                                                                                                                    |
|       **SR**       |  Double   |       J/m<sup>2</sup>       | Daily average surface downward solar radiation ([ERA5](https://www.ecmwf.int/en/forecasts/datasets/reanalysis-datasets/era5))                                                     |
|      **SRL**       |  Double   |       W/m<sup>2</sup>       | Daily average surface downward longwave radiation flux ([NLDAS](https://ldas.gsfc.nasa.gov/nldas))                                                                                |
|      **SRS**       |  Double   |       W/m<sup>2</sup>       | Daily average surface downward shortwave radiation flux ([NLDAS](https://ldas.gsfc.nasa.gov/nldas))                                                                               |
|       **LH**       |  Double   |       J/m<sup>2</sup>       | Daily average surface latent heat flux ([ERA5](https://www.ecmwf.int/en/forecasts/datasets/reanalysis-datasets/era5))                                                             |
|      **LHF**       |  Double   |       W/m<sup>2</sup>       | Daily average surface latent heat flux ([NLDAS](https://ldas.gsfc.nasa.gov/nldas))                                                                                                |
|       **PE**       |  Double   |              m              | Daily average potential evaporation / latent heat flux ([ERA5](https://www.ecmwf.int/en/forecasts/datasets/reanalysis-datasets/era5))                                             |
|      **PEF**       |  Double   |       W/m<sup>2</sup>       | Daily average potential evaporation / latent heat flux ([NLDAS](https://ldas.gsfc.nasa.gov/nldas))                                                                                |
|       **P**        |  Double   |           mm/day            | Daily total precipitation                                                                                                                                                         |
|       **U**        |  Double   |             m/s             | Daily average 10-m above ground Zonal wind speed                                                                                                                                  |
|       **V**        |  Double   |             m/s             | Daily average 10-m above ground Meridional wind speed                                                                                                                             |
| **HydrometSource** | Character |                             | Data source: [ERA5](https://www.ecmwf.int/en/forecasts/datasets/reanalysis-datasets/era5), [NLDAS](https://ldas.gsfc.nasa.gov/nldas) ± [CIESIN](http://www.ciesin.columbia.edu)\* |

- The hydromet data with `_CIESIN` suffix in `HydrometSource` are population-weighted using Gridded Population of the World ([GPW](https://sedac.ciesin.columbia.edu/data/collection/gpw-v4)), hosted by Center for International Earth Science Information Network ([CIESIN](http://www.ciesin.columbia.edu)).
