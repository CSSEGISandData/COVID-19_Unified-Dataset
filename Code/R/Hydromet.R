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

################################################################################################################

# # Join COVID-19 LVL data to the country map data
# COVID19.Map <- joinCountryData2Map(
#   COVID19.LVL |>
#     mutate(
#       Level = case_when(
#         LVL == 0 ~ "Admin 0",
#         LVL == 1 ~ "Admin 1",
#         LVL >= 2 ~ "Admin 2-3",
#         TRUE ~ NA_character_
#       )
#     ),
#   joinCode = "ISO3",
#   nameJoinColumn = "ISO1_3C",
#   mapResolution = "coarse" # one of :coarse low less islands li high
# )
#
# svg("COVID-19_Coverage.svg", width = 18, height = 9.4)
# COVID19.MapData <- mapCountryData(
#   COVID19.Map,
#   nameColumnToPlot = "Level",
#   catMethod = "categorical",
#   mapTitle = " ",
#   addLegend = FALSE,
#   missingCountryCol = gray(.8),
#   colourPalette = c("#E41A1C", "#377EB8", "#4DAF4A") # c("darkred", "darkblue", "darkgreen")
# )
#
# do.call(
#   addMapLegendBoxes,
#   c(
#     COVID19.MapData,
#     x = 'bottom',
#     xjust = 0,
#     yjust = 10,
#     title = "The Finest Administrative Level",
#     cex = 1.5,
#     horiz = TRUE
#   )
# )
# dev.off()

################################################################################

NLDAS.files <- list.files(
  path = NLDAS_PATH,
  pattern = "*.*.csv$",
  full.names = TRUE,
  recursive = TRUE
)

ERA5_FIPS.files <- list.files(
  path = ERA5_FIPS_PATH,
  pattern = "*.*.csv$",
  full.names = TRUE,
  recursive = TRUE
)

ERA5_NUTS.files <- list.files(
  path = ERA5_NUTS_PATH,
  pattern = "*.*.csv$",
  full.names = TRUE,
  recursive = TRUE
)

AllFiles <- c(
  NLDAS.files,
  ERA5_FIPS.files,
  ERA5_NUTS.files
) |>
  str_subset(
    pattern = "/2020/|/2021/|/2022/|/2023/",
    negate = FALSE
  )

#-------------------------------------------------------------------------------

AllVars <- c(
  ## NLDAS
  "APCP",
  "DLWRF",
  "DSWRF",
  "LHTFL",
  "MSTAV",
  "PEVPR",
  "PRES",
  "RH",
  "RZSM",
  "SOILM",
  "SPFH",
  "TMP",
  "TMPmax",
  "TMPmin",
  "UGRD",
  "VGRD",
  ## ERA5
  "d2m",
  "pev",
  "slhf",
  "sp",
  "ssrd",
  "swvl1",
  "swvl2",
  "swvl3",
  "swvl4",
  "t2mavg",
  "t2mmax",
  "t2mmin",
  "tp",
  "u10",
  "v10"
)

#-------------------------------------------------------------------------------

VarNames <- AllFiles |>
  basename() |>
  str_remove_all(
    pattern = "_NLDAS2_"
  ) |>
  str_remove_all(
    pattern = "_NLDAS2_US"
  ) |>
  str_remove_all(
    pattern = "_NLDAS2_STATES_US"
  ) |>
  str_remove_all(
    pattern = "_COUNTIES_US"
  ) |>
  str_remove_all(
    pattern = "_STATES_US"
  ) |>
  str_remove_all(
    pattern = "ERA5_US_FIPS"
  ) |>
  str_remove_all(
    pattern = "ERA5_US_STATE"
  ) |>
  str_remove_all(
    pattern = "ERA5_CIESIN_national"
  ) |>
  str_remove_all(
    pattern = "ERA5_CIESIN_national"
  ) |>
  str_remove_all(
    pattern = "ERA5_SAm"
  ) |>
  str_remove_all(
    pattern = "ERA5_Admin1_SAm_"
  ) |>
  str_remove_all(
    pattern = "notpopwtd"
  ) |>
  str_remove_all(
    pattern = "popwtd"
  ) |>
  str_remove_all(
    pattern = "CIESIN"
  ) |>
  str_remove_all(
    pattern = "GADM"
  ) |>
  str_remove_all(
    pattern = "ERA5_SAm_UVA"
  ) |>
  str_remove_all(
    pattern = "[0-9]{4}.csv"
  ) |>
  str_remove_all(
    pattern = "ERA5_IBGE[0-4]{1}"
  ) |>
  str_remove_all(
    pattern = "ERA5_NUTS[0-3]{1}"
  ) |>
  str_remove_all(
    pattern = "[0-9]{8}_[0-9]{8}"
  ) |>
  str_remove_all(
    pattern = "[0-9]{4}"
  ) |>
  str_remove_all(
    pattern = "_"
  ) |>
  str_remove_all(
    pattern = ".csv"
  )

