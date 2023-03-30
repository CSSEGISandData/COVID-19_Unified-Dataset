#!/usr/bin/env Rscript
################################################################################
# Copyright 2020-2023 Hamada S. Badr <badr@jhu.edu>
################################################################################

tstart <- Sys.time()

################################################################################

run.dir <- file.path(
  "/mnt",
  if (Sys.info()["nodename"] == "eps-monsoon") {
    "local_drive"
  } else if (Sys.info()["nodename"] == "eps-redwood") {
    "local_drive"
  } else if (Sys.info()["nodename"] == "eps-sahara") {
    "data2"
  } else {
    stop("Please check COVID-19 project directory!")
  },
  "badr",
  "run"
)

#-------------------------------------------------------------------------------

if (!exists("COVID19.dir")) {
  COVID19.dir <- file.path(
    run.dir,
    "COVID-19"
  )
}

#-------------------------------------------------------------------------------

dir.create(
  file.path(
    COVID19.dir,
    "Outputs"
  ),
  showWarnings = FALSE
)

setwd(
  file.path(
    COVID19.dir,
    "Outputs"
  )
)

################################################################################

if (!exists("pluck_multiple")) {
  source(
    file.path(
      COVID19.dir,
      "Modeling",
      "envir.R"
    ),
    local = parent.frame(),
    echo = FALSE,
    max.deparse.length = Inf
  )
}

################################################################################

data(fips_codes)

#-------------------------------------------------------------------------------

github_URL <- "https://raw.githubusercontent.com"

arcgis_URL <- "https://www.arcgis.com"
census_URL <- "https://www2.census.gov"
nycdat_URL <- "https://data.beta.nyc"
gob.mx_URL <- "http://187.191.75.115"

#-------------------------------------------------------------------------------

CSSE.github <- github_URL |>
  file.path(
    "CSSEGISandData"
  )

CSSE.dashboard <- CSSE.github |>
  file.path(
    "COVID-19",
    "master"
  )

CSSE.COVID19 <- CSSE.github |>
  file.path(
    "COVID-19_Unified-Dataset",
    "master"
  )

#-------------------------------------------------------------------------------

COVID19.URL <- CSSE.COVID19 |>
  file.path(
    "${filename}"
  )

#-------------------------------------------------------------------------------

# JHU CSSE UID LUT
UID_URL <- CSSE.dashboard |>
  file.path(
    "csse_covid_19_data",
    "UID_ISO_FIPS_LookUp_Table.csv"
  )

# JHU CSSE timeseries
JHU_URL <- CSSE.dashboard |>
  file.path(
    "csse_covid_19_data",
    "csse_covid_19_time_series",
    "time_series_covid19_${Type}_${Region}.csv"
  )

# JHU CSSE dashboard
JHUD_URL <- CSSE.dashboard |>
  file.path(
    "csse_covid_19_data",
    "csse_covid_19_daily_reports${Region}",
    "${Date}.csv"
  )

#-------------------------------------------------------------------------------

# New York Times
NYT_URL <- github_URL |>
  file.path(
    "nytimes",
    "covid-19-data",
    "master",
    "us-counties.csv"
  )

#-------------------------------------------------------------------------------

# The COVID Tracking Project
CTP_URL <- github_URL |>
  file.path(
    "COVID19Tracking",
    "covid-tracking-data",
    "master",
    "data",
    "states_daily_4pm_et.csv"
  )

#-------------------------------------------------------------------------------

# Italian Civil Protection Department (DPC)
DPC_URL <- github_URL |>
  file.path(
    "pcm-dpc",
    "COVID-19",
    "master",
    "dati-${Region}",
    "dpc-covid19-ita-${Region}.csv"
  )

#-------------------------------------------------------------------------------

# German Robert Koch-Institut (RKI)
RKI_URL <- arcgis_URL |>
  file.path(
    "sharing",
    "rest",
    "content",
    "items",
    "f10774f1c63e40168479a1feb6c7ca74",
    "data"
  )

AGS_JSON <- github_URL |>
  file.path(
    "jgehrcke",
    "covid-19-germany-gae",
    "master",
    "ags.json"
  )

#-------------------------------------------------------------------------------

NYC.repo <- github_URL |>
  file.path(
    "nychealth",
    "coronavirus-data",
    "master"
  )

NYC_MODZCTA_GEO_URL <- NYC.repo |>
  file.path(
    "Geography-resources",
    "MODZCTA_2010_WGS1984.geo.json"
  )

NYC_Borough_Epi_URL <- NYC.repo |>
  file.path(
    "trends",
    "data-by-day.csv"
  )

NYC_CityTot_Epi_URL <- NYC.repo |>
  file.path(
    "trends",
    "data-by-day.csv"
  )

NYC_ZCTA_County_URL <- census_URL |>
  file.path(
    "geo",
    "docs",
    "maps-data",
    "data",
    "rel",
    "zcta_county_rel_10.txt"
  )

NYC_Borough_Pop_URL <- nycdat_URL |>
  file.path(
    "dataset",
    "0ff93d2d-90ba-457c-9f7e-39e47bf2ac5f",
    "resource",
    "7caac650-d082-4aea-9f9b-3681d568e8a5",
    "download",
    "nyc_zip_borough_neighborhoods_pop.csv"
  )

#-------------------------------------------------------------------------------

BR.repo <- github_URL |>
  file.path(
    "wcota",
    "covid19br",
    "master"
  )

BR_URL <- BR.repo |>
  file.path(
    "cases-brazil-cities-time.csv.gz"
  )

BR_GPS <- BR.repo |>
  file.path(
    "gps_cities.csv"
  )

BR_Pop <- BR.repo |>
  file.path(
    "cities_info.csv"
  )

GOBMX_URL <- gob.mx_URL |>
  file.path(
    "gobmx",
    "salud",
    "datos_abiertos",
    "datos_abiertos_covid19.zip"
  )

#-------------------------------------------------------------------------------

JRC_URL <- github_URL |>
  file.path(
    "ec-jrc",
    "COVID-19",
    "master",
    "data-${subdir}",
    "jrc-covid-19-all-days-${subset}.csv"
  )

#-------------------------------------------------------------------------------

BOP_URL <- github_URL |>
  file.path(
    "beoutbreakprepared",
    "nCoV2019",
    "master",
    "latest_data",
    "latestdata.tar.gz"
  )

#-------------------------------------------------------------------------------

OxCGRT_URL <- github_URL |>
  file.path(
    "OxCGRT",
    "${repo}",
    "master",
    "data",
    "${file}"
  )

#-------------------------------------------------------------------------------

# JHU Vaccine
VAX_URL <- github_URL |>
  file.path(
    "govex",
    "COVID-19",
    "master",
    "data_tables",
    "vaccine_data",
    "${region}_data",
    "${file}"
  )

################################################################################

if (!exists("Hydromet.path")) {
  Hydromet.path <- file.path(
    "/mnt",
    case_when(
      Sys.info()["nodename"] == "eps-monsoon" ~ "redwood/local_drive",
      Sys.info()["nodename"] == "eps-redwood" ~ "local_drive",
      Sys.info()["nodename"] == "eps-sahara" ~ "data1",
      TRUE ~ ""
    ),
    "COVID",
    "code",
    "dataprocessing"
  )
}

if (!dir.exists(Hydromet.path)) stop("Please check Hydromet data path!")

NLDAS_PATH <- file.path(
  Hydromet.path,
  "UStables",
  "NLDAStables"
)
ERA5_FIPS_PATH <- file.path(
  Hydromet.path,
  "UStables",
  "ERA5tables"
)
ERA5_NUTS_PATH <- file.path(
  Hydromet.path,
  "ERA5tables"
)

AQ_PATH <- file.path(
  Hydromet.path,
  "AQtables"
)

################################################################################

COVID19.Mpath <- file.path(
  "${mobility_dir}",
  "${Country}",
  "mobility_factor_${mobility_source}_${Country}.csv"
)

# COVID19.Mpath <- COVID19.Mpath |>
#   str_replace(
#     pattern = ".csv",
#     replacement = "_state.csv"
#   )

#-------------------------------------------------------------------------------

Country <- "US"

cases_thresh <- 100

# Hydrometeorological Variables?
hydromet.Flag <- FALSE

mobility_source <- "Teralytics"
mobility_source <- "Safegraph"
if (mobility_source == "Teralytics") {
  mobility_thresh <- 10 # % Total Number of Trips / Population
  mobility_thresh.log.std <- -2
  mobility_baseline.date1 <- as.Date("2020-01-07")
  mobility_baseline.date2 <- as.Date("2020-02-01")
} else {
  mobility_thresh <- 10 # % Total Number of Trips / Population
  mobility_thresh.log.std <- -100
  mobility_baseline.date1 <- as.Date("2020-02-01")
  mobility_baseline.date2 <- as.Date("2020-03-01")
}

################################################################################

#' Clean daily new cases:
#' Spreads negative cases into the future and ... (more cleaning features soon)
#'
#' @param cases A numeric vector of cases
#'
#' @return A numeric vector of cases
#' @examples
#'
#' clean_cases(c(1:10, -10, 1:10))
clean_cases <- function(cases, clean_flag = TRUE) {
  if (clean_flag & length(cases) > 1L & length(cases) == sum(!is.na(cases))) {
    cases <- cases |>
      as.integer()

    overflow <- case_when(
      cases < 0L ~ abs(cases),
      TRUE ~ 0L
    )

    cases <- case_when(
      cases < 0 ~ 0L,
      TRUE ~ cases
    )

    for (i in 1:(length(cases) - 1L)) {
      current_overflow <- overflow[i]
      if (current_overflow > 0L) {
        j <- i + 1L
        while (
          current_overflow > 0L & j < length(cases)
        ) {
          cases[j] <- cases[j] - current_overflow
          if (cases[j] < 0L) {
            current_overflow <- -cases[j]
            cases[j] <- 0L
          } else {
            current_overflow <- 0L
          }
          j <- j + 1L
        }
      }
    }
  }

  return(cases)
}

################################################################################

