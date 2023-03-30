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

COVID19.JHU.Confirmed.US <- read_delim(
  file = JHU_URL |>
    str_interp(
      env = list(
        Type = "confirmed",
        Region = "US"
      )
    ),
  col_names = TRUE,
  col_types = cols(
    UID = col_integer(),
    iso2 = col_character(),
    iso3 = col_character(),
    code3 = col_double(),
    FIPS = col_character(),
    Admin2 = col_character(),
    Province_State = col_character(),
    Country_Region = col_character(),
    Lat = col_double(),
    Long_ = col_double(),
    Combined_Key = col_character()
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
  pivot_longer(
    cols = contains("/"),
    names_to = "Date",
    values_to = "Cases"
  ) |>
  rename(
    Admin1 = Province_State,
    Admin0 = Country_Region,
  ) |>
  mutate(
    Date = Date |>
      as.Date(format = "%m/%d/%y"),
    Type = "Confirmed",
    Age = "Total",
    Sex = "Total",
    Source = "JHU",
    Level = "County",
    Admin3 = NA_character_
  ) |>
  Unify_Everything() |>
  left_join(UID) |>
  select(
    Date, Cases, Type, matches("Age|Sex"),
    Source, Level, matches("Longitude|Latitude|Population"),
    FIPS, Admin3, Admin2, Admin1, Admin0
  )

#-------------------------------------------------------------------------------

COVID19.JHU.Deaths.US <- read_delim(
  file = JHU_URL |>
    str_interp(
      env = list(
        Type = "deaths",
        Region = "US"
      )
    ),
  col_names = TRUE,
  col_types = cols(
    UID = col_integer(),
    iso2 = col_character(),
    iso3 = col_character(),
    code3 = col_double(),
    FIPS = col_character(),
    Admin2 = col_character(),
    Province_State = col_character(),
    Country_Region = col_character(),
    Lat = col_double(),
    Long_ = col_double(),
    Combined_Key = col_character()
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
  pivot_longer(
    cols = contains("/"),
    names_to = "Date",
    values_to = "Cases"
  ) |>
  rename(
    Admin1 = Province_State,
    Admin0 = Country_Region,
  ) |>
  mutate(
    Date = Date |>
      as.Date(format = "%m/%d/%y"),
    Type = "Deaths",
    Age = "Total",
    Sex = "Total",
    Source = "JHU",
    Level = "County",
    Admin3 = NA_character_
  ) |>
  Unify_Everything() |>
  left_join(UID) |>
  select(
    Date, Cases, Type, matches("Age|Sex"),
    Source, Level, matches("Longitude|Latitude|Population"),
    FIPS, Admin3, Admin2, Admin1, Admin0
  )

#-------------------------------------------------------------------------------

COVID19.JHU.Confirmed.Global <- read_delim(
  file = JHU_URL |>
    str_interp(
      env = list(
        Type = "confirmed",
        Region = "global"
      )
    ),
  col_names = TRUE,
  col_types = cols(
    `Province/State` = col_character(),
    `Country/Region` = col_character(),
    Lat = col_double(),
    Long = col_double()
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
  pivot_longer(
    cols = c(
      contains("/"),
      -`Country/Region`,
      -`Province/State`
    ),
    names_to = "Date",
    values_to = "Cases"
  ) |>
  rename(
    Admin1 = `Province/State`,
    Admin0 = `Country/Region`
  ) |>
  mutate(
    Date = Date |>
      as.Date(format = "%m/%d/%y"),
    Type = "Confirmed",
    Age = "Total",
    Sex = "Total",
    Source = "JHU",
    Level = "Global",
    FIPS = NA_character_,
    Admin2 = NA_character_,
    Admin3 = NA_character_
  ) |>
  Unify_Everything() |>
  left_join(UID) |>
  select(
    Date, Cases, Type, matches("Age|Sex"),
    Source, Level, matches("Longitude|Latitude|Population"),
    FIPS, Admin3, Admin2, Admin1, Admin0
  ) |>
  {
    function(.) {
      . |>
        full_join(
          . |>
            filter(
              Level == "Province"
            ) |>
            Aggregate_Admin(
              Admin = 0L,
              Country = c("Australia", "Canada", "China"),
              State = NULL,
              na.rm = TRUE
            )
        )
    }
  }()

#-------------------------------------------------------------------------------

COVID19.JHU.Deaths.Global <- read_delim(
  file = JHU_URL |>
    str_interp(
      env = list(
        Type = "deaths",
        Region = "global"
      )
    ),
  col_names = TRUE,
  col_types = cols(
    `Province/State` = col_character(),
    `Country/Region` = col_character(),
    Lat = col_double(),
    Long = col_double()
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
  pivot_longer(
    cols = c(
      contains("/"),
      -`Country/Region`,
      -`Province/State`
    ),
    names_to = "Date",
    values_to = "Cases"
  ) |>
  rename(
    Admin1 = `Province/State`,
    Admin0 = `Country/Region`
  ) |>
  mutate(
    Date = Date |>
      as.Date(format = "%m/%d/%y"),
    Type = "Deaths",
    Age = "Total",
    Sex = "Total",
    Source = "JHU",
    Level = "Global",
    FIPS = NA_character_,
    Admin2 = NA_character_,
    Admin3 = NA_character_
  ) |>
  Unify_Everything() |>
  left_join(UID) |>
  select(
    Date, Cases, Type, matches("Age|Sex"),
    Source, Level, matches("Longitude|Latitude|Population"),
    FIPS, Admin3, Admin2, Admin1, Admin0
  ) |>
  {
    function(.) {
      . |>
        full_join(
          . |>
            filter(
              Level == "Province"
            ) |>
            Aggregate_Admin(
              Admin = 0L,
              Country = c("Australia", "Canada", "China"),
              State = NULL,
              na.rm = TRUE
            )
        )
    }
  }()

#-------------------------------------------------------------------------------

COVID19.JHU.Recovered.Global <- read_delim(
  file = JHU_URL |>
    str_interp(
      env = list(
        Type = "recovered",
        Region = "global"
      )
    ),
  col_names = TRUE,
  col_types = cols(
    `Province/State` = col_character(),
    `Country/Region` = col_character(),
    Lat = col_double(),
    Long = col_double()
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
  pivot_longer(
    cols = c(
      contains("/"),
      -`Country/Region`,
      -`Province/State`
    ),
    names_to = "Date",
    values_to = "Cases"
  ) |>
  rename(
    Admin1 = `Province/State`,
    Admin0 = `Country/Region`
  ) |>
  mutate(
    Date = Date |>
      as.Date(format = "%m/%d/%y"),
    # Correct data for Hainan, China (negative active cases)
    Cases = case_when(
      Date >= as.Date("2020-03-24") &
        Date <= as.Date("2020-04-01") &
        Admin0 == "China" &
        Admin1 == "Hainan" ~ 161L,
      TRUE ~ Cases |>
        as.integer()
    ),
    Type = "Recovered",
    Age = "Total",
    Sex = "Total",
    Source = "JHU",
    Level = "Global",
    FIPS = NA_character_,
    Admin2 = NA_character_,
    Admin3 = NA_character_
  ) |>
  Unify_Everything() |>
  left_join(UID) |>
  select(
    Date, Cases, Type, matches("Age|Sex"),
    Source, Level, matches("Longitude|Latitude|Population"),
    FIPS, Admin3, Admin2, Admin1, Admin0
  )

#-------------------------------------------------------------------------------

COVID19.JHU.Active.Global <- COVID19.JHU.Confirmed.Global |>
  rename(
    Confirmed = Cases
  ) |>
  select(-Type) |>
  full_join(
    COVID19.JHU.Deaths.Global |>
      rename(
        Deaths = Cases
      ) |>
      select(-Type)
  ) |>
  full_join(
    COVID19.JHU.Recovered.Global |>
      rename(
        Recovered = Cases
      ) |>
      select(-Type)
  ) |>
  mutate(
    Cases = Confirmed - Recovered - Deaths,
    Type = "Active"
  ) |>
  filter(
    !is.na(Cases)
  ) |>
  select(
    Date, Cases, Type, matches("Age|Sex"),
    Source, Level, matches("Longitude|Latitude|Population"),
    FIPS, Admin3, Admin2, Admin1, Admin0
  )

################################################################################

COVID19.NYT <- read_delim(
  file = NYT_URL,
  col_names = TRUE,
  col_types = cols(
    date = col_date(format = "%Y-%m-%d"),
    county = col_character(),
    state = col_character(),
    fips = col_character(),
    cases = col_integer(),
    deaths = col_integer()
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
  pivot_longer(
    cols = c(cases, deaths),
    names_to = "Type",
    values_to = "Cases"
  ) |>
  rename(
    Date = date,
    Admin2 = county,
    Admin1 = state,
    FIPS = fips
  ) |>
  mutate(
    Type = Type |>
      recode(
        "cases" = "Confirmed",
        "deaths" = "Deaths"
      ),
    Age = "Total",
    Sex = "Total",
    Source = "NYT",
    Level = "County",
    Admin3 = NA_character_,
    Admin0 = "United States"
  ) |>
  Unify_Everything() |>
  left_join(UID) |>
  select(
    Date, Cases, Type, matches("Age|Sex"),
    Source, Level, matches("Longitude|Latitude|Population"),
    FIPS, Admin3, Admin2, Admin1, Admin0
  )

################################################################################

COVID19.CTP <- read_delim(
  file = CTP_URL,
  col_names = TRUE,
  col_types = cols(
    date = col_date(format = "%Y%m%d"),
    state = col_character(),
    positive = col_integer(),
    negative = col_integer(),
    pending = col_integer(),
    hospitalizedCurrently = col_integer(),
    hospitalizedCumulative = col_integer(),
    inIcuCurrently = col_integer(),
    inIcuCumulative = col_integer(),
    onVentilatorCurrently = col_integer(),
    onVentilatorCumulative = col_integer(),
    recovered = col_integer(),
    dataQualityGrade = col_character(),
    lastUpdateEt = col_datetime(
      format = "%m/%d/%Y %H:%M"
    ),
    dateModified = col_character(),
    checkTimeEt = col_character(),
    death = col_integer(),
    hospitalized = col_integer(),
    dateChecked = col_character(),
    totalTestsViral = col_integer(),
    positiveTestsViral = col_integer(),
    negativeTestsViral = col_integer(),
    positiveCasesViral = col_integer(),
    deathConfirmed = col_integer(),
    deathProbable = col_integer(),
    totalTestEncountersViral = col_integer(),
    totalTestsPeopleViral = col_integer(),
    totalTestsAntibody = col_integer(),
    positiveTestsAntibody = col_integer(),
    negativeTestsAntibody = col_integer(),
    totalTestsPeopleAntibody = col_integer(),
    positiveTestsPeopleAntibody = col_integer(),
    negativeTestsPeopleAntibody = col_integer(),
    totalTestsPeopleAntigen = col_integer(),
    positiveTestsPeopleAntigen = col_integer(),
    totalTestsAntigen = col_integer(),
    positiveTestsAntigen = col_integer(),
    fips = col_character(),
    positiveIncrease = col_integer(),
    negativeIncrease = col_integer(),
    total = col_integer(),
    totalTestResultsSource = col_character(),
    totalTestResults = col_integer(),
    totalTestResultsIncrease = col_integer(),
    posNeg = col_integer(),
    deathIncrease = col_integer(),
    hospitalizedIncrease = col_integer(),
    hash = col_character(),
    commercialScore = col_double(),
    negativeRegularScore = col_double(),
    negativeScore = col_double(),
    positiveScore = col_double(),
    score = col_double(),
    grade = col_character()
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
    Date = date,
    ISO2 = state,
    FIPS = fips,
    Positive = positive,
    Negative = negative,
    Pending = pending,
    Recovered = recovered,
    Deaths = death,
    Tests = totalTestResults,
    Hospitalized = hospitalizedCumulative,
    ICU = inIcuCumulative,
    Ventilator = onVentilatorCumulative,
    Hospitalized_Now = hospitalizedCurrently,
    ICU_Now = inIcuCurrently,
    Ventilator_Now = onVentilatorCurrently
  ) |>
  mutate(
    Confirmed = Positive,
    Active = Confirmed - Recovered - Deaths,
    Tested = Tests - Pending
  ) |>
  pivot_longer(
    cols = c(
      Confirmed, Active, Recovered, Deaths,
      Positive, Negative, Pending, Tests, Tested,
      Hospitalized, ICU, Ventilator,
      Hospitalized_Now, ICU_Now, Ventilator_Now
    ),
    names_to = "Type",
    values_to = "Cases"
  ) |>
  mutate(
    Age = "Total",
    Sex = "Total",
    Source = "CTP",
    Level = "State",
    ISO2_UID = str_c("US-", ISO2),
    Admin3 = NA_character_,
    Admin2 = NA_character_,
    Admin0 = "United States"
  ) |>
  left_join(ISO2_Unified) |>
  rename(Admin1 = ISO2_Name) |>
  Unify_Everything() |>
  left_join(UID) |>
  select(
    Date, Cases, Type, matches("Age|Sex"),
    Source, Level, matches("Longitude|Latitude|Population"),
    FIPS, Admin3, Admin2, Admin1, Admin0
  ) |>
  {
    function(.) {
      . |>
        full_join(
          . |>
            filter(
              Level == "State"
            ) |>
            Aggregate_Admin(
              Admin = 0L,
              Country = NULL,
              State = NULL,
              na.rm = TRUE
            )
        )
    }
  }()

################################################################################

try(
  system(
    str_c(
      "cd ",
      file.path(
        COVID19.dir,
        "coronavirus-data"
      ),
      " ; ",
      "git pull",
      " ; ",
      file.path(
        COVID19.dir,
        "Modeling",
        "git-export-all-file-versions"
      ),
      " totals/data-by-modzcta.csv",
      " ; ",
      file.path(
        COVID19.dir,
        "Modeling",
        "git-export-all-file-versions"
      ),
      " archive/tests-by-zcta.csv",
      " ; ",
      "cd ",
      getwd()
    )
  )
)

################################################################################

COVID19.NYC.ZCTA <- list.files(
  path = file.path(
    COVID19.dir,
    "GitHub_Versions/coronavirus-data"
  ),
  pattern = "*.*.csv$",
  full.names = TRUE,
  recursive = TRUE
) |>
  map_dfr(
    function(filename) {
      message(filename)
      Date.git <- filename |>
        str_split(
          pattern = "\\."
        ) |>
        pluck(1) |>
        pluck(3) |>
        as.Date(
          format = "%d-%b-%YT%H_%M_%S"
        )

      Date.git |>
        str_c("\n") |>
        cat()

      if (
        filename |>
          str_split(
            pattern = "\\.",
            simplify = TRUE
          ) |>
          pluck(1) |>
          str_detect(
            pattern = "data-by-modzcta"
          ) |>
          coalesce(FALSE)
      ) {
        COVID19.NYC.git <- read_delim(
          file = filename,
          col_names = TRUE,
          col_types = cols(
            MODIFIED_ZCTA = col_character(),
            NEIGHBORHOOD_NAME = col_character(),
            BOROUGH_GROUP = col_character(),
            COVID_CASE_COUNT = col_integer(),
            COVID_CASE_RATE = col_double(),
            POP_DENOMINATOR = col_double(),
            COVID_DEATH_COUNT = col_integer(),
            COVID_DEATH_RATE = col_double(),
            PERCENT_POSITIVE = col_double()
            # TOTAL_COVID_TESTS = col_integer()
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
            ZCTA = MODIFIED_ZCTA,
            Neighborhood = NEIGHBORHOOD_NAME,
            Borough = BOROUGH_GROUP,
            Confirmed = COVID_CASE_COUNT,
            Case_Incidence = COVID_CASE_RATE,
            Deaths = COVID_DEATH_COUNT,
            Death_Incidence = COVID_DEATH_RATE,
            Testing_incidence = PERCENT_POSITIVE,
            # Tests = TOTAL_COVID_TESTS
          ) |>
          mutate(
            Date = Date.git - 1,
            Positive = Confirmed,
            Tests = (Positive * 100 / Testing_incidence) |>
              round() |>
              as.integer()
          ) |>
          select(
            ZCTA, Neighborhood, Borough,
            Date, Confirmed, Deaths, Positive, Tests
          )
      } else if (
        filename |>
          str_split(
            pattern = "\\.",
            simplify = TRUE
          ) |>
          pluck(1) |>
          str_detect(
            pattern = "tests-by-zcta"
          ) |>
          coalesce(FALSE)
      ) {
        COVID19.NYC.git <- read_delim(
          file = filename,
          col_names = TRUE,
          col_types = cols(
            # modzcta = col_character(),
            # MODZCTA = col_character(),
            Positive = col_integer(),
            Total = col_integer()
            # modzcta_cum_perc_pos = col_double(),
            # zcta_cum.perc_pos = col_double()
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
            modzcta = matches(
              "MODZCTA",
              ignore.case = FALSE
            ),
            Testing_incidence = matches(
              "zcta_cum.perc_pos|modzcta_cum_perc_pos"
            ),
            Tests = Total
          ) |>
          mutate(
            across(
              matches("modzcta"),
              as.character
            )
          ) |>
          mutate(
            across(
              matches("Testing_incidence"),
              as.double
            )
          ) |>
          mutate(
            ZCTA = modzcta,
            Date = Date.git - 1,
            Confirmed = Positive
          ) |>
          select(
            ZCTA,
            Date, Confirmed, Positive, Tests
          )
      } else {
        stop(
          "Please check the file names!",
          "Expected: data-by-modzcta or tests-by-zcta."
        )
      }

      return(COVID19.NYC.git)
    }
  ) |>
  select(
    ZCTA,
    Date, Confirmed, Positive, Deaths, Tests
  ) |>
  pivot_longer(
    cols = c(Confirmed, Deaths, Positive, Tests),
    names_to = "Type",
    values_to = "Cases"
  ) |>
  group_by(ZCTA, Date, Type) |>
  summarize(
    Cases = max(Cases),
    .groups = "keep"
  ) |>
  ungroup() |>
  left_join(
    read_delim(
      file = file.path(COVID19.dir, "Modeling/NYC_ZCTA_LatLonPop.csv"),
      col_names = TRUE,
      col_types = cols(
        ZCTA = col_character(),
        Longitude = col_double(),
        Latitude = col_double(),
        Population = col_integer(),
        FIPS = col_character(),
        Neighborhood = col_character(),
        Neighborhood_ZIP = col_character(),
        PO = col_character(),
        Borough = col_character(),
        Admin3 = col_character(),
        Admin2 = col_character(),
        Admin1 = col_character(),
        Admin0 = col_character()
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
        ZCTA, Longitude, Latitude, Population,
        FIPS, Neighborhood, Neighborhood_ZIP, PO, Borough,
        Admin3, Admin2, Admin1, Admin0
      )
  ) |>
  mutate(
    Age = "Total",
    Sex = "Total",
    Source = "NYC",
    Level = "ZCTA"
  ) |>
  filter(!is.na(Neighborhood)) |>
  Unify_Everything() |>
  select(
    Date, Cases, Type, matches("Age|Sex"),
    Source, Level, matches("Longitude|Latitude|Population"),
    FIPS, ZCTA, Admin3, Admin2, Admin1, Admin0
  ) |>
  arrange(ZCTA, Date)

#-------------------------------------------------------------------------------

COVID19.NYC.Borough <- read_delim(
  file = NYC_Borough_Epi_URL,
  col_names = TRUE,
  col_types = cols(
    date_of_interest = col_character(),
    CASE_COUNT = col_integer(),
    HOSPITALIZED_COUNT = col_integer(),
    DEATH_COUNT = col_integer(),
    BK_CASE_COUNT = col_integer(),
    BK_HOSPITALIZED_COUNT = col_integer(),
    BK_DEATH_COUNT = col_integer(),
    BX_CASE_COUNT = col_integer(),
    BX_HOSPITALIZED_COUNT = col_integer(),
    BX_DEATH_COUNT = col_integer(),
    MN_CASE_COUNT = col_integer(),
    MN_HOSPITALIZED_COUNT = col_integer(),
    MN_DEATH_COUNT = col_integer(),
    QN_CASE_COUNT = col_integer(),
    QN_HOSPITALIZED_COUNT = col_integer(),
    QN_DEATH_COUNT = col_integer(),
    SI_CASE_COUNT = col_integer(),
    SI_HOSPITALIZED_COUNT = col_integer(),
    SI_DEATH_COUNT = col_integer()
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
    -CASE_COUNT, -HOSPITALIZED_COUNT, -DEATH_COUNT,
    -PROBABLE_CASE_COUNT, -PROBABLE_DEATH_COUNT
  ) |>
  rename(
    Date = date_of_interest
  ) |>
  mutate(
    Date = Date |>
      as.Date(format = "%m/%d/%Y")
  ) |>
  pivot_longer(
    cols = ends_with("_COUNT"),
    names_to = "Type",
    values_to = "Cases"
  ) |>
  mutate(
    Borough = case_when(
      Type |>
        str_detect(
          pattern = "BK_"
        ) |>
        coalesce(FALSE) ~ "Brooklyn",
      Type |>
        str_detect(
          pattern = "BX_"
        ) |>
        coalesce(FALSE) ~ "Bronx",
      Type |>
        str_detect(
          pattern = "MN_"
        ) |>
        coalesce(FALSE) ~ "Manhattan",
      Type |>
        str_detect(
          pattern = "QN_"
        ) |>
        coalesce(FALSE) ~ "Queens",
      Type |>
        str_detect(
          pattern = "SI_"
        ) |>
        coalesce(FALSE) ~ "Staten Island",
      TRUE ~ NA_character_
    ),
    Type = case_when(
      Type |>
        str_detect(
          pattern = "CASE_COUNT"
        ) |>
        coalesce(FALSE) ~ "Confirmed",
      Type |>
        str_detect(
          pattern = "HOSPITALIZED_COUNT"
        ) |>
        coalesce(FALSE) ~ "Hospitalized",
      Type |>
        str_detect(
          pattern = "DEATH_COUNT"
        ) |>
        coalesce(FALSE) ~ "Deaths",
      TRUE ~ Type
    )
  ) |>
  left_join(
    read_delim(
      file = file.path(COVID19.dir, "Modeling/NYC_ZCTA_LatLonPop.csv"),
      col_names = TRUE,
      col_types = cols(
        ZCTA = col_character(),
        PO = col_character(),
        Borough = col_character(),
        Longitude = col_double(),
        Latitude = col_double(),
        Population = col_integer(),
        FIPS = col_character(),
        Neighborhood = col_character(),
        Neighborhood_ZIP = col_character(),
        Admin3 = col_character(),
        Admin2 = col_character(),
        Admin1 = col_character(),
        Admin0 = col_character()
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
      filter(is.na(Neighborhood)) |>
      select(
        ZCTA, Longitude, Latitude, Population,
        FIPS, Borough, Admin3, Admin2, Admin1, Admin0
      )
  ) |>
  mutate(
    Age = "Total",
    Sex = "Total",
    Source = "NYC",
    Level = "Borough"
  ) |>
  Unify_Everything() |>
  group_by(
    Type, Age, Sex, Source, Level,
    Longitude, Latitude, Population,
    FIPS, Admin3, Admin2, Admin1, Admin0
  ) |>
  mutate(
    Cases_Accu = cumsum(Cases)
  ) |>
  ungroup() |>
  mutate(
    Cases = Cases_Accu
  ) |>
  select(
    Date, Cases, Type, matches("Age|Sex"),
    Source, Level, matches("Longitude|Latitude|Population"),
    FIPS, ZCTA, Admin3, Admin2, Admin1, Admin0
  ) |>
  arrange(ZCTA, Date)

#-------------------------------------------------------------------------------

COVID19.NYC.Citywide <- read_delim(
  file = NYC_CityTot_Epi_URL,
  col_names = TRUE,
  col_types = cols(
    date_of_interest = col_character(),
    CASE_COUNT = col_integer(),
    HOSPITALIZED_COUNT = col_integer(),
    DEATH_COUNT = col_integer()
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
    date_of_interest, CASE_COUNT, HOSPITALIZED_COUNT, DEATH_COUNT
  ) |>
  rename(
    Date = date_of_interest
  ) |>
  mutate(
    Date = Date |>
      as.Date(format = "%m/%d/%Y")
  ) |>
  pivot_longer(
    cols = ends_with("_COUNT"),
    names_to = "Type",
    values_to = "Cases"
  ) |>
  mutate(
    Type = case_when(
      Type |>
        str_detect(
          pattern = "CASE_COUNT"
        ) |>
        coalesce(FALSE) ~ "Confirmed",
      Type |>
        str_detect(
          pattern = "HOSPITALIZED_COUNT"
        ) |>
        coalesce(FALSE) ~ "Hospitalized",
      Type |>
        str_detect(
          "DEATH_COUNT"
        ) |>
        coalesce(FALSE) ~ "Deaths",
      TRUE ~ Type
    )
  ) |>
  mutate(
    Age = "Total",
    Sex = "Total",
    Source = "NYC",
    Level = "County",
    FIPS = "36666",
    Admin3 = NA_character_,
    Admin2 = "New York City",
    Admin1 = "New York",
    Admin0 = "United States"
  ) |>
  Unify_Everything() |>
  left_join(UID) |>
  group_by(
    Type, Age, Sex, Source, Level,
    Longitude, Latitude, Population,
    FIPS, Admin3, Admin2, Admin1, Admin0
  ) |>
  mutate(Cases_Accu = cumsum(Cases)) |>
  ungroup() |>
  mutate(Cases = Cases_Accu) |>
  select(
    Date, Cases, Type, matches("Age|Sex"),
    Source, Level, matches("Longitude|Latitude|Population"),
    FIPS, Admin3, Admin2, Admin1, Admin0
  ) |>
  arrange(Date)

################################################################################

COVID19.JHUD <- seq(
  "2020-01-22" |>
    as.Date(),
  Sys.Date(),
  by = 1L
) |>
  format(
    "%m-%d-%Y"
  ) |>
  map_dfr(
    function(iDate) {
      filename <- JHUD_URL |>
        str_interp(
          env = list(
            Region = "",
            Date = iDate
          )
        )

      if (url.exists(filename)) {
        filename |>
          str_c("\n") |>
          cat()

        read_delim(
          file = filename,
          col_names = TRUE,
          col_types = cols(
            Confirmed = col_double(),
            Deaths = col_double(),
            Recovered = col_double()
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
          {
            function(.) {
              if ("Active" %in% names(.)) {
                . |>
                  rename(
                    Active.raw = Active
                  )
              } else {
                .
              }
            }
          }() |>
          {
            function(.) {
              if ("Country_Region" %in% names(.)) {
                . |>
                  rename(
                    Admin0 = Country_Region
                  )
              } else {
                . |>
                  rename(
                    Admin0 = `Country/Region`
                  )
              }
            }
          }() |>
          {
            function(.) {
              if ("Province_State" %in% names(.)) {
                . |>
                  rename(
                    Admin1 = Province_State
                  )
              } else {
                . |>
                  rename(
                    Admin1 = `Province/State`
                  )
              }
            }
          }() |>
          {
            function(.) {
              if ("Admin2" %!in% names(.)) {
                . |>
                  mutate(
                    Admin2 = NA_character_
                  )
              } else {
                .
              }
            }
          }() |>
          {
            function(.) {
              if ("Admin3" %!in% names(.)) {
                . |>
                  mutate(
                    Admin3 = NA_character_
                  )
              } else {
                .
              }
            }
          }() |>
          {
            function(.) {
              if ("FIPS" %!in% names(.)) {
                . |>
                  mutate(
                    FIPS = NA_character_
                  )
              } else {
                .
              }
            }
          }() |>
          filter(
            Admin1 != "Recovered"
          ) |>
          mutate(
            Active.raw = Confirmed - Recovered - Deaths,
            Confirmed = case_when(
              Admin0 == "Canada" &
                Admin1 == "Diamond Princess" &
                Active.raw == -1 ~ Confirmed + 1L,
              TRUE ~ Confirmed
            ),
            Active = Confirmed - Recovered - Deaths
          ) |>
          mutate(
            Active = case_when(
              Active < 0 ~ 0,
              TRUE ~ Active
            ),
            Recovered = case_when(
              Recovered > Confirmed & Active <= 0 ~ Confirmed - Deaths,
              TRUE ~ Recovered
            )
          ) |>
          pivot_longer(
            cols = c(
              Confirmed, Active, Recovered, Deaths
            ),
            names_to = "Type",
            values_to = "Cases"
          ) |>
          mutate(
            Date = iDate |>
              as.Date(format = "%m-%d-%Y"),
            Cases = Cases |>
              as.integer(),
            Age = "Total",
            Sex = "Total",
            Source = "JHU",
            Level = "Global"
          ) |>
          Unify_Everything() |>
          left_join(UID) |>
          select(
            Date, Cases, Type, matches("Age|Sex"),
            Source, Level, matches("Longitude|Latitude|Population"),
            FIPS, Admin3, Admin2, Admin1, Admin0
          )
      } else {
        tibble()
      }
    }
  )

################################################################################

COVID19.DPC_NUTS2 <- read_delim(
  file = DPC_URL |>
    str_interp(
      env = list(
        Region = "regioni"
      )
    ),
  col_names = TRUE,
  col_types = cols(
    data = col_date(format = "%Y-%m-%dT%H:%M:%S"),
    stato = col_character(),
    codice_regione = col_character(),
    denominazione_regione = col_character(),
    lat = col_double(),
    long = col_double(),
    ricoverati_con_sintomi = col_integer(),
    terapia_intensiva = col_integer(),
    totale_ospedalizzati = col_integer(),
    isolamento_domiciliare = col_integer(),
    totale_positivi = col_integer(),
    variazione_totale_positivi = col_integer(),
    nuovi_positivi = col_integer(),
    dimessi_guariti = col_integer(),
    deceduti = col_integer(),
    casi_da_sospetto_diagnostico = col_integer(),
    casi_da_screening = col_integer(),
    totale_casi = col_integer(),
    tamponi = col_integer(),
    casi_testati = col_integer(),
    note = col_character(),
    ingressi_terapia_intensiva = col_integer(),
    note_test = col_character(),
    note_casi = col_character(),
    totale_positivi_test_molecolare = col_integer(),
    totale_positivi_test_antigenico_rapido = col_integer(),
    tamponi_test_molecolare = col_integer(),
    tamponi_test_antigenico_rapido = col_integer(),
    codice_nuts_1 = col_character(),
    codice_nuts_2 = col_character()
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
    Date = data,
    Admin0 = stato,
    Region_Code = codice_regione,
    Admin2 = denominazione_regione,
    Latitude = lat,
    Longitude = long,
    Hospitalized_Sym = ricoverati_con_sintomi,
    ICU = terapia_intensiva,
    Hospitalized = totale_ospedalizzati,
    Home_Confinement = isolamento_domiciliare,
    Active = totale_positivi,
    Positive_Variation = variazione_totale_positivi,
    Positive_New = nuovi_positivi,
    Recovered = dimessi_guariti,
    Deaths = deceduti,
    Positive_Dx = casi_da_sospetto_diagnostico,
    Positive_Sc = casi_da_screening,
    Confirmed = totale_casi,
    Tests = tamponi,
    Tested = casi_testati,
    Note = note,
    ICU_Now = ingressi_terapia_intensiva,
    Note_Test = note_test,
    Note_Case = note_casi,
    Tests_PCR = tamponi_test_molecolare,
    Tests_Rapid = tamponi_test_antigenico_rapido,
    NUTS1 = codice_nuts_1,
    NUTS2 = codice_nuts_2
  ) |>
  mutate(
    Positive = Confirmed,
    Negative = Tested - Confirmed,
    Pending = Tests - Tested
  ) |>
  pivot_longer(
    cols = c(
      Confirmed, Active, Recovered, Deaths,
      Positive_Dx, Positive_Sc,
      Positive, Negative, Pending, Tests, Tested,
      Hospitalized, ICU, ICU_Now,
      Hospitalized_Sym, Home_Confinement
    ),
    names_to = "Type",
    values_to = "Cases"
  ) |>
  mutate(
    Age = "Total",
    Sex = "Total",
    Source = "DPC",
    Level = "NUTS2",
    FIPS = NA_character_,
    Admin3 = NA_character_,
    Admin1 = NA_character_,
    Admin0 = "Italy"
  ) |>
  Unify_Everything() |>
  select(-Admin1, -Population) |>
  select(-NUTS1, -NUTS2) |>
  mutate(
    NUTS_NAME = Admin2,
    ISO1_2C = "IT"
  ) |>
  left_join(
    NUTS_Unified |>
      select(
        ISO1_2C, Level, contains("Admin")
      )
  ) |>
  left_join(
    NUTS_Unified
  ) |>
  select(
    Date, Cases, Type, matches("Age|Sex"),
    Source, Level, matches("Longitude|Latitude|Population"),
    FIPS, Admin3, Admin2, Admin1, Admin0
  )

#-------------------------------------------------------------------------------

COVID19.DPC_NUTS1 <- COVID19.DPC_NUTS2 |>
  filter(Level == "NUTS2") |>
  Aggregate_Admin(
    Admin = 1L,
    Country = NULL,
    State = NULL,
    na.rm = FALSE
  ) |>
  mutate(
    Level = "NUTS1"
  ) |>
  select(-Population) |>
  mutate(
    NUTS_NAME = Admin1,
    ISO1_2C = "IT"
  ) |>
  left_join(
    NUTS_Unified
  ) |>
  select(
    Date, Cases, Type, matches("Age|Sex"),
    Source, Level, matches("Longitude|Latitude|Population"),
    FIPS, Admin3, Admin2, Admin1, Admin0
  )

#-------------------------------------------------------------------------------

COVID19.DPC_NUTS0 <- COVID19.DPC_NUTS2 |>
  filter(Level == "NUTS2") |>
  Aggregate_Admin(
    Admin = 0L,
    Country = NULL,
    State = NULL,
    na.rm = FALSE
  ) |>
  mutate(
    Level = "Country"
  )

#-------------------------------------------------------------------------------

COVID19.DPC_NUTS3 <- read_delim(
  file = DPC_URL |>
    str_interp(
      env = list(
        Region = "province"
      )
    ),
  col_names = TRUE,
  col_types = cols(
    data = col_date(format = "%Y-%m-%dT%H:%M:%S"),
    stato = col_character(),
    codice_regione = col_character(),
    denominazione_regione = col_character(),
    codice_provincia = col_character(),
    denominazione_provincia = col_character(),
    sigla_provincia = col_character(),
    lat = col_double(),
    long = col_double(),
    totale_casi = col_integer(),
    note = col_character(),
    codice_nuts_1 = col_character(),
    codice_nuts_2 = col_character(),
    codice_nuts_3 = col_character()
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
  str_replace_names(
    pattern = ";",
    replacement = ""
  ) |>
  mutate(
    across(
      contains("codice_nuts"),
      function(x) {
        x |>
          str_replace_all(
            pattern = ";",
            replacement = ""
          )
      }
    )
  ) |>
  mutate(
    across(
      contains("codice_nuts"),
      function(x) {
        x |>
          na_if("")
      }
    )
  ) |>
  rename(
    Date = data,
    Admin0 = stato,
    Region_Code = codice_regione,
    Admin2 = denominazione_regione,
    Province_Code = codice_provincia,
    Admin3 = denominazione_provincia,
    Admin3_Code = sigla_provincia,
    Latitude = lat,
    Longitude = long,
    Confirmed = totale_casi,
    Note = note,
    NUTS1 = codice_nuts_1,
    NUTS2 = codice_nuts_2,
    NUTS3 = codice_nuts_3
  ) |>
  pivot_longer(
    cols = c(
      Confirmed
    ),
    names_to = "Type",
    values_to = "Cases"
  ) |>
  mutate(
    Age = "Total",
    Sex = "Total",
    Source = "DPC",
    Level = "NUTS3",
    FIPS = NA_character_,
    Admin1 = NA_character_,
    Admin0 = "Italy"
  ) |>
  Unify_Everything() |>
  select(-Admin1, -Population) |>
  select(-NUTS1, -NUTS2, -NUTS3) |>
  mutate(
    NUTS_NAME = Admin3,
    ISO1_2C = "IT"
  ) |>
  left_join(
    NUTS_Unified |>
      select(
        ISO1_2C, Level, contains("Admin")
      )
  ) |>
  left_join(
    NUTS_Unified
  ) |>
  select(
    Date, Cases, Type, matches("Age|Sex"),
    Source, Level, matches("Longitude|Latitude|Population"),
    FIPS, Admin3, Admin2, Admin1, Admin0
  )

################################################################################

# COVID19.RKI_NUTS3 <- read_delim(
#   file = RKI_URL |>
#     str_interp(
#       env = list(
#         filename = "cases-rki-by-ags.csv"
#       )
#     ),
#   col_names = TRUE,
#   col_types = cols(
#     # ObjectId = col_integer(),
#     FID = col_integer(),
#     IdBundesland = col_integer(),
#     Bundesland = col_character(),
#     Landkreis = col_character(),
#     Altersgruppe = col_character(),
#     Geschlecht = col_character(),
#     AnzahlFall = col_integer(),
#     AnzahlTodesfall = col_integer(),
#     Meldedatum = col_date(format = "%Y/%m/%d %H:%M:%S"),
#     IdLandkreis = col_integer(),
#     Datenstand = col_date(format = "%d.%m.%Y, %H:%M Uhr"),
#     NeuerFall = col_integer(),
#     NeuerTodesfall = col_integer(),
#     Refdatum = col_date(format = "%Y/%m/%d %H:%M:%S"),
#     NeuGenesen = col_integer(),
#     AnzahlGenesen = col_integer(),
#     IstErkrankungsbeginn = col_logical(),
#     Altersgruppe2 = col_character()
#   ),
#   col_select = NULL,
#   id = NULL,
#   delim = ",",
#   quote = '"',
#   na = c("", ".", "-", "NA", "NULL"),
#   comment = "",
#   trim_ws = TRUE,
#   escape_double = TRUE,
#   escape_backslash = FALSE,
#   locale = default_locale(),
#   skip = 0,
#   n_max = Inf,
#   guess_max = 1000L,
#   num_threads = 1L,
#   progress = FALSE,
#   show_col_types = FALSE,
#   lazy = FALSE
# ) |>
#   rename(
#     State_ID = IdBundesland,
#     State = Bundesland,
#     District = Landkreis,
#     Age = Altersgruppe,
#     Sex = Geschlecht,
#     Confirmed = AnzahlFall,
#     Deaths = AnzahlTodesfall,
#     Date = Meldedatum,
#     District_ID = IdLandkreis,
#     Data_Status = Datenstand,
#     Confirmed_New = NeuerFall,
#     Deaths_New = NeuerTodesfall,
#     Date_Reference = Refdatum,
#     Recovered_New = NeuGenesen,
#     Recovered = AnzahlGenesen,
#     Onset = IstErkrankungsbeginn,
#     Age2 = Altersgruppe2
#   ) |>
#   mutate(
#     Active = Confirmed - Recovered - Deaths
#   ) |>
#   pivot_longer(
#     cols = c(Confirmed, Active, Recovered, Deaths),
#     names_to = "Type",
#     values_to = "Cases"
#   ) |>
#   mutate(
#     AGS = District_ID |>
#       as.integer() |>
#       as.character() |>
#       str_remove(
#         pattern = "^0+"
#       ) |>
#       str_pad(
#         width = 5,
#         pad = "0"
#       ),
#     Age = Age |>
#       recode(
#         "unbekannt" = "Unknown"
#       ),
#     Sex = Sex |>
#       recode(
#         "M" = "Male",
#         "W" = "Female",
#         "unbekannt" = "Unknown"
#       ),
#     Age2 = Age2 |>
#       recode(
#         "Nicht übermittelt" = "Not Submitted"
#       )
#   ) |>
#   left_join(
#     read_delim(
#       file = file.path(COVID19.dir, "Modeling/AGS_NUTS_DE.csv"),
#       col_names = TRUE,
#       col_types = cols(
#         Longitude = col_double(),
#         Latitude = col_double(),
#         Population = col_integer()
#       ),
#       col_select = NULL,
#       id = NULL,
#       delim = ",",
#       quote = '"',
#       na = c("", ".", "-", "NA", "NULL"),
#       comment = "",
#       trim_ws = TRUE,
#       escape_double = TRUE,
#       escape_backslash = FALSE,
#       locale = default_locale(),
#       skip = 0,
#       n_max = Inf,
#       guess_max = 1000L,
#       num_threads = 1L,
#       progress = FALSE,
#       show_col_types = FALSE,
#       lazy = FALSE
#     ) |>
#       mutate(
#         AGS = AGS |>
#           as.integer() |>
#           as.character() |>
#           str_remove(
#             pattern = "^0+"
#           ) |>
#           str_pad(
#             width = 5,
#             pad = "0"
#           )
#       )
#   ) |>
#   mutate(
#     Source = "RKI",
#     Level = "NUTS3",
#     FIPS = NA_character_
#   ) |>
#   Unify_Everything() |>
#   group_by(
#     Date, Type, Source, Level,
#     Longitude, Latitude, Population,
#     FIPS, AGS, Admin3, Admin2, Admin1, Admin0
#   ) |>
#   summarize(
#     Cases = Cases |>
#       sum(
#         na.rm = TRUE
#       ),
#     .groups = "keep"
#   ) |>
#   ungroup() |>
#   mutate(
#     Age = "Total",
#     Sex = "Total"
#   ) |>
#   select(
#     Date, Cases, Type, Age, Sex, Source, Level,
#     Longitude, Latitude, Population,
#     FIPS, AGS, Admin3, Admin2, Admin1, Admin0
#   ) |>
#   distinct(
#     across(-Cases),
#     .keep_all = TRUE
#   ) |>
#   arrange(
#     Date, Cases, Type, Age, Sex, Source, Level,
#     Longitude, Latitude, Population,
#     FIPS, AGS, Admin3, Admin2, Admin1, Admin0
#   ) |>
#   complete(
#     Date, Age, Sex,
#     nesting(
#       Type, Source, Level,
#       Longitude, Latitude, Population,
#       FIPS, AGS, Admin3, Admin2, Admin1, Admin0
#     ),
#     fill = list(
#       Cases = 0L
#     )
#   ) |>
#   group_by(
#     Type, Age, Sex, Source, Level,
#     Longitude, Latitude, Population,
#     FIPS, AGS, Admin3, Admin2, Admin1, Admin0
#   ) |>
#   mutate(
#     Cases_Accu = cumsum(Cases)
#   ) |>
#   ungroup() |>
#   mutate(Cases = Cases_Accu) |>
#   # filter(Age == "Total", Sex == "Total") |>
#   Unify_Everything() |>
#   select(-Population) |>
#   mutate(
#     NUTS_NAME = Admin3,
#     ISO1_2C = "DE"
#   ) |>
#   left_join(
#     NUTS_Unified
#   ) |>
#   select(
#     Date, Cases, Type, matches("Age|Sex"),
#     Source, Level, matches("Longitude|Latitude|Population"),
#     FIPS, AGS, Admin3, Admin2, Admin1, Admin0
#   )
#
# #-------------------------------------------------------------------------------
#
# COVID19.RKI_NUTS2 <- COVID19.RKI_NUTS3 |>
#   filter(Level == "NUTS3") |>
#   Aggregate_Admin(
#     Admin = 2L,
#     Country = NULL,
#     State = NULL,
#     na.rm = FALSE
#   ) |>
#   mutate(
#     Level = "NUTS2"
#   ) |>
#   Unify_Everything() |>
#   select(-Population) |>
#   mutate(
#     NUTS_NAME = Admin2,
#     ISO1_2C = "DE"
#   ) |>
#   left_join(
#     NUTS_Unified
#   ) |>
#   select(
#     Date, Cases, Type, matches("Age|Sex"),
#     Source, Level, matches("Longitude|Latitude|Population"),
#     FIPS, Admin3, Admin2, Admin1, Admin0
#   )
#
# #-------------------------------------------------------------------------------
#
# COVID19.RKI_NUTS1 <- COVID19.RKI_NUTS3 |>
#   filter(Level == "NUTS3") |>
#   Aggregate_Admin(
#     Admin = 1L,
#     Country = NULL,
#     State = NULL,
#     na.rm = FALSE
#   ) |>
#   mutate(
#     Level = "NUTS1"
#   ) |>
#   Unify_Everything() |>
#   select(-Population) |>
#   mutate(
#     NUTS_NAME = Admin1,
#     ISO1_2C = "DE"
#   ) |>
#   left_join(
#     NUTS_Unified
#   ) |>
#   select(
#     Date, Cases, Type, matches("Age|Sex"),
#     Source, Level, matches("Longitude|Latitude|Population"),
#     FIPS, Admin3, Admin2, Admin1, Admin0
#   )
#
# #-------------------------------------------------------------------------------
#
# COVID19.RKI_NUTS0 <- COVID19.RKI_NUTS3 |>
#   filter(Level == "NUTS3") |>
#   Aggregate_Admin(
#     Admin = 0L,
#     Country = NULL,
#     State = NULL,
#     na.rm = FALSE
#   ) |>
#   mutate(
#     Level = "Country"
#   )

#-------------------------------------------------------------------------------

COVID19.RKI <- readRDS("latest/COVID-19_RKI.rds")

################################################################################

COVID19.BR_URL <- function(URL) {
  read_delim(
    file = URL,
    col_names = TRUE,
    col_types = cols(
      epi_week = col_integer(),
      date = col_date(format = "%Y-%m-%d"),
      state = col_character(),
      city = col_character(),
      ibgeID = col_character(),
      newDeaths = col_integer(),
      deaths = col_integer(),
      newCases = col_integer(),
      totalCases = col_integer(),
      deaths_per_100k_inhabitants = col_double(),
      totalCases_per_100k_inhabitants = col_double(),
      deaths_by_totalCases = col_double()
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
      city != "TOTAL",
      state != "TOTAL"
    ) |>
    rename(
      Date = date,
      ISO2 = state,
      Admin2 = city,
      Confirmed = totalCases,
      Deaths = deaths,
      IBGE = ibgeID
    ) |>
    pivot_longer(
      cols = c(
        Confirmed, Deaths
      ),
      names_to = "Type",
      values_to = "Cases"
    ) |>
    left_join(
      ISO2_Unified |>
        filter(ISO1_2C == "BR")
    ) |>
    mutate(
      Age = "Total",
      Sex = "Total",
      Source = "SES",
      Level = case_when(
        Admin2 == "TOTAL" ~ "Country",
        TRUE ~ "Municipality"
      ),
      FIPS = NA_character_,
      Admin3 = NA_character_,
      Admin2 = case_when(
        Admin2 == "TOTAL" ~ NA_character_,
        TRUE ~ Admin2 |>
          str_replace(
            pattern = str_c("/", ISO2),
            replacement = ""
          )
      ),
      Admin1 = ISO2_Name,
      Admin0 = "Brazil"
    ) |>
    arrange(Date, Type, Age, Sex, Source, Level) |>
    left_join(
      read_delim(
        file = BR_GPS,
        col_names = TRUE,
        col_types = cols(
          ibgeID = col_character(),
          id = col_character(),
          lat = col_character(),
          lon = col_character(),
          longName = col_character()
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
          IBGE = ibgeID
        ) |>
        mutate(
          Longitude = lon |>
            as.double(),
          Latitude = lat |>
            as.double()
        ) |>
        drop_na(IBGE) |>
        select(
          IBGE, Longitude, Latitude
        )
    ) |>
    left_join(
      read_delim(
        file = BR_Pop,
        col_names = TRUE,
        col_types = cols(
          ibge = col_character(),
          city = col_character(),
          state = col_character(),
          region = col_character(),
          pop2019 = col_integer(),
          pop2020 = col_integer(),
          pop2021 = col_integer(),
          isCountryside = col_logical(),
          cod_RegiaoDeSaude = col_double(),
          name_RegiaoDeSaude = col_character(),
          ibge_id = col_character()
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
          IBGE = ibge,
          Population = pop2021
        ) |>
        drop_na(IBGE) |>
        select(
          IBGE, Population
        )
    ) |>
    Unify_Everything() |>
    select(
      Date, Cases, Type, matches("Age|Sex"),
      Source, Level, matches("Longitude|Latitude|Population", ignore.case = FALSE),
      FIPS, IBGE, Admin3, Admin2, Admin1, Admin0
    )
}

#-------------------------------------------------------------------------------

COVID19.BR_Municipality <- BR_URL |>
  str_replace(
    pattern = ".csv.gz",
    replacement = "_2020.csv.gz"
  ) |>
  COVID19.BR_URL() |>
  bind_rows(
    BR_URL |>
      str_replace(
        pattern = ".csv.gz",
        replacement = "_2021.csv.gz"
      ) |>
      COVID19.BR_URL()
  ) |>
  bind_rows(
    BR_URL |>
      COVID19.BR_URL()
  )

#-------------------------------------------------------------------------------

COVID19.BR_State <- COVID19.BR_Municipality |>
  filter(Level == "Municipality") |>
  Aggregate_Admin(
    Admin = 1L,
    Country = NULL,
    State = NULL,
    na.rm = FALSE
  ) |>
  mutate(
    Level = "State"
  )

#-------------------------------------------------------------------------------

COVID19.BR_Country <- COVID19.BR_Municipality |>
  filter(Level == "Municipality") |>
  Aggregate_Admin(
    Admin = 0L,
    Country = NULL,
    State = NULL,
    na.rm = FALSE
  ) |>
  mutate(
    Level = "Country"
  )

################################################################################

COVID19.JRC.world <- read_delim(
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
    ISO1_3C = iso3,
    Latitude = lat,
    Longitude = lon,
    Confirmed = CumulativePositive,
    Deaths = CumulativeDeceased,
    Recovered = CumulativeRecovered,
    Active = CurrentlyPositive,
    Hospitalized = Hospitalized,
    ICU = IntensiveCare
  ) |>
  pivot_longer(
    cols = c(
      Confirmed, Active, Recovered, Deaths,
      Hospitalized, ICU
    ),
    names_to = "Type",
    values_to = "Cases"
  ) |>
  mutate(
    Age = "Total",
    Sex = "Total",
    Source = "JRC",
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
    FIPS = NA_character_
  ) |>
  mutate(
    # Admin0 = CountryName |>
    #   Unify_Names(),
    NUTS_NAME = CountryName |>
      Unify_Names(),
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
  left_join(
    NUTS_Unified
  ) |>
  mutate(
    Admin0 = case_when(
      is.na(Admin0) & str_length(NUTS) == 2L ~ CountryName,
      TRUE ~ Admin0
    ),
    Level = case_when(
      (is.na(Level) & str_length(NUTS) == 2L) | Level == "NUTS0" ~ "Country",
      TRUE ~ Level
    )
  ) |>
  filter(
    # !is.na(Population),
    !is.na(Admin0),
    !is.na(NUTS) | Level == "Country",
  ) |>
  filter(
    Level %!in% c("NUTS2", "NUTS3") | !is.na(Admin1),
    Level != "NUTS3" | !is.na(Admin2)
  ) |>
  Unify_Everything() |>
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
      # "Russia",
      "Turks and Caicos islands",
      "United States Virgin Islands",
      "Virgin Islands"
    )
  ) |>
  arrange(
    Date, Cases, Type, Age, Sex,
    Source, Level, Longitude, Latitude, Population,
    FIPS, Admin3, Admin2, Admin1, Admin0
  ) |>
  complete(
    Date,
    nesting(
      Type, Age, Sex,
      Source, Level, Longitude, Latitude, Population,
      FIPS, Admin3, Admin2, Admin1, Admin0
    ),
    fill = list(
      Cases = NA_integer_
    )
  ) |>
  group_by(
    Type, Age, Sex,
    Source, Level, Longitude, Latitude, Population,
    FIPS, Admin3, Admin2, Admin1, Admin0
  ) |>
  fill(
    Cases,
    .direction = "up"
  ) |>
  ungroup() |>
  select(
    Date, Cases, Type, matches("Age|Sex"),
    Source, Level, matches("Longitude|Latitude|Population"),
    FIPS, Admin3, Admin2, Admin1, Admin0
  )

#-------------------------------------------------------------------------------

# COVID19.JRC.region <- read_delim(
#   file = JRC_URL |>
#     str_interp(
#       env = list(
#         subdir = "by-region",
#         subset = "by-regions"
#       )
#     ),
#   col_names = TRUE,
#   col_types = cols(
#     Date = col_date(format = "%Y-%m-%d"),
#     iso3 = col_character(),
#     CountryName = col_character(),
#     Region = col_character(),
#     lat = col_double(),
#     lon = col_double(),
#     CumulativePositive = col_integer(),
#     CumulativeDeceased = col_integer(),
#     CumulativeRecovered = col_integer(),
#     CurrentlyPositive = col_integer(),
#     Hospitalized = col_integer(),
#     IntensiveCare = col_integer(),
#     EUcountry = col_logical(),
#     EUCPMcountry = col_logical(),
#     NUTS = col_character()
#   ),
#   col_select = NULL,
#   id = NULL,
#   delim = ",",
#   quote = '"',
#   na = c("", ".", "-", "NA", "NULL"),
#   comment = "",
#   trim_ws = TRUE,
#   escape_double = TRUE,
#   escape_backslash = FALSE,
#   locale = default_locale(),
#   skip = 0,
#   n_max = Inf,
#   guess_max = 1000L,
#   num_threads = 1L,
#   progress = FALSE,
#   show_col_types = FALSE,
#   lazy = FALSE
# ) |>
#   rename(
#     ISO1_3C = iso3,
#     Latitude = lat,
#     Longitude = lon,
#     Confirmed = CumulativePositive,
#     Deaths = CumulativeDeceased,
#     Recovered = CumulativeRecovered,
#     Active = CurrentlyPositive,
#     Hospitalized = Hospitalized,
#     ICU = IntensiveCare
#   ) |>
#   pivot_longer(
#     cols = c(
#       Confirmed, Active, Recovered, Deaths,
#       Hospitalized, ICU
#     ),
#     names_to = "Type",
#     values_to = "Cases"
#   ) |>
#   mutate(
#     Age = "Total",
#     Sex = "Total",
#     Source = "JRC",
#     # XAD | XAX = Akrotiri and Dhekelia
#     # XCA | XCX = Caspian Sea
#     # KOS | XKO | XKX = Kosovo
#     # XNC | XNC = Northern Cyprus
#     ISO1_2C = case_when(
#       ISO1_3C %in% c("XAD", "XAX") ~ "XA",
#       ISO1_3C %in% c("XCA", "XCX") ~ "XC",
#       ISO1_3C %in% c("KOS", "XKO", "XKX") ~ "XK",
#       ISO1_3C %in% c("XNC", "XNX") ~ "XN",
#       ISO1_3C %in% c("WWW") ~ "WW",
#       TRUE ~ countrycode(
#         ISO1_3C |>
#           na_if("XAD") |>
#           na_if("XAX") |>
#           na_if("XCA") |>
#           na_if("XCX") |>
#           na_if("KOS") |>
#           na_if("XKO") |>
#           na_if("XKX") |>
#           na_if("XNC") |>
#           na_if("XNX") |>
#           na_if("WWW"),
#         origin = 'iso3c',
#         destination = 'iso2c'
#       ) |>
#         str_pad(
#           width = 2,
#           pad = "0"
#         )
#     ),
#     FIPS = NA_character_
#   ) |>
#   mutate(
#     # Admin0 = CountryName |>
#     #   Unify_Names(),
#     NUTS_NAME = Region |>
#       Unify_Names(),
#     Level2 = NUTS |>
#       str_length(),
#     Level = "NUTS" |>
#       str_c(
#         Level2 - 2
#       )
#   ) |>
#   filter(!is.na(NUTS)) |>
#   left_join(
#     NUTS_Unified
#   ) |>
#   mutate(
#     Admin0 = case_when(
#       is.na(Admin0) & str_length(NUTS) == 2L ~ CountryName,
#       TRUE ~ Admin0
#     ),
#     Level = case_when(
#       (is.na(Level) & str_length(NUTS) == 2L) | Level == "NUTS0" ~ "Country",
#       TRUE ~ Level
#     )
#   ) |>
#   filter(
#     # !is.na(Population),
#     !is.na(Admin0),
#     !is.na(NUTS) | Level == "Country",
#   ) |>
#   filter(
#     Level %!in% c("NUTS2", "NUTS3") | !is.na(Admin1),
#     Level != "NUTS3" | !is.na(Admin2)
#   ) |>
#   Unify_Everything() |>
#   filter(
#     Admin0 %!in% c(
#       "Anguilla",
#       "Aruba",
#       "Bermuda",
#       "Bonaire, Saint Eustatius and Saba",
#       "British Virgin Islands",
#       "Cayman Islands",
#       "Curacao",
#       "Falkland Islands",
#       "Guernsey",
#       "Gibraltar",
#       "Greenland",
#       "Guam",
#       "French Polynesia",
#       "Isle of Man",
#       "Jersey",
#       "Montserrat",
#       "New Caledonia",
#       "Northern Mariana Islands",
#       "Puerto Rico",
#       # "Russia",
#       "Turks and Caicos islands",
#       "United States Virgin Islands",
#       "Virgin Islands"
#     )
#   ) |>
#   # filter(Level == "Country") |>
#   arrange(
#     Date, Cases, Type, Age, Sex,
#     Source, Level, Longitude, Latitude, Population,
#     FIPS, Admin3, Admin2, Admin1, Admin0
#   ) |>
#   complete(
#     Date,
#     nesting(
#       Type, Age, Sex,
#       Source, Level, Longitude, Latitude, Population,
#       FIPS, Admin3, Admin2, Admin1, Admin0
#     ),
#     fill = list(
#       Cases = NA_integer_
#     )
#   ) |>
#   group_by(
#     Type, Age, Sex,
#     Source, Level, Longitude, Latitude, Population,
#     FIPS, Admin3, Admin2, Admin1, Admin0
#   ) |>
#   fill(
#     Cases,
#     .direction = "up"
#   ) |>
#   ungroup() |>
#   select(
#     Date, Cases, Type, matches("Age|Sex"),
#     Source, Level, matches("Longitude|Latitude|Population"),
#     FIPS, Admin3, Admin2, Admin1, Admin0
#   )

################################################################################

if (exists("INCLUDE_LINELIST")) {
  BOP_URL |>
    download.file(
      destfile = BOP_URL |>
        basename(),
      method = "auto",
      mode = "w",
      quiet = TRUE,
      cacheOK = TRUE,
      extra = NULL,
      headers = NULL
    ) |>
    {
      function(.) {
        if (. == 0) {
          untar(
            tarfile = BOP_URL |>
              basename(),
            files = BOP_URL |>
              basename() |>
              str_replace(
                pattern = "[.]tar.gz$",
                replacement = ".csv"
              )
          )
        } else {
          stop(
            paste(
              "Failed to download data from",
              BOP_URL
            )
          )
        }
      }
    }()

  #-------------------------------------------------------------------------------

  COVID19.BOP <- read_delim(
    file = BOP_URL |>
      basename() |>
      gsub(
        pattern = ".tar.gz$",
        replacement = ".csv"
      ),
    col_names = TRUE,
    col_types = cols(
      ID = col_character(),
      age = col_character(),
      sex = col_character(),
      city = col_character(),
      province = col_character(),
      country = col_character(),
      latitude = col_double(),
      longitude = col_double(),
      geo_resolution = col_character(),
      date_onset_symptoms = col_character(), # col_date(format = "%d.%m.%Y"),
      date_admission_hospital = col_character(), # col_date(format = "%d.%m.%Y"),
      date_confirmation = col_character(), # col_date(format = "%d.%m.%Y"),
      symptoms = col_character(),
      lives_in_Wuhan = col_character(),
      travel_history_dates = col_character(),
      travel_history_location = col_character(),
      reported_market_exposure = col_character(),
      additional_information = col_character(),
      chronic_disease_binary = col_logical(),
      chronic_disease = col_character(),
      source = col_character(),
      sequence_available = col_character(),
      outcome = col_character(),
      date_death_or_discharge = col_character(), # col_date(format = "%d.%m.%Y"),
      notes_for_discussion = col_character(),
      location = col_character(),
      admin3 = col_character(),
      admin2 = col_character(),
      admin1 = col_character(),
      country_new = col_character(),
      admin_id = col_character(),
      data_moderator_initials = col_character(),
      travel_history_binary = col_logical()
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
      date_onset_symptoms = date_onset_symptoms |>
        str_split_fixed(
          pattern = "-",
          n = 1
        ) |>
        as.Date(format = "%d.%m.%Y"),
      date_admission_hospital = date_admission_hospital |>
        str_split_fixed(
          pattern = "-",
          n = 1
        ) |>
        as.Date(
          format = "%d.%m.%Y"
        ),
      date_confirmation = date_confirmation |>
        str_split_fixed(
          pattern = "-",
          n = 1
        ) |>
        as.Date(
          format = "%d.%m.%Y"
        ),
      date_death_or_discharge = date_death_or_discharge |>
        str_split_fixed(
          pattern = "-",
          n = 1
        ) |>
        as.Date(
          format = "%d.%m.%Y"
        ),
      travel_history_dates = travel_history_dates |>
        str_split_fixed(
          pattern = "-",
          n = 1
        ) |>
        as.Date(
          format = "%d.%m.%Y"
        ),
      death = case_when(
        tolower(outcome) %in% tolower(
          c(
            "Dead", "Death", "Deceased", "Died"
          )
        ) ~ TRUE,
        TRUE ~ FALSE
      ),
      delay_onset_report = date_confirmation |>
        difftime(
          date_onset_symptoms,
          units = "days"
        ),
      delay_onset_admission = date_admission_hospital |>
        difftime(
          date_onset_symptoms,
          units = "days"
        ),
      delay_onset_death = date_death_or_discharge |>
        difftime(
          date_onset_symptoms,
          units = "days"
        ),
      lives_in_Wuhan = case_when(
        lives_in_Wuhan == "yes" ~ TRUE,
        TRUE ~ FALSE
      )
    ) |>
    rename(
      ID_BOP = ID,
      Admin0 = country_new,
      Admin1 = admin1,
      Admin2 = admin2,
      Admin3 = admin3,
      Latitude = latitude,
      Longitude = longitude,
      Age = age,
      Sex = sex
    ) |>
    mutate(
      Admin2_Missing = is.na(Admin2),
      Admin2 = case_when(
        !is.na(Admin3) & Admin2_Missing ~ Admin3,
        TRUE ~ Admin2
      ),
      Admin3 = case_when(
        Admin2_Missing ~ NA_character_,
        TRUE ~ Admin3
      ),
    ) |>
    Unify_Admins() |>
    left_join(
      COVID19.LUT |>
        Unify_Admins() |>
        select(
          ID, Admin0, Admin1, Admin2, Admin3
        )
    ) |>
    left_join(
      COVID19.LUT |>
        filter(Admin0 == "Germany") |>
        Unify_Admins() |>
        mutate(
          Admin2 = Admin3
        ) |>
        select(
          ID, Admin0, Admin1, Admin2
        )
    )

  # COVID19.BOP.test |>
  #   filter(
  #     is.na(ID),
  #     Admin0 != "United States"
  #   ) |>
  #   mutate(
  #     NameID = paste(
  #       Admin3,
  #       Admin2,
  #       Admin1,
  #       Admin0,
  #       sep = ", "
  #     )
  #   ) |>
  #   pull(NameID) |>
  #   unique()
}

################################################################################
################################################################################
################################################################################

try(
  system(
    str_c(
      "cd ",
      file.path(
        COVID19.dir,
        "UVA_CCEP_Public"
      ),
      " ; ",
      "git pull",
      " ; ",
      "cd ",
      getwd()
    )
  )
)

#-------------------------------------------------------------------------------

COVID19.UVA.LUT <- read_delim(
  file = file.path(
    COVID19.dir,
    "UVA_CCEP_Public",
    "CCEPM_LUT.csv"
  ),
  col_names = TRUE,
  col_types = cols(
    id = col_character(),
    iso2 = col_character(),
    iso1_3n = col_character(),
    iso1_3c = col_character(),
    iso1_2c = col_character(),
    iso2_uid = col_character(),
    admin = col_double(),
    admin0 = col_character(),
    admin1 = col_character(),
    admin2 = col_character(),
    admin3 = col_character(),
    level = col_character(),
    mean = col_double(),
    sum = col_double(),
    sum_o65 = col_double(),
    perc_o65 = col_double(),
    centroid_longitude = col_double(),
    centroid_latitude = col_double(),
    mean_city = col_double(),
    mean_motor = col_double(),
    mean_walk = col_double(),
    nameid = col_character()
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
) |>
  rename(
    ID = id,
    Level = level,
    ISO1_3N = iso1_3n,
    ISO1_3C = iso1_3c,
    ISO1_2C = iso1_2c,
    ISO2 = iso2,
    ISO2_UID = iso2_uid,
    Longitude = centroid_longitude,
    Latitude = centroid_latitude,
    Population = sum,
    Admin = admin,
    Admin0 = admin0,
    Admin1 = admin1,
    Admin2 = admin2,
    Admin3 = admin3,
  ) |>
  mutate(
    FIPS = NA_character_,
    NUTS = NA_character_,
    AGS = NA_character_,
    IBGE = NA_character_,
    ZCTA = NA_character_,
    NameID = str_c(
      Admin3 |> str_replace_na(
        replacement = "TMPSTRING"
      ),
      Admin2 |> str_replace_na(
        replacement = "TMPSTRING"
      ),
      Admin1 |> str_replace_na(
        replacement = "TMPSTRING"
      ),
      Admin0 |> str_replace_na(
        replacement = "TMPSTRING"
      ),
      sep = ", "
    ) |>
      str_replace(
        pattern = "TMPSTRING, ",
        replacement = ""
      ) |>
      str_replace(
        pattern = "TMPSTRING, ",
        replacement = ""
      ) |>
      str_replace(
        pattern = "TMPSTRING, ",
        replacement = ""
      ) |>
      str_replace(
        pattern = "TMPSTRING, ",
        replacement = ""
      )
  ) |>
  distinct(
    ID, NameID, Admin, Admin0, Admin1, Admin2, Admin3, Level,
    ISO1_3N, ISO1_3C, ISO1_2C, ISO2, ISO2_UID,
    FIPS, NUTS, AGS, IBGE, ZCTA,
    .keep_all = TRUE
  ) |>
  mutate(
    # Longitude = Longitude |>
    #   round(2) |>
    #   format(nsmall = 2, trim = TRUE) |>
    #   na_if("NA"),
    # Latitude = Latitude |>
    #   round(2) |>
    #   format(nsmall = 2, trim = TRUE) |>
    #   na_if("NA"),
    Population = Population |>
      as.integer(),
    Admin = Admin |>
      as.integer()
  ) |>
  mutate(
    ID = ID |>
      str_remove(
        pattern = str_c(
          "^",
          ISO1_2C,
          ISO2
        )
      ) |>
      str_remove(
        pattern = str_c(
          "^",
          ISO1_2C
        )
      ) |>
      {
        function(.) {
          str_c(
            str_c(
              ISO1_2C,
              ISO2
            ),
            .
          )
        }
      }()
  ) |>
  select(
    ID, Level,
    ISO1_3N, ISO1_3C, ISO1_2C, ISO2, ISO2_UID,
    FIPS, NUTS, AGS, IBGE, ZCTA,
    Longitude, Latitude, Population,
    Admin, Admin0, Admin1, Admin2, Admin3, NameID
  )

#-------------------------------------------------------------------------------

COVID19.UVA <- list.files(
  path = file.path(
    COVID19.dir,
    "UVA_CCEP_Public",
    "daily_covid_updates"
  ),
  pattern = "*.*.csv$",
  full.names = TRUE,
  recursive = TRUE
) |>
  # str_subset(
  #   pattern = "2021-01-01"
  # ) |>
  map_dfr(
    function(filename) {
      filename |>
        str_c("\n") |>
        cat()

      filename |>
        read_delim(
          col_names = TRUE,
          col_types = cols(
            admin0 = col_character(),
            admin1 = col_character(),
            admin2 = col_character(),
            admin3 = col_character(),
            id = col_character(),
            date = col_date(format = "%Y-%m-%d"),
            # date = col_date(format = "%m/%d/%Y"),
            cases = col_double()
            # movement_fb = col_double(),
            # non_moving_fb = col_double(),
            # a_mean = col_double(),
            # mean_pop = col_double(),
            # sum_pop = col_double(),
            # o65_sum_pop = col_double(),
            # o65_perc_pop = col_double(),
            # long = col_double(),
            # lat = col_double(),
            # mean_city = col_double(),
            # mean_motor = col_double(),
            # mean_walk = col_double(),
            # StringencyIndex = col_double(),
            # GovernmentResponseIndex = col_double(),
            # ContainmentHealthIndex = col_double(),
            # EconomicSupportIndex = col_double()
            # excess_deaths = col_double(),
            # expected_deaths = col_double(),
            # grocery_pharmacy_mobility = col_double(),
            # parks_mobility = col_double(),
            # workplaces_mobility = col_double(),
            # residential_mobility = col_double(),
            # retail_recreation_mobility = col_double(),
            # transit_mobility = col_double(),
            # household_confinement = col_character(),
            # H8_Flag = col_double()
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
          ID = id,
          Date = date,
          Cases_New = cases,
          Admin0 = admin0,
          Admin1 = admin1,
          Admin2 = admin2,
          Admin3 = admin3
        ) |>
        distinct(
          ID, Date,
          .keep_all = TRUE
        ) |>
        mutate(
          NameID = str_c(
            Admin3 |> str_replace_na("TMPSTRING"),
            Admin2 |> str_replace_na("TMPSTRING"),
            Admin1 |> str_replace_na("TMPSTRING"),
            Admin0 |> str_replace_na("TMPSTRING"),
            sep = ", "
          ) |>
            str_replace(
              pattern = "TMPSTRING, ",
              replacement = ""
            ) |>
            str_replace(
              pattern = "TMPSTRING, ",
              replacement = ""
            ) |>
            str_replace(
              pattern = "TMPSTRING, ",
              replacement = ""
            ) |>
            str_replace(
              pattern = "TMPSTRING, ",
              replacement = ""
            )
        ) |>
        select(
          ID, Date, Cases_New
        )
    }
  ) |>
  left_join(
    COVID19.UVA.LUT
  ) |>
  mutate(
    ID = case_when(
      Admin0 == "Chile" ~ ID |>
        str_remove(
          pattern = str_c(
            "^",
            ISO1_2C,
            ISO2
          )
        ) |>
        str_remove(
          pattern = str_c(
            "^",
            ISO1_2C
          )
        ) |>
        as.integer() |>
        str_pad(
          width = 2,
          pad = "0"
        ) |>
        {
          function(.) {
            str_c(
              str_c(
                ISO1_2C,
                ISO2
              ),
              .
            )
          }
        }(),
      TRUE ~ ID |>
        str_remove(
          pattern = str_c(
            "^",
            ISO1_2C,
            ISO2
          )
        ) |>
        str_remove(
          pattern = str_c(
            "^",
            ISO1_2C
          )
        ) |>
        {
          function(.) {
            str_c(
              str_c(
                ISO1_2C,
                ISO2
              ),
              .
            )
          }
        }()
    )
  ) |>
  mutate(
    Type = "Confirmed",
    Age = "Total",
    Sex = "Total",
    Source = "UVA"
  ) |>
  arrange(
    ID, Date, Type, Age, Sex, Source, Level, Admin
  ) |>
  group_by(
    Type, Age, Sex, Source, Level,
    Longitude, Latitude, Population,
    FIPS, Admin3, Admin2, Admin1, Admin0
  ) |>
  mutate(
    Cases = cumsum(Cases_New) |>
      as.integer()
  ) |>
  ungroup() |>
  select(
    Date,
    Cases, Type, Age, Sex, Source, Level,
    ID, Longitude, Latitude, Population,
    contains("ISO"), FIPS, NUTS, matches("AGS|IBGE|ZIP|ZCTA"),
    Admin, Admin3, Admin2, Admin1, Admin0, NameID
  )

################################################################################

COVID19.IHME <- IHME.load("SARS_COV_2_INFECTIONS") |>
  left_join(
    COVID19.LUT
  ) |>
  rename(
    Cases = Infections
  ) |>
  mutate(
    Type = "Infections",
    Age = "Total",
    Sex = "Total",
    Source = "IHME",
    Level = case_when(
      is.na(Level) & ID %in% c("KP", "TM") ~ "Country",
      TRUE ~ Level
    ),
    ISO1_3N = case_when(
      is.na(ISO1_3N) & ID == "KP" ~ "408",
      is.na(ISO1_3N) & ID == "TM" ~ "795",
      TRUE ~ ISO1_3N
    ),
    ISO1_3C = case_when(
      is.na(ISO1_3C) & ID == "KP" ~ "PRK",
      is.na(ISO1_3C) & ID == "TM" ~ "TKM",
      TRUE ~ ISO1_3C
    ),
    ISO1_2C = case_when(
      is.na(ISO1_2C) & ID == "KP" ~ "KP",
      is.na(ISO1_2C) & ID == "TM" ~ "TM",
      TRUE ~ ISO1_2C
    ),
    ISO2 = case_when(
      is.na(ISO2) & ID == "KP" ~ "KP",
      is.na(ISO2) & ID == "TM" ~ "TM",
      TRUE ~ ISO2
    ),
    ISO2_UID = case_when(
      is.na(ISO2_UID) & ID == "KP" ~ "KP",
      is.na(ISO2_UID) & ID == "TM" ~ "TM",
      TRUE ~ ISO2_UID
    ),
    NUTS = case_when(
      is.na(NUTS) & ID == "KP" ~ "KP",
      is.na(NUTS) & ID == "TM" ~ "TM",
      TRUE ~ NUTS
    ),
    Longitude = case_when(
      is.na(Longitude) & ID == "KP" ~ 127.5101,
      is.na(Longitude) & ID == "TM" ~ 59.5563,
      TRUE ~ Longitude
    ),
    Latitude = case_when(
      is.na(Latitude) & ID == "KP" ~ 40.3399,
      is.na(Latitude) & ID == "TM" ~ 38.9697,
      TRUE ~ Latitude
    ),
    Population = case_when(
      is.na(Population) & ID == "KP" ~ 25778815L,
      is.na(Population) & ID == "TM" ~ 6195005L,
      TRUE ~ Population
    ),
    Admin0 = case_when(
      is.na(Admin0) & ID == "KP" ~ "North Korea",
      is.na(Admin0) & ID == "TM" ~ "Turkmenistan",
      TRUE ~ Admin0
    ),
    Admin = case_when(
      is.na(Admin) & ID == "KP" ~ 0L,
      is.na(Admin) & ID == "TM" ~ 0L,
      TRUE ~ Admin
    ),
    NameID = case_when(
      is.na(NameID) & ID == "KP" ~ Admin0,
      is.na(NameID) & ID == "TM" ~ Admin0,
      TRUE ~ NameID
    )
  ) |>
  select(
    Date, Cases,
    Type, Age, Sex, Source, Level,
    ID, Longitude, Latitude, Population,
    contains("ISO"), FIPS, NUTS, matches("AGS|IBGE|ZIP|ZCTA"),
    Admin, Admin3, Admin2, Admin1, Admin0, NameID
  ) |>
  group_by(
    across(
      -c(Date, Cases)
    )
  ) |>
  mutate(
    Cases_Accu = cumsum(Cases)
  ) |>
  ungroup() |>
  mutate(
    Cases = Cases_Accu
  ) |>
  arrange(
    ID, Date, Type, Age, Sex, Source, Level, Admin
  ) |>
  select(
    Date,
    Cases, Type, Age, Sex, Source, Level,
    ID, Longitude, Latitude, Population,
    contains("ISO"), FIPS, NUTS, matches("AGS|IBGE|ZIP|ZCTA"),
    Admin, Admin3, Admin2, Admin1, Admin0, NameID
  )

################################################################################
################################################################################
################################################################################

COVID19 <- tibble(
  Date = character() |>
    as.Date(),
  Cases = integer(),
  Type = character(),
  Age = character(),
  Sex = character(),
  Source = character(),
  Level = character(),
  Longitude = double(),
  Latitude = double(),
  Population = integer(),
  FIPS = character(),
  AGS = character(),
  IBGE = character(),
  ZCTA = character(),
  Admin3 = character(),
  Admin2 = character(),
  Admin1 = character(),
  Admin0 = character()
) |>
  # as.data.table() |>
  # lazy_dt(
  #   name = "COVID19",
  #   immutable = FALSE,
  #   key_by = NULL
  # ) |>
  full_join(COVID19.BR_Municipality) |>
  full_join(COVID19.BR_State) |>
  full_join(COVID19.BR_Country) |>
  full_join(COVID19.DPC_NUTS3) |>
  full_join(COVID19.DPC_NUTS2) |>
  full_join(COVID19.DPC_NUTS1) |>
  full_join(COVID19.DPC_NUTS0) |>
  # full_join(COVID19.RKI_NUTS3) |>
  # full_join(COVID19.RKI_NUTS2) |>
  # full_join(COVID19.RKI_NUTS1) |>
  # full_join(COVID19.RKI_NUTS0) |>
  full_join(COVID19.NYC.ZCTA) |>
  full_join(COVID19.NYC.Borough) |>
  full_join(COVID19.NYC.Citywide) |>
  full_join(COVID19.CTP) |>
  full_join(COVID19.NYT) |>
  full_join(COVID19.JHU.Confirmed.US) |>
  full_join(COVID19.JHU.Deaths.US) |>
  full_join(COVID19.JHU.Confirmed.Global) |>
  full_join(COVID19.JHU.Deaths.Global) |>
  full_join(COVID19.JHU.Recovered.Global) |>
  full_join(COVID19.JHU.Active.Global) |>
  full_join(
    COVID19.JHUD |>
      filter(
        Level != "Country",
        Admin0 %!in% c(
          # COVID19.JHU.Confirmed.Global |>
          #   filter(Level != "Country") |>
          #   pull(Admin0) |>
          #   unique(),
          "Brazil", "Canada", "Germany", "Italy", "United States"
        ),
        Admin1 %!in% c("None")
      )
  ) |>
  full_join(COVID19.JRC.world) |>
  # full_join(COVID19.JRC.region) |>
  Unify_Everything() |>
  distinct(
    across(-Cases),
    .keep_all = TRUE
  ) |>
  {
    function(.) {
      . |>
        full_join(
          . |>
            as_tibble() |>
            filter(
              Level %in% c(
                "County",
                "Island",
                "Municipality"
              ),
              Admin0 == "United States"
            ) |>
            Aggregate_Admin(
              Admin = 1L,
              Country = NULL,
              State = NULL,
              na.rm = FALSE
            ) |>
            mutate(
              Level = "State"
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
              Level %in% c(
                "NUTS1",
                "Province",
                "State"
              )
            ) |>
            Aggregate_Admin(
              Admin = 0L,
              Country = NULL,
              State = NULL,
              na.rm = FALSE
            ) |>
            mutate(
              Level = "Country"
            )
        )
    }
  }() |>
  Unify_Everything() |>
  distinct(
    across(-Cases),
    .keep_all = TRUE
  ) |>
  mutate(
    ISO1_3N = case_when(
      # XAD | XAX = Akrotiri and Dhekelia
      # XCA | XCX = Caspian Sea
      # KOS | XKO | XKX = Kosovo
      Admin0 == "Akrotiri and Dhekelia" ~ "997",
      Admin0 == "Caspian Sea" ~ "998",
      Admin0 == "Cruise Ship" ~ "999",
      Admin0 == "Kosovo" ~ "926",
      TRUE ~ countrycode(
        Admin0 |>
          na_if("Olympics") |>
          na_if("Summer Olympics 2020") |>
          na_if("Winter Olympics 2022") |>
          na_if("Akrotiri and Dhekelia") |>
          na_if("Caspian Sea") |>
          na_if("Cruise Ship") |>
          na_if("Kosovo"),
        origin = "country.name",
        destination = "iso3n"
      ) |>
        str_pad(
          width = 3,
          pad = "0"
        )
    ),
    ISO1_3C = case_when(
      # XAD | XAX = Akrotiri and Dhekelia
      # XCA | XCX = Caspian Sea
      # KOS | XKO | XKX = Kosovo
      Admin0 == "Akrotiri and Dhekelia" ~ "XAX",
      Admin0 == "Caspian Sea" ~ "XCX",
      Admin0 == "Cruise Ship" ~ "XXX",
      Admin0 == "Kosovo" ~ "XKX",
      TRUE ~ countrycode(
        Admin0 |>
          na_if("Olympics") |>
          na_if("Summer Olympics 2020") |>
          na_if("Winter Olympics 2022") |>
          na_if("Akrotiri and Dhekelia") |>
          na_if("Caspian Sea") |>
          na_if("Cruise Ship") |>
          na_if("Kosovo"),
        origin = "country.name",
        destination = "iso3c"
      ) |>
        str_pad(
          width = 3,
          pad = "0"
        )
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
        Admin0 |>
          na_if("Olympics") |>
          na_if("Summer Olympics 2020") |>
          na_if("Winter Olympics 2022") |>
          na_if("Akrotiri and Dhekelia") |>
          na_if("Caspian Sea") |>
          na_if("Cruise Ship") |>
          na_if("Kosovo"),
        origin = "country.name",
        destination = "iso2c"
      ) |>
        str_pad(
          width = 2,
          pad = "0"
        )
    )
  ) |>
  mutate(
    ISO2_Name = case_when(
      is.na(Admin1) & is.na(Admin2) & is.na(Admin3) ~ Admin0,
      Admin0 == "Italy" & !is.na(Admin1) & !is.na(Admin2) ~ Admin2,
      Admin0 == "Italy" & !is.na(Admin1) & is.na(Admin2) ~ Admin1,
      TRUE ~ Admin1
    )
  ) |>
  left_join(ISO2_Unified) |>
  mutate(
    ISO2 = case_when(
      (is.na(ISO2) | Level == "Country") &
        ISO2_Name == Admin0 ~ ISO1_2C,
      is.na(ISO2_UID) & ISO2_Name == "Repatriated Travellers" ~ "ZT",
      is.na(ISO2) & ISO2_Name == "Port Quarantine" ~ "YY",
      is.na(ISO2) & ISO2_Name == "Unassigned" ~ "ZZ",
      Level == "Cruise Ship" ~ case_when(
        is.na(Admin1) ~ ISO1_2C,
        Admin1 == "Diamond Princess" ~ "99",
        Admin1 == "Grand Princess" ~ "98",
        Admin1 == "MS Zaandam" ~ "97",
        TRUE ~ "XX"
      ),
      TRUE ~ ISO2
    ),
    ISO2_UID = case_when(
      (is.na(ISO2_UID) | Level == "Country") &
        ISO2_Name == Admin0 ~ ISO1_2C,
      is.na(ISO2_UID) &
        ISO2_Name == "Repatriated Travellers" ~ ISO1_2C |>
        str_c("ZT", sep = "-"),
      is.na(ISO2_UID) &
        ISO2_Name == "Port Quarantine" ~ ISO1_2C |>
        str_c("YY", sep = "-"),
      is.na(ISO2_UID) &
        ISO2_Name == "Unassigned" ~ ISO1_2C |>
        str_c("ZZ", sep = "-"),
      Level == "Cruise Ship" ~ case_when(
        is.na(Admin1) ~ ISO1_2C,
        Admin1 == "Diamond Princess" ~ ISO1_2C |>
          str_c("99", sep = "-"),
        Admin1 == "Grand Princess" ~ ISO1_2C |>
          str_c("98", sep = "-"),
        Admin1 == "MS Zaandam" ~ ISO1_2C |>
          str_c("97", sep = "-"),
        TRUE ~ ISO1_2C |>
          str_c("XX", sep = "-")
      ),
      TRUE ~ ISO2_UID
    )
  ) |>
  left_join(
    NUTS_Unified |>
      rename(
        Population2 = Population
      )
  ) |>
  mutate(
    NUTS = case_when(
      is.na(NUTS) & (
        Level == "NUTS0" | Level == "Country"
      ) ~ ISO1_2C,
      TRUE ~ NUTS
    ),
    Population = Population |>
      coalesce(Population2)
  ) |>
  select(-Population2) |>
  mutate(
    ID = case_when(
      Admin0 |>
        str_detect(
          pattern = "Olympics"
        ) ~ "OLYMPICS",
      is.na(FIPS) &
        !is.na(NUTS) ~ NUTS,
      is.na(FIPS) &
        is.na(NUTS) &
        Level == "Country" ~ ISO1_2C,
      is.na(FIPS) &
        is.na(NUTS) &
        !is.na(ISO2) &
        Level %in% c(
          "Cruise Ship",
          "Province",
          "Territory"
        ) ~ ISO1_2C |>
        str_c(ISO2),
      is.na(FIPS) &
        is.na(NUTS) &
        !is.na(ISO2) &
        Level %in% c("State") &
        Admin0 %in% c("Brazil") ~ ISO1_2C |>
        str_c(ISO2),
      is.na(FIPS) &
        is.na(NUTS) &
        !is.na(IBGE) ~ ISO1_2C |>
        str_c(ISO2, IBGE),
      !is.na(FIPS) &
        is.na(NUTS) &
        Level %in% c(
          "Cruise Ship",
          "Territory"
        ) ~ ISO1_2C |>
        str_c(FIPS),
      !is.na(FIPS) &
        is.na(NUTS) &
        Level %in% c(
          "District",
          "County",
          "Island",
          "Jurisdiction",
          "Municipality",
          "State"
        ) ~ ISO1_2C |>
        str_c(FIPS),
      !is.na(FIPS) &
        is.na(NUTS) &
        Level %in% c(
          "ZCTA",
          "Borough"
        ) ~ ISO1_2C |>
        str_c(FIPS, ZCTA),
      TRUE ~ NA_character_
    ),
    Admin = case_when(
      !is.na(Admin3) ~ 3L,
      !is.na(Admin2) ~ 2L,
      !is.na(Admin1) ~ 1L,
      TRUE ~ 0L,
    ),
    NameID = str_c(
      Admin3 |>
        str_replace_na(
          replacement = "TMPSTRING"
        ),
      Admin2 |>
        str_replace_na(
          replacement = "TMPSTRING"
        ),
      Admin1 |>
        str_replace_na(
          replacement = "TMPSTRING"
        ),
      Admin0 |>
        str_replace_na(
          replacement = "TMPSTRING"
        ),
      sep = ", "
    ) |>
      str_replace(
        pattern = "TMPSTRING, ",
        replacement = ""
      ) |>
      str_replace(
        pattern = "TMPSTRING, ",
        replacement = ""
      ) |>
      str_replace(
        pattern = "TMPSTRING, ",
        replacement = ""
      ) |>
      str_replace(
        pattern = "TMPSTRING, ",
        replacement = ""
      )
  ) |>
  full_join(
    COVID19.UVA
  ) |>
  full_join(
    COVID19.IHME
  ) |>
  full_join(
    COVID19.RKI
  ) |>
  group_by(
    Type, Age, Sex, Source, Level, NameID
  ) |>
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
    Type, Age, Sex, Source, Level,
    ID, Longitude, Latitude, Population,
    contains("ISO"), FIPS, NUTS, matches("AGS|IBGE|ZIP|ZCTA"),
    Admin, Admin3, Admin2, Admin1, Admin0, NameID
  ) |>
  mutate(
    across(
      c(Type, Age, Sex, Source, Level),
      as.factor
    )
  ) |>
  arrange(
    ID, Date, Type, Age, Sex, Source, Level, Admin
  )

#-------------------------------------------------------------------------------

rm(
  list = ls(
    pattern = str_c(
      "COVID19.BR",
      "COVID19.DPC",
      "COVID19.RKI",
      "COVID19.NYC",
      "COVID19.CTP",
      "COVID19.NYT",
      "COVID19.JHU",
      "COVID19.JRC",
      sep = "|"
    )
  )
)

#-------------------------------------------------------------------------------

COVID19.LUT <- COVID19 |>
  select(
    -any_of(
      c(
        "Date", "nDate",
        "Year", "Month", "Week", "Day",
        "DayW", "DoW", "EpiW", "EpiW_End"
      )
    )
  ) |>
  select(
    -contains("Cases"), -contains("GR")
  ) |>
  distinct(
    ID, NameID, Admin, Admin0, Admin1, Admin2, Admin3, Level,
    ISO1_3N, ISO1_3C, ISO1_2C, ISO2, ISO2_UID,
    FIPS, NUTS, AGS, IBGE, ZCTA,
    .keep_all = TRUE
  ) |>
  mutate(
    Longitude = Longitude |>
      round(2) |>
      format(nsmall = 2, trim = TRUE) |>
      na_if("NA"),
    Latitude = Latitude |>
      round(2) |>
      format(nsmall = 2, trim = TRUE) |>
      na_if("NA")
  ) |>
  select(
    ID, Level,
    ISO1_3N, ISO1_3C, ISO1_2C, ISO2, ISO2_UID,
    FIPS, NUTS, AGS, IBGE, ZCTA,
    Longitude, Latitude, Population,
    Admin, Admin0, Admin1, Admin2, Admin3, NameID
  )

#-------------------------------------------------------------------------------

COVID19.LUT |>
  write_delim(
    file = "COVID-19_LUT_Full.csv",
    delim = ",",
    eol = "\n",
    na = "",
    escape = "double",
    num_threads = 1L,
    append = FALSE,
    col_names = TRUE,
    progress = FALSE
  )

#-------------------------------------------------------------------------------

COVID19.LUT |>
  # Remove missing IDs
  filter(
    !is.na(ID)
  ) |>
  write_delim(
    file = "COVID-19_LUT.csv",
    delim = ",",
    eol = "\n",
    na = "",
    escape = "double",
    num_threads = 1L,
    append = FALSE,
    col_names = TRUE,
    progress = FALSE
  )

#-------------------------------------------------------------------------------

COVID19 |>
  saveRDS(
    file = "COVID-19_Data.rds",
    compress = "xz",
    ascii = FALSE,
    version = NULL,
    refhook = NULL
  )

#-------------------------------------------------------------------------------

COVID19 |>
  write_fst(
    path = "COVID-19_Data.fst",
    compress = 100,
    uniform_encoding = TRUE
  )

#-------------------------------------------------------------------------------

COVID19 |>
  # Remove missing IDs
  filter(
    !is.na(ID)
  ) |>
  select(
    ID, Date, Cases, Cases_New, Type, matches("Age|Sex|Source")
  ) |>
  saveRDS(
    file = "COVID-19.rds",
    compress = "xz",
    ascii = FALSE,
    version = NULL,
    refhook = NULL
  )

#-------------------------------------------------------------------------------

COVID19 |>
  # Remove missing IDs
  filter(
    !is.na(ID)
  ) |>
  select(
    ID, Date, Cases, Cases_New, Type, matches("Age|Sex|Source")
  ) |>
  write_fst(
    path = "COVID-19.fst",
    compress = 100,
    uniform_encoding = TRUE
  )

#-------------------------------------------------------------------------------

COVID19 |>
  # Remove missing IDs
  filter(
    !is.na(ID)
  ) |>
  select(
    ID, Date, Cases, Cases_New, Type, Age, Sex, Source
  ) |>
  write_delim(
    file = "COVID-19.csv.xz",
    delim = ",",
    eol = "\n",
    na = "",
    escape = "double",
    num_threads = 1L,
    append = FALSE,
    col_names = TRUE,
    progress = FALSE
  )

#-------------------------------------------------------------------------------

# COVID19 |>
#   # Remove missing IDs
#   filter(
#     !is.na(ID)
#   ) |>
#   select(
#     ID, Date, Cases, Cases_New, Type, Age, Sex, Source
#   ) |>
#   write_feather(
#     sink = "COVID-19.feather",
#     version = 2,
#     chunk_size = 65536L,
#     compression = "zstd",
#     compression_level = 22
#   )

################################################################################
################################################################################
################################################################################

Sys.time() - tstart

################################################################################
