# Unified COVID-19 Dataset

[![Copyright: © 2021 JHU)](https://img.shields.io/badge/Copyright-%C2%A9%202021%20JHU-blue.svg)](https://systems.jhu.edu)
[![Credits: NASA/NIH](https://img.shields.io/badge/Credits-NASA%20&%20NIH-blue.svg)](#Credits)
[![DOI: 10.1101/2021.05.05.21256712](https://zenodo.org/badge/DOI/10.1101%2F2021.05.05.21256712.svg)](https://doi.org/10.1101/2021.05.05.21256712)
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
- Integrating an augmented version from all sources (_future releases_).
- Optimizing the data for machine learning applications.

## Coverage Map

<img src="https://hsbadr.github.io/files/COVID-19_Coverage.svg#5" title="Coverage Map for the Unified COVID-19 Dataset" alt="COVID-19 Coverage" style="display: block; margin: auto;" />

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
|  **Source**   | Character | Data source: [JHU](https://github.com/CSSEGISandData/COVID-19), [CTP](https://covidtracking.com), [NYC](https://github.com/nychealth/coronavirus-data), [NYT](https://github.com/nytimes/covid-19-data), [UVA](https://github.com/Phiinson/UVA_CCEP_Public), [SES](https://github.com/wcota/covid19br), [DPC](https://github.com/pcm-dpc/COVID-19), [RKI](https://npgeo-corona-npgeo-de.hub.arcgis.com/datasets/dd4580c810204019a7b8eb3e0b329dd6_0), [JRC](https://github.com/ec-jrc/COVID-19) |

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

## Static Data Structure

[Static Data README](COVID-19_Static.md)

## Hydromet Data Structure

[Hydromet README](Hydromet/README.md)

## Policy Data Structure

[Policy README](Policy.md)

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
|  **RKI**   | [Robert Koch-Institut, Germany](https://npgeo-corona-npgeo-de.hub.arcgis.com/datasets/dd4580c810204019a7b8eb3e0b329dd6_0) | NUTS 0-3, Germany                        |
|  **JRC**   | [Joint Research Centre](https://github.com/ec-jrc/COVID-19)                                                               | Global & NUTS 0-3, Europe                |
|  **ERA5**  | [The fifth generation of ECMWF reanalysis](https://www.ecmwf.int/en/forecasts/datasets/reanalysis-datasets/era5)          | All levels                               |
| **NLDAS**  | [North American Land Data Assimilation System](https://ldas.gsfc.nasa.gov/nldas)                                          | County/State, United States              |
| **CIESIN** | [C. for International Earth Science Information Net.](http://www.ciesin.columbia.edu)                                     | Global gridded population                |
| **OxCGRT** | [Oxford COVID-19 Government Response Tracker](https://github.com/OxCGRT)                                                  | National (global) & subnational (US, UK) |

## Credits

This work is supported by NASA Health & Air Quality project `80NSSC18K0327`, under a COVID-19 supplement, and National Institute of Health (NIH) project `3U19AI135995-03S1` ("Consortium for Viral Systems Biology (CViSB)"; Collaboration with The Scripps Research Institute and UCLA).

## Citation

To cite this dataset:

> Badr, H. S., B. F. Zaitchik, G. H. Kerr, N. Nguyen, Y. Chen, P. Hinson, J. M. Colston, M. N. Kosek, E. Dong, H. Du, M. Marshall, K. Nixon, A. Mohegh, D. L. Goldberg, S. C. Anenberg, and L. M. Gardner, **2021**: Unified real-time environmental-epidemiological data for multiscale modeling of the COVID-19 pandemic. *MedRxiv*, 2021.05.05.21256712.

### BibTeX

```latex
@article {Badr2021.05.05.21256712,
	author = {Badr, Hamada S. and Zaitchik, Benjamin F. and Kerr, Gaige H. and Nguyen, Nhat-Lan and Chen, Yen-Ting and Hinson, Patrick and Colston, Josh M. and Kosek, Margaret N. and Dong, Ensheng and Du, Hongru and Marshall, Maximilian and Nixon, Kristen and Mohegh, Arash and Goldberg, Daniel L. and Anenberg, Susan C. and Gardner, Lauren M.},
	title = {Unified real-time environmental-epidemiological data for multiscale modeling of the COVID-19 pandemic},
	elocation-id = {2021.05.05.21256712},
	year = {2021},
	doi = {10.1101/2021.05.05.21256712},
	publisher = {Cold Spring Harbor Laboratory Press},
	abstract = {An impressive number of COVID-19 data catalogs exist. None, however, are optimized for data science applications, e.g., inconsistent naming and data conventions, uneven quality control, and lack of alignment between disease data and potential predictors pose barriers to robust modeling and analysis. To address this gap, we generated a unified dataset that integrates and implements quality checks of the data from numerous leading sources of COVID-19 epidemiological and environmental data. We use a globally consistent hierarchy of administrative units to facilitate analysis within and across countries. The dataset applies this unified hierarchy to align COVID-19 case data with a number of other data types relevant to understanding and predicting COVID-19 risk, including hydrometeorological data, air quality, information on COVID-19 control policies, and key demographic characteristics.Competing Interest StatementThe authors have declared no competing interest.Funding StatementThis work is supported by NASA Health \&amp; Air Quality project 80NSSC18K0327, under a COVID-19 supplement, National Institute of Health (NIH) project 3U19AI135995-03S1 ("Consortium for Viral Systems Biology (CViSB)"; Collaboration with The Scripps Research Institute and UCLA), and NASA grant 80NSSC20K1122. Johns Hopkins Applied Physics Laboratory (APL), Data Services and Esri provide professional support on designing the automatic data collection structure, and maintaining the JHU CSSE GitHub repository.Author DeclarationsI confirm all relevant ethical guidelines have been followed, and any necessary IRB and/or ethics committee approvals have been obtained.YesThe details of the IRB/oversight body that provided approval or exemption for the research described are given below:IRB approval is not required.All necessary patient/participant consent has been obtained and the appropriate institutional forms have been archived.YesI understand that all clinical trials and any other prospective interventional studies must be registered with an ICMJE-approved registry, such as ClinicalTrials.gov. I confirm that any such study reported in the manuscript has been registered and the trial registration ID is provided (note: if posting a prospective study registered retrospectively, please provide a statement in the trial ID field explaining why the study was not registered in advance).Yes I have followed all appropriate research reporting guidelines and uploaded the relevant EQUATOR Network research reporting checklist(s) and other pertinent material as supplementary files, if applicable.YesThe source code used to clean, unify, aggregate, and merge the different data components from all sources will be available on GitHub.https://github.com/CSSEGISandData/COVID-19_Unified-Dataset},
	URL = {https://www.medrxiv.org/content/early/2021/05/07/2021.05.05.21256712},
	eprint = {https://www.medrxiv.org/content/early/2021/05/07/2021.05.05.21256712.full.pdf},
	journal = {medRxiv}
}
```
