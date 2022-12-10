# Unified COVID-19 Dataset

## Policy Data Structure

|      Column      |   Type    | Description                                        |
| :--------------: | :-------: | :------------------------------------------------- |
|      **ID**      | Character | Geospatial ID, unique identifier                   |
|     **Date**     |   Date    | Date of data record                                |
| **Jurisdiction** | Character | Level of the policy jurisdiction                   |
|  **PolicyType**  | Character | Type of the policy                                 |
| **PolicyValue**  |  Double   | Value of the policy                                |
|  **PolicyFlag**  |  Logical  | Logical flag for geographic scope                  |
| **PolicyNotes**  | Character | Notes on the policy record                         |
| **PolicySource** | Character | Data source: [OxCGRT](https://github.com/OxCGRT)   |

## Policy Types

|   Type   | Description                          |
| :------: | :----------------------------------- |
|  **CX**  | **Containment and closure policies** |
|  **C1**  | School closing                       |
|  **C2**  | Workplace closing                    |
|  **C3**  | Cancel public events                 |
|  **C4**  | Restrictions on gatherings           |
|  **C5**  | Close public transport               |
|  **C6**  | Stay at home requirements            |
|  **C7**  | Restrictions on internal movement    |
|  **C8**  | International travel controls        |
|  **EX**  | **Economic policies**                |
|  **E1**  | Income support                       |
|  **E2**  | Debt/contract relief                 |
|  **E3**  | Fiscal measures                      |
|  **E4**  | International support                |
|  **HX**  | **health system policies**           |
|  **H1**  | Public information campaigns         |
|  **H2**  | Testing policy                       |
|  **H3**  | Contact tracing                      |
|  **H4**  | Emergency investment in healthcare   |
|  **H5**  | Investment in vaccines               |
|  **H6**  | Investment in vaccines               |
|  **H7**  | Vaccination policy                   |
|  **H8**  | Protection of elderly people         |
|  **MX**  | **Miscellaneous policies**           |
|  **M1**  | Wildcard                             |
|  **VX**  | **Vaccine policies**                 |
|  **V1**  | Vaccine prioritisation               |
|  **V2**  | Vaccine availability                 |
|  **V2A** | Vaccine availability (summary)       |
|  **V2B** | Vaccine availability (age, general)  |
|  **V2C** | Vaccine availability (age, at risk)  |
|  **V2D** | Vaccine availability (medically)     |
|  **V2E** | Vaccine availability (education)     |
|  **V2F** | Vaccine availability (frontline)     |
|  **V2G** | Vaccine availability (healthcare)    |
|  **V3**  | Vaccine financial support            |
|  **V4**  | Vaccine requirement/mandate          |
|  **IX**  | **Policy indices**                   |
|  **I1**  | Containment health index             |
|  **I2**  | Economic support index               |
|  **I3**  | Government response index            |
|  **I4**  | Stringency index                     |
| *Cases*  | **Confirmed cases**                  |
| *Deaths* | **Confirmed deaths**                 |
| **IXD**  | _Policy indices (Display)_           |
| **IXL**  | _Policy indices (Legacy)_            |
| **IXLD** | _Policy indices (Legacy, Display)_   |
| **IXS**  | _Policy indices (Simple Average)_    |
| **IXW**  | _Policy indices (Weighted Average)_  |

## Policy Type Suffixes (differentiated policies)

|   Type   | Description                            |
| :------: | :------------------------------------- |
|  **E**   | Apply to everyone                      |
|  **EV**  | Apply to everyone or vaccinated people |
|  **NV**  | Apply to non-vaccinated people         |
|  **V**   | Apply to vaccinated people             |
|  **M**   | Apply to the majority                  |

For more details, see OxCGRT's [codebook](https://github.com/OxCGRT/covid-policy-tracker/blob/master/documentation/codebook.md), [index methodology](https://github.com/OxCGRT/covid-policy-tracker/blob/master/documentation/index_methodology.md), [interpretation guide](https://github.com/OxCGRT/covid-policy-tracker/blob/master/documentation/interpretation_guide.md), and [subnational interpretation](https://github.com/OxCGRT/covid-policy-tracker/blob/master/documentation/subnational_interpretation.md).

The policy jurisdiction includes a suffix of `.US` or `.BR`, which cannot be interpreted alongside the primary OxCGRT's global data; see [USA-covid-policy](https://github.com/OxCGRT/USA-covid-policy) and [Brazil-covid-policy](https://github.com/OxCGRT/Brazil-covid-policy) for more details.
