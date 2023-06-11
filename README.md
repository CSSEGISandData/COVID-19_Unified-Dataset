# Unified COVID-19 Dataset

[![Copyright: © 2023 JHU)](https://img.shields.io/badge/Copyright-%C2%A9%202023%20JHU-blue.svg)](https://systems.jhu.edu)
[![Credits: NASA/NIH](https://img.shields.io/badge/Credits-NASA%20&%20NIH-blue.svg)](#Credits)
[![DOI: 10.1038/s41597-023-02276-y](https://zenodo.org/badge/DOI/10.1038%2Fs41597-023-02276-y.svg)](https://doi.org/10.1038/s41597-023-02276-y)
[![GitHub Commit](https://img.shields.io/github/last-commit/CSSEGISandData/COVID-19_Unified-Dataset)](https://github.com/CSSEGISandData/COVID-19_Unified-Dataset/commits/master)

This is a unified COVID-19 dataset to fulfill the following objectives:

- Mapping all geospatial units globally into a unique standardized ID.
- Standardizing administrative names and codes at all levels.
- Standardizing dates, data types, and formats.
- Unifying variable names, types, and categories.
- Merging data from all credible sources at all levels.
- Cleaning the data and fixing confusing entries.
- Integrating hydrometeorological variables at all levels.
- Integrating population-weighted hydrometeorological variables.
- Integrating air quality, comorbidities, WorldPop, and other static data.
- Integrating policy data from Oxford government response tracker.
- Integrating vaccination data from JHU Centers for Civic Impact.
- Integrating estimates of daily infections (cases by date of infection).
- Integrating an augmented version from all sources (_future releases_).
- Generating [epidemiological estimates](https://github.com/hsbadr/COVID-19_Estimates) of infections and effective reproduction number.
- Optimizing the data for machine learning applications.
- Providing multiple data formats, including the lightning fast [`fst`](http://www.fstpackage.org/fst/).
- Providing code to efficiently load and combine/subset the datasets (_coming soon_).

## Coverage Map

<img src="https://hsbadr.github.io/files/COVID-19_Coverage.svg#7" title="Coverage Map for the Unified COVID-19 Dataset" alt="COVID-19 Coverage" style="display: block; margin: auto;" />

## Geospatial ID

<img src="https://hsbadr.github.io/files/COVID-19_ID.svg#3" title="Geospatial ID for the Unified COVID-19 Dataset" alt="COVID-19 ID" style="display: block; margin: auto;" />

Note that COVID-19 data for some European countries from Johns Hopkins University (JHU) Center for Systems Science and Engineering (CSSE) are reported in the global daily reports at province level, which will be replaced by higher-resolution data at NUTS 0-3 levels.

## COVID-19 Data Structure

|    Column     |   Type    | Description                                                                                                                                                                                                                                                                                                                                                                                                                                |
| :-----------: | :-------: | :----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
|    **ID**     | Character | Geospatial ID, unique identifier                                                                                                                                                                                                                                                                                                                                                                                                           |
|   **Date**    |   Date    | Date of data record                                                                                                                                                                                                                                                                                                                                                                                                                        |
|   **Cases**   |  Integer  | Number of cumulative cases                                                                                                                                                                                                                                                                                                                                                                                                                 |
| **Cases_New** |  Integer  | Number of new daily cases                                                                                                                                                                                                                                                                                                                                                                                                                  |
|   **Type**    | Character | Type of the reported cases                                                                                                                                                                                                                                                                                                                                                                                                                 |
|    **Age**    | Character | Age group of the reported cases                                                                                                                                                                                                                                                                                                                                                                                                            |
|    **Sex**    | Character | Sex/gender of the reported cases                                                                                                                                                                                                                                                                                                                                                                                                           |
|  **Source**   | Character | Data source: [JHU](https://github.com/CSSEGISandData/COVID-19), [CTP](https://covidtracking.com), [NYC](https://github.com/nychealth/coronavirus-data), [NYT](https://github.com/nytimes/covid-19-data), [UVA](https://github.com/Phiinson/UVA_CCEP_Public), [SES](https://github.com/wcota/covid19br), [DPC](https://github.com/pcm-dpc/COVID-19), [RKI](https://npgeo-corona-npgeo-de.hub.arcgis.com), [JRC](https://github.com/ec-jrc/COVID-19), [IHME](https://ghdx.healthdata.org/record/ihme-data/covid_19_cumulative_infections) |

## Case Types

|         Type         | Description                                                       |
| :------------------: | :---------------------------------------------------------------- |
|      **Active**      | Active cases                                                      |
|    **Confirmed**     | Confirmed cases                                                   |
|      **Deaths**      | Deaths                                                            |
| **Home_Confinement** | Home confinement / isolation                                      |
|   **Hospitalized**   | Total hospitalized cases excluding intensive care units           |
| **Hospitalized_Now** | Currently hospitalized cases excluding intensive care units       |
| **Hospitalized_Sym** | Symptomatic hospitalized cases excluding intensive care units     |
|       **ICU**        | Total cases in intensive care units                               |
|     **ICU_Now**      | Currently in intensive care units                                 |
|    **Infections**    | Estimated infections                                              |
|     **Negative**     | Negative tests                                                    |
|     **Pending**      | Pending tests                                                     |
|     **Positive**     | Positive tests, including hospitalised cases and home confinement |
|   **Positive_Dx**    | Positive cases emerged from clinical activity / diagnostics       |
|   **Positive_Sc**    | Positive cases emerging from surveys and tests                    |
|    **Recovered**     | Recovered cases                                                   |
|      **Tested**      | Cases tested = Tests - Pending                                    |
|      **Tests**       | Total performed tests                                             |
|    **Ventilator**    | Total cases receiving mechanical ventilation                      |
|  **Ventilator_Now**  | Currently receiving mechanical ventilation                        |

## Lookup Table

[Lookup Table](COVID-19_LUT.md)

## Epidemiological Estimates

[COVID-19 Estimates](https://github.com/hsbadr/COVID-19_Estimates)

## Static Data Structure

[Static Data README](COVID-19_Static.md)

## Hydromet Data Structure

[Hydromet README](Hydromet/README.md)

## Policy Data Structure

[Policy README](Policy.md)

## Vaccine Data Structure

[Vaccine README](Vaccine.md)

## Data Sources

|   Source   | Description                                                                                                               | Level                                    |
| :--------: | :------------------------------------------------------------------------------------------------------------------------ | :--------------------------------------- |
|  **JHU**   | [Johns Hopkins University CSSE](https://github.com/CSSEGISandData/COVID-19)                                               | Global & County/State, United States     |
|  **CTP**   | [The COVID Tracking Project](https://covidtracking.com)                                                                   | State, United States                     |
|  **NYC**   | [New York City Department of Health and Mental Hygiene](https://github.com/nychealth/coronavirus-data)                    | ZCTA/Borough, New York City              |
|  **NYT**   | [The New York Times](https://github.com/nytimes/covid-19-data)                                                            | County/State, United States              |
|  **UVA**   | [University of Virginia School of Medicine](https://github.com/Phiinson/UVA_CCEP_Public)                                  | Municipality/State, South America        |
|  **SES**   | [Monitoring COVID-19 Cases and Deaths in Brazil](https://github.com/wcota/covid19br)                                      | Municipality/State/Country, Brazil       |
|  **DPC**   | [Italian Civil Protection Department](https://github.com/pcm-dpc/COVID-19)                                                | NUTS 0-3, Italy                          |
|  **RKI**   | [Robert Koch-Institut, Germany](https://npgeo-corona-npgeo-de.hub.arcgis.com)                                             | NUTS 0-3, Germany                        |
|  **JRC**   | [Joint Research Centre](https://github.com/ec-jrc/COVID-19)                                                               | Global & NUTS 0-3, Europe                |
|  **ERA5**  | [The fifth generation of ECMWF reanalysis](https://github.com/Phiinson/UVA_CCEP_Public)                                   | All levels                               |
| **NLDAS**  | [North American Land Data Assimilation System](https://ldas.gsfc.nasa.gov/nldas)                                          | County/State, United States              |
| **CIESIN** | [C. for International Earth Science Information Net.](http://www.ciesin.columbia.edu)                                     | Global gridded population                |
| **OxCGRT** | [Oxford COVID-19 Government Response Tracker](https://github.com/OxCGRT)                                                  | National (global) & subnational (US, UK) |
|  **CRC**   | [Johns Hopkins Centers for Civic Impact](https://github.com/govex)                                                        | National (global) & subnational (US)     |
|  **IHME**  | [Institute for Health Metrics and Evaluation](https://ghdx.healthdata.org/record/ihme-data/covid_19_cumulative_infections)| National (global) & subnational (US)     |

## Credits

This work is supported by NASA Health & Air Quality project `80NSSC18K0327`, under a COVID-19 supplement, and National Institute of Health (NIH) project `3U19AI135995-03S1` ("Consortium for Viral Systems Biology (CViSB)"; Collaboration with The Scripps Research Institute and UCLA).

## Citation

To cite this dataset:

> Badr, H.S., Zaitchik, B.F., Kerr, G.H. et al. Unified real-time environmental-epidemiological data for multiscale modeling of the COVID-19 pandemic. *Sci Data* **10**, 367 (2023). https://doi.org/10.1038/s41597-023-02276-y

### BibTeX

```latex
@article{Badr2023,
	title        = {Unified real-time environmental-epidemiological data for multiscale modeling of the COVID-19 pandemic},
	author       = {Badr, Hamada S. and Zaitchik, Benjamin F. and Kerr, Gaige H. and Nguyen, Nhat-Lan H. and Chen, Yen-Ting and Hinson, Patrick and Colston, Josh M. and Kosek, Margaret N. and Dong, Ensheng and Du, Hongru and Marshall, Maximilian and Nixon, Kristen and Mohegh, Arash and Goldberg, Daniel L. and Anenberg, Susan C. and Gardner, Lauren M.},
	year         = 2023,
	month        = {Jun},
	day          = {07},
	journal      = {Scientific Data},
	volume       = 10,
	number       = 1,
	pages        = 367,
	doi          = {10.1038/s41597-023-02276-y},
	issn         = {2052-4463},
	url          = {https://doi.org/10.1038/s41597-023-02276-y},
	abstract     = {An impressive number of COVID-19 data catalogs exist. However, none are fully optimized for data science applications. Inconsistent naming and data conventions, uneven quality control, and lack of alignment between disease data and potential predictors pose barriers to robust modeling and analysis. To address this gap, we generated a unified dataset that integrates and implements quality checks of the data from numerous leading sources of COVID-19 epidemio logical and environmental data. We use a globally consistent hierarchy of administrative units to facilitate analysis within and across countries. The dataset applies this unified hierarchy to align COVID-19 epidemiological data with a number of other data types relevant to understanding and predicting COVID-19 risk, including hydrometeorological data, air quality, information on COVID-19 control policies, vaccine data, and key demographic characteristics.}
}
```

### RIS
```ris
TY  - JOUR
AU  - Badr, Hamada S.
AU  - Zaitchik, Benjamin F.
AU  - Kerr, Gaige H.
AU  - Nguyen, Nhat-Lan H.
AU  - Chen, Yen-Ting
AU  - Hinson, Patrick
AU  - Colston, Josh M.
AU  - Kosek, Margaret N.
AU  - Dong, Ensheng
AU  - Du, Hongru
AU  - Marshall, Maximilian
AU  - Nixon, Kristen
AU  - Mohegh, Arash
AU  - Goldberg, Daniel L.
AU  - Anenberg, Susan C.
AU  - Gardner, Lauren M.
PY  - 2023
DA  - 2023/06/07
TI  - Unified real-time environmental-epidemiological data for multiscale modeling of the COVID-19 pandemic
JO  - Scientific Data
SP  - 367
VL  - 10
IS  - 1
AB  - An impressive number of COVID-19 data catalogs exist. However, none are fully optimized for data science applications. Inconsistent naming and data conventions, uneven quality control, and lack of alignment between disease data
 and potential predictors pose barriers to robust modeling and analysis. To address this gap, we generated a unified dataset that integrates and implements quality checks of the data from numerous leading sources of COVID-19 epidemio
logical and environmental data. We use a globally consistent hierarchy of administrative units to facilitate analysis within and across countries. The dataset applies this unified hierarchy to align COVID-19 epidemiological data with
 a number of other data types relevant to understanding and predicting COVID-19 risk, including hydrometeorological data, air quality, information on COVID-19 control policies, vaccine data, and key demographic characteristics.
SN  - 2052-4463
UR  - https://doi.org/10.1038/s41597-023-02276-y
DO  - 10.1038/s41597-023-02276-y
ID  - Badr2023
ER  -
```
