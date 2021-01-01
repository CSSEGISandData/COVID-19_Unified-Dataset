# Unified COVID-19 Dataset

## Lookup Table

|     Column     |   Type    | Description                                                                          |
| :------------: | :-------: | :----------------------------------------------------------------------------------- |
|     **ID**     | Character | Geospatial ID, unique identifier                                                     |
|   **Level**    | Character | Geospatial level (e.g., Country, Province, State, County, District, and NUTS 0-3)    |
|  **ISO1_3N**   | Character | ISO 3166-1 numeric code, 3-digit, administrative level 0 (countries)                 |
|  **ISO1_3C**   | Character | ISO 3166-1 alpha-3 code, 3-letter, administrative level 0 (countries)                |
|  **ISO1_2C**   | Character | ISO 3166-1 alpha-2 code, 2-letter, administrative level 0 (countries)                |
|    **ISO2**    | Character | ISO 3166-2 code, principal subdivisions (e.g., provinces and states)                 |
|  **ISO2_UID**  | Character | ISO 3166-2 code, principal subdivisions (e.g., provinces and states), full unique ID |
|    **FIPS**    | Character | Federal Information Processing Standard (FIPS, United States)                        |
|    **NUTS**    | Character | Nomenclature of Territorial Units for Statistics (NUTS, Europe)                      |
|    **AGS**     | Character | Official municipality key / Amtlicher Gemeindeschlüssel (AGS, German regions only)   |
|    **IBGE**    | Character | Brazilian municipality code, Brazilian Institute of Geography and Statistics         |
|    **ZTCA**    | Character | ZIP Code Tabulation Area (ZCTA, United States)                                       |
| **Longitude**  |  Double   | Geospatial coordinate (centroid), east–west                                          |
|  **Latitude**  |  Double   | Geospatial coordinate (centroid), north–south                                        |
| **Population** |  Integer  | Total population of each geospatial unit                                             |
|   **Admin**    |  Integer  | Administrative level (0-3)                                                           |
|   **Admin0**   | Character | Standard name of administrative level 0 (countries)                                  |
|   **Admin1**   | Character | Standard name of administrative level 1 (e.g., provinces, states, groups of regions) |
|   **Admin2**   | Character | Standard name of administrative level 2 (e.g., counties, municipalities, regions)    |
|   **Admin3**   | Character | Standard name of administrative level 3 (e.g., districts and ZTCA)                   |
|   **NameID**   | Character | Full name ID of combined administrative levels, unique identifier                    |