Unify_Names <- function(Names) {
  Names.Unified <- Names |>
    recode(
      #####################
      # United States (US*):
      #####################
      "Alexandria City" = "Alexandria",
      "Bristol Bay plus Lake Peninsula" =
        "Bristol Bay + Lake and Peninsula",
      "Bristol Bay plus Lake and Peninsula" =
        "Bristol Bay + Lake and Peninsula",
      "Bristol City" = "Bristol",
      "Buena Vista City" = "Buena Vista",
      "Charlottesville City" = "Charlottesville",
      "Chesapeake City" = "Chesapeake",
      "Colonial Heights City" = "Colonial Heights",
      "Covington City" = "Covington",
      "Danville City" = "Danville",
      "Doña Ana" = "Dona Ana",
      "DoÃ±a Ana" = "Dona Ana",
      "Do??a Ana" = "Dona Ana",
      "De Kalb" = "DeKalb",
      "Desoto" = "DeSoto",
      "Dewitt" = "DeWitt",
      "Dupage" = "DuPage",
      "Emporia City" = "Emporia",
      "Falls Church City" = "Falls Church",
      "Fredericksburg City" = "Fredericksburg",
      "Galax City" = "Galax",
      "Hampton City" = "Hampton",
      "Harrisonburg City" = "Harrisonburg",
      "Hopewell City" = "Hopewell",
      "Lake Saint Clair" = "St. Clair",
      "Lake St. Clair" = "St. Clair",
      "La Salle" = "LaSalle",
      "Lexington City" = "Lexington",
      "Lynchburg City" = "Lynchburg",
      "Manassas City" = "Manassas",
      "Manassas Park City" = "Manassas Park",
      "Martinsville City" = "Martinsville",
      "Newport News City" = "Newport News",
      # "New York City" = "New York",
      "Norfolk City" = "Norfolk",
      "Norton City" = "Norton",
      "Pending Assignment" = "Unassigned",
      "Petersburg City" = "Petersburg",
      "Poquoson City" = "Poquoson",
      "Portsmouth City" = "Portsmouth",
      "Radford City" = "Radford",
      "Skagway Municipality" = "Skagway",
      "Salem City" = "Salem",
      "Staunton City" = "Staunton",
      "Suffolk City" = "Suffolk",
      "United States Virgin Islands" = "Virgin Islands",
      "Unknown" = "Unassigned",
      "Virginia Beach City" = "Virginia Beach",
      "Washington DC" = "District of Columbia",
      "Washington, DC" = "District of Columbia",
      "Waynesboro City" = "Waynesboro",
      "Williamsburg City" = "Williamsburg",
      "Winchester City" = "Winchester",
      "Yakutat plus Hoonah-Angoon" = "Yakutat",
      #####################
      #           JRC (EU):
      #####################
      "Czech Republic" = "Czechia",
      "DANMARK" = "Denmark",
      "Faroe Islands" = "Faroe",
      "Guinea Bissau" = "Guinea-Bissau",
      "NOT SPECIFIED" = "Unassigned",
      "SHQIPERIA" = "Albania",
      #####################
      #     Belgium (BE*):
      #####################
      "Antwerpen" = "Antwerp",
      "Bruxelles-Capitale, Region de;Brussels Hoofdstedelijk Gewest" =
        "Brussels",
      "Bruxelles-Capitale, Region de" = "Brussels",
      "Brussels Hoofdstedelijk Gewest" = "Brussels",
      "Vlaams-Brabant" = "Flemish Brabant",
      "Vlaams Gewest" = "Flemish Region",
      "wallonne, Region" = "Walloon Brabant",
      "Oost-Vlaanderen" = "East Flanders",
      "West-Vlaanderen" = "West Flanders",
      #####################
      #       Canada (CA*):
      #####################
      "Yukon Territory" = "Yukon",
      #####################
      #        China (CN*):
      #####################
      "Anhui Sheng" = "Anhui",
      "Beijing Shi" = "Beijing",
      "Chongqing Shi" = "Chongqing",
      "Fujian Sheng" = "Fujian",
      "Gansu Sheng" = "Gansu",
      "Guangdong Sheng" = "Guangdong",
      "Guangxi Zhuangzu Zizhiqu" = "Guangxi",
      "Guizhou Sheng" = "Guizhou",
      "Hainan Sheng" = "Hainan",
      "Hebei Sheng" = "Hebei",
      "Heilongjiang Sheng" = "Heilongjiang",
      "Henan Sheng" = "Henan",
      "Hong Kong SAR" = "Hong Kong",
      "Hong Kong SAR (see also separate country code entry under HK)" =
        "Hong Kong",
      "Hubei Sheng" = "Hubei",
      "Hunan Sheng" = "Hunan",
      "Jiangsu Sheng" = "Jiangsu",
      "Jiangxi Sheng" = "Jiangxi",
      "Jilin Sheng" = "Jilin",
      "Liaoning Sheng" = "Liaoning",
      "Macau SAR" = "Macau",
      "Macao SAR" = "Macau",
      "Macao SAR (see also separate country code entry under MO)" = "Macau",
      "Mainland China" = "China",
      "Nei Mongol Zizhiqu" = "Inner Mongolia",
      "Ningxia Huizi Zizhiqu" = "Ningxia",
      "Qinghai Sheng" = "Qinghai",
      "Shaanxi Sheng" = "Shaanxi",
      "Shandong Sheng" = "Shandong",
      "Shanghai Shi" = "Shanghai",
      "Shanxi Sheng" = "Shanxi",
      "Sichuan Sheng" = "Sichuan",
      "Tianjin Shi" = "Tianjin",
      "Xizang Zizhiqu" = "Tibet",
      "Xinjiang Uygur Zizhiqu" = "Xinjiang",
      "Yunnan Sheng" = "Yunnan",
      "Zhejiang Sheng" = "Zhejiang",
      #####################
      #       France (FR*):
      #####################
      # "Guadeloupe" = "Guadeloupe",
      "Guyane (française)" = "French Guiana",
      "Fench Guiana" = "French Guiana",
      # "Martinique" = "Martinique",
      # "Mayotte" = "Mayotte",
      "Nouvelle-Calédonie" = "New Caledonia",
      "Polynésie française" = "French Polynesia",
      "La Réunion" = "Reunion",
      "Saint-Barthélemy" = "Saint Barthelemy",
      # "Saint-Martin" = "St Martin",
      "Saint-Martin" = "Saint Martin",
      "Saint-Pierre-et-Miquelon" = "Saint Pierre and Miquelon",
      "St Martin" = "Saint Martin",
      "Terres australes françaises" = "French Southern Territories",
      "Wallis-et-Futuna" = "Wallis and Futuna",
      #####################
      #      Germany (DE*):
      #####################
      "DEUTSCHLAND" = "Germany",
      "Schleswig-Holstein" = "Schleswig Holstein",
      #####################
      #        Italy (IT*):
      #####################
      "ITALIA" = "Italy",
      "Italia" = "Italy",
      "NORD-OVEST" = "Northwest Italy",
      "Nord-Ovest" = "Northwest Italy",
      "SUD" = "South Italy",
      "Sud" = "South Italy",
      "ISOLE" = "Insular Italy",
      "Isole" = "Insular Italy",
      "NORD-EST" = "Northeast Italy",
      "Nord-Est" = "Northeast Italy",
      "CENTRO (IT)" = "Central Italy",
      "Centro (IT)" = "Central Italy",
      # "Aosta" = "Valle d'Aosta",
      "Bolzano" = "Bolzano-Bozen",
      "Emilia Romagna" = "Emilia-Romagna",
      "fuori Regione/P.A." = "Out of Region/Province",
      "Fuori Regione / Provincia Autonoma" = "Out of Region/Province",
      "Friuli Venezia Giulia" = "Friuli-Venezia Giulia",
      "In fase di aggiornamento" = "Unassigned",
      "In fase di definizione" = "Unassigned",
      "In fase di definizione/aggiornamento" = "Unassigned",
      "Massa Carrara" = "Massa-Carrara",
      "P.A. Bolzano" = "Bolzano-Bozen",
      "P.A. Trento" = "Trento",
      "Provincia Autonoma di Bolzano/Bozen" = "Bolzano-Bozen",
      "Provincia Autonoma di Trento" = "Trento",
      "Sardegna" = "Sardinia",
      "Sud Sardinia" = "South Sardinia",
      "Sud Sardegna" = "South Sardinia",
      "Valle d'Aosta/Vallée d'Aoste" = "Valle d'Aosta",
      #####################
      #  Netherlands (NL*):
      #####################
      # "Bonaire, Sint Eustatius and Saba" = "Bonaire",
      "Curacao" = "Curaçao",
      #####################
      #       Brazil (BR*):
      #####################
      "Acre" = "Acre",
      "Alagoas" = "Alagoas",
      "Amazonas" = "Amazonas",
      "Amapá" = "Amapa",
      "Bahia" = "Bahia",
      "CASO SEM LOCALIZAÇÃO DEFINIDA" = "Unassigned",
      "Ceará" = "Ceara",
      "Distrito Federal" = "Distrito Federal",
      "Espírito Santo" = "Espirito Santo",
      "Fernando de Noronha" = "Fernando de Noronha",
      "Goiás" = "Goias",
      "Importados/Indefinidos" = "Unassigned",
      "Maranhão" = "Maranhao",
      "Minas Gerais" = "Minas Gerais",
      "Mato Grosso do Sul" = "Mato Grosso do Sul",
      "Mato Grosso" = "Mato Grosso",
      "Pará" = "Para",
      "Paraíba" = "Paraiba",
      "Pernambuco" = "Pernambuco",
      "Piauí" = "Piaui",
      "Paraná" = "Parana",
      "Rio de Janeiro" = "Rio de Janeiro",
      "Rio Grande do Norte" = "Rio Grande do Norte",
      "Rondônia" = "Rondonia",
      "Roraima" = "Roraima",
      "Rio Grande do Sul" = "Rio Grande do Sul",
      "Santa Catarina" = "Santa Catarina",
      "Sergipe" = "Sergipe",
      "São Paulo" = "Sao Paulo",
      "Tocantins" = "Tocantins",
      #####################
      #        Chile (CL*):
      #####################
      "Aisén del General Carlos Ibáñez del Campo" = "Aysen",
      "Aisen del General Carlos Ibanez del Campo" = "Aysen",
      "Antofagasta" = "Antofagasta",
      "Arica y Parinacota" = "Arica y Parinacota",
      "Araucanía" = "Araucania",
      "La Araucania" = "Araucania",
      "Atacama" = "Atacama",
      "Bío-Bío" = "Biobio",
      "Coquimbo" = "Coquimbo",
      "Libertador General Bernardo O'Higgins" = "OHiggins",
      "Los Lagos" = "Los Lagos",
      "Los Ríos" = "Los Rios",
      "Magallanes y Antártica Chilena" = "Magallanes",
      "Maule" = "Maule",
      "Ñuble Region" = "Nuble",
      "Región Metropolitana de Santiago" = "Metropolitana",
      "Tarapacá" = "Tarapaca",
      "Valparaíso" = "Valparaiso",
      #####################
      #     Columbia (CO*):
      #####################
      "Amazonas" = "Amazonas",
      "Antioquia" = "Antioquia",
      "Arauca" = "Arauca",
      "Atlántico" = "Atlantico",
      "Bolívar" = "Bolivar",
      "Boyacá" = "Boyaca",
      "Caldas" = "Caldas",
      "Caquetá" = "Caqueta",
      "Casanare" = "Casanare",
      "Cauca" = "Cauca",
      "Cesar" = "Cesar",
      "Chocó" = "Choco",
      "Córdoba" = "Cordoba",
      "Cundinamarca" = "Cundinamarca",
      "Distrito Capital de Bogotá" = "Capital District",
      "Guainía" = "Guainia",
      "Guaviare" = "Guaviare",
      "Huila" = "Huila",
      "La Guajira" = "La Guajira",
      "Magdalena" = "Magdalena",
      "Meta" = "Meta",
      "Nariño" = "Narino",
      "Norte de Santander" = "Norte de Santander",
      "Putumayo" = "Putumayo",
      "Quindío" = "Quindio",
      "Risaralda" = "Risaralda",
      "Santander" = "Santander",
      "San Andrés, Providencia y Santa Catalina" = "San Andres y Providencia",
      "Sucre" = "Sucre",
      "Tolima" = "Tolima",
      "Valle del Cauca" = "Valle del Cauca",
      "Vaupés" = "Vaupes",
      "Vichada" = "Vichada",
      #####################
      #        India (IN*):
      #####################
      "Dadar Nagar Haveli" = "Dadra and Nagar Haveli",
      "Dadra and Nagar Haveli and Daman and Diu" = "Dadra and Nagar Haveli",
      #####################
      #        Japan (JP*):
      #####################
      # "Port Quarantine" = "Unassigned",
      #####################
      #     Malaysia (MY*):
      #####################
      "W.P. Kuala Lumpur" = "Kuala Lumpur",
      "Wilayah Persekutuan Kuala Lumpur" = "Kuala Lumpur",
      "W.P. Labuan" = "Labuan",
      "Wilayah Persekutuan Labuan" = "Labuan",
      "W.P. Putrajaya" = "Putrajaya",
      "Wilayah Persekutuan Putrajaya" = "Putrajaya",
      #####################
      #       Mexico (MX*):
      #####################
      "Aguascalientes" = "Aguascalientes",
      "Baja California" = "Baja California",
      "Baja California Sur" = "Baja California Sur",
      "Campeche" = "Campeche",
      "Chihuahua" = "Chihuahua",
      "Chiapas" = "Chiapas",
      "Ciudad de México" = "Ciudad de Mexico",
      "Coahuila de Zaragoza" = "Coahuila",
      "Colima" = "Colima",
      "Durango" = "Durango",
      "Guerrero" = "Guerrero",
      "Guanajuato" = "Guanajuato",
      "Hidalgo" = "Hidalgo",
      "Jalisco" = "Jalisco",
      "México" = "Mexico",
      "Michoacán de Ocampo" = "Michoacan",
      "Morelos" = "Morelos",
      "Nayarit" = "Nayarit",
      "Nuevo León" = "Nuevo Leon",
      "Oaxaca" = "Oaxaca",
      "Puebla" = "Puebla",
      "Querétaro" = "Queretaro",
      "Quintana Roo" = "Quintana Roo",
      "Sinaloa" = "Sinaloa",
      "San Luis Potosí" = "San Luis Potosi",
      "Sonora" = "Sonora",
      "Tabasco" = "Tabasco",
      "Tamaulipas" = "Tamaulipas",
      "Tlaxcala" = "Tlaxcala",
      "Veracruz de Ignacio de la Llave" = "Veracruz",
      "Yucatán" = "Yucatan",
      "Zacatecas" = "Zacatecas",
      #####################
      #     Pakistan (PK*):
      #####################
      "Azad Jammu and Kashmir" = "Azad Kashmir",
      #####################
      #         Peru (PE*):
      #####################
      "Amazonas" = "Amazonas",
      "Ancash" = "Ancash",
      "Apurímac" = "Apurimac",
      "Arequipa" = "Arequipa",
      "Ayacucho" = "Ayacucho",
      "Cajamarca" = "Cajamarca",
      "El Callao" = "Callao",
      "Cusco [Cuzco]" = "Cusco",
      "Huánuco" = "Huanuco",
      "Huancavelica" = "Huancavelica",
      "Ica" = "Ica",
      "Junín" = "Junin",
      "La Libertad" = "La Libertad",
      "Lambayeque" = "Lambayeque",
      # "Municipalidad Metropolitana de Lima" = "Lima",
      "Loreto" = "Loreto",
      "Madre de Dios" = "Madre de Dios",
      "Moquegua" = "Moquegua",
      "Pasco" = "Pasco",
      "Piura" = "Piura",
      "Puno" = "Puno",
      "San Martín" = "San Martin",
      "Tacna" = "Tacna",
      "Tumbes" = "Tumbes",
      "Ucayali" = "Ucayali",
      #####################
      #       Russia (RU*):
      #####################
      "Adygeya, Respublika" = "Adygea Republic",
      "Altay, Respublika" = "Altai Republic",
      "Altayskiy kray" = "Altai Krai",
      "Amurskaya oblast'" = "Amur Oblast",
      "Arkhangel'skaya oblast'" = "Arkhangelsk Oblast",
      "Astrakhanskaya oblast'" = "Astrakhan Oblast",
      "Bashkortostan, Respublika" = "Bashkortostan Republic",
      "Belgorodskaya oblast'" = "Belgorod Oblast",
      "Bryanskaya oblast'" = "Bryansk Oblast",
      "Buryatiya, Respublika" = "Buryatia Republic",
      "Chechenskaya Respublika" = "Chechen Republic",
      "Chelyabinskaya oblast'" = "Chelyabinsk Oblast",
      "Chukotskiy avtonomnyy okrug" = "Chukotka Autonomous Okrug",
      "Chuvashskaya Respublika" = "Chuvashia Republic",
      "Dagestan, Respublika" = "Dagestan Republic",
      "Respublika Ingushetiya" = "Karelia Republic",
      "Irkutiskaya oblast'" = "Irkutsk Oblast",
      "Ivanovskaya oblast'" = "Ivanovo Oblast",
      "Kamchatskiy kray" = "Kamchatka Krai",
      "Kabardino-Balkarskaya Respublika" = "Kabardino-Balkarian Republic",
      "Karachayevo-Cherkesskaya Respublika" = "Karachay-Cherkess Republic",
      "Krasnodarskiy kray" = "Krasnoyarsk Krai",
      "Kemerovskaya oblast'" = "Kemerovo Oblast",
      "Kaliningradskaya oblast'" = "Kaliningrad Oblast",
      "Kurganskaya oblast'" = "Kurgan Oblast",
      "Khabarovskiy kray" = "Khabarovsk Krai",
      "Khanty-Mansiysky avtonomnyy okrug-Yugra" =
        "Khanty-Mansi Autonomous Okrug",
      "Kirovskaya oblast'" = "Kirov Oblast",
      "Khakasiya, Respublika" = "Khakassia Republic",
      "Kalmykiya, Respublika" = "Kalmykia Republic",
      "Kaluzhskaya oblast'" = "Kaluga Oblast",
      "Komi, Respublika" = "Komi Republic",
      "Kostromskaya oblast'" = "Kostroma Oblast",
      "Kareliya, Respublika" = "Ingushetia Republic",
      "Kurskaya oblast'" = "Kursk Oblast",
      "Krasnoyarskiy kray" = "Krasnodar Krai",
      "Leningradskaya oblast'" = "Leningrad Oblast",
      "Lipetskaya oblast'" = "Lipetsk Oblast",
      "Magadanskaya oblast'" = "Magadan Oblast",
      "Mariy El, Respublika" = "Mari El Republic",
      "Mordoviya, Respublika" = "Mordovia Republic",
      "Moskovskaya oblast'" = "Moscow Oblast",
      "Moskva" = "Moscow",
      "Murmanskaya oblast'" = "Murmansk Oblast",
      "Nenetskiy avtonomnyy okrug" = "Nenets Autonomous Okrug",
      "Novgorodskaya oblast'" = "Novgorod Oblast",
      "Nizhegorodskaya oblast'" = "Nizhny Novgorod Oblast",
      "Novosibirskaya oblast'" = "Novosibirsk Oblast",
      "Omskaya oblast'" = "Omsk Oblast",
      "Orenburgskaya oblast'" = "Orenburg Oblast",
      "Orlovskaya oblast'" = "Orel Oblast",
      "Permskiy kray" = "Perm Krai",
      "Penzenskaya oblast'" = "Penza Oblast",
      "Primorskiy kray" = "Primorsky Krai",
      "Pskovskaya oblast'" = "Pskov Oblast",
      "Rostovskaya oblast'" = "Rostov Oblast",
      "Ryazanskaya oblast'" = "Ryazan Oblast",
      "Sakha, Respublika [Yakutiya]" = "Sakha (Yakutiya) Republic",
      "Sakhalinskaya oblast'" = "Sakhalin Oblast",
      "Samaraskaya oblast'" = "Samara Oblast",
      "Saratovskaya oblast'" = "Saratov Oblast",
      "Severnaya Osetiya-Alaniya, Respublika" =
        "North Ossetia - Alania Republic",
      "Smolenskaya oblast'" = "Smolensk Oblast",
      "Sankt-Peterburg" = "Saint Petersburg",
      "Stavropol'skiy kray" = "Stavropol Krai",
      "Sverdlovskaya oblast'" = "Sverdlovsk Oblast",
      "Tatarstan, Respublika" = "Tatarstan Republic",
      "Tambovskaya oblast'" = "Tambov Oblast",
      "Tomskaya oblast'" = "Tomsk Oblast",
      "Tul'skaya oblast'" = "Tula Oblast",
      "Tverskaya oblast'" = "Tver Oblast",
      "Tyva, Respublika [Tuva]" = "Tyva Republic",
      "Tyumenskaya oblast'" = "Tyumen Oblast",
      "Udmurtskaya Respublika" = "Udmurt Republic",
      "Ul'yanovskaya oblast'" = "Ulyanovsk Oblast",
      "Volgogradskaya oblast'" = "Volgograd Oblast",
      "Vladimirskaya oblast'" = "Vladimir Oblast",
      "Vologodskaya oblast'" = "Vologda Oblast",
      "Voronezhskaya oblast'" = "Voronezh Oblast",
      "Yamalo-Nenetskiy avtonomnyy okrug" = "Yamalo-Nenets Autonomous Okrug",
      "Yaroslavskaya oblast'" = "Yaroslavl Oblast",
      "Yevreyskaya avtonomnaya oblast'" = "Jewish Autonomous Okrug",
      "Zabajkal'skij kraj" = "Zabaykalsky Krai",
      #####################
      #        Spain (ES*):
      #####################
      "Andalucía" = "Andalusia",
      "Aragón" = "Aragon",
      "Asturias, Principado de" = "Principality of Asturias",
      "Canarias" = "Canary Islands",
      "Cantabria" = "Cantabria",
      "Castilla y León" = "Castile and León",
      "Castilla y Leon" = "Castile and León",
      "Castilla-La Mancha" = "Castile-La Mancha",
      "Castilla - La Mancha" = "Castile-La Mancha",
      "Catalunya (ca) [Cataluña]" = "Catalonia",
      "Catalunya [Cataluna]" = "Catalonia",
      "Catalunya" = "Catalonia",
      "Ceuta" = "Ceuta",
      "Extremadura" = "Extremadura",
      "Galicia (gl) [Galicia]" = "Galicia",
      "Galicia [Galicia] " = "Galicia",
      "Illes Balears (ca) [Islas Baleares]" = "Balearic Islands",
      "Illes Balears [Islas Baleares]" = "Balearic Islands",
      "Illes Balears" = "Balearic Islands",
      "Baleares" = "Balearic Islands",
      "La Rioja" = "La Rioja",
      "Madrid, Comunidad de" = "Community of Madrid",
      "Melilla" = "Melilla",
      "Murcia, Región de" = "Region of Murcia",
      "Navarra, Comunidad Foral de" = "Chartered Community of Navarre",
      "Navarra, Comunidad Foral de / Nafarroako Foru Komunitatea" =
        "Chartered Community of Navarre",
      "Navarra" = "Chartered Community of Navarre",
      "Nafarroako Foru Komunitatea*" = "Chartered Community of Navarre",
      "Nafarroako Foru Komunitatea (eu)" = "",
      "País Vasco" = "Basque Country",
      "País Vasco" = "Basque Country",
      "País Vasco / Euskal Herria" = "Basque Country",
      "Pais Vasco" = "Basque Country",
      "Euskal Herria" = "Basque Country",
      "Euskal Herria (eu)" = "",
      "Valenciana, Comunidad" = "Valencian Community",
      "Valenciana, Comunidad / Valenciana, Comunitat" = "Valencian Community",
      "C. Valenciana" = "Valencian Community",
      #####################
      #       Sweden (SE*):
      #####################
      "Stockholms län" = "Stockholm",
      "Västerbottens län" = "Vasterbotten",
      "Norrbottens län" = "Norrbotten",
      "Uppsala län" = "Uppsala",
      "Södermanlands län" = "Sormland",
      "Östergötlands län" = "Ostergotland",
      "Jönköpings län" = "Jonkoping",
      "Kronobergs län" = "Kronoberg",
      "Kalmar län" = "Kalmar",
      "Gotlands län" = "Gotland",
      "Blekinge län" = "Blekinge",
      "Skåne län" = "Skane",
      "Hallands län" = "Halland",
      "Västra Götalands län" = "Vastra Gotaland",
      "Värmlands län" = "Varmland",
      "Örebro län" = "Orebro",
      "Västmanlands län" = "Vastmanland",
      "Dalarnas län" = "Dalarna",
      "Gävleborgs län" = "Gavleborg",
      "Västernorrlands län" = "Vasternorrland",
      "Jämtlands län" = "Jamtland",
      "Jamtland Harjedalen" = "Jamtland",
      #####################
      #      Ukraine (UA*):
      #####################
      "Vinnyts'ka Oblast'" = "Vinnytsia Oblast",
      "Volyns'ka Oblast'" = "Volyn Oblast",
      "Luhans'ka Oblast'" = "Luhansk Oblast",
      "Dnipropetrovs'ka Oblast'" = "Dnipropetrovsk Oblast",
      "Donets'ka Oblast'" = "Donetsk Oblast",
      "Zhytomyrs'ka Oblast'" = "Zhytomyr Oblast",
      "Zakarpats'ka Oblast'" = "Zakarpattia Oblast",
      "Zaporiz'ka Oblast'" = "Zaporizhia Oblast",
      "Ivano-Frankivs'ka Oblast'" = "Ivano-Frankivsk Oblast",
      "Kiev" = "Kiev",
      "Kiev Oblast" = "Kiev Oblast",
      "Kirovohrads'ka Oblast'" = "Kirovohrad Oblast",
      "Sevastopol*" = "Sevastopol",
      "Crimea Republic*" = "Crimea Republic",
      "Kyïvs'ka mis'ka rada" = "Kiev",
      "Kyïvs'ka Oblast'" = "Kiev Oblast",
      "L'vivs'ka Oblast'" = "Lviv Oblast",
      "Mykolaïvs'ka Oblast'" = "Mykolaiv Oblast",
      "Odes'ka Oblast'" = "Odessa Oblast",
      "Poltavs'ka Oblast'" = "Poltava Oblast",
      "Respublika Krym" = "Crimea Republic",
      "Rivnens'ka Oblast'" = "Rivne Oblast",
      "Sums 'ka Oblast'" = "Sumy Oblast",
      "Ternopil's'ka Oblast'" = "Ternopil Oblast",
      "Kharkivs'ka Oblast'" = "Kharkiv Oblast",
      "Khersons'ka Oblast'" = "Kherson Oblast",
      "Khmel'nyts'ka Oblast'" = "Khmelnytskyi Oblast",
      "Cherkas'ka Oblast'" = "Cherkasy Oblast",
      "Chernihivs'ka Oblast'" = "Chernihiv Oblast",
      "Chernivets'ka Oblast'" = "Chernivtsi Oblast",
      #####################
      # United Kingdom (GB*):
      #####################
      "British Virgin Islands" = "Virgin Islands",
      "Falkland Islands (Islas Malvinas)" = "Falkland Islands",
      "Falkland Islands (Malvinas)" = "Falkland Islands",
      "Saint Helena, Ascension and Tristan da Cunha" = "St. Helens",
      "UK" = "United Kingdom",
      "Wales; Cymru" = "Wales",
      #####################
      #    Other/Countries:
      #####################
      # "Bolivia" = "Bolivia, Plurinational State of",
      # "Brunei" = "Brunei Darussalam",
      # "Burma" = "Myanmar",
      # "Cape Verde" = "Cabo Verde",
      # "Congo (Brazzaville)" = "Congo",
      # "Congo (Kinshasa)" = "Congo, The Democratic Republic of the",
      # "Cote d'Ivoire" = "Côte d'Ivoire",
      # "East Timor" = "Timor-Leste",
      # "Gambia, The" = "Gambia",
      # "Iran" = "Iran, Islamic Republic of",
      # "Iran (Islamic Republic of)" = "Iran, Islamic Republic of",
      # "Korea, South" = "Korea, Republic of",
      # "Laos" = "Lao People's Democratic Republic",
      # "Moldova" = "Moldova, Republic of",
      # "occupied Palestinian territory" = "Palestine, State of",
      # "Republic of Korea" = "Korea, Republic of",
      # "Republic of Moldova" = "Moldova, Republic of",
      # "South Korea" = "Korea, Republic of",
      # "Taipei and environs" = "Taiwan, Province of China",
      # "Taiwan*" = "Taiwan, Province of China",
      # "Tanzania" = "Tanzania, United Republic of",
      # "The Bahamas" = "Bahamas",
      # "The Gambia" = "Gambia",
      # "US" = "United States",
      # "Venezuela" = "Venezuela, Bolivarian Republic of",
      # "Vietnam" = "Viet Nam",
      # "West Bank and Gaza" = "Palestine, State of"
      #####################################################
      # Bahamas
      "Bahamas" = "The Bahamas",
      "Commonwealth of The Bahamas" = "The Bahamas",
      "The Commonwealth of The Bahamas" = "The Bahamas",
      # Bolivia
      "Bolivia, Plurinational State of" = "Bolivia",
      "Plurinational State of Bolivia" = "Bolivia",
      # Brunei
      "Brunei Darussalam" = "Brunei",
      "Nation of Brunei" = "Brunei",
      # Cape Verde
      "Cabo Verde" = "Cape Verde",
      "Cabo Verde, Republic of" = "Cape Verde",
      "Cape Verde, Republic of" = "Cape Verde",
      "Micronesia" = "Federated States of Micronesia",
      "Republic of Cabo Verde" = "Cape Verde",
      "Republic of Cape Verde" = "Cape Verde",
      # Congo
      "Congo" = "Congo (Brazzaville)",
      "Congo, Rep. Of" = "Congo (Brazzaville)",
      "Congo, Democratic Republic of the" = "Congo (Kinshasa)",
      "Congo, The Democratic Republic of the" = "Congo (Kinshasa)",
      "DR Congo" = "Congo (Kinshasa)",
      "Republic of the Congo" = "Congo (Brazzaville)",
      "Cote d'Ivoire" = "Côte d'Ivoire",
      "Timor-Leste" = "East Timor",
      # Cruise Ship
      "Diamond Princess cruise ship" = "Diamond Princess",
      "Diamond Princess Cruise Ship" = "Diamond Princess",
      "From Diamond Princess" = "Diamond Princess",
      "From Grand Princess" = "Grand Princess",
      "From MS Zaandam" = "MS Zaandam",
      "Grand Princess cruise ship" = "Grand Princess",
      "Grand Princess Cruise Ship" = "Grand Princess",
      "MS Zaandam cruise ship" = "MS Zaandam",
      "MS Zaandam Cruise Ship" = "MS Zaandam",
      # Gambia
      "Gambia, The" = "The Gambia",
      "Gambia" = "The Gambia",
      # Iran
      "Islamic Republic of Iran" = "Iran",
      "Iran, Islamic Republic of" = "Iran",
      "Iran (Islamic Republic of)" = "Iran",
      # Laos
      "Lao People's Democratic Republic" = "Laos",
      # Moldova
      "Moldova, Republic of" = "Moldova",
      "Republic of Moldova" = "Moldova",
      # Myanmar
      "Burma" = "Myanmar",
      "Myanmar, Republic of the Union of" = "Myanmar",
      "Myanmar, Union of" = "Myanmar",
      "Republic of the Union of Myanmar" = "Myanmar",
      # Palestine
      "occupied Palestinian territory" = "Palestine",
      "Palestine, State of" = "Palestine",
      "State of Palestine" = "Palestine",
      "West Bank and Gaza" = "Palestine",
      # Russia
      "Russian Fed." = "Russia",
      "Russian Federation" = "Russia",
      "The Russian Federation" = "Russia",
      # North Korea
      "Democratic People's Republic of Korea" = "North Korea",
      "Korea, North" = "North Korea",
      # South Korea
      "Korea, Republic of" = "South Korea",
      "Republic of Korea" = "South Korea",
      "Korea, South" = "South Korea",
      # Syria:
      "Syrian Arab Republic" = "Syria",
      # Taiwan
      "Taipei and environs" = "Taiwan",
      "Taiwan*" = "Taiwan",
      "Taiwan (province of China)" = "Taiwan",
      "Taiwan Province of China" = "Taiwan",
      "Taiwan, Province of China" = "Taiwan",
      "The Republic of China" = "Taiwan",
      # Tanzania
      "Tanzania, United Republic of" = "Tanzania",
      "United Republic of Tanzania" = "Tanzania",
      # United States
      "America" = "United States",
      "US" = "United States",
      "USA" = "United States",
      "United States of America" = "United States",
      # Vatican
      "City State of Vatican" = "Vatican City",
      "City-State of Vatican" = "Vatican City",
      "Holy See (Vatican City State)" = "Vatican City",
      "The City State of Vatican" = "Vatican City",
      "The City-State of Vatican" = "Vatican City",
      "The Holy See" = "Vatican City",
      "The Holy See (Vatican City)" = "Vatican City",
      "The Holy See (Vatican City State)" = "Vatican City",
      "The Holy See (Vatican City-State)" = "Vatican City",
      "The Vatican City State" = "Vatican City",
      "The Vatican City-State" = "Vatican City",
      "Vatican City State" = "Vatican City",
      "Vatican City-State" = "Vatican City",
      "Holy See" = "Vatican City",
      # Venezuela
      "Bolivarian Republic of Venezuela" = "Venezuela",
      "Venezuela, Bolivarian Republic of" = "Venezuela",
      # Vietnam
      "Socialist Republic of Vietnam" = "Vietnam",
      "The Socialist Republic of Vietnam" = "Vietnam",
      "Viet Nam" = "Vietnam",
      "Summer Olympics 2020" = "Olympics",
      "Winter Olympics 2022" = "Olympics"
    ) |>
    iconv(
      to = "ASCII//TRANSLIT"
    )

  return(Names.Unified)
}