setdiff(VarNames, AllVars)
setdiff(AllVars, VarNames)

#-------------------------------------------------------------------------------

dataSources <- case_when(
  (
    AllFiles |>
      str_detect(
        pattern = "ERA5"
      ) |>
      coalesce(FALSE)
  ) &
    (
      AllFiles |>
        str_detect(
          pattern = "/popwtd/"
        ) |>
        coalesce(FALSE)
    ) ~ "ERA5_CIESIN",
  (
    AllFiles |>
      str_detect(
        pattern = "NLDAS"
      ) |>
      coalesce(FALSE)
  ) &
    (
      AllFiles |>
        str_detect(
          pattern = "/popwtd/"
        ) |>
        coalesce(FALSE)
    ) ~ "NLDAS_CIESIN",
  TRUE ~ ClosestMatch2(
    AllFiles |>
      basename(),
    c("NLDAS", "ERA5")
  )
)

################################################################################

Unify_Hydromet.names <- function(varname) {
  varname.Unified <- varname |>
    recode(
      "APCP" = "P",
      "DLWRF" = "SRL",
      "DSWRF" = "SRS",
      "LHTFL" = "LHF",
      "MSTAV" = "MA",
      "PEVPR" = "PEF",
      "PRES" = "SP",
      "RH" = "RH",
      "RZSM" = "RZSM",
      "SOILM" = "SM",
      "SPFH" = "SH",
      "TMP" = "T",
      "TMPmax" = "Tmax",
      "TMPmin" = "Tmin",
      "UGRD" = "U",
      "VGRD" = "V",
      "d2m" = "Td",
      "pev" = "PE",
      "slhf" = "LH",
      "sp" = "SP",
      "ssrd" = "SR",
      "swvl1" = "SM1",
      "swvl2" = "SM2",
      "swvl3" = "SM3",
      "swvl4" = "SM4",
      "t2mavg" = "T",
      "t2mmax" = "Tmax",
      "t2mmin" = "Tmin",
      "tp" = "P",
      "u10" = "U",
      "v10" = "V"
    )

  return(varname.Unified)
}

################################################################################

Unify_Hydromet <- function(HydrometTBL) {
  HydrometTBL.Unified <- HydrometTBL |>
    {
      function(.) {
        if ("TMP" %in% names(.)) {
          . |>
            mutate(
              TMP = TMP - 273.15
            )
        } else if ("TMPmax" %in% names(.)) {
          . |>
            mutate(
              TMPmax = TMPmax - 273.15
            )
        } else if ("TMPmin" %in% names(.)) {
          . |>
            mutate(
              TMPmin = TMPmin - 273.15
            )
        } else if ("t2mavg" %in% names(.)) {
          . |>
            mutate(
              t2mavg = t2mavg - 273.15
            )
        } else if ("t2mmax" %in% names(.)) {
          . |>
            mutate(
              t2mmax = t2mmax - 273.15
            )
        } else if ("t2mmin" %in% names(.)) {
          . |>
            mutate(
              t2mmin = t2mmin - 273.15
            )
        } else if ("d2m" %in% names(.)) {
          . |>
            mutate(
              d2m = d2m - 273.15
            )
          # } else if ("DLWRF" %in% names(.)) {
          #   . |>
          #     mutate(
          #       DLWRF = DLWRF * 86400.
          #     )
          # } else if ("DSWRF" %in% names(.)) {
          #   . |>
          #     mutate(
          #       DSWRF = DSWRF * 86400.
          #     )
          # } else if ("LHTFL" %in% names(.)) {
          #   . |>
          #     mutate(
          #       LHTFL = LHTFL * 86400.
          #     )
          # } else if ("PEVPR" %in% names(.)) {
          #   # convert W/m2 to m by multiplying by sec/day and dividing by J/kg and mm/m
          #   . |>
          #     mutate(
          #       PEVPR = PEVPR * 86400. / 2450000000.
          #     )
          # } else if ("APCP" %in% names(.)) {
          #   . |>
          #     mutate(
          #       APCP = APCP * 1000.
          #     )
        } else if ("tp" %in% names(.)) {
          . |>
            mutate(
              tp = tp * 1000.
            )
        } else {
          .
        }
      }
    }() |>
    {
      function(.) {
        . |>
          setNames(
            . |>
              names() |>
              Unify_Hydromet.names()
          )
      }
    }()

  return(HydrometTBL.Unified)
}

