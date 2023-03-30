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

if (!exists("COVID19.LUT")) {
  source(
    file.path(
      COVID19.dir,
      "Modeling",
      "COVID-19_Common.R"
    ),
    local = parent.frame(),
    echo = FALSE,
    max.deparse.length = Inf
  )
}

################################################################################

Sex_Ratio <- read_delim(
  file = file.path(
    COVID19.dir,
    "Modeling",
    "Population_SexRatio.csv"
  ),
  col_names = TRUE,
  col_types = cols(
    Entity = col_character(),
    Code = col_character(),
    Year = col_double(),
    `Population, female (% of total)` = col_double()
  ),
  col_select = NULL,
  id = NULL,
  delim = ",",
  quote = '"',
  na = c("", ".", "-", "NULL"),
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
    ISO1_3C = Code,
    WorldPop_F = `Population, female (% of total)`
  ) |>
  filter(
    !is.na(ISO1_3C),
    ISO1_3C %!in% c("OWID_CIS", "OWID_WRL")
  ) |>
  mutate(
    ID = countrycode(
      ISO1_3C,
      origin = "iso3c",
      destination = "iso2c"
    )
  ) |>
  filter(
    !is.na(ID)
  ) |>
  group_by(ID) |>
  summarize(
    WorldPop_F = WorldPop_F |>
      last(),
    .groups = "keep"
  ) |>
  ungroup() |>
  mutate(
    WorldPop_F = WorldPop_F |>
      divide_by(100),
    WorldPop_M = 1 |>
      subtract(WorldPop_F),
    Sex_Ratio = WorldPop_M |>
      divide_by(WorldPop_F)
  ) |>
  {
    function(.) {
      . |>
        full_join(
          . |>
            as_tibble() |>
            filter(
              ID == "DO"
            ) |>
            mutate(
              ID = "DM"
            )
        )
    }
  }() |>
  add_row(
    ID = "AD",
    WorldPop_F = 0.486618,
    WorldPop_M = 0.513382,
    Sex_Ratio = 1.055
  ) |>
  select(
    ID, WorldPop_F, WorldPop_M, Sex_Ratio
  )

################################################################################

COVID19.Static_UVA <- read_delim(
  file = file.path(
    COVID19.dir,
    "Modeling",
    "static.csv"
  ),
  col_names = TRUE,
  col_types = cols(
    id = col_character(),
    population_m = col_double(),
    population_f = col_double(),
    sex_ratio = col_double(),
    access_city = col_double(),
    access_motor = col_double(),
    access_walk = col_double(),
    diabetes_prev = col_double(),
    hiv_m = col_double(),
    hiv_f = col_double(),
    obesity_prev = col_double(),
    hypertension_prev_f = col_double(),
    hypertension_prev_m = col_double(),
    smoking_prev = col_double(),
    copd_m = col_double(),
    copd_f = col_double(),
    cvd_m = col_double(),
    cvd_f = col_double(),
    total_increasedrisk = col_double(),
    agestd_increasedrisk = col_double(),
    highrisk = col_double(),
    mers_cases = col_double(),
    sarscov1_cases = col_double(),
    hypertension_prev = col_double(),
    mean_worldpop = col_double(),
    sum_worldpop = col_double(),
    sum_o65_worldpop = col_double(),
    perc_o65_worldpop = col_double()
  ),
  col_select = NULL,
  id = NULL,
  delim = ",",
  quote = '"',
  na = c("", ".", "-", "NULL"),
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
    ID = id,
    WorldPop_F = population_f,
    WorldPop_M = population_m,
    Sex_Ratio = sex_ratio,
    Access_City = access_city,
    Access_Motor = access_motor,
    Access_Walk = access_walk,
    Diabetes = diabetes_prev,
    HIV_M = hiv_m,
    HIV_F = hiv_f,
    # HIV = hiv_prev,
    Obesity = obesity_prev,
    Hypertension_F = hypertension_prev_f,
    Hypertension_M = hypertension_prev_m,
    Smoking = smoking_prev,
    COPD_M = copd_m,
    COPD_F = copd_f,
    CVD_M = cvd_m,
    CVD_F = cvd_f,
    Risk_Tot = total_increasedrisk,
    Risk_Age = agestd_increasedrisk,
    Risk_High = highrisk,
    Cases_MERS = mers_cases,
    Cases_SARS = sarscov1_cases,
    Hypertension = hypertension_prev,
    WorldPop_Density = mean_worldpop,
    WorldPop = sum_worldpop,
    WorldPop_65_Tot = sum_o65_worldpop,
    WorldPop_65 = perc_o65_worldpop
  ) |>
  # left_join(
  #   Sex_Ratio
  # ) |>
  mutate(
    WorldPop_F = WorldPop_F |>
      divide_by(WorldPop),
    WorldPop_M = WorldPop_M |>
      divide_by(WorldPop),
    COPD = COPD_M * WorldPop_M + COPD_F * WorldPop_F,
    CVD = CVD_M * WorldPop_M + CVD_F * WorldPop_F,
    HIV = HIV_M * WorldPop_M + HIV_F * WorldPop_F,
    Hypertension = Hypertension |>
      coalesce(
        Hypertension_M * WorldPop_M + Hypertension_F * WorldPop_F
      )
  ) |>
  arrange(ID) |>
  select(
    ID, Access_City, Access_Motor, Access_Walk,
    Diabetes, Obesity, Smoking,
    COPD, COPD_F, COPD_M,
    CVD, CVD_F, CVD_M,
    HIV, HIV_F, HIV_M,
    Hypertension, Hypertension_F, Hypertension_M,
    Risk_Tot, Risk_Age, Risk_High,
    Cases_MERS, Cases_SARS,
    WorldPop, WorldPop_Density, WorldPop_65,
    WorldPop_F, WorldPop_M, Sex_Ratio
  )