#-------------------------------------------------------------------------------

# census_api_key(
#   key = "c4f630415cf475502fbc3dc3d243857e895ed463",
#   install = TRUE
# )

Population_Census <- get_acs(
  geography = "county",
  variables = c(population = "B01003_001"),
  # state = "Puerto Rico",
  year = 2019
) |>
  mutate(
    FIPS = GEOID,
    Population = estimate |>
      as.integer()
  ) |>
  select(FIPS, Population)

#-------------------------------------------------------------------------------

Unify_Admins <- function(COVID19.TBL) {
  COVID19.Unified <- COVID19.TBL |>
    mutate(
      Admin3 = Admin3 |>
        na_if("") |>
        str_remove(
          pattern = " District$"
        ) |>
        Unify_Names(),
      Admin2 = case_when(
        Admin1 %in% c(
          "Guam",
          "Northern Mariana Islands",
          "Puerto Rico",
          "Virgin Islands"
        ) & (Admin2 == Admin1) ~ NA_character_,
        TRUE ~ Admin2
      ) |>
        na_if("") |>
        str_remove(
          pattern = " Census Area"
        ) |>
        str_replace(
          pattern = "Saint ",
          replacement = "St. "
        ) |>
        str_replace(
          pattern = " city",
          replacement = " City"
        ) |>
        str_remove(
          pattern = " City and Borough"
        ) |>
        str_remove(
          pattern = " County"
        ) |>
        str_remove(
          pattern = " District$"
        ) |>
        str_remove(
          pattern = " Parish"
        ) |>
        str_remove(
          pattern = " Borough"
        ) |>
        Unify_Names(),
      Admin1 = case_when(
        Admin0 == "Diamond Princess" ~ "Diamond Princess",
        Admin0 == "Grand Princess" ~ "Grand Princess",
        Admin0 == "MS Zaandam" ~ "MS Zaandam",
        Admin0 == "Saint Barthelemy" ~ "Saint Barthelemy",
        Admin0 == "Sint Maarten (Dutch part)" ~ "Sint Maarten",
        Admin0 == "Turks and Caicos Islands" ~ "Turks and Caicos Islands",
        Admin0 == "Germany" ~ Admin1 |>
          str_to_title(),
        Admin0 == "Taiwan" & Admin1 == "Taiwan" ~ NA_character_,
        Admin0 == "Others" & Admin1 == "Cruise Ship" ~ NA_character_,
        TRUE ~ Admin1
      ) |>
        na_if("") |>
        Unify_Names(),
      Admin0 = case_when(
        Admin0 == "Diamond Princess" ~ "Cruise Ship",
        Admin0 == "Grand Princess" ~ "Cruise Ship",
        Admin0 == "MS Zaandam" ~ "Cruise Ship",
        Admin0 == "Saint Barthelemy" ~ "France",
        Admin0 == "Sint Maarten (Dutch part)" ~ "Netherlands",
        Admin0 == "Turks and Caicos Islands" ~ "United Kingdom",
        Admin0 %in% c("Hong Kong", "Macau", "Mainland China") ~ "China",
        Admin0 == "Others" &
          (
            is.na(Admin1) |
              Admin1 %in% c(
                "Cruise Ship",
                "Diamond Princess",
                "Grand Princess",
                "MS Zaandam"
              )
          ) ~ "Cruise Ship",
        TRUE ~ Admin0
      ) |>
        na_if("") |>
        Unify_Names()
    )

  return(COVID19.Unified)
}

