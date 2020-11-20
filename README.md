# Unified COVID-19 Dataset
[![Copyright: © 2020 JHU)](https://img.shields.io/badge/Copyright-%C2%A9%202020%20JHU-blue.svg)](https://systems.jhu.edu)
[![Credits: NASA/NIH](https://img.shields.io/badge/Credits-NASA%20&%20NIH-blue.svg)](#Credits)
[![Citation: Badr et. al 2020](https://img.shields.io/badge/Citation-Badr%20et%20al.%202020-blue.svg)](#Citation)
[![License: GPL v3](https://img.shields.io/badge/License-GPLv3-blue.svg)](https://www.gnu.org/licenses/gpl-3.0)
[![GitHub Commit](https://img.shields.io/github/last-commit/CSSEGISandData/COVID-19_Unified-Dataset)](https://github.com/CSSEGISandData/COVID-19_Unified-Dataset/commits/master)

This is an all-in-one harmonized COVID-19 dataset to fulfill the following objectives:
  * Mapping all geospatial units globally into a unique standardized ID.
  * Standardizing administrative names and codes at all levels.
  * Standardizing dates, data types, and formats.
  * Unifying variable names, types, and categories.
  * Merging data from all credible sources at all levels.
  * Cleaning the data and fixing confusing entries.
  * Integrating hydrometeorological variables at all levels.
  * Integrating policy data from Oxford government response tracker.
  * Integrating an augmented version from all sources (*future releases*).
  * Optimizing the data for machine learning applications.

## Coverage Map

<img src="https://hsbadr.github.io/files/COVID-19_Coverage.svg#3" title="Coverage Map for the Unified COVID-19 Dataset" alt="COVID-19 Coverage" style="display: block; margin: auto;" />

## Geospatial ID

<img src="http://hsbadr.github.io/files/COVID-19_ID.svg#3" title="Geospatial ID for the Unified COVID-19 Dataset" alt="COVID-19 ID" style="display: block; margin: auto;" />

Note that COVID-19 data for some European countries from Johns Hopkins University (JHU) Center for Systems Science and Engineering (CSSE) are reported in the global daily reports at province level, which will be replaced by higher-resolution data at NUTS 0-3 levels.

## Lookup Table

|     Column         |    Type    |              Description            |
|:------------------:|:----------:|:------------------------------------|
| **ID**             | Character  | Geospatial ID, unique identifier (described above) |
| **Level**          | Character  | Geospatial level (e.g., Country, Province, State, County, District, and NUTS 0-3) |
| **ISO1_3N**        | Character  | ISO 3166-1 numeric code, 3-digit, administrative level 0 (countries) |
| **ISO1_3C**        | Character  | ISO 3166-1 alpha-3 code, 3-letter, administrative level 0 (countries) |
| **ISO1_2C**        | Character  | ISO 3166-1 alpha-2 code, 2-letter, administrative level 0 (countries) |
| **ISO2**           | Character  | ISO 3166-2 code, principal subdivisions (e.g., provinces and states) |
| **ISO2_UID**       | Character  | ISO 3166-2 code, principal subdivisions (e.g., provinces and states), full unique ID |
| **FIPS**           | Character  | Federal Information Processing Standard (FIPS, United States) |
| **NUTS**           | Character  | Nomenclature of Territorial Units for Statistics (NUTS, Europe) |
| **AGS**            | Character  | Official municipality key / Amtlicher Gemeindeschlüssel (AGS, German regions only) |
| **IBGE**           | Character  | Brazilian municipality code, Brazilian Institute of Geography and Statistics |
| **ZTCA**           | Character  | ZIP Code Tabulation Area (ZCTA, United States) |
| **Longitude**      | Double     | Geospatial coordinate (centroid), east–west |
| **Latitude**       | Double     | Geospatial coordinate (centroid), north–south |
| **Population**     | Integer    | Total population of each geospatial unit |
| **Admin**          | Integer    | Administrative level (0-3) |
| **Admin0**         | Character  | Standard name of administrative level 0 (countries) |
| **Admin1**         | Character  | Standard name of administrative level 1 (e.g., provinces, states, groups of regions) |
| **Admin2**         | Character  | Standard name of administrative level 2 (e.g., counties, municipalities, regions) |
| **Admin3**         | Character  | Standard name of administrative level 3 (e.g., districts and ZTCA) |
| **NameID**         | Character  | Full name ID of combined administrative levels, unique identifier |

## COVID-19 Data Structure

|     Column         |    Type    |              Description            |
|:------------------:|:----------:|:------------------------------------|
| **ID**             | Character  | Geospatial ID, unique identifier (described above) |
| **Date**           | Date       | Date of data record |
| **Cases**          | Integer    | Number of cumulative cases |
| **Cases_New**      | Integer    | Number of new daily cases |
| **Type**           | Character  | Type of the reported cases |
| **Age**            | Character  | Age group of the reported cases |
| **Sex**            | Character  | Sex/gender of the reported cases |
| **Source**         | Character  | Data source: [JHU](https://github.com/CSSEGISandData/COVID-19), [CTP](https://covidtracking.com), [NYC](https://github.com/nychealth/coronavirus-data), [NYT](https://github.com/nytimes/covid-19-data), [SES](https://github.com/wcota/covid19br), [DPC](https://github.com/pcm-dpc/COVID-19), [RKI](https://npgeo-corona-npgeo-de.hub.arcgis.com/datasets/dd4580c810204019a7b8eb3e0b329dd6_0) |

## Case Types

|        Type          |    Description   |
|:--------------------:|:-----------------|
| **Active**           | Active cases |
| **Confirmed**        | Confirmed cases |
| **Deaths**           | Deaths |
| **Home_Confinement** | Home confinement / isolation |
| **Hospitalized**     | Total hospitalized cases excluding intensive care units |
| **Hospitalized_Now** | Currently hospitalized cases excluding intensive care units |
| **Hospitalized_Sym** | Symptomatic hospitalized cases excluding intensive care units |
| **ICU**              | Total cases in intensive care units |
| **ICU_Now**          | Currently in intensive care units |
| **Negative**         | Negative tests |
| **Pending**          | Pending tests |
| **Positive**         | Positive tests, including hospitalised cases and home confinement |
| **Positive_Dx**      | Positive cases emerged from clinical activity / diagnostics |
| **Positive_Sc**      | Positive cases emerging from surveys and tests |
| **Recovered**        | Recovered cases |
| **Tested**           | Cases tested = Tests - Pending |
| **Tests**            | Total performed tests |
| **Ventilator**       | Total cases receiving mechanical ventilation |
| **Ventilator_Now**   | Currently receiving mechanical ventilation |


## Hydromet Data Structure

|     Column         |    Type    |   Unit   |              Description            |
|:------------------:|:----------:|:--------:|:------------------------------------|
| **ID**             | Character  |          | Geospatial ID, unique identifier (described above) |
| **Date**           | Date       |          | Date of data record |
| **T**              | Double     |   °C     | Daily average near-surface air temperature |
| **Tmax**           | Double     |   °C     | Daily maximum near-surface air temperature |
| **Tmin**           | Double     |   °C     | Daily minimum near-surface air temperature |
| **Td**             | Double     |   °C     | Daily average near-surface dew point temperature |
| **Tdd**            | Double     |   °C     | Daily average near-surface dew point depression |
| **RH**             | Double     |    %     | Daily average near-surface relative humidity |
| **SH**             | Double     |  kg/kg   | Daily average near-surface specific humidity |
| **MA**             | Double     |    %     | Daily average moisture availability ([NLDAS](https://ldas.gsfc.nasa.gov/nldas)) |
| **RZSM**           | Double     | kg/m<sup>2</sup> | Daily average root zone soil moisture content ([NLDAS](https://ldas.gsfc.nasa.gov/nldas)) |
| **SM**             | Double     | kg/m<sup>2</sup> | Daily average soil moisture content ([NLDAS](https://ldas.gsfc.nasa.gov/nldas)) |
| **SM1**            | Double     | m<sup>3</sup>/m<sup>3</sup> | Daily average volumetric soil water layer 1 ([ERA5](https://www.ecmwf.int/en/forecasts/datasets/reanalysis-datasets/era5)) |
| **SM2**            | Double     | m<sup>3</sup>/m<sup>3</sup> | Daily average volumetric soil water layer 2 ([ERA5](https://www.ecmwf.int/en/forecasts/datasets/reanalysis-datasets/era5)) |
| **SM3**            | Double     | m<sup>3</sup>/m<sup>3</sup> | Daily average volumetric soil water layer 3 ([ERA5](https://www.ecmwf.int/en/forecasts/datasets/reanalysis-datasets/era5)) |
| **SM4**            | Double     | m<sup>3</sup>/m<sup>3</sup> | Daily average volumetric soil water layer 4 ([ERA5](https://www.ecmwf.int/en/forecasts/datasets/reanalysis-datasets/era5)) |
| **SP**             | Double     |   Pa     | Daily average surface pressure |
| **SR**             | Double     | J/m<sup>2</sup> | Daily average surface downward solar radiation ([ERA5](https://www.ecmwf.int/en/forecasts/datasets/reanalysis-datasets/era5)) |
| **SRL**            | Double     | W/m<sup>2</sup> | Daily average surface downward longwave radiation flux ([NLDAS](https://ldas.gsfc.nasa.gov/nldas)) |
| **SRS**            | Double     | W/m<sup>2</sup> | Daily average surface downward shortwave radiation flux ([NLDAS](https://ldas.gsfc.nasa.gov/nldas)) |
| **LH**             | Double     | J/m<sup>2</sup> | Daily average surface latent heat flux ([ERA5](https://www.ecmwf.int/en/forecasts/datasets/reanalysis-datasets/era5)) |
| **LHF**            | Double     | W/m<sup>2</sup> | Daily average surface latent heat flux ([NLDAS](https://ldas.gsfc.nasa.gov/nldas)) |
| **PE**             | Double     |    m     | Daily average potential evaporation / latent heat flux ([ERA5](https://www.ecmwf.int/en/forecasts/datasets/reanalysis-datasets/era5)) |
| **PEF**            | Double     | W/m<sup>2</sup> | Daily average potential evaporation / latent heat flux ([NLDAS](https://ldas.gsfc.nasa.gov/nldas)) |
| **P**              | Double     |  mm/day  | Daily total precipitation |
| **U**              | Double     |    m/s   | Daily average 10-m above ground Zonal wind speed |
| **V**              | Double     |    m/s   | Daily average 10-m above ground Meridional wind speed |
| **HydrometSource** | Character  |          | Data source: [ERA5](https://www.ecmwf.int/en/forecasts/datasets/reanalysis-datasets/era5), [NLDAS](https://ldas.gsfc.nasa.gov/nldas) |

## Policy Data Structure

|     Column         |    Type    |              Description            |
|:------------------:|:----------:|:------------------------------------|
| **ID**             | Character  | Geospatial ID, unique identifier (described above) |
| **Date**           | Date       | Date of data record |
| **PolicyType**     | Character  | Type of the policy |
| **PolicyValue**    | Double     | Value of the policy |
| **PolicyFlag**     | Logical    | Logical flag for geographic scope |
| **PolicyNotes**    | Character  | Notes on the policy record |
| **PolicySource**   | Character  | Data source: [OxCGRT](https://github.com/OxCGRT) |

## Policy Types

|        Type          |    Description   |
|:--------------------:|:-----------------|
| **CX**               | **Containment and closure policies** |
| **C1**               | School closing |
| **C2**               | Workplace closing |
| **C3**               | Cancel public events |
| **C4**               | Restrictions on gatherings |
| **C5**               | Close public transport |
| **C6**               | Stay at home requirements |
| **C7**               | Restrictions on internal movement |
| **C8**               | International travel controls |
| **EX**               | **Economic policies** |
| **E1**               | Income support |
| **E2**               | Debt/contract relief |
| **E3**               | Fiscal measures |
| **E4**               | International support |
| **HX**               | **health system policies** |
| **H1**               | Public information campaigns |
| **H2**               | Testing policy |
| **H3**               | Contact tracing |
| **H4**               | Emergency investment in healthcare |
| **H5**               | Investment in vaccines |
| **H6**               | Investment in vaccines |
| **MX**               | **Miscellaneous policies** |
| **M1**               | Wildcard |
| **IX**               | **Policy indices** |
| **I1**               | Containment health index |
| **I2**               | Economic support index |
| **I3**               | Government response index |
| **I4**               | Stringency index |
| **IC**               | **Confirmed cases** |
| **ID**               | **Confirmed deaths** |
| **IXD**              | *Policy indices (Display)* |
| **IXL**              | *Policy indices (Legacy)* |
| **IXLD**             | *Policy indices (Legacy, Display)* |

For more details, see OxCGRT's [codebook](https://github.com/OxCGRT/covid-policy-tracker/blob/master/documentation/codebook.md), [index methodology](https://github.com/OxCGRT/covid-policy-tracker/blob/master/documentation/index_methodology.md), [interpretation guide](https://github.com/OxCGRT/covid-policy-tracker/blob/master/documentation/interpretation_guide.md), and [subnational interpretation](https://github.com/OxCGRT/covid-policy-tracker/blob/master/documentation/subnational_interpretation.md).

## Data Sources

|   Source   |   Description    |    Level    |
|:----------:|:-----------------|:------------|
| **JHU**    | [Johns Hopkins University CSSE](https://github.com/CSSEGISandData/COVID-19) | Global & County/State, United States |
| **CTP**    | [The COVID Tracking Project](https://covidtracking.com) | State, United States |
| **NYC**    | [New York City Department of Health and Mental Hygiene](https://github.com/nychealth/coronavirus-data) | ZCTA/Borough, New York City |
| **NYT**    | [The New York Times](https://github.com/nytimes/covid-19-data) | County/State, United States |
| **SES**    | [Monitoring COVID-19 Cases and Deaths in Brazil](https://github.com/wcota/covid19br) | Municipality/State/Country, Brazil |
| **DPC**    | [Italian Civil Protection Department](https://github.com/pcm-dpc/COVID-19) | NUTS 0-3, Italy |
| **RKI**    | [Robert Koch-Institut, Germany](https://npgeo-corona-npgeo-de.hub.arcgis.com/datasets/dd4580c810204019a7b8eb3e0b329dd6_0) | NUTS 0-3, Germany |
| **ERA5**   | [The fifth generation of ECMWF reanalysis](https://www.ecmwf.int/en/forecasts/datasets/reanalysis-datasets/era5) | All levels |
| **NLDAS**  | [North American Land Data Assimilation System](https://ldas.gsfc.nasa.gov/nldas) | County/State, United States |
| **OxCGRT** | [Oxford COVID-19 Government Response Tracker](https://github.com/OxCGRT) | National (global) & subnational (US, UK) |


## Credits

This work is supported by NASA Health & Air Quality project `80NSSC18K0327`, under a COVID-19 supplement, and National Institute of Health (NIH) project `3U19AI135995-03S1` ("Consortium for Viral Systems Biology (CViSB)"; Collaboration with The Scripps Research Institute and UCLA).

## Citation

To cite this dataset:

> Badr, H. S., B. F. Zaitchik, G. H. Kerr, J. M. Colston, P. Hinson, Y. Chen, N. H. Nguyen, M. Kosek, H. Du, E. Dong, M. Marshall, K. Nixon, and L. M. Gardner, **2020**: Unified COVID-19 Dataset.
`https://github.com/CSSEGISandData/COVID-19_Unified-Dataset`.