################################################################################

Sex_Ratio_US <- read_delim(
  file = file.path(
    COVID19.dir,
    "Modeling",
    "cc-est2019-alldata.csv"
  ),
  col_names = TRUE,
  col_types = cols(
    SUMLEV = col_integer(),
    STATE = col_integer(),
    COUNTY = col_integer(),
    STNAME = col_character(),
    CTYNAME = col_character(),
    YEAR = col_double(),
    AGEGRP = col_double(),
    TOT_POP = col_double(),
    TOT_MALE = col_double(),
    TOT_FEMALE = col_double(),
    WA_MALE = col_double(),
    WA_FEMALE = col_double(),
    BA_MALE = col_double(),
    BA_FEMALE = col_double(),
    IA_MALE = col_double(),
    IA_FEMALE = col_double(),
    AA_MALE = col_double(),
    AA_FEMALE = col_double(),
    NA_MALE = col_double(),
    NA_FEMALE = col_double(),
    TOM_MALE = col_double(),
    TOM_FEMALE = col_double(),
    WAC_MALE = col_double(),
    WAC_FEMALE = col_double(),
    BAC_MALE = col_double(),
    BAC_FEMALE = col_double(),
    IAC_MALE = col_double(),
    IAC_FEMALE = col_double(),
    AAC_MALE = col_double(),
    AAC_FEMALE = col_double(),
    NAC_MALE = col_double(),
    NAC_FEMALE = col_double(),
    NH_MALE = col_double(),
    NH_FEMALE = col_double(),
    NHWA_MALE = col_double(),
    NHWA_FEMALE = col_double(),
    NHBA_MALE = col_double(),
    NHBA_FEMALE = col_double(),
    NHIA_MALE = col_double(),
    NHIA_FEMALE = col_double(),
    NHAA_MALE = col_double(),
    NHAA_FEMALE = col_double(),
    NHNA_MALE = col_double(),
    NHNA_FEMALE = col_double(),
    NHTOM_MALE = col_double(),
    NHTOM_FEMALE = col_double(),
    NHWAC_MALE = col_double(),
    NHWAC_FEMALE = col_double(),
    NHBAC_MALE = col_double(),
    NHBAC_FEMALE = col_double(),
    NHIAC_MALE = col_double(),
    NHIAC_FEMALE = col_double(),
    NHAAC_MALE = col_double(),
    NHAAC_FEMALE = col_double(),
    NHNAC_MALE = col_double(),
    NHNAC_FEMALE = col_double(),
    H_MALE = col_double(),
    H_FEMALE = col_double(),
    HWA_MALE = col_double(),
    HWA_FEMALE = col_double(),
    HBA_MALE = col_double(),
    HBA_FEMALE = col_double(),
    HIA_MALE = col_double(),
    HIA_FEMALE = col_double(),
    HAA_MALE = col_double(),
    HAA_FEMALE = col_double(),
    HNA_MALE = col_double(),
    HNA_FEMALE = col_double(),
    HTOM_MALE = col_double(),
    HTOM_FEMALE = col_double(),
    HWAC_MALE = col_double(),
    HWAC_FEMALE = col_double(),
    HBAC_MALE = col_double(),
    HBAC_FEMALE = col_double(),
    HIAC_MALE = col_double(),
    HIAC_FEMALE = col_double(),
    HAAC_MALE = col_double(),
    HAAC_FEMALE = col_double(),
    HNAC_MALE = col_double(),
    HNAC_FEMALE = col_double()
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
  filter(
    YEAR == last(YEAR),
    AGEGRP == 0
  ) |>
  mutate(
    ID = str_c(
      "US",
      STATE |>
        str_remove(
          pattern = "^0+"
        ) |>
        str_pad(
          width = 2,
          pad = "0"
        ),
      COUNTY |>
        str_remove(
          pattern = "^0+"
        ) |>
        str_pad(
          width = 3,
          pad = "0"
        )
    ),
    WorldPop_F = TOT_FEMALE / TOT_POP,
    WorldPop_M = TOT_MALE / TOT_POP,
    Sex_Ratio = WorldPop_M / WorldPop_F
  ) |>
  group_by(ID) |>
  summarize(
    WorldPop_F = WorldPop_F |>
      last(),
    WorldPop_M = WorldPop_M |>
      last(),
    Sex_Ratio = Sex_Ratio |>
      last(),
    .groups = "keep"
  ) |>
  ungroup() |>
  select(
    ID, WorldPop_F, WorldPop_M, Sex_Ratio
  ) |>
  add_row(
    ID = "US25901",
    WorldPop_F = 6262 / (6262 + 5658),
    WorldPop_M = 5658 / (6262 + 5658),
    Sex_Ratio = 5658 / 6262
  ) |>
  arrange(ID)

################################################################################

COVID19.Static_US <- read_delim(
  file = file.path(
    COVID19.dir,
    "Modeling",
    "county_static_data.csv"
  ),
  col_names = TRUE,
  col_types = cols(
    FIPS = col_integer(),
    total_pop = col_double(),
    `0_to_4` = col_double(),
    `5_to_9` = col_double(),
    `10_to_14` = col_double(),
    `15_to_19` = col_double(),
    `20_to_24` = col_double(),
    `25_to_29` = col_double(),
    `30_to_34` = col_double(),
    `35_to_39` = col_double(),
    `40_to_44` = col_double(),
    `45_to_49` = col_double(),
    `50_to_54` = col_double(),
    `55_to_59` = col_double(),
    `60_to_64` = col_double(),
    `65_to_69` = col_double(),
    `70_to_74` = col_double(),
    `75_to_79` = col_double(),
    `80_to_84` = col_double(),
    `85_and_older` = col_double(),
    `65_UP_RATIO` = col_double(),
    Diabetes = col_double(),
    Adult.smoking = col_double(),
    Adult.obesity = col_double(),
    Poor.physical.health.days = col_double(),
    Poverty.Rate.below.federal.poverty.threshold = col_double(),
    White = col_double(),
    Black = col_double(),
    Hispanic = col_double(),
    Asian = col_double(),
    Amerindian = col_double(),
    Other_demographic = col_double()
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
    Population = total_pop,
    Age_00_04 = `0_to_4`,
    Age_06_09 = `5_to_9`,
    Age_10_14 = `10_to_14`,
    Age_15_19 = `15_to_19`,
    Age_20_24 = `20_to_24`,
    Age_25_29 = `25_to_29`,
    Age_30_34 = `30_to_34`,
    Age_35_39 = `35_to_39`,
    Age_40_44 = `40_to_44`,
    Age_45_49 = `45_to_49`,
    Age_50_54 = `50_to_54`,
    Age_55_59 = `55_to_59`,
    Age_60_64 = `60_to_64`,
    Age_65_69 = `65_to_69`,
    Age_70_74 = `70_to_74`,
    Age_75_79 = `75_to_79`,
    Age_80_84 = `80_to_84`,
    Age_GTE85 = `85_and_older`,
    Age_GTE65_Ratio = `65_UP_RATIO`,
    Smoking = Adult.smoking,
    Obesity = Adult.obesity,
    HRQoL = Poor.physical.health.days,
    Poverty_Rate = Poverty.Rate.below.federal.poverty.threshold
  ) |>
  mutate(
    ID = str_c(
      "US",
      FIPS |>
        str_remove(
          pattern = "^0+"
        ) |>
        str_pad(
          width = 5,
          pad = "0"
        )
    )
  ) |>
  select(
    -FIPS, -Population
  ) |>
  left_join(
    Sex_Ratio_US
  ) |>
  select(
    ID, everything()
  )

################################################################################

# Check cc-est2019-alldata.csv and add Sex_Ratio for US counties...
# Same for EU...

################################################################################

AQ.files <- list.files(
  path = AQ_PATH,
  pattern = "*.*.csv$",
  full.names = TRUE,
  recursive = TRUE
)

#-------------------------------------------------------------------------------

Join_AQ <- function(Files) {
  AQ <- Files |>
    map_dfr(
      function(filename) {
        cat(filename, "\n")

        AQ.file <- read_delim(
          file = filename,
          col_names = TRUE,
          col_types = NULL,
          col_select = NULL,
          id = NULL,
          delim = ",",
          quote = '"',
          na = c("", ".", "-", "NULL"),
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
          {
            function(.) {
              if ("ID" %in% names(.)) {
                .
              } else if ("FIPS" %in% names(.)) {
                . |>
                  mutate(
                    FIPS = FIPS |>
                      str_remove(
                        pattern = "^0+"
                      ) |>
                      str_pad(
                        width = 5,
                        pad = "0"
                      ),
                    ID = str_c("US", FIPS)
                  ) |>
                  select(-FIPS)
              } else if ("STATE" %in% names(.)) {
                . |>
                  mutate(
                    FIPS = STATE |>
                      str_remove(
                        pattern = "^0+"
                      ) |>
                      str_pad(
                        width = 2,
                        pad = "0"
                      ),
                    ID = str_c("US", FIPS)
                  ) |>
                  select(-STATE)
              } else if ("IBGE" %in% names(.)) {
                . |>
                  mutate(
                    ID = IBGE
                  ) |>
                  select(-IBGE)
              } else if (
                "NUTS" %in% names(.) &&
                  filename |>
                    str_detect(
                      pattern = "NUTS0",
                      negate = TRUE
                    )
              ) {
                . |>
                  mutate(
                    ID = NUTS
                  ) |>
                  select(-NUTS)
              } else if (
                "NUTS" %in% names(.) &&
                  filename |>
                    str_detect(
                      pattern = "NUTS0"
                    )
              ) {
                . |>
                  filter(
                    NUTS %!in% c("SPR")
                  ) |>
                  rename(
                    ID = NUTS
                  ) |>
                  mutate(
                    # XAD | XAX = Akrotiri and Dhekelia
                    # XCA | XCX = Caspian Sea
                    # XKO | XKX = Kosovo
                    # XNC | XNC = Northern Cyprus
                    ID = case_when(
                      ID %in% c("XAD", "XAX") ~ "XA",
                      ID %in% c("XCA", "XCX") ~ "XC",
                      ID %in% c("KOS", "XKO", "XKX") ~ "XK",
                      ID %in% c("XNC", "XNX") ~ "XN",
                      TRUE ~ countrycode(
                        ID |>
                          na_if("XAD") |>
                          na_if("XAX") |>
                          na_if("XCA") |>
                          na_if("XCX") |>
                          na_if("KOS") |>
                          na_if("XKO") |>
                          na_if("XKX") |>
                          na_if("XNC") |>
                          na_if("XNX"),
                        origin = "iso3c",
                        destination = "iso2c"
                      )
                    )
                  )
              } else {
                . |>
                  mutate(
                    ID = id
                  ) |>
                  select(-id)
              }
            }
          }()

        return(AQ.file)
      }
    )

  return(AQ)
}

#-------------------------------------------------------------------------------

AQ <- AQ.files |>
  str_subset(
    pattern = "popwtd",
    negate = TRUE
  ) |>
  Join_AQ() |>
  full_join(
    AQ.files |>
      str_subset(
        pattern = "popwtd",
        negate = FALSE
      ) |>
      Join_AQ() |>
      rename(
        PM25_PopWtd = PM25,
        NO2_PopWtd = NO2
      )
  ) |>
  arrange(ID) |>
  rename(
    PM2.5 = PM25,
    PM2.5_PopWtd = PM25_PopWtd,
  ) |>
  group_by(ID) |>
  summarise(
    across(
      matches("PM2.5|NO2"),
      function(x) {
        x |>
          mean(
            na.rm = TRUE
          )
      }
    ),
    .groups = "keep"
  ) |>
  ungroup() |>
  select(
    ID, PM2.5, PM2.5_PopWtd, NO2, NO2_PopWtd
  )

################################################################################

COVID19.Static <- COVID19.LUT |>
  select(ID) |>
  left_join(
    AQ
  ) |>
  # left_join(
  #   COVID19.Static_US
  # ) |>
  left_join(
    COVID19.Static_UVA
  ) |>
  remove_empty(
    c("rows", "cols")
  ) |>
  arrange(ID)

#-------------------------------------------------------------------------------

COVID19.Static_All <- COVID19.LUT |>
  select(ID) |>
  full_join(
    COVID19.Static_US
  ) |>
  left_join(
    AQ
  ) |>
  left_join(
    COVID19.Static_UVA |>
      select(
        -matches("Diabetes|Smoking|Obesity|WorldPop_F|WorldPop_M|Sex_Ratio")
      )
  ) |>
  remove_empty(
    c("rows", "cols")
  ) |>
  arrange(ID)

################################################################################

COVID19.Static |>
  saveRDS(
    file = "COVID-19_Static.rds",
    compress = "xz",
    ascii = FALSE,
    version = NULL,
    refhook = NULL
  )

COVID19.Static_All |>
  saveRDS(
    file = "COVID-19_Static_All.rds",
    compress = "xz",
    ascii = FALSE,
    version = NULL,
    refhook = NULL
  )

COVID19.Static_US |>
  saveRDS(
    file = "COVID-19_Static_US.rds",
    compress = "xz",
    ascii = FALSE,
    version = NULL,
    refhook = NULL
  )

COVID19.Static_UVA |>
  saveRDS(
    file = "COVID-19_Static_UVA.rds",
    compress = "xz",
    ascii = FALSE,
    version = NULL,
    refhook = NULL
  )

#-------------------------------------------------------------------------------

COVID19.Static |>
  write_fst(
    path = "COVID-19_Static.fst",
    compress = 100,
    uniform_encoding = TRUE
  )

COVID19.Static_All |>
  write_fst(
    path = "COVID-19_Static_All.fst",
    compress = 100,
    uniform_encoding = TRUE
  )

COVID19.Static_US |>
  write_fst(
    path = "COVID-19_Static_US.fst",
    compress = 100,
    uniform_encoding = TRUE
  )

COVID19.Static_UVA |>
  write_fst(
    path = "COVID-19_Static_UVA.fst",
    compress = 100,
    uniform_encoding = TRUE
  )

#-------------------------------------------------------------------------------

COVID19.Static |>
  write_delim(
    file = "COVID-19_Static.csv.xz",
    delim = ",",
    eol = "\n",
    na = "",
    escape = "double",
    num_threads = 1L,
    append = FALSE,
    col_names = TRUE,
    progress = FALSE
  )

################################################################################

saveRDS(
  AQ,
  file = "AQ.rds",
  compress = "xz",
  ascii = FALSE,
  version = NULL,
  refhook = NULL
)

#-------------------------------------------------------------------------------

AQ <- AQ |>
  mutate(
    PM2.5 = PM2.5 |>
      round(2) |>
      format(nsmall = 2, trim = TRUE) |>
      na_if("NA"),
    PM2.5_PopWtd = PM2.5_PopWtd |>
      round(2) |>
      format(nsmall = 2, trim = TRUE) |>
      na_if("NA"),
    NO2 = NO2 |>
      round(2) |>
      format(nsmall = 2, trim = TRUE) |>
      na_if("NA"),
    NO2_PopWtd = NO2_PopWtd |>
      round(2) |>
      format(nsmall = 2, trim = TRUE) |>
      na_if("NA")
  ) |>
  select(
    ID, PM2.5, PM2.5_PopWtd, NO2, NO2_PopWtd
  )

#-------------------------------------------------------------------------------

AQ |>
  write_delim(
    file = "AQ.csv",
    delim = ",",
    eol = "\n",
    na = "",
    escape = "double",
    num_threads = 1L,
    append = FALSE,
    col_names = TRUE,
    progress = FALSE
  )

################################################################################
################################################################################
################################################################################

Sys.time() - tstart

################################################################################