#-------------------------------------------------------------------------------

Unify_Everything <- function(COVID19.TBL) {
  COVID19.Unified <- COVID19.TBL |>
    mutate(
      across(
        matches("Cases|Population"),
        as.integer
      )
    ) |>
    Unify_Admins() |>
    mutate(
      FIPS = FIPS |>
        as.integer() |>
        as.character(),
      FIPS = case_when(
        Admin0 != "United States" ~ NA_character_,
        # Bristol Bay + Lake and Peninsula
        Admin2 == "Bristol Bay + Lake and Peninsula" &
          Admin1 == "Alaska" ~ "02164",
        # # Yakutat + Hoonah-Angoon
        # Admin2 == "Yakutat + Hoonah-Angoon" & Admin1 == "Alaska" ~ "02282",
        Admin2 == "Yakutat" & Admin1 == "Alaska" ~ "02282",
        # Exceptions:
        # Dukes and Nantucket = 25007 + 25019
        Admin2 == "Dukes and Nantucket" & Admin1 == "Massachusetts" ~ "25901",
        # Kansas City = 29095 + 29047 + 29165 + 29037 + 20209
        Admin2 == "Kansas City" & Admin1 == "Missouri" ~ "29901",
        # New York City = 36061 + 36005 + 36047 + 36081 + 36085
        Admin2 == "New York City" & Admin1 == "New York" ~ "36666",
        Admin2 == "New York" & Admin1 == "New York" ~ "36061",
        # is.na(FIPS) & !is.na(Admin2) ~
        !is.na(Admin2) ~
          # Unassigned:
          case_when(
            Admin2 == "Unassigned" ~
              fips_codes |>
              pull(state_code) |>
              pluck_multiple(
                Admin1 |>
                  match(
                    fips_codes |>
                      pull(state_name) |>
                      str_remove(
                        pattern = "U.S. "
                      )
                  )
              ) |>
              str_pad(
                width = 2,
                pad = "0"
              ) |>
              str_c(
                "900"
              ),
            # Jurisdictions:
            Admin2 == "Bear River" & Admin1 == "Utah" ~ "49901",
            Admin2 == "Central Utah" & Admin1 == "Utah" ~ "49902",
            Admin2 == "Southeast Utah" & Admin1 == "Utah" ~ "49903",
            Admin2 == "Southwest Utah" & Admin1 == "Utah" ~ "49904",
            Admin2 == "TriCounty" & Admin1 == "Utah" ~ "49905",
            Admin2 == "Weber-Morgan" & Admin1 == "Utah" ~ "49906",
            # Other:
            Admin2 == "Federal Correctional Institution (FCI)" &
              Admin1 == "Michigan" ~ "26901",
            Admin2 == "Michigan Department of Corrections (MDOC)" &
              Admin1 == "Michigan" ~ "26902",
            Admin2 == "Unknown" ~ NA_character_,
            Admin2 == "Joplin" & Admin1 == "Missouri" ~ "29592",
            # Default:
            TRUE ~ FIPS |>
              str_remove(
                pattern = "^0+"
              ) |>
              str_pad(
                width = 5,
                pad = "0"
              )
          ),
        # Cruise Ships
        Admin1 == "Diamond Princess" & Admin0 == "United States" ~ "99",
        Admin1 == "Grand Princess" & Admin0 == "United States" ~ "98",
        Admin1 == "MS Zaandam" & Admin0 == "United States" ~ "97",
        # State FIPS:
        is.na(FIPS) & is.na(Admin2) ~
          fips_codes |>
          pull(state_code) |>
          pluck_multiple(
            Admin1 |>
              match(
                fips_codes |>
                  pull(state_name) |>
                  str_remove(
                    pattern = "U.S. "
                  )
              )
          ) |>
          str_remove(
            pattern = "^0+"
          ) |>
          str_pad(
            width = 2,
            pad = "0"
          ),
        (
          FIPS |>
            str_remove(
              pattern = "^0+"
            ) |>
            str_length() <= 2L
        ) ~ FIPS |>
          str_remove(
            pattern = "^0+"
          ) |>
          str_pad(
            width = 2,
            pad = "0"
          ),
        # County FIPS
        (
          FIPS |>
            str_remove(
              pattern = "^0+"
            ) |>
            str_length() > 2L
        ) ~ FIPS |>
          str_remove(
            pattern = "^0+"
          ) |>
          str_pad(
            width = 5,
            pad = "0"
          ),
        TRUE ~ FIPS
      ),
      Level = case_when(
        Admin0 |>
          str_detect(
            pattern = "Olympics"
          ) ~ "Olympics",
        Level %!in% c(
          "NUTS1",
          "NUTS2",
          "NUTS3",
          "Municipality",
          "ZCTA",
          "Borough"
        ) ~ case_when(
          Admin0 == "Taiwan" &
            (
              is.na(Admin1) | Admin1 == "Taiwan"
            ) &
            is.na(Admin2) ~ "Country",
          Admin0 == "Cruise Ship" ~ "Cruise Ship",
          Admin1 %in% c(
            "Diamond Princess",
            "Grand Princess",
            "MS Zaandam"
          ) ~ "Cruise Ship",
          # !is.na(FIPS) &
          #   !is.na(Admin2) &
          #   Level != "County" ~ "County",
          # Exceptions:
          # Dukes and Nantucket = 25007 + 25019
          Admin2 == "Dukes and Nantucket" &
            Admin1 == "Massachusetts" ~ "County",
          # Kansas City = 29095 + 29047 + 29165 + 29037 + 20209
          Admin2 == "Kansas City" & Admin1 == "Missouri" ~ "County",
          # New York City = 36061 + 36005 + 36047 + 36081 + 36085
          Admin2 == "New York City" & Admin1 == "New York" ~ "County",
          # Jurisdictions:
          # is.na(FIPS) &
          #   (!is.na(Admin2) | Level == "County") &
          #   Admin1 == "Utah" ~  "Jurisdiction",
          Admin2 == "Bear River" & Admin1 == "Utah" ~ "Jurisdiction",
          Admin2 == "Central Utah" & Admin1 == "Utah" ~ "Jurisdiction",
          Admin2 == "Southeast Utah" & Admin1 == "Utah" ~ "Jurisdiction",
          Admin2 == "Southwest Utah" & Admin1 == "Utah" ~ "Jurisdiction",
          Admin2 == "TriCounty" & Admin1 == "Utah" ~ "Jurisdiction",
          Admin2 == "Weber-Morgan" & Admin1 == "Utah" ~ "Jurisdiction",
          # Other:
          Admin2 == "Federal Correctional Institution (FCI)" &
            Admin1 == "Michigan" ~ "County",
          Admin2 == "Michigan Department of Corrections (MDOC)" &
            Admin1 == "Michigan" ~ "County",
          Admin2 == "Unknown" ~ "County",
          !is.na(FIPS) & !is.na(Admin2) &
            Admin1 %in% c("Guam", "Puerto Rico") ~ "Municipality",
          !is.na(FIPS) & !is.na(Admin2) &
            Admin1 %in% c(
              "Guernsey",
              "Jersey",
              "Northern Mariana Islands",
              "Pitcairn Islands",
              "Virgin Islands"
            ) ~ "Island",
          # is.na(FIPS) &
          #   (!is.na(Admin2) | Level == "County") &
          #   Admin2 |>
          #   str_detect(
          #     pattern = "FCI"
          #   ) |>
          #   coalesce(FALSE) ~  "FCI",
          # is.na(FIPS) &
          #   (!is.na(Admin2) | Level == "County") &
          #   Admin2 |>
          #   str_detect(
          #     pattern = "MDOC"
          #   ) |>
          #   coalesce(FALSE) ~  "MDOC",
          is.na(FIPS) &
            (!is.na(Admin2) | Level == "County") &
            Admin1 == "US Military" ~ "Military",
          is.na(FIPS) &
            (!is.na(Admin2) | Level == "County") &
            Admin1 == "Federal Bureau of Prisons" ~ "Prison",
          is.na(FIPS) &
            !is.na(Admin2) &
            Level != "County" ~ "County",
          !is.na(FIPS) &
            is.na(Admin3) &
            !is.na(Admin2) &
            Admin0 == "United States" &
            Level == "Global" ~ "County",
          (is.na(Admin2) | Level %!in% c(
            "County",
            "Island",
            "Municipality"
          )) &
            Admin1 %in% c(
              "Guam",
              "Northern Mariana Islands",
              "Puerto Rico",
              "Virgin Islands"
            ) ~ "Territory",
          (is.na(Admin2) | Level != "County") &
            !is.na(Admin1) & Level != "State" &
            Admin0 == "United States" ~ "State",
          (is.na(Admin2) | Level != "County") &
            !is.na(Admin1) & Level != "State" &
            Admin0 == "Cruise Ship" ~ "Cruise Ship",
          is.na(FIPS) &
            (is.na(Admin2) | Level != "County") &
            !is.na(Admin1) & Level != "State" &
            Admin0 == "Brazil" ~ "State",
          is.na(FIPS) &
            (is.na(Admin2) | Level != "County") &
            !is.na(Admin1) & Level != "State" &
            !is.na(Admin0) & Admin0 != "Cruise Ship" ~ "Province",
          is.na(FIPS) &
            (is.na(Admin2) | Level != "County") &
            is.na(Admin1) & Level %!in% c("County", "State", "Province") &
            !is.na(Admin0) & Admin0 != "Cruise Ship" ~ "Country",
          TRUE ~ Level
        ),
        TRUE ~ Level
      )
    ) |>
    {
      function(.) {
        if (exists("UID")) {
          . |>
            left_join(
              UID |>
                rename(
                  Longitude.JHU = Longitude,
                  Latitude.JHU = Latitude,
                  Population.JHU = Population
                ) |>
                select(-UID),
              multiple = "first"
            )
        } else {
          . |>
            mutate(
              Longitude.JHU = NA_real_,
              Latitude.JHU = NA_real_,
              Population.JHU = NA_integer_
            )
        }
      }
    }() |>
    {
      function(.) {
        if ("Longitude" %!in% names(.)) {
          . |>
            mutate(
              Longitude = Longitude.JHU
            )
        } else {
          .
        }
      }
    }() |>
    {
      function(.) {
        if ("Latitude" %!in% names(.)) {
          . |>
            mutate(
              Latitude = Latitude.JHU
            )
        } else {
          .
        }
      }
    }() |>
    {
      function(.) {
        if ("Population" %!in% names(.)) {
          . |>
            mutate(
              Population = Population.JHU
            )
        } else {
          .
        }
      }
    }() |>
    mutate(
      Longitude = coalesce(Longitude.JHU, Longitude),
      Latitude = coalesce(Latitude.JHU, Latitude),
      Population = coalesce(Population.JHU, Population),
      Longitude = case_when(
        is.na(Longitude) &
          Level == "County" &
          !is.na(FIPS) &
          Admin2 == "Joplin" &
          Admin1 == "Missouri" ~ -94.5133,
        is.na(Longitude) &
          Level == "County" &
          !is.na(FIPS) &
          Admin2 == "New York City" &
          Admin1 == "New York" ~ -73.97152637,
        is.na(Longitude) &
          Level %in% c(
            "County",
            "Island",
            "Municipality"
          ) &
          !is.na(FIPS) &
          Admin2 != "Unassigned" &
          Admin1 == "Puerto Rico" ~ -66.5901,
        is.na(Longitude) &
          Level %in% c(
            "County",
            "Island",
            "Municipality"
          ) &
          !is.na(FIPS) &
          Admin2 == "Rota" &
          Admin1 == "Northern Mariana Islands" ~ 145.2149,
        is.na(Longitude) &
          Level %in% c(
            "County",
            "Island",
            "Municipality"
          ) &
          !is.na(FIPS) &
          Admin2 == "Saipan" &
          Admin1 == "Northern Mariana Islands" ~ 145.7467,
        is.na(Longitude) &
          Level %in% c(
            "County",
            "Island",
            "Municipality"
          ) &
          !is.na(FIPS) &
          Admin2 == "Tinian" &
          Admin1 == "Northern Mariana Islands" ~ 145.6357,
        is.na(Longitude) &
          Level %in% c(
            "County",
            "Island",
            "Municipality"
          ) &
          !is.na(FIPS) &
          Admin2 == "St. Croix" &
          Admin1 == "Virgin Islands" ~ 64.8348,
        is.na(Longitude) &
          Level %in% c(
            "County",
            "Island",
            "Municipality"
          ) &
          !is.na(FIPS) &
          Admin2 == "St. John" &
          Admin1 == "Virgin Islands" ~ 64.7281,
        is.na(Longitude) &
          Level %in% c(
            "County",
            "Island",
            "Municipality"
          ) &
          !is.na(FIPS) &
          Admin2 == "St. Thomas" &
          Admin1 == "Virgin Islands" ~ 64.8941,
        (Longitude == 0 & Latitude == 0) |
          is.na(Longitude) | is.na(Latitude) |
          Population == 0 |
          Admin3 %in% c(
            "Unassigned",
            "Out of Region/Province"
          ) |
          Admin2 == "Unassigned" |
          Admin2 |>
            str_detect(
              pattern = "Out of "
            ) |>
            coalesce(FALSE) |
          Admin0 == "Cruise Ship" | Level == "Cruise Ship" ~ NA_real_,
        Admin0 |>
          str_detect(
            pattern = "Olympics"
          ) ~ NA_real_, # 139.7737,
        # !is.na(Longitude.JHU) ~ Longitude.JHU,
        TRUE ~ Longitude
      ),
      Latitude = case_when(
        is.na(Latitude) &
          Level == "County" &
          !is.na(FIPS) &
          Admin2 == "Joplin" &
          Admin1 == "Missouri" ~ 37.0842,
        is.na(Latitude) &
          Level == "County" &
          !is.na(FIPS) &
          Admin2 == "New York City" &
          Admin1 == "New York" ~ 40.7672726,
        is.na(Latitude) &
          Level %in% c(
            "County",
            "Island",
            "Municipality"
          ) &
          !is.na(FIPS) &
          Admin2 != "Unassigned" &
          Admin1 == "Puerto Rico" ~ 18.2208,
        is.na(Latitude) &
          Level %in% c(
            "County",
            "Island",
            "Municipality"
          ) &
          !is.na(FIPS) &
          Admin2 == "Rota" &
          Admin1 == "Northern Mariana Islands" ~ 14.1509,
        is.na(Latitude) &
          Level %in% c(
            "County",
            "Island",
            "Municipality"
          ) &
          !is.na(FIPS) &
          Admin2 == "Saipan" &
          Admin1 == "Northern Mariana Islands" ~ 15.1850,
        is.na(Latitude) &
          Level %in% c(
            "County",
            "Island",
            "Municipality"
          ) &
          !is.na(FIPS) &
          Admin2 == "Tinian" &
          Admin1 == "Northern Mariana Islands" ~ 15.0043,
        is.na(Latitude) &
          Level %in% c(
            "County",
            "Island",
            "Municipality"
          ) &
          !is.na(FIPS) &
          Admin2 == "St. Croix" &
          Admin1 == "Virgin Islands" ~ 17.7246,
        is.na(Latitude) &
          Level %in% c(
            "County",
            "Island",
            "Municipality"
          ) &
          !is.na(FIPS) &
          Admin2 == "St. John" &
          Admin1 == "Virgin Islands" ~ 18.3368,
        is.na(Latitude) &
          Level %in% c(
            "County",
            "Island",
            "Municipality"
          ) &
          !is.na(FIPS) &
          Admin2 == "St. Thomas" &
          Admin1 == "Virgin Islands" ~ 18.3381,
        (Longitude == 0 & Latitude == 0) |
          is.na(Longitude) | is.na(Latitude) |
          Population == 0 |
          Admin3 %in% c(
            "Unassigned",
            "Out of Region/Province"
          ) |
          Admin2 == "Unassigned" |
          Admin2 |>
            str_detect(
              pattern = "Out of "
            ) |>
            coalesce(FALSE) |
          Admin0 == "Cruise Ship" | Level == "Cruise Ship" ~ NA_real_,
        Admin0 |>
          str_detect(
            pattern = "Olympics"
          ) ~ NA_real_, # 35.6491,
        # !is.na(Latitude.JHU) ~ Latitude.JHU,
        TRUE ~ Latitude
      ),
      Population = case_when(
        is.na(Population) &
          Level == "County" &
          !is.na(FIPS) &
          Admin2 == "Joplin" &
          Admin1 == "Missouri" ~ 50657L,
        is.na(Population) &
          Level == "County" &
          !is.na(FIPS) &
          Admin2 == "New York City" &
          Admin1 == "New York" ~ 8336817L,
        is.na(Population) &
          Level %in% c(
            "County",
            "Island",
            "Municipality"
          ) &
          !is.na(FIPS) &
          Admin2 == "Rota" &
          Admin1 == "Northern Mariana Islands" ~ 3283L,
        is.na(Population) &
          Level %in% c(
            "County",
            "Island",
            "Municipality"
          ) &
          !is.na(FIPS) &
          Admin2 == "Saipan" &
          Admin1 == "Northern Mariana Islands" ~ 52263L,
        is.na(Population) &
          Level %in% c(
            "County",
            "Island",
            "Municipality"
          ) &
          !is.na(FIPS) & Admin2 == "Tinian" &
          Admin1 == "Northern Mariana Islands" ~ 3540L,
        is.na(Population) &
          Level %in% c(
            "County",
            "Island",
            "Municipality"
          ) &
          !is.na(FIPS) &
          Admin2 == "St. Croix" &
          Admin1 == "Virgin Islands" ~ 50601L,
        is.na(Population) &
          Level %in% c(
            "County",
            "Island",
            "Municipality"
          ) &
          !is.na(FIPS) &
          Admin2 == "St. John" &
          Admin1 == "Virgin Islands" ~ 4170L,
        is.na(Population) &
          Level %in% c(
            "County",
            "Island",
            "Municipality"
          ) &
          !is.na(FIPS) &
          Admin2 == "St. Thomas" &
          Admin1 == "Virgin Islands" ~ 51634L,
        is.na(Population) &
          Level %in% c(
            "County",
            "Island",
            "Municipality"
          ) &
          !is.na(FIPS) ~ Population_Census |>
          pull(Population) |>
          pluck_multiple(
            FIPS |>
              match(
                Population_Census |>
                  pull(FIPS)
              )
          ),
        (Longitude == 0 & Latitude == 0) |
          is.na(Longitude) | is.na(Latitude) |
          Population == 0 |
          Admin3 %in% c(
            "Unassigned",
            "Out of Region/Province"
          ) |
          Admin2 == "Unassigned" |
          Admin2 |>
            str_detect(
              pattern = "Out of "
            ) |>
            coalesce(FALSE) |
          Admin0 == "Cruise Ship" | Level == "Cruise Ship" ~ NA_integer_,
        # !is.na(Population.JHU) ~ Population.JHU,
        TRUE ~ Population |>
          as.integer()
      ),
    ) |>
    select(
      -Longitude.JHU,
      -Latitude.JHU,
      -Population.JHU
    )

  return(COVID19.Unified)
}

