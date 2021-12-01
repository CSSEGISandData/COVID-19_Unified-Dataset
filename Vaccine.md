# Unified COVID-19 Dataset

## Vaccine Data Structure

|      Column      |   Type    | Description                                        |
| :--------------: | :-------: | :------------------------------------------------- |
|     **ID**       | Character | Geospatial ID, unique identifier                   |
|     **Date**     |   Date    | Date of data record                                |
|    **Vaccine**   | Character | Common name of the vaccine provider, or all        |
|   **DoseType**   | Character | Type of the vaccine dose                           |
|  **DoseValue**   |  Double   | Cumulative number of doses                         |
|   **Vax_Full**   |  Double   | Cumulative number of people fully vaccinated       |
|  **Vax_Partial** |  Double   | Cumulative number of people partially vaccinated   |

## Dose Types

|    Type    | Description                          |
| :--------: | :----------------------------------- |
| **Admin**  | Doses administered                   |
| **Alloc**  | Doses allocated                      |
| **Ship**   | Doses shipped/arrived to vax sites   |
| **Stage1** | Doses administered as first          |
| **Stage2** | Doses administered as second         |
