#!/usr/bin/env Rscript
################################################################################
# Copyright 2020-2023 Hamada S. Badr <badr@jhu.edu>
################################################################################

tstart <- Sys.time()

################################################################################

run.dir <- Sys.getenv(
  "runDir",
  file.path(
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
  showWarnings = FALSE,
  recursive = TRUE,
  mode = "0775"
)

setwd(
  file.path(
    COVID19.dir,
    "Outputs"
  )
)

################################################################################

envFile <- ifelse(
  file.path(
    Sys.getenv("HOME"),
    ".R",
    "env.R"
  ) |>
    file.exists(),
  file.path(
    Sys.getenv("HOME"),
    ".R",
    "env.R"
  ),
  file.path(
    COVID19.dir,
    "Modeling",
    "env.R"
  )
)

if (!file.exists(envFile)) {
  stop(
    paste(
      "Environment file",
      envFile,
      "does not exist!"
    )
  )
}

#-------------------------------------------------------------------------------

if (!exists("parallel_plan")) {
  source(
    file = envFile,
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

Policy.raw.2020 <- read_delim(
  file = OxCGRT_URL |>
    str_interp(
      env = list(
        repo = "covid-policy-tracker",
        file = "OxCGRT_nat_differentiated_withnotes_2020.csv"
      )
    ),
  col_names = TRUE,
  col_types = cols(
    CountryName = col_character(),
    CountryCode = col_character(),
    RegionName = col_character(),
    RegionCode = col_character(),
    Jurisdiction = col_character(),
    Date = col_date(format = "%Y%m%d"),
    `C1E_School closing` = col_double(),
    C1E_Flag = col_logical(),
    `C1NV_School closing` = col_double(),
    C1NV_Flag = col_logical(),
    `C1V_School closing` = col_double(),
    C1V_Flag = col_logical(),
    `C1M_School closing` = col_double(),
    C1M_Flag = col_logical(),
    C1_Notes = col_character(),
    `C2E_Workplace closing` = col_double(),
    C2E_Flag = col_logical(),
    `C2NV_Workplace closing` = col_double(),
    C2NV_Flag = col_logical(),
    `C2V_Workplace closing` = col_double(),
    C2V_Flag = col_logical(),
    `C2M_Workplace closing` = col_double(),
    C2M_Flag = col_logical(),
    C2_Notes = col_character(),
    `C3E_Cancel public events` = col_double(),
    C3E_Flag = col_logical(),
    `C3NV_Cancel public events` = col_double(),
    C3NV_Flag = col_logical(),
    `C3V_Cancel public events` = col_double(),
    C3V_Flag = col_logical(),
    `C3M_Cancel public events` = col_double(),
    C3M_Flag = col_logical(),
    C3_Notes = col_character(),
    `C4E_Restrictions on gatherings` = col_double(),
    C4E_Flag = col_logical(),
    `C4NV_Restrictions on gatherings` = col_double(),
    C4NV_Flag = col_logical(),
    `C4V_Restrictions on gatherings` = col_double(),
    C4V_Flag = col_logical(),
    `C4M_Restrictions on gatherings` = col_double(),
    C4M_Flag = col_logical(),
    C4_Notes = col_character(),
    `C5E_Close public transport` = col_double(),
    C5E_Flag = col_logical(),
    `C5NV_Close public transport` = col_double(),
    C5NV_Flag = col_logical(),
    `C5V_Close public transport` = col_double(),
    C5V_Flag = col_logical(),
    `C5M_Close public transport` = col_double(),
    C5M_Flag = col_logical(),
    C5_Notes = col_character(),
    `C6E_Stay at home requirements` = col_double(),
    C6E_Flag = col_logical(),
    `C6NV_Stay at home requirements` = col_double(),
    C6NV_Flag = col_logical(),
    `C6V_Stay at home requirements` = col_double(),
    C6V_Flag = col_logical(),
    `C6M_Stay at home requirements` = col_double(),
    C6M_Flag = col_logical(),
    C6_Notes = col_character(),
    `C7E_Restrictions on internal movement` = col_double(),
    C7E_Flag = col_logical(),
    `C7NV_Restrictions on internal movement` = col_double(),
    C7NV_Flag = col_logical(),
    `C7V_Restrictions on internal movement` = col_double(),
    C7V_Flag = col_logical(),
    `C7M_Restrictions on internal movement` = col_double(),
    C7M_Flag = col_logical(),
    C7_Notes = col_character(),
    `C8E_International travel controls` = col_double(),
    `C8NV_International travel controls` = col_double(),
    `C8V_International travel controls` = col_double(),
    `C8EV_International travel controls` = col_double(),
    C8_Notes = col_character(),
    `E1E_Income support` = col_double(),
    E1E_Flag = col_logical(),
    E1_Notes = col_character(),
    `E2E_Debt/contract relief` = col_double(),
    E2_Notes = col_character(),
    `E3E_Fiscal measures` = col_double(),
    E3_Notes = col_character(),
    `E4E_International support` = col_double(),
    E4_Notes = col_character(),
    `H1E_Public information campaigns` = col_double(),
    H1E_Flag = col_logical(),
    H1_Notes = col_character(),
    `H2E_Testing policy` = col_double(),
    H2_Notes = col_character(),
    `H3E_Contact tracing` = col_double(),
    H3_Notes = col_character(),
    `H4E_Emergency investment in healthcare` = col_double(),
    H4_Notes = col_character(),
    `H5E_Investment in vaccines` = col_double(),
    H5_Notes = col_character(),
    `H6E_Facial Coverings` = col_double(),
    H6E_Flag = col_logical(),
    `H6NV_Facial Coverings` = col_double(),
    H6NV_Flag = col_logical(),
    `H6V_Facial Coverings` = col_double(),
    H6V_Flag = col_logical(),
    `H6M_Facial Coverings` = col_double(),
    H6M_Flag = col_logical(),
    H6_Notes = col_character(),
    `H7E_Vaccination policy` = col_double(),
    H7E_Flag = col_logical(),
    H7_Notes = col_character(),
    `H8E_Protection of elderly people` = col_double(),
    H8E_Flag = col_logical(),
    `H8NV_Protection of elderly people` = col_double(),
    H8NV_Flag = col_logical(),
    `H8V_Protection of elderly people` = col_double(),
    H8V_Flag = col_logical(),
    `H8M_Protection of elderly people` = col_double(),
    H8M_Flag = col_logical(),
    H8_Notes = col_character(),
    M1E_Wildcard = col_logical(),
    M1_Notes = col_character(),
    `V1_Vaccine Prioritisation (summary)` = col_double(),
    V1_Notes = col_character(),
    `V2A_Vaccine Availability (summary)` = col_double(),
    V2_Notes = col_character(),
    `V2B_Vaccine age eligibility/availability age floor (general population summary)` = col_character(),
    `V2C_Vaccine age eligibility/availability age floor (at risk summary)` = col_character(),
    `V2D_Medically/ clinically vulnerable (Non-elderly)` = col_double(),
    V2E_Education = col_double(),
    `V2F_Frontline workers  (non healthcare)` = col_double(),
    `V2G_Frontline workers  (healthcare)` = col_double(),
    `V3_Vaccine Financial Support (summary)` = col_double(),
    V3_Notes = col_character(),
    `V4_Mandatory Vaccination (summary)` = col_double(),
    V4_Notes = col_character(),
    ConfirmedCases = col_double(),
    ConfirmedDeaths = col_double(),
    PopulationVaccinated = col_double(),
    StringencyIndex_NonVaccinated = col_double(),
    StringencyIndex_NonVaccinated_ForDisplay = col_double(),
    StringencyIndex_Vaccinated = col_double(),
    StringencyIndex_Vaccinated_ForDisplay = col_double(),
    StringencyIndex_SimpleAverage = col_double(),
    StringencyIndex_SimpleAverage_ForDisplay = col_double(),
    StringencyIndex_WeightedAverage = col_double(),
    StringencyIndex_WeightedAverage_ForDisplay = col_double(),
    GovernmentResponseIndex_NonVaccinated = col_double(),
    GovernmentResponseIndex_NonVaccinated_ForDisplay = col_double(),
    GovernmentResponseIndex_Vaccinated = col_double(),
    GovernmentResponseIndex_Vaccinated_ForDisplay = col_double(),
    GovernmentResponseIndex_SimpleAverage = col_double(),
    GovernmentResponseIndex_SimpleAverage_ForDisplay = col_double(),
    GovernmentResponseIndex_WeightedAverage = col_double(),
    GovernmentResponseIndex_WeightedAverage_ForDisplay = col_double(),
    ContainmentHealthIndex_NonVaccinated = col_double(),
    ContainmentHealthIndex_NonVaccinated_ForDisplay = col_double(),
    ContainmentHealthIndex_Vaccinated = col_double(),
    ContainmentHealthIndex_Vaccinated_ForDisplay = col_double(),
    ContainmentHealthIndex_SimpleAverage = col_double(),
    ContainmentHealthIndex_SimpleAverage_ForDisplay = col_double(),
    ContainmentHealthIndex_WeightedAverage = col_double(),
    ContainmentHealthIndex_WeightedAverage_ForDisplay = col_double(),
    EconomicSupportIndex = col_double(),
    EconomicSupportIndex_ForDisplay = col_double()
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
)

#-------------------------------------------------------------------------------

Policy.raw.2021 <- read_delim(
  file = OxCGRT_URL |>
    str_interp(
      env = list(
        repo = "covid-policy-tracker",
        file = "OxCGRT_nat_differentiated_withnotes_2021.csv"
      )
    ),
  col_names = TRUE,
  col_types = cols(
    CountryName = col_character(),
    CountryCode = col_character(),
    RegionName = col_character(),
    RegionCode = col_character(),
    Jurisdiction = col_character(),
    Date = col_date(format = "%Y%m%d"),
    `C1E_School closing` = col_double(),
    C1E_Flag = col_logical(),
    `C1NV_School closing` = col_double(),
    C1NV_Flag = col_logical(),
    `C1V_School closing` = col_double(),
    C1V_Flag = col_logical(),
    `C1M_School closing` = col_double(),
    C1M_Flag = col_logical(),
    C1_Notes = col_character(),
    `C2E_Workplace closing` = col_double(),
    C2E_Flag = col_logical(),
    `C2NV_Workplace closing` = col_double(),
    C2NV_Flag = col_logical(),
    `C2V_Workplace closing` = col_double(),
    C2V_Flag = col_logical(),
    `C2M_Workplace closing` = col_double(),
    C2M_Flag = col_logical(),
    C2_Notes = col_character(),
    `C3E_Cancel public events` = col_double(),
    C3E_Flag = col_logical(),
    `C3NV_Cancel public events` = col_double(),
    C3NV_Flag = col_logical(),
    `C3V_Cancel public events` = col_double(),
    C3V_Flag = col_logical(),
    `C3M_Cancel public events` = col_double(),
    C3M_Flag = col_logical(),
    C3_Notes = col_character(),
    `C4E_Restrictions on gatherings` = col_double(),
    C4E_Flag = col_logical(),
    `C4NV_Restrictions on gatherings` = col_double(),
    C4NV_Flag = col_logical(),
    `C4V_Restrictions on gatherings` = col_double(),
    C4V_Flag = col_logical(),
    `C4M_Restrictions on gatherings` = col_double(),
    C4M_Flag = col_logical(),
    C4_Notes = col_character(),
    `C5E_Close public transport` = col_double(),
    C5E_Flag = col_logical(),
    `C5NV_Close public transport` = col_double(),
    C5NV_Flag = col_logical(),
    `C5V_Close public transport` = col_double(),
    C5V_Flag = col_logical(),
    `C5M_Close public transport` = col_double(),
    C5M_Flag = col_logical(),
    C5_Notes = col_character(),
    `C6E_Stay at home requirements` = col_double(),
    C6E_Flag = col_logical(),
    `C6NV_Stay at home requirements` = col_double(),
    C6NV_Flag = col_logical(),
    `C6V_Stay at home requirements` = col_double(),
    C6V_Flag = col_logical(),
    `C6M_Stay at home requirements` = col_double(),
    C6M_Flag = col_logical(),
    C6_Notes = col_character(),
    `C7E_Restrictions on internal movement` = col_double(),
    C7E_Flag = col_logical(),
    `C7NV_Restrictions on internal movement` = col_double(),
    C7NV_Flag = col_logical(),
    `C7V_Restrictions on internal movement` = col_double(),
    C7V_Flag = col_logical(),
    `C7M_Restrictions on internal movement` = col_double(),
    C7M_Flag = col_logical(),
    C7_Notes = col_character(),
    `C8E_International travel controls` = col_double(),
    `C8NV_International travel controls` = col_double(),
    `C8V_International travel controls` = col_double(),
    `C8EV_International travel controls` = col_double(),
    C8_Notes = col_character(),
    `E1E_Income support` = col_double(),
    E1E_Flag = col_logical(),
    E1_Notes = col_character(),
    `E2E_Debt/contract relief` = col_double(),
    E2_Notes = col_character(),
    `E3E_Fiscal measures` = col_double(),
    E3_Notes = col_character(),
    `E4E_International support` = col_double(),
    E4_Notes = col_character(),
    `H1E_Public information campaigns` = col_double(),
    H1E_Flag = col_logical(),
    H1_Notes = col_character(),
    `H2E_Testing policy` = col_double(),
    H2_Notes = col_character(),
    `H3E_Contact tracing` = col_double(),
    H3_Notes = col_character(),
    `H4E_Emergency investment in healthcare` = col_double(),
    H4_Notes = col_character(),
    `H5E_Investment in vaccines` = col_double(),
    H5_Notes = col_character(),
    `H6E_Facial Coverings` = col_double(),
    H6E_Flag = col_logical(),
    `H6NV_Facial Coverings` = col_double(),
    H6NV_Flag = col_logical(),
    `H6V_Facial Coverings` = col_double(),
    H6V_Flag = col_logical(),
    `H6M_Facial Coverings` = col_double(),
    H6M_Flag = col_logical(),
    H6_Notes = col_character(),
    `H7E_Vaccination policy` = col_double(),
    H7E_Flag = col_logical(),
    H7_Notes = col_character(),
    `H8E_Protection of elderly people` = col_double(),
    H8E_Flag = col_logical(),
    `H8NV_Protection of elderly people` = col_double(),
    H8NV_Flag = col_logical(),
    `H8V_Protection of elderly people` = col_double(),
    H8V_Flag = col_logical(),
    `H8M_Protection of elderly people` = col_double(),
    H8M_Flag = col_logical(),
    H8_Notes = col_character(),
    M1E_Wildcard = col_logical(),
    M1_Notes = col_character(),
    `V1_Vaccine Prioritisation (summary)` = col_double(),
    V1_Notes = col_character(),
    `V2A_Vaccine Availability (summary)` = col_double(),
    V2_Notes = col_character(),
    `V2B_Vaccine age eligibility/availability age floor (general population summary)` = col_character(),
    `V2C_Vaccine age eligibility/availability age floor (at risk summary)` = col_character(),
    `V2D_Medically/ clinically vulnerable (Non-elderly)` = col_double(),
    V2E_Education = col_double(),
    `V2F_Frontline workers  (non healthcare)` = col_double(),
    `V2G_Frontline workers  (healthcare)` = col_double(),
    `V3_Vaccine Financial Support (summary)` = col_double(),
    V3_Notes = col_character(),
    `V4_Mandatory Vaccination (summary)` = col_double(),
    V4_Notes = col_character(),
    ConfirmedCases = col_double(),
    ConfirmedDeaths = col_double(),
    PopulationVaccinated = col_double(),
    StringencyIndex_NonVaccinated = col_double(),
    StringencyIndex_NonVaccinated_ForDisplay = col_double(),
    StringencyIndex_Vaccinated = col_double(),
    StringencyIndex_Vaccinated_ForDisplay = col_double(),
    StringencyIndex_SimpleAverage = col_double(),
    StringencyIndex_SimpleAverage_ForDisplay = col_double(),
    StringencyIndex_WeightedAverage = col_double(),
    StringencyIndex_WeightedAverage_ForDisplay = col_double(),
    GovernmentResponseIndex_NonVaccinated = col_double(),
    GovernmentResponseIndex_NonVaccinated_ForDisplay = col_double(),
    GovernmentResponseIndex_Vaccinated = col_double(),
    GovernmentResponseIndex_Vaccinated_ForDisplay = col_double(),
    GovernmentResponseIndex_SimpleAverage = col_double(),
    GovernmentResponseIndex_SimpleAverage_ForDisplay = col_double(),
    GovernmentResponseIndex_WeightedAverage = col_double(),
    GovernmentResponseIndex_WeightedAverage_ForDisplay = col_double(),
    ContainmentHealthIndex_NonVaccinated = col_double(),
    ContainmentHealthIndex_NonVaccinated_ForDisplay = col_double(),
    ContainmentHealthIndex_Vaccinated = col_double(),
    ContainmentHealthIndex_Vaccinated_ForDisplay = col_double(),
    ContainmentHealthIndex_SimpleAverage = col_double(),
    ContainmentHealthIndex_SimpleAverage_ForDisplay = col_double(),
    ContainmentHealthIndex_WeightedAverage = col_double(),
    ContainmentHealthIndex_WeightedAverage_ForDisplay = col_double(),
    EconomicSupportIndex = col_double(),
    EconomicSupportIndex_ForDisplay = col_double()
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
)

#-------------------------------------------------------------------------------

Policy.raw.2022 <- read_delim(
  file = OxCGRT_URL |>
    str_interp(
      env = list(
        repo = "covid-policy-tracker",
        file = "OxCGRT_nat_differentiated_withnotes_2022.csv"
      )
    ),
  col_names = TRUE,
  col_types = cols(
    CountryName = col_character(),
    CountryCode = col_character(),
    RegionName = col_character(),
    RegionCode = col_character(),
    Jurisdiction = col_character(),
    Date = col_date(format = "%Y%m%d"),
    `C1E_School closing` = col_double(),
    C1E_Flag = col_logical(),
    `C1NV_School closing` = col_double(),
    C1NV_Flag = col_logical(),
    `C1V_School closing` = col_double(),
    C1V_Flag = col_logical(),
    `C1M_School closing` = col_double(),
    C1M_Flag = col_logical(),
    C1_Notes = col_character(),
    `C2E_Workplace closing` = col_double(),
    C2E_Flag = col_logical(),
    `C2NV_Workplace closing` = col_double(),
    C2NV_Flag = col_logical(),
    `C2V_Workplace closing` = col_double(),
    C2V_Flag = col_logical(),
    `C2M_Workplace closing` = col_double(),
    C2M_Flag = col_logical(),
    C2_Notes = col_character(),
    `C3E_Cancel public events` = col_double(),
    C3E_Flag = col_logical(),
    `C3NV_Cancel public events` = col_double(),
    C3NV_Flag = col_logical(),
    `C3V_Cancel public events` = col_double(),
    C3V_Flag = col_logical(),
    `C3M_Cancel public events` = col_double(),
    C3M_Flag = col_logical(),
    C3_Notes = col_character(),
    `C4E_Restrictions on gatherings` = col_double(),
    C4E_Flag = col_logical(),
    `C4NV_Restrictions on gatherings` = col_double(),
    C4NV_Flag = col_logical(),
    `C4V_Restrictions on gatherings` = col_double(),
    C4V_Flag = col_logical(),
    `C4M_Restrictions on gatherings` = col_double(),
    C4M_Flag = col_logical(),
    C4_Notes = col_character(),
    `C5E_Close public transport` = col_double(),
    C5E_Flag = col_logical(),
    `C5NV_Close public transport` = col_double(),
    C5NV_Flag = col_logical(),
    `C5V_Close public transport` = col_double(),
    C5V_Flag = col_logical(),
    `C5M_Close public transport` = col_double(),
    C5M_Flag = col_logical(),
    C5_Notes = col_character(),
    `C6E_Stay at home requirements` = col_double(),
    C6E_Flag = col_logical(),
    `C6NV_Stay at home requirements` = col_double(),
    C6NV_Flag = col_logical(),
    `C6V_Stay at home requirements` = col_double(),
    C6V_Flag = col_logical(),
    `C6M_Stay at home requirements` = col_double(),
    C6M_Flag = col_logical(),
    C6_Notes = col_character(),
    `C7E_Restrictions on internal movement` = col_double(),
    C7E_Flag = col_logical(),
    `C7NV_Restrictions on internal movement` = col_double(),
    C7NV_Flag = col_logical(),
    `C7V_Restrictions on internal movement` = col_double(),
    C7V_Flag = col_logical(),
    `C7M_Restrictions on internal movement` = col_double(),
    C7M_Flag = col_logical(),
    C7_Notes = col_character(),
    `C8E_International travel controls` = col_double(),
    `C8NV_International travel controls` = col_double(),
    `C8V_International travel controls` = col_double(),
    `C8EV_International travel controls` = col_double(),
    C8_Notes = col_character(),
    `E1E_Income support` = col_double(),
    E1E_Flag = col_logical(),
    E1_Notes = col_character(),
    `E2E_Debt/contract relief` = col_double(),
    E2_Notes = col_character(),
    `E3E_Fiscal measures` = col_double(),
    E3_Notes = col_character(),
    `E4E_International support` = col_double(),
    E4_Notes = col_character(),
    `H1E_Public information campaigns` = col_double(),
    H1E_Flag = col_logical(),
    H1_Notes = col_character(),
    `H2E_Testing policy` = col_double(),
    H2_Notes = col_character(),
    `H3E_Contact tracing` = col_double(),
    H3_Notes = col_character(),
    `H4E_Emergency investment in healthcare` = col_double(),
    H4_Notes = col_character(),
    `H5E_Investment in vaccines` = col_double(),
    H5_Notes = col_character(),
    `H6E_Facial Coverings` = col_double(),
    H6E_Flag = col_logical(),
    `H6NV_Facial Coverings` = col_double(),
    H6NV_Flag = col_logical(),
    `H6V_Facial Coverings` = col_double(),
    H6V_Flag = col_logical(),
    `H6M_Facial Coverings` = col_double(),
    H6M_Flag = col_logical(),
    H6_Notes = col_character(),
    `H7E_Vaccination policy` = col_double(),
    H7E_Flag = col_logical(),
    H7_Notes = col_character(),
    `H8E_Protection of elderly people` = col_double(),
    H8E_Flag = col_logical(),
    `H8NV_Protection of elderly people` = col_double(),
    H8NV_Flag = col_logical(),
    `H8V_Protection of elderly people` = col_double(),
    H8V_Flag = col_logical(),
    `H8M_Protection of elderly people` = col_double(),
    H8M_Flag = col_logical(),
    H8_Notes = col_character(),
    M1E_Wildcard = col_logical(),
    M1_Notes = col_character(),
    `V1_Vaccine Prioritisation (summary)` = col_double(),
    V1_Notes = col_character(),
    `V2A_Vaccine Availability (summary)` = col_double(),
    V2_Notes = col_character(),
    `V2B_Vaccine age eligibility/availability age floor (general population summary)` = col_character(),
    `V2C_Vaccine age eligibility/availability age floor (at risk summary)` = col_character(),
    `V2D_Medically/ clinically vulnerable (Non-elderly)` = col_double(),
    V2E_Education = col_double(),
    `V2F_Frontline workers  (non healthcare)` = col_double(),
    `V2G_Frontline workers  (healthcare)` = col_double(),
    `V3_Vaccine Financial Support (summary)` = col_double(),
    V3_Notes = col_character(),
    `V4_Mandatory Vaccination (summary)` = col_double(),
    V4_Notes = col_character(),
    ConfirmedCases = col_double(),
    ConfirmedDeaths = col_double(),
    PopulationVaccinated = col_double(),
    StringencyIndex_NonVaccinated = col_double(),
    StringencyIndex_NonVaccinated_ForDisplay = col_double(),
    StringencyIndex_Vaccinated = col_double(),
    StringencyIndex_Vaccinated_ForDisplay = col_double(),
    StringencyIndex_SimpleAverage = col_double(),
    StringencyIndex_SimpleAverage_ForDisplay = col_double(),
    StringencyIndex_WeightedAverage = col_double(),
    StringencyIndex_WeightedAverage_ForDisplay = col_double(),
    GovernmentResponseIndex_NonVaccinated = col_double(),
    GovernmentResponseIndex_NonVaccinated_ForDisplay = col_double(),
    GovernmentResponseIndex_Vaccinated = col_double(),
    GovernmentResponseIndex_Vaccinated_ForDisplay = col_double(),
    GovernmentResponseIndex_SimpleAverage = col_double(),
    GovernmentResponseIndex_SimpleAverage_ForDisplay = col_double(),
    GovernmentResponseIndex_WeightedAverage = col_double(),
    GovernmentResponseIndex_WeightedAverage_ForDisplay = col_double(),
    ContainmentHealthIndex_NonVaccinated = col_double(),
    ContainmentHealthIndex_NonVaccinated_ForDisplay = col_double(),
    ContainmentHealthIndex_Vaccinated = col_double(),
    ContainmentHealthIndex_Vaccinated_ForDisplay = col_double(),
    ContainmentHealthIndex_SimpleAverage = col_double(),
    ContainmentHealthIndex_SimpleAverage_ForDisplay = col_double(),
    ContainmentHealthIndex_WeightedAverage = col_double(),
    ContainmentHealthIndex_WeightedAverage_ForDisplay = col_double(),
    EconomicSupportIndex = col_double(),
    EconomicSupportIndex_ForDisplay = col_double()
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
)

#-------------------------------------------------------------------------------

Policy.raw.2023 <- read_delim(
  file = OxCGRT_URL |>
    str_interp(
      env = list(
        repo = "covid-policy-tracker",
        file = "OxCGRT_nat_differentiated_withnotes_2023.csv"
      )
    ),
  col_names = TRUE,
  col_types = cols(
    CountryName = col_character(),
    CountryCode = col_character(),
    RegionName = col_character(),
    RegionCode = col_character(),
    Jurisdiction = col_character(),
    Date = col_date(format = "%Y%m%d"),
    `C1E_School closing` = col_double(),
    C1E_Flag = col_logical(),
    `C1NV_School closing` = col_double(),
    C1NV_Flag = col_logical(),
    `C1V_School closing` = col_double(),
    C1V_Flag = col_logical(),
    `C1M_School closing` = col_double(),
    C1M_Flag = col_logical(),
    C1_Notes = col_character(),
    `C2E_Workplace closing` = col_double(),
    C2E_Flag = col_logical(),
    `C2NV_Workplace closing` = col_double(),
    C2NV_Flag = col_logical(),
    `C2V_Workplace closing` = col_double(),
    C2V_Flag = col_logical(),
    `C2M_Workplace closing` = col_double(),
    C2M_Flag = col_logical(),
    C2_Notes = col_character(),
    `C3E_Cancel public events` = col_double(),
    C3E_Flag = col_logical(),
    `C3NV_Cancel public events` = col_double(),
    C3NV_Flag = col_logical(),
    `C3V_Cancel public events` = col_double(),
    C3V_Flag = col_logical(),
    `C3M_Cancel public events` = col_double(),
    C3M_Flag = col_logical(),
    C3_Notes = col_character(),
    `C4E_Restrictions on gatherings` = col_double(),
    C4E_Flag = col_logical(),
    `C4NV_Restrictions on gatherings` = col_double(),
    C4NV_Flag = col_logical(),
    `C4V_Restrictions on gatherings` = col_double(),
    C4V_Flag = col_logical(),
    `C4M_Restrictions on gatherings` = col_double(),
    C4M_Flag = col_logical(),
    C4_Notes = col_character(),
    `C5E_Close public transport` = col_double(),
    C5E_Flag = col_logical(),
    `C5NV_Close public transport` = col_double(),
    C5NV_Flag = col_logical(),
    `C5V_Close public transport` = col_double(),
    C5V_Flag = col_logical(),
    `C5M_Close public transport` = col_double(),
    C5M_Flag = col_logical(),
    C5_Notes = col_character(),
    `C6E_Stay at home requirements` = col_double(),
    C6E_Flag = col_logical(),
    `C6NV_Stay at home requirements` = col_double(),
    C6NV_Flag = col_logical(),
    `C6V_Stay at home requirements` = col_double(),
    C6V_Flag = col_logical(),
    `C6M_Stay at home requirements` = col_double(),
    C6M_Flag = col_logical(),
    C6_Notes = col_character(),
    `C7E_Restrictions on internal movement` = col_double(),
    C7E_Flag = col_logical(),
    `C7NV_Restrictions on internal movement` = col_double(),
    C7NV_Flag = col_logical(),
    `C7V_Restrictions on internal movement` = col_double(),
    C7V_Flag = col_logical(),
    `C7M_Restrictions on internal movement` = col_double(),
    C7M_Flag = col_logical(),
    C7_Notes = col_character(),
    `C8E_International travel controls` = col_double(),
    `C8NV_International travel controls` = col_double(),
    `C8V_International travel controls` = col_double(),
    `C8EV_International travel controls` = col_double(),
    C8_Notes = col_character(),
    `E1E_Income support` = col_double(),
    E1E_Flag = col_logical(),
    E1_Notes = col_character(),
    `E2E_Debt/contract relief` = col_double(),
    E2_Notes = col_character(),
    `E3E_Fiscal measures` = col_double(),
    E3_Notes = col_character(),
    `E4E_International support` = col_double(),
    E4_Notes = col_character(),
    `H1E_Public information campaigns` = col_double(),
    H1E_Flag = col_logical(),
    H1_Notes = col_character(),
    `H2E_Testing policy` = col_double(),
    H2_Notes = col_character(),
    `H3E_Contact tracing` = col_double(),
    H3_Notes = col_character(),
    `H4E_Emergency investment in healthcare` = col_double(),
    H4_Notes = col_character(),
    `H5E_Investment in vaccines` = col_double(),
    H5_Notes = col_character(),
    `H6E_Facial Coverings` = col_double(),
    H6E_Flag = col_logical(),
    `H6NV_Facial Coverings` = col_double(),
    H6NV_Flag = col_logical(),
    `H6V_Facial Coverings` = col_double(),
    H6V_Flag = col_logical(),
    `H6M_Facial Coverings` = col_double(),
    H6M_Flag = col_logical(),
    H6_Notes = col_character(),
    `H7E_Vaccination policy` = col_double(),
    H7E_Flag = col_logical(),
    H7_Notes = col_character(),
    `H8E_Protection of elderly people` = col_double(),
    H8E_Flag = col_logical(),
    `H8NV_Protection of elderly people` = col_double(),
    H8NV_Flag = col_logical(),
    `H8V_Protection of elderly people` = col_double(),
    H8V_Flag = col_logical(),
    `H8M_Protection of elderly people` = col_double(),
    H8M_Flag = col_logical(),
    H8_Notes = col_character(),
    M1E_Wildcard = col_logical(),
    M1_Notes = col_character(),
    `V1_Vaccine Prioritisation (summary)` = col_double(),
    V1_Notes = col_character(),
    `V2A_Vaccine Availability (summary)` = col_double(),
    V2_Notes = col_character(),
    `V2B_Vaccine age eligibility/availability age floor (general population summary)` = col_character(),
    `V2C_Vaccine age eligibility/availability age floor (at risk summary)` = col_character(),
    `V2D_Medically/ clinically vulnerable (Non-elderly)` = col_double(),
    V2E_Education = col_double(),
    `V2F_Frontline workers  (non healthcare)` = col_double(),
    `V2G_Frontline workers  (healthcare)` = col_double(),
    `V3_Vaccine Financial Support (summary)` = col_double(),
    V3_Notes = col_character(),
    `V4_Mandatory Vaccination (summary)` = col_double(),
    V4_Notes = col_character(),
    ConfirmedCases = col_double(),
    ConfirmedDeaths = col_double(),
    PopulationVaccinated = col_double(),
    StringencyIndex_NonVaccinated = col_double(),
    StringencyIndex_NonVaccinated_ForDisplay = col_double(),
    StringencyIndex_Vaccinated = col_double(),
    StringencyIndex_Vaccinated_ForDisplay = col_double(),
    StringencyIndex_SimpleAverage = col_double(),
    StringencyIndex_SimpleAverage_ForDisplay = col_double(),
    StringencyIndex_WeightedAverage = col_double(),
    StringencyIndex_WeightedAverage_ForDisplay = col_double(),
    GovernmentResponseIndex_NonVaccinated = col_double(),
    GovernmentResponseIndex_NonVaccinated_ForDisplay = col_double(),
    GovernmentResponseIndex_Vaccinated = col_double(),
    GovernmentResponseIndex_Vaccinated_ForDisplay = col_double(),
    GovernmentResponseIndex_SimpleAverage = col_double(),
    GovernmentResponseIndex_SimpleAverage_ForDisplay = col_double(),
    GovernmentResponseIndex_WeightedAverage = col_double(),
    GovernmentResponseIndex_WeightedAverage_ForDisplay = col_double(),
    ContainmentHealthIndex_NonVaccinated = col_double(),
    ContainmentHealthIndex_NonVaccinated_ForDisplay = col_double(),
    ContainmentHealthIndex_Vaccinated = col_double(),
    ContainmentHealthIndex_Vaccinated_ForDisplay = col_double(),
    ContainmentHealthIndex_SimpleAverage = col_double(),
    ContainmentHealthIndex_SimpleAverage_ForDisplay = col_double(),
    ContainmentHealthIndex_WeightedAverage = col_double(),
    ContainmentHealthIndex_WeightedAverage_ForDisplay = col_double(),
    EconomicSupportIndex = col_double(),
    EconomicSupportIndex_ForDisplay = col_double()
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
)

################################################################################

Policy.raw.US <- read_delim(
  file = OxCGRT_URL |>
    str_interp(
      env = list(
        repo = "USA-covid-policy",
        file = "OxCGRT_US_latest.csv"
      )
    ),
  col_names = TRUE,
  col_types = cols(
    CountryName = col_character(),
    CountryCode = col_character(),
    RegionName = col_character(),
    RegionCode = col_character(),
    Jurisdiction = col_character(),
    Date = col_date(format = "%Y%m%d"),
    `C1_School closing` = col_double(),
    C1_Flag = col_logical(),
    C1_Notes = col_character(),
    `C2_Workplace closing` = col_double(),
    C2_Flag = col_logical(),
    C2_Notes = col_character(),
    `C3_Cancel public events` = col_double(),
    C3_Flag = col_logical(),
    C3_Notes = col_character(),
    `C4_Restrictions on gatherings` = col_double(),
    C4_Flag = col_logical(),
    C4_Notes = col_character(),
    `C5_Close public transport` = col_double(),
    C5_Flag = col_logical(),
    C5_Notes = col_character(),
    `C6_Stay at home requirements` = col_double(),
    C6_Flag = col_logical(),
    C6_Notes = col_character(),
    `C7_Restrictions on internal movement` = col_double(),
    C7_Flag = col_logical(),
    C7_Notes = col_character(),
    `C8_International travel controls` = col_double(),
    C8_Notes = col_character(),
    `E1_Income support` = col_double(),
    E1_Flag = col_logical(),
    E1_Notes = col_character(),
    `E2_Debt/contract relief` = col_double(),
    E2_Notes = col_character(),
    `E3_Fiscal measures` = col_double(),
    E3_Notes = col_character(),
    `E4_International support` = col_double(),
    E4_Notes = col_character(),
    `H1_Public information campaigns` = col_double(),
    H1_Flag = col_logical(),
    H1_Notes = col_character(),
    `H2_Testing policy` = col_double(),
    H2_Notes = col_character(),
    `H3_Contact tracing` = col_double(),
    H3_Notes = col_character(),
    `H4_Emergency investment in healthcare` = col_double(),
    H4_Notes = col_character(),
    `H5_Investment in vaccines` = col_double(),
    H5_Notes = col_character(),
    `H6_Facial Coverings` = col_double(),
    H6_Flag = col_logical(),
    H6_Notes = col_character(),
    `H7_Vaccination policy` = col_double(),
    H7_Flag = col_logical(),
    H7_Notes = col_character(),
    `H8_Protection of elderly people` = col_double(),
    H8_Flag = col_logical(),
    H8_Notes = col_character(),
    M1_Wildcard = col_logical(),
    M1_Notes = col_character(),
    `V1_Vaccine Prioritisation (summary)` = col_double(),
    V1_Notes = col_character(),
    `V2A_Vaccine Availability (summary)` = col_double(),
    V2_Notes = col_character(),
    `V2B_Vaccine age eligibility/availability age floor (general population summary)` = col_character(),
    `V2C_Vaccine age eligibility/availability age floor (at risk summary)` = col_character(),
    `V2D_Medically/ clinically vulnerable (Non-elderly)` = col_double(),
    V2E_Education = col_double(),
    `V2F_Frontline workers  (non healthcare)` = col_double(),
    `V2G_Frontline workers  (healthcare)` = col_double(),
    `V3_Vaccine Financial Support (summary)` = col_double(),
    V3_Notes = col_character(),
    `V4_Mandatory Vaccination (summary)` = col_double(),
    V4_Notes = col_character(),
    ConfirmedCases = col_double(),
    ConfirmedDeaths = col_double(),
    StringencyIndex = col_double(),
    StringencyIndexForDisplay = col_double(),
    StringencyLegacyIndex = col_double(),
    StringencyLegacyIndexForDisplay = col_double(),
    GovernmentResponseIndex = col_double(),
    GovernmentResponseIndexForDisplay = col_double(),
    ContainmentHealthIndex = col_double(),
    ContainmentHealthIndexForDisplay = col_double(),
    EconomicSupportIndex = col_double(),
    EconomicSupportIndexForDisplay = col_double()
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
  mutate(
    Jurisdiction = Jurisdiction |>
      str_c(
        "US",
        sep = "."
      )
  )

################################################################################

Policy.raw.BR <- read_delim(
  # file = OxCGRT_URL |>
  #   str_interp(
  #     env = list(
  #       repo = "Brazil-covid-policy",
  #       file = "Survey_Brazil_Covid.dta" # "OxCGRT_Brazil_latest.csv"
  #     )
  #   ),
  file = "OxCGRT_Brazil_latest.csv",
  col_names = TRUE,
  col_types = cols(
    CountryName = col_character(),
    CountryCode = col_character(),
    RegionName = col_character(),
    RegionCode = col_character(),
    CityName = col_character(),
    CityCode = col_character(),
    Jurisdiction = col_character(),
    Date = col_date(format = "%Y%m%d"),
    `C1_School closing` = col_double(),
    C1_Flag = col_logical(),
    C1_Notes = col_character(),
    `C2_Workplace closing` = col_double(),
    C2_Flag = col_logical(),
    C2_Notes = col_character(),
    `C3_Cancel public events` = col_double(),
    C3_Flag = col_logical(),
    C3_Notes = col_character(),
    `C4_Restrictions on gatherings` = col_double(),
    C4_Flag = col_logical(),
    C4_Notes = col_character(),
    `C5_Close public transport` = col_double(),
    C5_Flag = col_logical(),
    C5_Notes = col_character(),
    `C6_Stay at home requirements` = col_double(),
    C6_Flag = col_logical(),
    C6_Notes = col_character(),
    `C7_Restrictions on internal movement` = col_double(),
    C7_Flag = col_logical(),
    C7_Notes = col_character(),
    `C8_International travel controls` = col_double(),
    C8_Notes = col_character(),
    `E1_Income support` = col_double(),
    E1_Flag = col_logical(),
    E1_Notes = col_character(),
    `E2_Debt/contract relief` = col_double(),
    E2_Notes = col_character(),
    `E3_Fiscal measures` = col_double(),
    E3_Notes = col_character(),
    `E4_International support` = col_double(),
    E4_Notes = col_character(),
    `H1_Public information campaigns` = col_double(),
    H1_Flag = col_logical(),
    H1_Notes = col_character(),
    `H2_Testing policy` = col_double(),
    H2_Notes = col_character(),
    `H3_Contact tracing` = col_double(),
    H3_Notes = col_character(),
    `H4_Emergency investment in healthcare` = col_double(),
    H4_Notes = col_character(),
    `H5_Investment in vaccines` = col_double(),
    H5_Notes = col_character(),
    `H6_Facial Coverings` = col_double(),
    H6_Flag = col_logical(),
    H6_Notes = col_character(),
    `H7_Vaccination policy` = col_double(),
    H7_Flag = col_logical(),
    H7_Notes = col_character(),
    `H8_Protection of elderly people` = col_double(),
    H8_Flag = col_logical(),
    H8_Notes = col_character(),
    M1_Wildcard = col_logical(),
    M1_Notes = col_character(),
    `V1_Vaccine Prioritisation` = col_double(),
    V1_Notes = col_character(),
    `V2_Vaccine Availability` = col_double(),
    V2_Notes = col_character(),
    `V3_Vaccine Financial Support` = col_double(),
    V3_Notes = col_character(),
    `V4_Mandatory Vaccination` = col_double(),
    V4_Notes = col_character(),
    ConfirmedCases = col_double(),
    ConfirmedDeaths = col_double(),
    StringencyIndex = col_double(),
    StringencyIndexForDisplay = col_double(),
    StringencyLegacyIndex = col_double(),
    StringencyLegacyIndexForDisplay = col_double(),
    GovernmentResponseIndex = col_double(),
    GovernmentResponseIndexForDisplay = col_double(),
    ContainmentHealthIndex = col_double(),
    ContainmentHealthIndexForDisplay = col_double(),
    EconomicSupportIndex = col_double(),
    EconomicSupportIndexForDisplay = col_double()
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
  mutate(
    Jurisdiction = Jurisdiction |>
      str_c(
        "BR",
        sep = "."
      )
  ) |>
  filter(
    is.na(CityCode)
  )

################################################################################

Policy.raw <- Policy.raw.2020 |>
  rename_with(
    function(x) {
      x |>
        str_replace(
          pattern = "_ForDisplay",
          replacement = "ForDisplay"
        ) |>
        str_remove_all(
          pattern = " \\(summary\\)"
        )
    }
  ) |>
  bind_rows(
    Policy.raw.2021 |>
      rename_with(
        function(x) {
          x |>
            str_replace(
              pattern = "_ForDisplay",
              replacement = "ForDisplay"
            ) |>
            str_remove_all(
              pattern = " \\(summary\\)"
            )
        }
      )
  ) |>
  bind_rows(
    Policy.raw.2022 |>
      rename_with(
        function(x) {
          x |>
            str_replace(
              pattern = "_ForDisplay",
              replacement = "ForDisplay"
            ) |>
            str_remove_all(
              pattern = " \\(summary\\)"
            )
        }
      )
  ) |>
  bind_rows(
    Policy.raw.2023 |>
      rename_with(
        function(x) {
          x |>
            str_replace(
              pattern = "_ForDisplay",
              replacement = "ForDisplay"
            ) |>
            str_remove_all(
              pattern = " \\(summary\\)"
            )
        }
      )
  ) |>
  bind_rows(
    Policy.raw.US |>
      rename_with(
        function(x) {
          x |>
            str_replace(
              pattern = "_ForDisplay",
              replacement = "ForDisplay"
            ) |>
            str_remove_all(
              pattern = " \\(summary\\)"
            )
        }
      )
  ) |>
  bind_rows(
    Policy.raw.BR |>
      rename_with(
        function(x) {
          x |>
            str_replace(
              pattern = "_ForDisplay",
              replacement = "ForDisplay"
            ) |>
            str_remove_all(
              pattern = " \\(summary\\)"
            )
        }
      )
  ) |>
  rename(
    Admin0 = CountryName,
    Admin1 = RegionName,
    ISO1_3C = CountryCode,
    ISO2_UID = RegionCode,
    Cases = ConfirmedCases,
    Deaths = ConfirmedDeaths,
    Population_Vax = PopulationVaccinated
  ) |>
  rename_with(
    function(x) {
      x |>
        str_remove(
          pattern = "_School closing"
        ) |>
        str_remove(
          pattern = "_Workplace closing"
        ) |>
        str_remove(
          pattern = "_Cancel public events"
        ) |>
        str_remove(
          pattern = "_Restrictions on gatherings"
        ) |>
        str_remove(
          pattern = "_Close public transport"
        ) |>
        str_remove(
          pattern = "_Stay at home requirements"
        ) |>
        str_remove(
          pattern = "_Restrictions on internal movement"
        ) |>
        str_remove(
          pattern = "_International travel controls"
        ) |>
        str_remove(
          pattern = "_Income support"
        ) |>
        str_remove(
          pattern = "_Debt/contract relief"
        ) |>
        str_remove(
          pattern = "_Fiscal measures"
        ) |>
        str_remove(
          pattern = "_International support"
        ) |>
        str_remove(
          pattern = "_Public information campaigns"
        ) |>
        str_remove(
          pattern = "_Testing policy"
        ) |>
        str_remove(
          pattern = "_Contact tracing"
        ) |>
        str_remove(
          pattern = "_Emergency investment in healthcare"
        ) |>
        str_remove(
          pattern = "_Investment in vaccines"
        ) |>
        str_remove(
          pattern = "_Facial Coverings"
        ) |>
        str_remove(
          pattern = "_Vaccination policy"
        ) |>
        str_remove(
          pattern = "_Protection of elderly people"
        ) |>
        str_remove(
          pattern = "_Wildcard"
        ) |>
        str_remove(
          pattern = "_Vaccine Prioritisation"
        ) |>
        str_remove(
          pattern = "_Vaccine Availability"
        ) |>
        str_remove(
          pattern = "_Vaccine Availability"
        ) |>
        str_remove(
          pattern = " \\(general population summary\\)"
        ) |>
        str_remove(
          pattern = " \\(at risk summary\\)"
        ) |>
        str_remove(
          pattern = "_Vaccine age eligibility/availability age floor"
        ) |>
        str_remove(
          pattern = "_Vaccine age eligibility/availability age floor"
        ) |>
        str_remove(
          pattern = "_Medically/ clinically vulnerable \\(Non-elderly\\)"
        ) |>
        str_remove(
          pattern = "_Education"
        ) |>
        str_remove(
          pattern = "_Frontline workers  \\(non healthcare\\)"
        ) |>
        str_remove(
          pattern = "_Frontline workers  \\(healthcare\\)"
        ) |>
        str_remove(
          pattern = "_Frontline workers \\(non healthcare\\)"
        ) |>
        str_remove(
          pattern = "_Frontline workers \\(healthcare\\)"
        ) |>
        str_remove(
          pattern = "_Vaccine Financial Support"
        ) |>
        str_remove(
          pattern = "_Mandatory Vaccination"
        ) |>
        str_replace(
          pattern = "ContainmentHealthIndex",
          replacement = "I1"
        ) |>
        str_replace(
          pattern = "EconomicSupportIndex",
          replacement = "I2"
        ) |>
        str_replace(
          pattern = "GovernmentResponseIndex",
          replacement = "I3"
        ) |>
        str_replace(
          pattern = "StringencyIndex",
          replacement = "I4"
        ) |>
        str_replace(
          pattern = "LegacyIndex",
          replacement = "L"
        ) |>
        str_replace(
          pattern = "ContainmentHealth",
          replacement = "I1"
        ) |>
        str_replace(
          pattern = "EconomicSupport",
          replacement = "I2"
        ) |>
        str_replace(
          pattern = "GovernmentResponse",
          replacement = "I3"
        ) |>
        str_replace(
          pattern = "Stringency",
          replacement = "I4"
        ) |>
        str_replace(
          pattern = "_NonVaccinated",
          replacement = "NV"
        ) |>
        str_replace(
          pattern = "_Vaccinated",
          replacement = "V"
        ) |>
        str_replace(
          pattern = "_SimpleAverage",
          replacement = "S"
        ) |>
        str_replace(
          pattern = "_WeightedAverage",
          replacement = "W"
        ) |>
        # str_replace(
        #   pattern = "_ForDisplay",
        #   replacement = "D"
        # ) |>
        str_replace(
          pattern = "ForDisplay",
          replacement = "D"
        )
    }
  ) |>
  mutate(
    Admin0 = Admin0 |>
      Unify_Names(),
    Admin1 = Admin1 |>
      Unify_Names(),
    Resolution = case_when(
      is.na(Admin1) ~ "National",
      TRUE ~ "Subnational"
    ),
    ISO1_3C = case_when(
      # XAD | XAX = Akrotiri and Dhekelia
      # XCA | XCX = Caspian Sea
      # KOS | XKO | XKX = Kosovo
      Admin0 == "Akrotiri and Dhekelia" ~ "XAX",
      Admin0 == "Caspian Sea" ~ "XCX",
      Admin0 == "Cruise Ship" ~ "XXX",
      Admin0 == "Kosovo" ~ "XKX",
      TRUE ~ ISO1_3C
    ),
    ISO1_2C = case_when(
      # XAD | XAX = Akrotiri and Dhekelia
      # XCA | XCX = Caspian Sea
      # KOS | XKO | XKX = Kosovo
      Admin0 == "Akrotiri and Dhekelia" ~ "XA",
      Admin0 == "Caspian Sea" ~ "XC",
      Admin0 == "Cruise Ship" ~ "XX",
      Admin0 == "Kosovo" ~ "XK",
      TRUE ~ countrycode(
        ISO1_3C |>
          na_if("XAX") |>
          na_if("XCX") |>
          na_if("XXX") |>
          na_if("XKX"),
        origin = "iso3c",
        destination = "iso2c"
      )
    ),
    ISO2_UID = case_when(
      is.na(ISO2_UID) ~ ISO1_2C,
      ISO2_UID == "UK_ENG" ~ "GB-ENG",
      ISO2_UID == "UK_NIR" ~ "GB-NIR",
      ISO2_UID == "UK_SCO" ~ "GB-SCT",
      ISO2_UID == "UK_WAL" ~ "GB-WLS",
      TRUE ~ ISO2_UID |>
        str_replace(
          pattern = "_",
          replacement = "-"
        )
    ),
    ID = case_when(
      is.na(Admin1) ~ ISO1_2C,
      !is.na(Admin1) &
        Admin0 == "United States" ~ COVID19.LUT |>
        pull(ID) |>
        pluck_multiple(
          Admin1 |>
            match(
              COVID19.LUT |>
                pull("Admin1")
            )
        ),
      TRUE ~ ISO2_UID |>
        str_remove(
          pattern = "-"
        )
    )
  ) |>
  mutate(
    V2B = V2B |>
      str_remove_all(
        pattern = " yrs"
      ) |>
      str_remove_all(
        pattern = "\\+"
      ) |>
      str_split(
        pattern = "-"
      ) |>
      map(first) |>
      unlist() |>
      as.numeric(),
    V2C = V2C |>
      str_remove_all(
        pattern = " yrs"
      ) |>
      str_remove_all(
        pattern = "\\+"
      ) |>
      str_split(
        pattern = "-"
      ) |>
      map(first) |>
      unlist() |>
      as.numeric()
  ) |>
  select(
    ID, Jurisdiction, Date,
    Cases, Deaths,
    any_of(
      c(
        "C",
        "E",
        "H",
        "M",
        "V",
        "I"
      ) |>
        expand_grid(
          1:9
        ) |>
        setNames(
          c("x", "y")
        ) |>
        unite(
          "xy",
          x:y,
          sep = ""
        ) |>
        pull(xy) |>
        expand_grid(
          letters |>
            str_to_upper() |>
            c("")
        ) |>
        setNames(
          c("x", "y")
        ) |>
        unite(
          "xy",
          x:y,
          sep = ""
        ) |>
        pull(xy) |>
        expand_grid(
          c(
            "",
            "E",
            "EV",
            "NV",
            "V",
            "M"
          )
        ) |>
        setNames(
          c("x", "y")
        ) |>
        unite(
          "xy",
          x:y,
          sep = ""
        ) |>
        pull(xy)
    ),
    contains("Flag"),
    contains("Notes")
  )

#-------------------------------------------------------------------------------

Policy <- Policy.raw |>
  select(
    -matches("Flag|Notes")
  ) |>
  pivot_longer(
    cols = -c(
      ID, Jurisdiction, Date
    ),
    names_to = "PolicyType",
    values_to = "PolicyValue"
  ) |>
  left_join(
    Policy.raw |>
      select(
        ID, Jurisdiction, Date,
        contains("Flag")
      ) |>
      pivot_longer(
        cols = contains("Flag"),
        names_to = "PolicyType",
        values_to = "Flag"
      ) |>
      mutate(
        PolicyType = PolicyType |>
          str_remove_all(
            pattern = "_Flag"
          )
      )
  ) |>
  left_join(
    Policy.raw |>
      select(
        ID, Jurisdiction, Date,
        contains("Notes")
      ) |>
      pivot_longer(
        cols = contains("Notes"),
        names_to = "PolicyType",
        values_to = "Notes"
      ) |>
      mutate(
        PolicyType = PolicyType |>
          str_remove_all(
            pattern = "_Notes"
          )
      )
  ) |>
  rename(
    PolicyFlag = Flag,
    PolicyNotes = Notes
  ) |>
  mutate(
    PolicySource = "OxCGRT"
  ) |>
  mutate(
    across(
      c(Jurisdiction, PolicyType, PolicySource),
      as.factor
    )
  ) |>
  arrange(
    ID, Jurisdiction, Date, PolicyType
  ) |>
  select(
    ID, Jurisdiction, Date, PolicyType,
    PolicyValue, PolicyFlag, PolicyNotes, PolicySource
  )

################################################################################

Policy |>
  saveRDS(
    file = "Policy.rds",
    compress = "xz",
    ascii = FALSE,
    version = NULL,
    refhook = NULL
  )

#-------------------------------------------------------------------------------

Policy |>
  write_fst(
    path = "Policy.fst",
    compress = 100,
    uniform_encoding = TRUE
  )

#-------------------------------------------------------------------------------

Policy |>
  write_delim(
    file = "Policy.csv.xz",
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