#-------------------------------------------------------------------------------

Aggregate_Admin <- function(COVID19.TBL,
                            Admin = 0L,
                            Country = NULL,
                            State = NULL,
                            na.rm = TRUE) {
  grp_cols <- intersect(
    COVID19.TBL |>
      names(),
    c(
      "Date",
      "Type",
      "Age",
      "Sex",
      "Source",
      "Level",
      "Admin" |>
        str_c(0:Admin)
    )
  )

  COVID19.Aggregated <- COVID19.TBL |>
    filter(
      if (!is.null(Country)) Admin0 %in% Country else TRUE
    ) |>
    filter(
      if (!is.null(State)) Admin1 %in% State else TRUE
    ) |>
    group_by(
      across(
        all_of(grp_cols)
      )
    ) |>
    {
      function(.) {
        . |>
          summarize(
            Cases = sum(
              Cases,
              na.rm = na.rm
            ),
            Longitude = if ("Longitude" %in% names(.)) {
              Longitude |>
                median(na.rm = TRUE)
            } else {
              NA_real_
            },
            Latitude = if ("Latitude" %in% names(.)) {
              Latitude |>
                median(na.rm = TRUE)
            } else {
              NA_real_
            },
            Population = if ("Population" %in% names(.)) {
              Population |>
                sum(na.rm = TRUE)
            } else {
              NA_integer_
            },
            .groups = "keep"
          )
      }
    }() |>
    ungroup() |>
    {
      function(.) {
        . |>
          mutate(
            Level = str_c("Admin", Admin),
            FIPS = if ("FIPS" %in% names(.)) FIPS else NA_character_,
            Admin3 = if ("Admin3" %in% names(.)) Admin3 else NA_character_,
            Admin2 = if ("Admin2" %in% names(.)) Admin2 else NA_character_,
            Admin1 = if ("Admin1" %in% names(.)) Admin1 else NA_character_,
          )
      }
    }() |>
    Unify_Everything() |>
    select(
      Date, Cases, Type, matches("Age|Sex"),
      Source, Level, matches("Longitude|Latitude|Population"),
      FIPS, Admin3, Admin2, Admin1, Admin0
    )

  return(COVID19.Aggregated)
}