#-------------------------------------------------------------------------------

Join_Hydromet <- function(Files) {
  Hydromet <- Files |>
    map(
      function(filename) {
        varname <- filename |>
          basename() |>
          str_remove_all(
            pattern = "_NLDAS2_"
          ) |>
          str_remove_all(
            pattern = "_NLDAS2_US"
          ) |>
          str_remove_all(
            pattern = "_NLDAS2_STATES_US"
          ) |>
          str_remove_all(
            pattern = "_COUNTIES_US"
          ) |>
          str_remove_all(
            pattern = "_STATES_US"
          ) |>
          str_remove_all(
            pattern = "ERA5_US_FIPS"
          ) |>
          str_remove_all(
            pattern = "ERA5_US_STATE"
          ) |>
          str_remove_all(
            pattern = "ERA5_CIESIN_national"
          ) |>
          str_remove_all(
            pattern = "ERA5_CIESIN_national"
          ) |>
          str_remove_all(
            pattern = "ERA5_SAm"
          ) |>
          str_remove_all(
            pattern = "ERA5_Admin1_SAm_"
          ) |>
          str_remove_all(
            pattern = "notpopwtd"
          ) |>
          str_remove_all(
            pattern = "popwtd"
          ) |>
          str_remove_all(
            pattern = "CIESIN"
          ) |>
          str_remove_all(
            pattern = "GADM"
          ) |>
          str_remove_all(
            pattern = "ERA5_SAm_UVA"
          ) |>
          str_remove_all(
            pattern = "[0-9]{4}.csv"
          ) |>
          str_remove_all(
            pattern = "ERA5_IBGE[0-4]{1}"
          ) |>
          str_remove_all(
            pattern = "ERA5_NUTS[0-3]{1}"
          ) |>
          str_remove_all(
            pattern = "[0-9]{8}_[0-9]{8}"
          ) |>
          str_remove_all(
            pattern = "[0-9]{4}"
          ) |>
          str_remove_all(
            pattern = "_"
          ) |>
          str_remove_all(
            pattern = ".csv"
          )

        dataSource <- case_when(
          (
            filename |>
              str_detect(
                pattern = "ERA5"
              ) |>
              coalesce(FALSE)
          ) &
            (
              filename |>
                str_detect(
                  pattern = "/popwtd/"
                ) |>
                coalesce(FALSE)
            ) ~ "ERA5_CIESIN",
          (
            filename |>
              str_detect(
                pattern = "NLDAS"
              ) |>
              coalesce(FALSE)
          ) &
            (
              filename |>
                str_detect(
                  pattern = "/popwtd/"
                ) |>
                coalesce(FALSE)
            ) ~ "NLDAS_CIESIN",
          TRUE ~ ClosestMatch2(
            filename |>
              basename(),
            c("NLDAS", "ERA5")
          )
        )

        if (varname %in% AllVars) {
          cat(
            dataSource,
            varname,
            filename,
            "\n"
          )

          Hydromet.var <- read_delim(
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
            modify_at_names(
              1,
              function(x) {
                x |>
                  str_remove(
                    pattern = "\\.\\.\\.1"
                  )
              }
            ) |>
            select(
              -matches("\\.\\.\\.")
            ) |>
            pivot_longer(
              cols = -matches("FIPS|STATE|GADM_0|IBGE|NUTS|id"),
              names_to = "Date",
              values_to = varname
            ) |>
            {
              function(.) {
                if ("FIPS" %in% names(.)) {
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
                } else if ("NUTS" %in% names(.)) {
                  . |>
                    mutate(
                      ID = NUTS
                    ) |>
                    select(-NUTS)
                } else {
                  . |>
                    mutate(
                      ID = case_when(
                        (
                          id |>
                            str_detect(
                              pattern = "^CL"
                            )
                        ) &
                          (
                            id |>
                              str_detect(
                                pattern = "0",
                                negate = TRUE
                              )
                          ) &
                          (
                            id |>
                              parse_number() |>
                              is_weakly_less_than(9L)
                          ) ~ id |>
                          sub(
                            pattern = "([0-9])",
                            replacement = "0\\1"
                          ),
                        TRUE ~ id
                      )
                    ) |>
                    select(-id)
                }
              }
            }() |>
            mutate(
              Date = Date |>
                as.Date(
                  format = "%Y-%m-%d"
                ),
              Source = dataSource
            ) |>
            Unify_Hydromet() |>
            select(
              ID, Date, Source, everything()
            ) |>
            relocate(
              Source,
              .after = last_col()
            ) |>
            drop_na()
        } else {
          Hydromet.var <- tibble(
            ID = character()
          )
        }

        return(Hydromet.var)
      }
    ) |>
    reduce(
      full_join
    ) |>
    arrange(
      ID, Date, Source
    ) |>
    relocate(
      Source,
      .after = last_col()
    )

  return(Hydromet)
}

################################################################################

# # SouthAmerica only, until it's merged into the unified COVID-19 dataset
# tablesDirs <- file.path(
#   ERA5_NUTS_PATH,
#   "SouthAmerica"
# )

#-------------------------------------------------------------------------------

# tablesDirs <- file.path(ERA5_NUTS_PATH, "NUTS0/CIESIN/notpopwtd/2020")
# Hydromet.Unified.notpopwtd <- Hydromet.Unified
#
# tablesDirs <- file.path(ERA5_NUTS_PATH, "NUTS0/CIESIN/popwtd/2020")
# Hydromet.Unified.popwtd <- Hydromet.Unified
#
# tablesDirs <- file.path(ERA5_NUTS_PATH, "NUTS0/GADM/2020")
# Hydromet.Unified.GADM <- Hydromet.Unified
#
# #-------------------------------------------------------------------------------
#
# Hydromet.IDs.notpopwtd <- Hydromet.Unified.notpopwtd |>
#   pull(ID) |>
#   unique()
#
# Hydromet.IDs.popwtd <- Hydromet.Unified.popwtd |>
#   pull(ID) |>
#   unique()
#
# Hydromet.IDs.GADM <- Hydromet.Unified.GADM |>
#   pull(ID) |>
#   unique()
#
# plot(Hydromet.Unified.notpopwtd$T, Hydromet.Unified.popwtd$T)
#
# Hydromet.Unified <- Hydromet.Unified.GADM |>
#   pivot_longer(
#     cols = -c(ID, Date, Source),
#     names_to = "Name",
#     values_to = "Value"
#   ) |>
#   mutate(Source = "GADM") |>
#   full_join(
#     Hydromet.Unified.notpopwtd |>
#       pivot_longer(
#         cols = -c(ID, Date, Source),
#         names_to = "Name",
#         values_to = "Value"
#       ) |>
#       mutate(Source = "CIESIN")
#   ) |>
#   full_join(
#     Hydromet.Unified.popwtd |>
#       pivot_longer(
#         cols = -c(ID, Date, Source),
#         names_to = "Name",
#         values_to = "Value"
#       ) |>
#       mutate(Source = "CIESIN.popwtd")
#   ) |>
#   drop_na(Value) |>
#   pivot_wider(
#     names_from = Source,
#     values_from = Value
#   )
#
# #-------------------------------------------------------------------------------
#
# Hydromet.Unified <- Hydromet |>
#   filter(HydrometSource != "NLDAS") |>
#   left_join(
#     COVID19.LUT |>
#       select(ID, Level)
#   ) |>
#   filter(Level == "Country") |>
#   select(-Level) |>
#   pivot_longer(
#     cols = -c(ID, Date, HydrometSource),
#     names_to = "Name",
#     values_to = "Value"
#   ) |>
#   drop_na(Value) |>
#   pivot_wider(
#     names_from = HydrometSource,
#     values_from = Value
#   )
#
# #-------------------------------------------------------------------------------
#
# ggplot(
#   Hydromet.Unified |>
#     filter(ID == "BR"),
#   aes(x = ERA5)
# ) +
#   geom_point(aes(y = ERA5_CIESIN), linewidth = 0.5, color = "blue") +
#   geom_abline(slope = 1, intercept = 0, linetype = "dashed", color = "red") +
#   # guides(color = "none") +
#   facet_wrap(~Name, scales = "free", ncol = 6) +
#   theme_custom(
#     theme_color = "white",
#     legend.position = "bottom",
#     legend.direction = "horizontal",
#     base_family = "",
#     base_size = 15,
#     axis.text.angle = c(0, 90),
#     blank_axes = FALSE,
#     blank_axisLabels = FALSE
#   )
#
# #-------------------------------------------------------------------------------
#
# ggplot(
#   Hydromet.Unified |>
#     filter(ID == "US"),
#   aes(x = CIESIN, y = GADM)
# ) +
#   geom_point(size = 0.5) +
#   geom_abline(slope = 1, intercept = 0, linetype = "dashed") +
#   # xlab("CIESIN") +
#   # ylab("GADM") +
#   # guides(color = "none") +
#   facet_wrap(~Name, scales = "free", ncol = 6) +
#   theme_custom(
#     theme_color = "white",
#     legend.position = "bottom",
#     legend.direction = "horizontal",
#     base_family = "",
#     base_size = 15,
#     axis.text.angle = c(0, 90),
#     blank_axes = FALSE,
#     blank_axisLabels = FALSE
#   )
#
# ggplot(
#   Hydromet.Unified,
#   aes(x = CIESIN, y = CIESIN.popwtd)
# ) +
#   geom_point(size = 0.5) +
#   # xlab("CIESIN") +
#   # ylab("CIESIN.popwtd") +
#   # guides(color = "none") +
#   facet_wrap(~Name, scales = "free", ncol = 6) +
#   theme_custom(
#     theme_color = "white",
#     legend.position = "bottom",
#     legend.direction = "horizontal",
#     base_family = "",
#     base_size = 15,
#     axis.text.angle = c(0, 90),
#     blank_axes = FALSE,
#     blank_axisLabels = FALSE
#
#   )
#
################################################################################

tablesDirs <- AllFiles |>
  dirname() |>
  unique() |>
  setdiff(
    c(
      ERA5_NUTS_PATH,
      file.path(
        ERA5_NUTS_PATH,
        "NUTS0",
        "GADM",
        "2020"
      ),
      # file.path(
      #   ERA5_NUTS_PATH,
      #   "NUTS0",
      #   "CIESIN",
      #   "notpopwtd",
      #   "2020"
      # ),
      # file.path(
      #   ERA5_NUTS_PATH,
      #   "NUTS0",
      #   "CIESIN",
      #   "popwtd",
      #   "2020"
      # ),
      file.path(
        ERA5_NUTS_PATH,
        "SouthAmerica"
      )
    )
  )

################################################################################

Hydromet <- tablesDirs |>
  map(
    function(tablesDir) {
      cat(tablesDir, "\n", "\n")

      tablesFiles <- list.files(
        path = tablesDir,
        pattern = "*.*.csv$",
        full.names = TRUE,
        recursive = TRUE
      )

      Hydromet.dir <- Join_Hydromet(tablesFiles) |>
        {
          function(.) {
            if (tablesDir |>
              str_detect(
                pattern = "NUTS0"
              ) |>
              coalesce(FALSE)) {
              . |>
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
              .
            }
          }
        }()

      return(Hydromet.dir)
    }
  ) |>
  reduce(
    full_join
  ) |>
  arrange(
    ID, Date, Source
  ) |>
  relocate(
    Source,
    .after = last_col()
  )

#-------------------------------------------------------------------------------

Hydromet.Unified <- Hydromet |>
  filter(
    !is.na(ID)
  ) |>
  filter(
    ID %in% COVID19.IDs
  ) |>
  add_column(
    AllVars |>
      Unify_Hydromet.names() |>
      setdiff(
        names(Hydromet)
      ) |>
      map_dfc(setNames, object = list(NA_real_))
  ) |>
  mutate(
    es = 6.112 * exp((17.67 * T) / (T + 243.5)),
    e = case_when(
      Source |>
        str_detect(
          pattern = "NLDAS"
        ) ~ es * (RH / 100.0),
      TRUE ~ 6.112 * exp((17.67 * Td) / (Td + 243.5))
    ),
    Td = case_when(
      Source |>
        str_detect(
          pattern = "NLDAS"
        ) ~ log(e / 6.112) * 243.5 / (17.67 - log(e / 6.112)),
      TRUE ~ Td
    ),
    Tdd = T - Td,
    RH = case_when(
      Source |>
        str_detect(
          pattern = "NLDAS"
        ) ~ RH,
      TRUE ~ 100.0 * (e / es)
    ),
    SH = case_when(
      Source |>
        str_detect(
          pattern = "NLDAS"
        ) ~ SH,
      TRUE ~ 100.0 * (0.622 * e) / (SP - (0.378 * e))
    )
    # RH = 100.0 * (e / es),
    # SH = (0.622 * e) / (SP - (0.378 * e))
  ) |>
  distinct(
    ID, Date, Source,
    .keep_all = TRUE
  ) |>
  arrange(
    ID, Date, Source
  ) |>
  select(
    ID, Date,
    T, Tmax, Tmin,
    Td, Tdd, RH, SH,
    MA, RZSM, SM, SM1, SM2, SM3, SM4,
    SP, SR, SRL, SRS,
    LH, LHF, PE, PEF, P,
    U, V,
    Source
  )

#-------------------------------------------------------------------------------

Hydromet.IDs <- Hydromet.Unified |>
  pull(ID) |>
  unique()

#-------------------------------------------------------------------------------

Hydromet <- Hydromet.Unified |>
  rename(
    HydrometSource = Source
  ) |>
  mutate(
    across(
      c(HydrometSource),
      as.factor
    )
  ) |>
  remove_empty(
    c("rows", "cols")
  )

Hydromet |>
  saveRDS(
    file = "Hydromet.rds",
    compress = "xz",
    ascii = FALSE,
    version = NULL,
    refhook = NULL
  )

Hydromet |>
  write_fst(
    path = "Hydromet.fst",
    compress = 100,
    uniform_encoding = TRUE
  )

################################################################################

Hydromet_YYYYMM <- Hydromet |>
  mutate(
    YYYYMM = Date |>
      format("%Y%m")
  ) |>
  group_by(YYYYMM) |>
  group_split(
    .keep = FALSE
  ) |>
  setNames(
    str_c(
      "Hydromet",
      Hydromet |>
        mutate(
          YYYYMM = Date |>
            format("%Y%m")
        ) |>
        distinct(YYYYMM) |>
        pull(YYYYMM),
      sep = "_"
    )
  )

Hydromet_YYYYMM |>
  list2env(
    envir = .GlobalEnv
  )

Hydromet_YYYYMM |>
  names() |>
  walk(
    ~
      saveRDS(
        object = get(.),
        file = str_c(., ".rds"),
        compress = "xz",
        ascii = FALSE,
        version = NULL,
        refhook = NULL
      )
  )

Hydromet_YYYYMM |>
  names() |>
  walk(
    ~
      write_fst(
        x = get(.),
        path = str_c(., ".fst"),
        compress = 100,
        uniform_encoding = TRUE
      )
  )

################################################################################

setdiff(Hydromet.IDs, COVID19.IDs)
setdiff(COVID19.IDs, Hydromet.IDs)

#-------------------------------------------------------------------------------

Hydromet.missing <- COVID19.LUT |>
  filter(
    ID %in%
      COVID19.IDs |>
      setdiff(Hydromet.IDs)
  ) |>
  filter(
    Level %!in% c(
      "Borough",
      "Cruise Ship",
      "Jurisdiction"
    ),
    Admin1 %!in% "Unassigned",
    Admin2 %!in% "Unassigned",
    Admin3 %!in% "Unassigned"
  ) |>
  arrange(Level)

#-------------------------------------------------------------------------------

Hydromet.missing |>
  write_delim(
    file = "Hydromet_missing.csv",
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
