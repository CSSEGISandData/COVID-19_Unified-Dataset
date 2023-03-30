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

Vaccine.US <- read_delim(
  file = VAX_URL |>
    str_interp(
      env = list(
        region = "us",
        file = file.path(
          "time_series",
          "time_series_covid19_vaccine_us.csv"
        )
      )
    ),
  col_names = TRUE,
  col_types = cols(
    Date = col_date(format = "%Y-%m-%d"),
    UID = col_integer(),
    Province_State = col_character(),
    Country_Region = col_character(),
    Doses_admin = col_double(),
    People_at_least_one_dose = col_double(),
    People_fully_vaccinated = col_double(),
    Total_additional_doses = col_double()
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
  left_join(
    UID
  ) |>
  # filter(
  #   !is.na(FIPS)
  # ) |>
  mutate(
    ID = case_when(
      is.na(FIPS) ~ "US",
      TRUE ~ "US" |>
        str_c(
          FIPS |>
            str_pad(
              width = 2,
              pad = "0"
            )
        )
    )
  ) |>
  rename(
    Doses_Additional = Total_additional_doses,
    Vax_Full = People_fully_vaccinated,
    Vax_Partial = People_at_least_one_dose
  ) |>
  pivot_longer(
    cols = contains("Dose"),
    names_to = "DoseType",
    values_to = "DoseValue"
  ) |>
  mutate(
    DoseType = DoseType |>
      recode(
        "Doses_alloc" = "Alloc",
        "Doses_shipped" = "Ship",
        "Doses_admin" = "Admin",
        "Doses_Additional" = "Addit",
        "Stage_One_Doses" = "Stage1",
        "Stage_Two_Doses" = "Stage2"
      )
  ) |>
  filter(
    ID != "US" | UID == 840
  ) |>
  arrange(
    ID, Date, DoseType
  ) |>
  select(
    ID, Date, contains("Vax"), contains("Dose")
  )

################################################################################

Vaccine.Global <- read_delim(
  file = VAX_URL |>
    str_interp(
      env = list(
        region = "global",
        file = "time_series_covid19_vaccine_global.csv"
      )
    ),
  col_names = TRUE,
  col_types = cols(
    Date = col_date(format = "%Y-%m-%d"),
    UID = col_integer(),
    Province_State = col_character(),
    Country_Region = col_character(),
    Doses_admin = col_double(),
    People_at_least_one_dose = col_double()
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
  select(
    Date, UID,
    contains("Doses"),
    contains("People")
  ) |>
  left_join(
    UID |>
      select(
        UID, contains("Admin")
      )
  ) |>
  left_join(
    COVID19.LUT |>
      select(
        ID, contains("Admin")
      )
  ) |>
  filter(
    !is.na(ID)
  ) |>
  rename(
    # Vax_Full = People_fully_vaccinated,
    Vax_Partial = People_at_least_one_dose
  ) |>
  pivot_longer(
    cols = contains("Dose"),
    names_to = "DoseType",
    values_to = "DoseValue"
  ) |>
  mutate(
    DoseType = DoseType |>
      recode(
        "Doses_alloc" = "Alloc",
        "Doses_shipped" = "Ship",
        "Doses_admin" = "Admin",
        "Doses_Additional" = "Addit",
        "Stage_One_Doses" = "Stage1",
        "Stage_Two_Doses" = "Stage2"
      )
  ) |>
  select(
    ID, Date, contains("Vax"), contains("Dose")
  )

################################################################################

Vaccine <- Vaccine.US |>
  full_join(Vaccine.Global) |>
  mutate(
    across(
      DoseType,
      as.factor
    )
  ) |>
  arrange(
    ID, Date, DoseType
  ) |>
  select(
    ID, Date, contains("Dose"),
    contains("Vax")
  )

################################################################################

Vaccine |>
  saveRDS(
    file = "Vaccine.rds",
    compress = "xz",
    ascii = FALSE,
    version = NULL,
    refhook = NULL
  )

#-------------------------------------------------------------------------------

Vaccine |>
  write_fst(
    path = "Vaccine.fst",
    compress = 100,
    uniform_encoding = TRUE
  )

#-------------------------------------------------------------------------------

Vaccine |>
  write_delim(
    file = "Vaccine.csv.xz",
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