################################################################################

# ISO2_Unified <- ISO_3166_2 |>
ISO2_Unified <- readRDS(
  file = file.path(
    COVID19.dir,
    "Modeling",
    "ISO2_3166.rds"
  ),
  refhook = NULL
) |>
  filter(
    Code %!in% c("FR-GUA", "FR-LRE", "FR-MAY"),
    Name %!in% c("Cantabria", "La Rioja") | Type != "Autonomous community"
  ) |>
  mutate(
    ISO2_Name = case_when(
      Code |>
        str_detect(
          pattern = "DE-"
        ) |>
        coalesce(FALSE) ~ Name |>
        str_to_title(),
      TRUE ~ Name
    ),
    ISO1_2C = Code |>
      str_split_fixed(
        pattern = "-",
        n = 2
      ) |>
      as.data.frame() |>
      pull(1),
    ISO2 = Code |>
      str_split_fixed(
        pattern = "-",
        n = 2
      ) |>
      as.data.frame() |>
      pull(2),
    ISO2_UID = Code
  ) |>
  select(ISO2_Name, ISO1_2C, ISO2, ISO2_UID) |>
  add_row(
    ISO2_Name = c(
      "Faroe",
      "Greenland"
    ),
    ISO1_2C = "DK",
    ISO2 = c(
      "FO",
      "GL"
    ),
    ISO2_UID = c(
      "DK-FO",
      "DK-GL"
    )
  ) |>
  add_row(
    ISO2_Name = c(
      "Northwest Italy",
      "Northeast Italy",
      "Central Italy",
      "South Italy",
      "Insular Italy"
    ),
    ISO1_2C = "IT",
    ISO2 = c(
      "C",
      "F",
      "I",
      "F",
      "G"
    ),
    ISO2_UID = c(
      "IT-C",
      "IT-F",
      "IT-I",
      "IT-F",
      "IT-G"
    ),
  ) |>
  add_row(
    ISO2_Name = c(
      "Anguilla",
      "Bermuda",
      "Guernsey",
      "Jersey",
      "Virgin Islands",
      "Cayman Islands",
      "Channel Islands",
      "Falkland Islands",
      "Gibraltar",
      "Isle of Man",
      "Montserrat",
      "Pitcairn Islands",
      "Turks and Caicos Islands"
    ),
    ISO1_2C = "GB",
    ISO2 = c(
      "AI",
      "BM",
      "GG",
      "JE",
      "VG",
      "KY",
      "CHA",
      "FK",
      "GI",
      "IM",
      "MS",
      "PN",
      "TC"
    ),
    ISO2_UID = c(
      "GB-AI",
      "GB-BM",
      "GB-GG",
      "GB-JE",
      "GB-VG",
      "GB-KY",
      "GB-CHA",
      "GB-FK",
      "GB-GI",
      "GB-IM",
      "GB-MS",
      "GB-PN",
      "GB-TC"
    )
  ) |>
  add_row(
    ISO2_Name = c(
      "Bonaire, Sint Eustatius and Saba"
    ),
    ISO1_2C = "NL",
    ISO2 = c(
      "BQ"
    ),
    ISO2_UID = c(
      "NL-BQ"
    )
  ) |>
  add_row(
    ISO2_Name = c(
      "Nuble"
    ),
    ISO1_2C = "CL",
    ISO2 = c(
      "NB"
    ),
    ISO2_UID = c(
      "CL-NB"
    )
  ) |>
  add_row(
    ISO2_Name = c(
      "Ladakh"
    ),
    ISO1_2C = "IN",
    ISO2 = c(
      "LA"
    ),
    ISO2_UID = c(
      "IN-LA"
    )
  ) |>
  add_row(
    ISO2_Name = c(
      "Cook Islands",
      "Niue"
    ),
    ISO1_2C = "NZ",
    ISO2 = c(
      "CK",
      "NU"
    ),
    ISO2_UID = c(
      "NZ-CK",
      "NZ-NU"
    )
  ) |>
  mutate(
    ISO2_Name = ISO2_Name |>
      Unify_Names() |>
      Unify_Names()
  ) |>
  as_tibble()

#-------------------------------------------------------------------------------

NUTS_Unified <- read_delim(
  file = JRC_URL |>
    str_interp(
      env = list(
        subdir = "of-world",
        subset = "of-world"
      )
    ),
  col_names = TRUE,
  col_types = cols(
    Date = col_date(format = "%Y-%m-%d"),
    iso3 = col_character(),
    Continent = col_character(),
    CountryName = col_character(),
    lat = col_double(),
    lon = col_double(),
    CumulativePositive = col_integer(),
    CumulativeDeceased = col_integer(),
    CumulativeRecovered = col_integer(),
    CurrentlyPositive = col_integer(),
    Hospitalized = col_integer(),
    IntensiveCare = col_integer(),
    EUcountry = col_logical(),
    EUCPMcountry = col_logical(),
    NUTS = col_character()
  ),
  col_select = NULL,
  id = NULL,
  delim = ",",
  quote = '"',
  na = c("", ".", "-", "NA", "NULL"),
  comment = "",
  trim_ws = TRUE,
  escape_double = TRUE,
  escape_backslash = FALSE,
  locale = default_locale(),
  skip = 0,
  n_max = Inf,
  guess_max = 1000L,
  num_threads = 1L,
  progress = FALSE,
  show_col_types = FALSE,
  lazy = FALSE
) |>
  rename(
    ISO1_3C = iso3
  ) |>
  mutate(
    Admin0 = CountryName |>
      Unify_Names(),
    # XAD | XAX = Akrotiri and Dhekelia
    # XCA | XCX = Caspian Sea
    # KOS | XKO | XKX = Kosovo
    # XNC | XNC = Northern Cyprus
    ISO1_2C = case_when(
      ISO1_3C %in% c("XAD", "XAX") ~ "XA",
      ISO1_3C %in% c("XCA", "XCX") ~ "XC",
      ISO1_3C %in% c("KOS", "XKO", "XKX") ~ "XK",
      ISO1_3C %in% c("XNC", "XNX") ~ "XN",
      ISO1_3C %in% c("WWW") ~ "WW",
      TRUE ~ countrycode(
        ISO1_3C |>
          na_if("XAD") |>
          na_if("XAX") |>
          na_if("XCA") |>
          na_if("XCX") |>
          na_if("KOS") |>
          na_if("XKO") |>
          na_if("XKX") |>
          na_if("XNC") |>
          na_if("XNX") |>
          na_if("WWW"),
        origin = "iso3c",
        destination = "iso2c"
      ) |>
        str_pad(
          width = 2,
          pad = "0"
        )
    ),
    NUTS_NAME_JRC = Admin0,
    NUTS = case_when(
      is.na(NUTS) & CountryName == "Holy See" ~ "VA",
      is.na(NUTS) & CountryName == "Namibia" ~ "NA",
      is.na(NUTS) & CountryName == "Greenland" ~ "GL",
      TRUE ~ NUTS
    ),
    Level2 = NUTS |>
      str_length(),
    Level = "NUTS" |>
      str_c(
        Level2 - 2
      )
  ) |>
  filter(!is.na(NUTS)) |>
  distinct(
    NUTS,
    .keep_all = TRUE
  ) |>
  select(
    NUTS_NAME_JRC, ISO1_2C, Level, NUTS
  ) |>
  full_join(
    read_delim(
      file = JRC_URL |>
        str_interp(
          env = list(
            subdir = "by-region",
            subset = "by-regions"
          )
        ),
      col_names = TRUE,
      col_types = cols(
        Date = col_date(format = "%Y-%m-%d"),
        iso3 = col_character(),
        CountryName = col_character(),
        Region = col_character(),
        lat = col_double(),
        lon = col_double(),
        CumulativePositive = col_integer(),
        CumulativeDeceased = col_integer(),
        CumulativeRecovered = col_integer(),
        CurrentlyPositive = col_integer(),
        Hospitalized = col_integer(),
        IntensiveCare = col_integer(),
        EUcountry = col_logical(),
        EUCPMcountry = col_logical(),
        NUTS = col_character()
      ),
      col_select = NULL,
      id = NULL,
      delim = ",",
      quote = '"',
      na = c("", ".", "-", "NA", "NULL"),
      comment = "",
      trim_ws = TRUE,
      escape_double = TRUE,
      escape_backslash = FALSE,
      locale = default_locale(),
      skip = 0,
      n_max = Inf,
      guess_max = 1000L,
      num_threads = 1L,
      progress = FALSE,
      show_col_types = FALSE,
      lazy = FALSE
    ) |>
      rename(
        ISO1_3C = iso3
      ) |>
      mutate(
        Admin0 = CountryName |>
          Unify_Names(),
        # XAD | XAX = Akrotiri and Dhekelia
        # XCA | XCX = Caspian Sea
        # KOS | XKO | XKX = Kosovo
        # XNC | XNC = Northern Cyprus
        ISO1_2C = case_when(
          ISO1_3C %in% c("XAD", "XAX") ~ "XA",
          ISO1_3C %in% c("XCA", "XCX") ~ "XC",
          ISO1_3C %in% c("KOS", "XKO", "XKX") ~ "XK",
          ISO1_3C %in% c("XNC", "XNX") ~ "XN",
          ISO1_3C %in% c("WWW") ~ "WW",
          TRUE ~ countrycode(
            ISO1_3C |>
              na_if("XAD") |>
              na_if("XAX") |>
              na_if("XCA") |>
              na_if("XCX") |>
              na_if("KOS") |>
              na_if("XKO") |>
              na_if("XKX") |>
              na_if("XNC") |>
              na_if("XNX") |>
              na_if("WWW"),
            origin = "iso3c",
            destination = "iso2c"
          ) |>
            str_pad(
              width = 2,
              pad = "0"
            )
        ),
        NUTS_NAME_JRC = Region |>
          Unify_Names(),
        Level2 = NUTS |>
          str_length(),
        Level = "NUTS" |>
          str_c(
            Level2 - 2
          )
      ) |>
      filter(!is.na(NUTS)) |>
      distinct(
        NUTS,
        .keep_all = TRUE
      ) |>
      select(
        NUTS_NAME_JRC, ISO1_2C, Level, NUTS
      )
  ) |>
  full_join(
    get_eurostat_geospatial(
      output_class = "sf",
      resolution = "60",
      nuts_level = "all",
      year = "2021", # 2016
      cache = TRUE,
      update_cache = TRUE,
      cache_dir = file.path(
        COVID19.dir,
        "Outputs",
        "eurostat"
      ),
      crs = "4326",
      make_valid = TRUE
    ) |>
      as_tibble() |>
      mutate(
        NUTS_NAME = case_when(
          NUTS_ID == "ITC20" ~ "Aosta",
          CNTR_CODE == "DE" & LEVL_CODE == 1 ~ NUTS_NAME |>
            str_to_title(),
          TRUE ~ NUTS_NAME
        ) |>
          Unify_Names(),
        ISO1_2C = CNTR_CODE,
        Level = str_c("NUTS", LEVL_CODE),
        NUTS = NUTS_ID
      ) |>
      distinct(
        NUTS,
        .keep_all = TRUE
      ) |>
      select(
        NUTS_NAME, ISO1_2C, Level, NUTS
      )
  ) |>
  distinct(
    NUTS,
    .keep_all = TRUE
  ) |>
  mutate(
    NUTS_NAME = NUTS_NAME_JRC |>
      coalesce(NUTS_NAME) |>
      Unify_Names(),
    Level2 = NUTS |>
      str_length(),
    Level = "NUTS" |>
      str_c(
        Level2 - 2
      )
  ) |>
  mutate(
    NUTS0 = case_when(
      Level2 >= 2L ~ NUTS |>
        str_sub(
          start = 1L,
          end = 2L
        ),
      TRUE ~ NA_character_
    ),
    NUTS1 = case_when(
      Level2 >= 3L ~ NUTS |>
        str_sub(
          start = 1L,
          end = 3L
        ),
      TRUE ~ NA_character_
    ),
    NUTS2 = case_when(
      Level2 >= 4L ~ NUTS |>
        str_sub(
          start = 1L,
          end = 4L
        ),
      TRUE ~ NA_character_
    ),
    NUTS3 = case_when(
      Level2 >= 5L ~ NUTS |>
        str_sub(
          start = 1L,
          end = 5L
        ),
      TRUE ~ NA_character_
    ),
  ) |>
  {
    function(.) {
      . |>
        left_join(
          . |>
            as_tibble() |>
            filter(
              Level == "NUTS0"
            ) |>
            mutate(
              Admin0 = NUTS_NAME
            ) |>
            distinct(
              NUTS0,
              .keep_all = TRUE
            ) |>
            select(Admin0, NUTS0)
        )
    }
  }() |>
  {
    function(.) {
      . |>
        left_join(
          . |>
            as_tibble() |>
            filter(
              Level == "NUTS1"
            ) |>
            mutate(
              Admin1 = NUTS_NAME
            ) |>
            distinct(
              NUTS1,
              .keep_all = TRUE
            ) |>
            select(Admin1, NUTS1)
        )
    }
  }() |>
  {
    function(.) {
      . |>
        left_join(
          . |>
            as_tibble() |>
            filter(
              Level == "NUTS2"
            ) |>
            mutate(
              Admin2 = NUTS_NAME
            ) |>
            distinct(
              NUTS2,
              .keep_all = TRUE
            ) |>
            select(Admin2, NUTS2)
        )
    }
  }() |>
  {
    function(.) {
      . |>
        left_join(
          . |>
            as_tibble() |>
            filter(
              Level == "NUTS3"
            ) |>
            mutate(
              Admin3 = NUTS_NAME
            ) |>
            distinct(
              NUTS3,
              .keep_all = TRUE
            ) |>
            select(Admin3, NUTS3)
        )
    }
  }() |>
  {
    function(.) {
      . |>
        full_join(
          . |>
            as_tibble() |>
            filter(
              Level == "NUTS3"
            ) |>
            mutate(
              NUTS_NAME = "Unassigned",
              Admin3 = NUTS_NAME,
              NUTS3 = NUTS2 |>
                str_c("X"),
              NUTS = NUTS3
            ) |>
            distinct(
              NUTS,
              .keep_all = TRUE
            )
        )
    }
  }() |>
  {
    function(.) {
      . |>
        full_join(
          . |>
            as_tibble() |>
            filter(
              Level == "NUTS2"
            ) |>
            mutate(
              NUTS_NAME = "Unassigned",
              Admin3 = NA_character_,
              Admin2 = NUTS_NAME,
              NUTS3 = NA_character_,
              NUTS2 = NUTS1 |>
                str_c("X"),
              NUTS = NUTS2
            ) |>
            distinct(
              NUTS,
              .keep_all = TRUE
            )
        )
    }
  }() |>
  {
    function(.) {
      . |>
        full_join(
          . |>
            as_tibble() |>
            filter(
              Level == "NUTS1"
            ) |>
            mutate(
              NUTS_NAME = "Unassigned",
              Admin3 = NA_character_,
              Admin2 = NA_character_,
              Admin1 = NUTS_NAME,
              NUTS3 = NA_character_,
              NUTS2 = NA_character_,
              NUTS1 = NUTS0 |>
                str_c("X"),
              NUTS = NUTS1
            ) |>
            distinct(
              NUTS,
              .keep_all = TRUE
            )
        )
    }
  }() |>
  {
    function(.) {
      . |>
        full_join(
          . |>
            as_tibble() |>
            filter(
              Level == "NUTS3"
            ) |>
            mutate(
              NUTS_NAME = "Out of Region/Province",
              Admin3 = NUTS_NAME,
              NUTS3 = NUTS2 |>
                str_c("Z"),
              NUTS = NUTS3
            ) |>
            distinct(
              NUTS,
              .keep_all = TRUE
            )
        )
    }
  }() |>
  {
    function(.) {
      . |>
        full_join(
          . |>
            as_tibble() |>
            filter(
              Level == "NUTS2"
            ) |>
            mutate(
              NUTS_NAME = "Out of Region/Province",
              Admin3 = NA_character_,
              Admin2 = NUTS_NAME,
              NUTS3 = NA_character_,
              NUTS2 = NUTS1 |>
                str_c("Z"),
              NUTS = NUTS2
            ) |>
            distinct(
              NUTS,
              .keep_all = TRUE
            )
        )
    }
  }() |>
  {
    function(.) {
      . |>
        full_join(
          . |>
            as_tibble() |>
            filter(
              Level == "NUTS1"
            ) |>
            mutate(
              NUTS_NAME = "Out of Region/Province",
              Admin3 = NA_character_,
              Admin2 = NA_character_,
              Admin1 = NUTS_NAME,
              NUTS3 = NA_character_,
              NUTS2 = NA_character_,
              NUTS1 = NUTS0 |>
                str_c("Z"),
              NUTS = NUTS1
            ) |>
            distinct(
              NUTS,
              .keep_all = TRUE
            )
        )
    }
  }() |>
  left_join(
    #   get_eurostat(
    #     id = "demo_r_pjanaggr3",
    #     time_format = "num",
    #     filters = "none",
    #     cache = TRUE,
    #     update_cache = TRUE,
    #     cache_dir = file.path(
    #       COVID19.dir,
    #       "Outputs",
    #       "eurostat"
    #     ),
    #     compress_file = TRUE,
    #     stringsAsFactors = FALSE,
    #     keepFlags = FALSE
    #   ) |>
    readRDS(
      file = file.path(
        COVID19.dir,
        "Modeling",
        "demo_r_pjanaggr3_num_code_FF.rds"
      ),
      refhook = NULL
    ) |>
      mutate(
        NUTS = geo |>
          recode(
            "ITG25" = "ITG2D",
            "ITG26" = "ITG2E",
            "ITG27" = "ITG2F",
            "ITG28" = "ITG2G",
            "ITG2Y" = "ITG2H"
          ),
        Population = values |>
          as.integer()
      ) |>
      filter(
        sex == "T",
        age == "TOTAL",
        time == 2019
      ) |>
      select(NUTS, Population) |>
      add_row(
        NUTS = c(
          "DEA25",
          "ITG2H"
        ),
        Population = c(
          300000L,
          354554L
        )
      )
  ) |>
  # mutate(
  #   FIPS = NA_character_
  # ) |>
  # Unify_Everything() |>
  select(
    NUTS_NAME, ISO1_2C, Level, NUTS,
    Admin0, Admin1, Admin2, Admin3,
    Population
  ) |>
  filter(
    NUTS_NAME != "Faroe",
    Level %!in% c("NUTS2", "NUTS3") | !is.na(Admin1),
    Level != "NUTS3" | !is.na(Admin2)
  ) |>
  filter(
    Admin0 %!in% c(
      "Anguilla",
      "Aruba",
      "Bermuda",
      "Bonaire, Saint Eustatius and Saba",
      "British Virgin Islands",
      "Cayman Islands",
      "Curacao",
      "Falkland Islands",
      "Guernsey",
      "Gibraltar",
      "Greenland",
      "Guam",
      "French Polynesia",
      "Isle of Man",
      "Jersey",
      "Montserrat",
      "New Caledonia",
      "Northern Mariana Islands",
      "Puerto Rico",
      "Russia",
      "Turks and Caicos islands",
      "United States Virgin Islands",
      "Virgin Islands"
    )
  ) |>
  add_row(
    NUTS_NAME = c(
      "Aachen, Kreis",
      "Berlin Mitte",
      "Berlin Friedrichshain-Kreuzberg",
      "Berlin Pankow",
      "Berlin Charlottenburg-Wilmersdorf",
      "Berlin Spandau",
      "Berlin Steglitz-Zehlendorf",
      "Berlin Tempelhof-Schöneberg",
      "Berlin Neukölln",
      "Berlin Treptow-Köpenick",
      "Berlin Marzahn-Hellersdorf",
      "Berlin Lichtenberg",
      "Berlin Reinickendorf",
      "Faroe"
    ) |>
      Unify_Names(),
    ISO1_2C = c(
      "DE",
      "DE",
      "DE",
      "DE",
      "DE",
      "DE",
      "DE",
      "DE",
      "DE",
      "DE",
      "DE",
      "DE",
      "DE",
      "DK"
    ),
    Level = c(
      "NUTS3",
      "NUTS3",
      "NUTS3",
      "NUTS3",
      "NUTS3",
      "NUTS3",
      "NUTS3",
      "NUTS3",
      "NUTS3",
      "NUTS3",
      "NUTS3",
      "NUTS3",
      "NUTS3",
      "NUTS1"
    ),
    NUTS = c(
      "DEA25",
      "DE301",
      "DE302",
      "DE303",
      "DE304",
      "DE305",
      "DE306",
      "DE307",
      "DE308",
      "DE309",
      "DE30A",
      "DE30B",
      "DE30C",
      "DKF"
    ),
    Admin0 = c(
      "Germany",
      "Germany",
      "Germany",
      "Germany",
      "Germany",
      "Germany",
      "Germany",
      "Germany",
      "Germany",
      "Germany",
      "Germany",
      "Germany",
      "Germany",
      "Denmark"
    ) |>
      Unify_Names(),
    Admin1 = c(
      "Nordrhein-Westfalen",
      "Berlin",
      "Berlin",
      "Berlin",
      "Berlin",
      "Berlin",
      "Berlin",
      "Berlin",
      "Berlin",
      "Berlin",
      "Berlin",
      "Berlin",
      "Berlin",
      "Faroe"
    ) |>
      Unify_Names(),
    Admin2 = c(
      "Koln",
      "Berlin",
      "Berlin",
      "Berlin",
      "Berlin",
      "Berlin",
      "Berlin",
      "Berlin",
      "Berlin",
      "Berlin",
      "Berlin",
      "Berlin",
      "Berlin",
      NA_character_
    ) |>
      Unify_Names(),
    Admin3 = c(
      "Aachen, Kreis",
      "Berlin Mitte",
      "Berlin Friedrichshain-Kreuzberg",
      "Berlin Pankow",
      "Berlin Charlottenburg-Wilmersdorf",
      "Berlin Spandau",
      "Berlin Steglitz-Zehlendorf",
      "Berlin Tempelhof-Schöneberg",
      "Berlin Neukölln",
      "Berlin Treptow-Köpenick",
      "Berlin Marzahn-Hellersdorf",
      "Berlin Lichtenberg",
      "Berlin Reinickendorf",
      NA_character_
    ) |>
      Unify_Names(),
    Population = c(
      310000L,
      384172L,
      289762L,
      407765L,
      342332L,
      243977L,
      308697L,
      351644L,
      329691L,
      271153L,
      268548L,
      291452L,
      265225L,
      48865L
    )
  )

################################################################################

UID <- read_delim(
  file = UID_URL,
  col_names = TRUE,
  col_types = cols(
    UID = col_integer(),
    iso2 = col_character(),
    iso3 = col_character(),
    code3 = col_integer(),
    FIPS = col_character(),
    Admin2 = col_character(),
    Province_State = col_character(),
    Country_Region = col_character(),
    Lat = col_double(),
    Long_ = col_double(),
    Combined_Key = col_character(),
    Population = col_integer()
  ),
  col_select = NULL,
  id = NULL,
  delim = ",",
  quote = '"',
  na = c("", ".", "-", "NA", "NULL"),
  comment = "",
  trim_ws = TRUE,
  escape_double = TRUE,
  escape_backslash = FALSE,
  locale = default_locale(),
  skip = 0,
  n_max = Inf,
  guess_max = 1000L,
  num_threads = 1L,
  progress = FALSE,
  show_col_types = FALSE,
  lazy = FALSE
) |>
  rename(
    Admin1 = Province_State,
    Admin0 = Country_Region,
    Longitude = Long_,
    Latitude = Lat
  ) |>
  mutate(
    Level = "Unknown",
    Admin3 = NA_character_
  ) |>
  Unify_Everything() |>
  select(
    UID, FIPS, Admin3, Admin2, Admin1, Admin0, Longitude, Latitude, Population
  )

################################################################################

COVID19.LUT <- read_delim(
  file = COVID19.URL |>
    str_interp(
      env = list(
        filename = "COVID-19_LUT.csv"
      )
    ),
  col_names = TRUE,
  col_types = cols(
    ID = col_character(),
    Level = col_character(),
    ISO1_3N = col_character(),
    ISO1_3C = col_character(),
    ISO1_2C = col_character(),
    ISO2 = col_character(),
    ISO2_UID = col_character(),
    FIPS = col_character(),
    NUTS = col_character(),
    AGS = col_character(),
    IBGE = col_character(),
    ZCTA = col_character(),
    Longitude = col_double(),
    Latitude = col_double(),
    Population = col_integer(),
    Admin = col_integer(),
    Admin0 = col_character(),
    Admin1 = col_character(),
    Admin2 = col_character(),
    Admin3 = col_character(),
    NameID = col_character()
  ),
  col_select = NULL,
  id = NULL,
  delim = ",",
  quote = '"',
  # na = c("", ".", "-", "NA", "NULL"),
  na = c(""),
  comment = "",
  trim_ws = TRUE,
  escape_double = TRUE,
  escape_backslash = FALSE,
  locale = default_locale(),
  skip = 0,
  n_max = Inf,
  guess_max = 1000L,
  num_threads = 1L,
  progress = FALSE,
  show_col_types = FALSE,
  lazy = FALSE
)

COVID19.IDs <- COVID19.LUT |>
  pull(ID) |>
  unique()

#-------------------------------------------------------------------------------

world <- ne_countries(
  scale = "medium",
  returnclass = "sf"
) |>
  mutate(
    ID = case_when(
      is.na(iso_a2) & geounit == "France" ~ "FR",
      is.na(iso_a2) & geounit == "Norway" ~ "NO",
      TRUE ~ iso_a2
    )
  )

################################################################################

COVID19.LVL <- COVID19.LUT |>
  mutate(
    ISO1_3C = case_when(
      ID == "DKGL" ~ "GRL",
      ID == "FRGF" ~ "GUF",
      TRUE ~ ISO1_3C
    )
  ) |>
  group_by(ISO1_3C) |>
  summarize(
    LVL = max(Admin),
    .groups = "keep"
  ) |>
  ungroup()

################################################################################
################################################################################
################################################################################

IHME.load <- function(file_subtr) {
  if (file_subtr %!in% c("RATIOS", "SARS_COV_2_INFECTIONS")) {
    abort('File substring should be "Ratios" or "SARS_COV_2_INFECTIONS"!')
  }

  COVID19.IHME.raw <- read_delim(
    file = file.path(
      COVID19.dir,
      "Modeling",
      "IHME",
      str_c(
        "IHME",
        "COVID_19",
        "IES",
        "2019",
        "2021",
        file_subtr,
        "Y2022M04D08.CSV",
        sep = "_"
      )
    ),
    col_names = TRUE,
    col_types = cols(
      location_id = col_integer(),
      location_name = col_character(),
      level = col_integer(),
      date = col_date(format = "%Y-%m-%d"),
      measure_name = col_character(),
      metric_id = col_integer(),
      metric_name = col_character(),
      value_mean = col_number(),
      value_lower = col_number(),
      value_upper = col_number()
    ),
    col_select = NULL,
    id = NULL,
    delim = ",",
    quote = '"',
    # na = c("", ".", "-", "NA", "NULL"),
    na = c(""),
    comment = "",
    trim_ws = TRUE,
    escape_double = TRUE,
    escape_backslash = FALSE,
    locale = default_locale(),
    skip = 0,
    n_max = Inf,
    guess_max = 1000L,
    num_threads = 1L,
    progress = FALSE,
    show_col_types = FALSE,
    lazy = FALSE
  )

  COVID19.IHME.raw |>
    filter(
      level == 3,
      measure_name %in% c(
        "Cumulative infection-detection ratio",
        "Cumulative infection-hospitalisation ratio",
        "Cumulative infection-fatality ratio",
        "Daily infections"
      )
    ) |>
    rename(
      Date = date,
      Type = measure_name,
      Estimate = value_mean
    ) |>
    mutate(
      Admin0 = location_name |>
        Unify_Names(),
      Type = Type |>
        recode(
          "Cumulative infection-detection ratio" = "IDR",
          "Cumulative infection-hospitalisation ratio" = "IHR",
          "Cumulative infection-fatality ratio" = "IFR",
          "Daily infections" = "Infections"
        )
    ) |>
    left_join(
      COVID19.LUT |>
        filter(
          Admin == 0
        ) |>
        Unify_Admins() |>
        select(
          ID, Admin0, Admin1, Admin2, Admin3
        )
    ) |>
    mutate(
      ID = case_when(
        Admin0 == "Turkmenistan" ~ "TM",
        Admin0 == "North Korea" ~ "KP",
        TRUE ~ ID
      )
    ) |>
    filter(
      !is.na(ID)
    ) |>
    select(
      ID, Date, Type, Estimate
    ) |>
    bind_rows(
      COVID19.IHME.raw |>
        filter(
          level == 4 | location_name %in% c(
            "American Samoa",
            "Diamond Princess",
            "Grand Princess",
            "Guam",
            "Northern Mariana Islands",
            "Puerto Rico",
            "Virgin Islands"
          ),
          measure_name %in% c(
            "Cumulative infection-detection ratio",
            "Cumulative infection-hospitalisation ratio",
            "Cumulative infection-fatality ratio",
            "Daily infections"
          )
        ) |>
        rename(
          Date = date,
          Type = measure_name,
          Estimate = value_mean
        ) |>
        mutate(
          Admin0 = "United States",
          Admin1 = location_name |>
            Unify_Names(),
          Type = Type |>
            recode(
              "Cumulative infection-detection ratio" = "IDR",
              "Cumulative infection-hospitalisation ratio" = "IHR",
              "Cumulative infection-fatality ratio" = "IFR",
              "Daily infections" = "Infections"
            )
        ) |>
        left_join(
          COVID19.LUT |>
            filter(
              Admin == 1,
              Admin0 == "United States"
            ) |>
            Unify_Admins() |>
            select(
              ID, Admin0, Admin1, Admin2, Admin3
            )
        ) |>
        mutate(
          ID = case_when(
            Admin0 == "Turkmenistan" ~ "TM",
            Admin0 == "North Korea" ~ "KP",
            TRUE ~ ID
          )
        ) |>
        filter(
          !is.na(ID)
        ) |>
        select(
          ID, Date, Type, Estimate
        )
    ) |>
    arrange(
      ID, Date, Type
    ) |>
    pivot_wider(
      names_from = Type,
      values_from = Estimate
    )
}

################################################################################

COVID19.load <- function(infile = NULL,
                         outfile = NULL,
                         filters = NULL,
                         clean = FALSE,
                         ihme = FALSE,
                         hydromet = FALSE,
                         policy = FALSE,
                         static = FALSE,
                         vaccine = FALSE) {
  if (is.null(infile)) {
    infile <- "COVID-19_Data.rds"
  }

  if (file.exists(infile)) {
    COVID19 <- readRDS(
      file = infile,
      refhook = NULL
    )
  } else if (file.exists(file.path("latest", infile))) {
    COVID19 <- readRDS(
      file = file.path(
        "latest",
        infile
      ),
      refhook = NULL
    )
  } else {
    if (!file.exists("COVID-19.rds")) {
      download.file(
        url = COVID19.URL |>
          str_interp(
            env = list(
              filename = "COVID-19.rds"
            )
          ),
        destfile = "COVID-19.rds",
        method = "auto",
        mode = "wb",
        quiet = TRUE,
        cacheOK = TRUE,
        extra = NULL,
        headers = NULL
      )
    }

    COVID19 <- readRDS(
      file = "COVID-19.rds",
      refhook = NULL
    ) |>
      left_join(
        COVID19.LUT,
        multiple = "all"
      )
  }

  if (!is.null(filters) && is_expression(filters)) {
    COVID19 <- COVID19 |>
      filter(!!filters)
  }

  if (clean && infile %in% c("COVID-19.rds", "COVID-19_Data.rds")) {
    COVID19 <- COVID19 |>
      COVID19.clean()
  }

  if (ihme) {
    COVID19 <- COVID19 |>
      left_join(
        IHME.load("RATIOS"),
        multiple = "all"
      ) |>
      left_join(
        IHME.load("SARS_COV_2_INFECTIONS"),
        multiple = "all"
      )
  }

  if (hydromet) {
    if (file.exists("Hydromet.rds")) {
      COVID19 <- COVID19 |>
        left_join(
          readRDS(
            file = "Hydromet.rds",
            refhook = NULL
          ),
          multiple = "all"
        )
    } else if (file.exists(file.path("latest", "Hydromet.rds"))) {
      COVID19 <- COVID19 |>
        left_join(
          readRDS(
            file = file.path(
              "latest",
              "Hydromet.rds"
            ),
            refhook = NULL
          ),
          multiple = "all"
        )
    } else {
      Hydromet.files <- "2020-01-01" |>
        as.Date() |>
        seq(
          COVID19 |>
            pull(Date) |>
            max(
              na.rm = TRUE
            ) |>
            subtract(7L),
          by = "1 month"
        ) |>
        format("%Y%m") |>
        {
          function(.) {
            str_c(
              "Hydromet_",
              .,
              ".rds"
            )
          }
        }()

      Hydromet.files |>
      walk(
        function(x) {
          download.file(
            url = COVID19.URL |>
              str_interp(
                env = list(
                  filename = str_c(
                    "Hydromet/",
                    x
                  )
                )
              ),
            destfile = x,
            method = "auto",
            mode = "wb",
            quiet = TRUE,
            cacheOK = TRUE,
            extra = NULL,
            headers = NULL
          )
        }
      )

      COVID19 <- COVID19 |>
        left_join(
          Hydromet.files |>
            map_dfr(
              readRDS
            ),
          multiple = "all"
        )
    }
  }

  if (policy) {
    if (file.exists("Policy.rds")) {
      COVID19 <- COVID19 |>
        left_join(
          readRDS(
            file = "Policy.rds",
            refhook = NULL
          ),
          multiple = "all"
        )
    } else if (file.exists(file.path("latest", "Policy.rds"))) {
      COVID19 <- COVID19 |>
        left_join(
          readRDS(
            file = file.path(
              "latest",
              "Policy.rds"
            ),
            refhook = NULL
          ),
          multiple = "all"
        )
    } else {
      download.file(
        url = COVID19.URL |>
          str_interp(
            env = list(
              filename = "Policy.rds"
            )
          ),
        destfile = "Policy.rds",
        method = "auto",
        mode = "wb",
        quiet = TRUE,
        cacheOK = TRUE,
        extra = NULL,
        headers = NULL
      )

      COVID19 <- COVID19 |>
        left_join(
          readRDS(
            file = "Policy.rds",
            refhook = NULL
          ),
          multiple = "all"
        )
    }
  }

  if (vaccine) {
    if (file.exists("Vaccine.rds")) {
      COVID19 <- COVID19 |>
        left_join(
          readRDS(
            file = "Vaccine.rds",
            refhook = NULL
          ),
          multiple = "all"
        )
    } else if (file.exists(file.path("latest", "Vaccine.rds"))) {
      COVID19 <- COVID19 |>
        left_join(
          readRDS(
            file = file.path(
              "latest",
              "Vaccine.rds"
            ),
            refhook = NULL
          ),
          multiple = "all"
        )
    } else {
      download.file(
        url = COVID19.URL |>
          str_interp(
            env = list(
              filename = "Vaccine.rds"
            )
          ),
        destfile = "Vaccine.rds",
        method = "auto",
        mode = "wb",
        quiet = TRUE,
        cacheOK = TRUE,
        extra = NULL,
        headers = NULL
      )

      COVID19 <- COVID19 |>
        left_join(
          readRDS(
            file = "Vaccine.rds",
            refhook = NULL
          ),
          multiple = "all"
        )
    }
  }

  if (static) {
    if (file.exists("COVID-19_Static.rds")) {
      COVID19 <- COVID19 |>
        left_join(
          readRDS(
            file = if_else(
              file.exists("COVID-19_Static_All.rds"),
              "COVID-19_Static_All.rds",
              "COVID-19_Static.rds"
            ),
            refhook = NULL
          ),
          multiple = "all"
        )
    } else if (file.exists(file.path("latest", "COVID-19_Static.rds"))) {
      COVID19 <- COVID19 |>
        left_join(
          readRDS(
            file = if_else(
              file.exists(
                file.path(
                  "latest",
                  "COVID-19_Static_All.rds"
                )
              ),
              file.path(
                "latest",
                "COVID-19_Static_All.rds"
              ),
              file.path(
                "latest",
                "COVID-19_Static.rds"
              )
            ),
            refhook = NULL
          ),
          multiple = "all"
        )
    } else {
      download.file(
        url = COVID19.URL |>
          str_interp(
            env = list(
              filename = "COVID-19_Static.rds"
            )
          ),
        destfile = "COVID-19_Static.rds",
        method = "auto",
        mode = "wb",
        quiet = TRUE,
        cacheOK = TRUE,
        extra = NULL,
        headers = NULL
      )

      COVID19 <- COVID19 |>
        left_join(
          readRDS(
            file = if_else(
              file.exists("COVID-19_Static_All.rds"),
              "COVID-19_Static_All.rds",
              "COVID-19_Static.rds"
            ),
            refhook = NULL
          ),
          multiple = "all"
        )
    }
  }

  if (!is.null(outfile)) {
    COVID19 |>
      saveRDS(
        file = outfile,
        compress = "xz",
        ascii = FALSE,
        version = NULL,
        refhook = NULL
      )
  }

  return(COVID19)
}

#-------------------------------------------------------------------------------

COVID19.clean <- function(COVID19.TBL) {
  if ("Cases_Clean" %in% names(COVID19.TBL)) {
    COVID19.TBL
  } else {
    COVID19.TBL |>
      as_tibble() |>
      group_by(Type, Age, Sex, Source, Level, ID) |>
      # group_by(Type, Age, Sex, Source, Level, NameID) |>
      mutate(
        Cases_Max = Cases |>
          coalesce(0L) |>
          max(),
        Cases_New =
          (
            Cases -
              Cases[match(Date - 1, Date)] |> coalesce(0L)
          )
      ) |>
      mutate(
        Clean_Flag = (
          !is.na(Population) &
            Admin1 |>
              str_detect(
                pattern = "^Out of",
                negate = TRUE
              ) |>
              coalesce(FALSE) &
            Admin2 |>
              str_detect(
                pattern = "^Out of",
                negate = TRUE
              ) |>
              coalesce(FALSE) &
            Admin3 |>
              str_detect(
                pattern = "^Out of",
                negate = TRUE
              ) |>
              coalesce(FALSE) &
            Admin1 %!in% c(
              "Cruise Ship",
              "Port Quarantine",
              "Repatriated Travellers",
              "Unassigned"
            ) &
            Admin2 %!in% c(
              "Cruise Ship",
              "Unassigned"
            ) &
            Admin3 %!in% c(
              "Cruise Ship",
              "Unassigned"
            ) &
            Level %!in% c(
              "Cruise Ship",
              "Olympics"
            )
        )
      ) |>
      mutate(
        Cases_Clean = Cases |>
          clean_cases(
            clean_flag = all(Clean_Flag)
          ),
        Cases_New_Clean = Cases_New |>
          clean_cases(
            clean_flag = all(Clean_Flag)
          )
      ) |>
      ungroup() |>
      # Drop all records with zero maximum of cumulative case
      # We do not need records with no cases at all
      filter(Cases_Max > 0) |>
      # Drop all records with zero cases and new cases
      # We do not need records with no change.
      # filter(Cases > 0, Cases_New > 0) |>
      # Select and order the selected columns
      select(
        Date,
        Cases, Cases_Max, Cases_New,
        Clean_Flag, Cases_Clean,
        Cases_New_Clean,
        Type, Age, Sex, Source, Level,
        ID, Longitude, Latitude, Population,
        contains("ISO"), FIPS, NUTS, matches("AGS|IBGE|ZIP|ZCTA"),
        Admin, Admin3, Admin2, Admin1, Admin0, NameID, everything()
      ) |>
      arrange(ID, Date, Type, Age, Sex, Source, Level, Admin)
  }
}

################################################################################
################################################################################
################################################################################

Sys.time() - tstart

################################################################################
