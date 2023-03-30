#!/usr/bin/env Rscript
################################################################################
# Copyright 2020-2023 Hamada S. Badr <badr@jhu.edu>
################################################################################

tstart <- Sys.time()

################################################################################

library <- function(...) {
  suppressWarnings(
    suppressMessages(
      suppressPackageStartupMessages(
        base::library(
          ...,
          warn.conflicts = FALSE,
          quietly = TRUE,
          verbose = FALSE
        )
      )
    )
  )
}

################################################################################

conflictRules(
  "additive",
  mask.ok = list(
    base = TRUE,
    stats = TRUE,
    utils = TRUE
  ),
  exclude = NULL
)

conflictRules(
  "bayesian",
  mask.ok = list(
    base = TRUE,
    stats = TRUE,
    utils = TRUE
  ),
  exclude = NULL
)

conflictRules(
  "brms",
  mask.ok = list(
    base = TRUE,
    stats = TRUE,
    utils = TRUE
  ),
  exclude = c(
    "s",
    "t2"
  )
)

conflictRules(
  "broom",
  mask.ok = list(
    base = TRUE,
    stats = TRUE,
    utils = TRUE
  ),
  exclude = NULL
)

conflictRules(
  "cli",
  mask.ok = list(
    base = TRUE,
    stats = TRUE,
    utils = TRUE
  ),
  exclude = NULL
)

conflictRules(
  "cpp11",
  mask.ok = list(
    base = TRUE,
    stats = TRUE,
    utils = TRUE
  ),
  exclude = NULL
)

conflictRules(
  "dials",
  mask.ok = list(
    base = TRUE,
    stats = TRUE,
    utils = TRUE
  ),
  exclude = NULL
)

conflictRules(
  "dplyr",
  mask.ok = list(
    base = TRUE,
    stats = TRUE,
    utils = TRUE
  ),
  exclude = NULL
)

conflictRules(
  "ellipsis",
  mask.ok = list(
    base = TRUE,
    stats = TRUE,
    utils = TRUE
  ),
  exclude = NULL
)

conflictRules(
  "future",
  mask.ok = list(
    base = TRUE,
    stats = TRUE,
    utils = TRUE
  ),
  exclude = NULL
)

conflictRules(
  "GGally",
  mask.ok = list(
    base = TRUE,
    stats = TRUE,
    utils = TRUE
  ),
  exclude = NULL
)

conflictRules(
  "ggplot2",
  mask.ok = list(
    base = TRUE,
    stats = TRUE,
    utils = TRUE
  ),
  exclude = NULL
)

conflictRules(
  "glue",
  mask.ok = list(
    base = TRUE,
    stats = TRUE,
    utils = TRUE
  ),
  exclude = NULL
)

conflictRules(
  "hardhat",
  mask.ok = list(
    base = TRUE,
    stats = TRUE,
    utils = TRUE
  ),
  exclude = NULL
)

conflictRules(
  "incidence",
  mask.ok = NULL,
  exclude = c(
    "fit"
  )
)

conflictRules(
  "infer",
  mask.ok = list(
    base = TRUE,
    stats = TRUE,
    utils = TRUE
  ),
  exclude = NULL
)

conflictRules(
  "insight",
  mask.ok = list(
    base = TRUE,
    stats = TRUE,
    utils = TRUE
  ),
  exclude = NULL
)

conflictRules(
  "keras",
  mask.ok = list(
    base = TRUE,
    stats = TRUE,
    utils = TRUE
  ),
  exclude = NULL
)

conflictRules(
  "knitr",
  mask.ok = list(
    base = TRUE,
    stats = TRUE,
    utils = TRUE
  ),
  exclude = NULL
)

conflictRules(
  "loo",
  mask.ok = list(
    base = TRUE,
    stats = TRUE,
    utils = TRUE
  ),
  exclude = NULL
)

conflictRules(
  "luz",
  mask.ok = list(
    base = TRUE,
    stats = TRUE,
    utils = TRUE
  ),
  exclude = NULL
)

conflictRules(
  "lubridate",
  mask.ok = list(
    base = TRUE,
    stats = TRUE,
    utils = TRUE
  ),
  exclude = NULL
)

conflictRules(
  "magrittr",
  mask.ok = list(
    base = TRUE,
    stats = TRUE,
    utils = TRUE
  ),
  exclude = NULL
)

conflictRules(
  "Matrix",
  mask.ok = list(
    base = TRUE,
    stats = TRUE,
    utils = TRUE
  ),
  exclude = NULL
)

conflictRules(
  "mgcv",
  mask.ok = list(
    base = TRUE,
    brms = TRUE,
    stats = TRUE,
    utils = TRUE
  ),
  exclude = NULL
)

conflictRules(
  "mgcViz",
  mask.ok = list(
    base = TRUE,
    stats = TRUE,
    utils = TRUE
  ),
  exclude = NULL
)

conflictRules(
  "parsnip",
  mask.ok = list(
    base = TRUE,
    stats = TRUE,
    utils = TRUE
  ),
  exclude = NULL
)

conflictRules(
  "patchwork",
  mask.ok = list(
    base = TRUE,
    stats = TRUE,
    utils = TRUE
  ),
  exclude = NULL
)

conflictRules(
  "posterior",
  mask.ok = list(
    base = TRUE,
    stats = TRUE,
    utils = TRUE
  ),
  exclude = NULL
)

conflictRules(
  "probably",
  mask.ok = list(
    base = TRUE,
    stats = TRUE,
    utils = TRUE
  ),
  exclude = NULL
)

conflictRules(
  "projpred",
  mask.ok = list(
    base = TRUE,
    stats = TRUE,
    utils = TRUE
  ),
  exclude = NULL
)

conflictRules(
  "purrr",
  mask.ok = list(
    base = TRUE,
    stats = TRUE,
    utils = TRUE
  ),
  exclude = NULL
)

conflictRules(
  "Rcpp",
  mask.ok = list(
    base = TRUE,
    stats = TRUE,
    utils = TRUE
  ),
  exclude = NULL
)

conflictRules(
  "RcppEigen",
  mask.ok = list(
    base = TRUE,
    stats = TRUE,
    utils = TRUE
  ),
  exclude = NULL
)

conflictRules(
  "RcppParallel",
  mask.ok = list(
    base = TRUE,
    stats = TRUE,
    utils = TRUE
  ),
  exclude = NULL
)

conflictRules(
  "raster",
  mask.ok = list(
    base = TRUE,
    stats = TRUE,
    utils = TRUE
  ),
  exclude = NULL
)

conflictRules(
  "readr",
  mask.ok = list(
    base = TRUE,
    scales = TRUE,
    stats = TRUE,
    utils = TRUE,
    vroom = TRUE
  ),
  exclude = NULL
)

conflictRules(
  "recipes",
  mask.ok = list(
    base = TRUE,
    stats = TRUE,
    utils = TRUE
  ),
  exclude = NULL
)

conflictRules(
  "reshape2",
  mask.ok = list(
    base = TRUE,
    stats = TRUE,
    utils = TRUE
  ),
  exclude = NULL
)

conflictRules(
  "rlang",
  mask.ok = list(
    base = TRUE,
    stats = TRUE,
    utils = TRUE
  ),
  exclude = NULL
)

conflictRules(
  "rsample",
  mask.ok = list(
    base = TRUE,
    stats = TRUE,
    utils = TRUE
  ),
  exclude = NULL
)

conflictRules(
  "rstan",
  mask.ok = list(
    base = TRUE,
    stats = TRUE,
    utils = TRUE
  ),
  exclude = NULL
)

conflictRules(
  "scales",
  mask.ok = list(
    base = TRUE,
    stats = TRUE,
    utils = TRUE
  ),
  exclude = NULL
)

conflictRules(
  "terra",
  mask.ok = list(
    base = TRUE,
    stats = TRUE,
    utils = TRUE
  ),
  exclude = NULL
)

conflictRules(
  "themis",
  mask.ok = list(
    base = TRUE,
    stats = TRUE,
    utils = TRUE
  ),
  exclude = NULL
)

conflictRules(
  "tidyr",
  mask.ok = list(
    base = TRUE,
    stats = TRUE,
    utils = TRUE
  ),
  exclude = NULL
)

conflictRules(
  "torch",
  mask.ok = list(
    base = TRUE,
    stats = TRUE,
    utils = TRUE
  ),
  exclude = NULL
)

conflictRules(
  "tune",
  mask.ok = list(
    base = TRUE,
    stats = TRUE,
    utils = TRUE
  ),
  exclude = NULL
)

conflictRules(
  "vctrs",
  mask.ok = list(
    base = TRUE,
    stats = TRUE,
    utils = TRUE
  ),
  exclude = NULL
)

conflictRules(
  "vetiver",
  mask.ok = list(
    base = TRUE,
    stats = TRUE,
    utils = TRUE
  ),
  exclude = NULL
)

conflictRules(
  "vip",
  mask.ok = list(
    base = TRUE,
    stats = TRUE,
    utils = TRUE
  ),
  exclude = NULL
)

conflictRules(
  "waldo",
  mask.ok = list(
    base = TRUE,
    stats = TRUE,
    utils = TRUE
  ),
  exclude = NULL
)

conflictRules(
  "yardstick",
  mask.ok = list(
    base = TRUE,
    stats = TRUE,
    utils = TRUE
  ),
  exclude = NULL
)

################################################################################

library(conflicted)

conflict_prefer("score", "applicable")

conflict_prefer("Buffer", "arrow")

conflict_prefer("unwrap", "batchtools")

conflict_prefer("hdi", "bayestestR")

conflict_prefer("ar", "brms")
conflict_prefer("as_draws_matrix", "brms")
conflict_prefer("dirichlet", "brms")
conflict_prefer("do_call", "brms")
conflict_prefer("dstudent_t", "brms")
conflict_prefer("exponential", "brms")
conflict_prefer("get_y", "brms")
conflict_prefer("kidney", "brms")
conflict_prefer("lasso", "brms")
conflict_prefer("ma", "brms")
conflict_prefer("mixture", "brms")
conflict_prefer("pstudent_t", "brms")
conflict_prefer("qstudent_t", "brms")
conflict_prefer("rstudent_t", "brms")

conflict_prefer("bootstrap", "broom")

conflict_prefer("asInt", "checkmate")
conflict_prefer("check_class", "checkmate")

conflict_prefer("as_iterator", "coro")

conflict_prefer("focus", "corrr")
conflict_prefer("stretch", "corrr")

conflict_prefer("theme_map", "cowplot")

conflict_prefer("happiness_train", "DALEX")

conflict_prefer("yearmon", "data.table")
conflict_prefer("yearqtr", "data.table")

conflict_prefer("center", "datawizard")
conflict_prefer("skewness", "datawizard")
conflict_prefer("kurtosis", "datawizard")

conflict_prefer("finalize", "dials")
conflict_prefer("get_n", "dials")
conflict_prefer("max_rules", "dials")
conflict_prefer("momentum", "dials")
conflict_prefer("neighbors", "dials")
conflict_prefer("parameters", "dials")
conflict_prefer("penalty", "dials")

conflict_prefer("smoothness", "discrim")

conflict_prefer("between", "dplyr")
conflict_prefer("collapse", "dplyr")
conflict_prefer("collect", "dplyr")
conflict_prefer("dim_desc", "dplyr")
conflict_prefer("filter", "dplyr")
conflict_prefer("first", "dplyr")
conflict_prefer("group_rows", "dplyr")
conflict_prefer("ident", "dplyr")
conflict_prefer("if_any", "dplyr")
conflict_prefer("lag", "dplyr")
conflict_prefer("last", "dplyr")
conflict_prefer("rename", "dplyr")
conflict_prefer("select", "dplyr")
conflict_prefer("slice", "dplyr")
conflict_prefer("sql", "dplyr")

conflict_prefer("change_scale", "effectsize")

conflict_prefer("dictionary", "embed")

conflict_prefer("explain", "fastshap")
conflict_prefer("gen_friedman", "fastshap")

conflict_prefer("%->%", "future")
conflict_prefer("cluster", "future")
conflict_prefer("values", "future")

conflict_prefer("flea", "GGally")
conflict_prefer("pigs", "GGally")
conflict_prefer("wrap", "GGally")

conflict_prefer("animate", "gganimate")
conflict_prefer("View", "gganimate")

conflict_prefer("data_grid", "ggeffects")
conflict_prefer("get_title", "ggeffects")
conflict_prefer("install_latest", "ggeffects")
conflict_prefer("new_data", "ggeffects")

conflict_prefer("has_flipped_aes", "ggplot2")
conflict_prefer("Position", "ggplot2")

conflict_prefer("get_legend", "ggpubr")
conflict_prefer("get_palette", "ggpubr")
conflict_prefer("gghistogram", "ggpubr")
conflict_prefer("rotate", "ggpubr")

conflict_prefer("request_generate", "googledrive")
conflict_prefer("request_make", "googledrive")

conflict_prefer("add_residuals", "gratia")
conflict_prefer("draw", "gratia")
conflict_prefer("fitted_samples", "gratia")
conflict_prefer("posterior_samples", "gratia")
conflict_prefer("predicted_samples", "gratia")

conflict_prefer("as.path", "grid")

conflict_prefer("model_matrix", "hardhat")
conflict_prefer("standardize", "hardhat")

conflict_prefer("scale_x_comma", "hrbragg")
conflict_prefer("scale_x_percent", "hrbragg")
conflict_prefer("scale_y_comma", "hrbragg")
conflict_prefer("scale_y_percent", "hrbragg")

conflict_prefer("group_names", "incidence")

conflict_prefer("observe", "infer")
conflict_prefer("p_value", "infer")

conflict_prefer("data_match", "insight")
conflict_prefer("data_relocate", "insight")
conflict_prefer("data_restoretype", "insight")
conflict_prefer("download_model", "insight")
conflict_prefer("get_data", "insight")
conflict_prefer("get_random", "insight")
conflict_prefer("is_model", "insight")
conflict_prefer("model_info", "insight")
conflict_prefer("model_name", "insight")
conflict_prefer("n_unique", "insight")
conflict_prefer("reshape_ci", "insight")
conflict_prefer("supported_models", "insight")

conflict_prefer("chisq.test", "janitor")
conflict_prefer("clean_names", "janitor")
conflict_prefer("crosstab", "janitor")
conflict_prefer("fisher.test", "janitor")
conflict_prefer("remove_empty", "janitor")
conflict_prefer("remove_empty_rows", "janitor")

conflict_prefer("metric_accuracy", "keras")
conflict_prefer("metric_auc", "keras")
conflict_prefer("new_model_class", "keras")
conflict_prefer("normalize", "keras")

conflict_prefer("loo", "loo")
conflict_prefer("nlist", "loo")

conflict_prefer("as.difftime", "lubridate")
conflict_prefer("date", "lubridate")
conflict_prefer("duration", "lubridate")
conflict_prefer("hms", "lubridate")
conflict_prefer("hour", "lubridate")
conflict_prefer("interval", "lubridate")
conflict_prefer("isoweek", "lubridate")
conflict_prefer("mday", "lubridate")
conflict_prefer("minute", "lubridate")
conflict_prefer("month", "lubridate")
conflict_prefer("origin", "lubridate")
conflict_prefer("quarter", "lubridate")
conflict_prefer("second", "lubridate")
conflict_prefer("stamp", "lubridate")
conflict_prefer("wday", "lubridate")
conflict_prefer("week", "lubridate")
conflict_prefer("yday", "lubridate")
conflict_prefer("year", "lubridate")

conflict_prefer("evaluate", "luz")

conflict_prefer("predictions", "marginaleffects")

conflict_prefer("equals", "magrittr")
conflict_prefer("extract", "magrittr")
conflict_prefer("is_in", "magrittr")

conflict_prefer("chol", "Matrix")
conflict_prefer("chol2inv", "Matrix")
conflict_prefer("colMeans", "Matrix")
conflict_prefer("cov2cor", "Matrix")
conflict_prefer("crossprod", "Matrix")
conflict_prefer("determinant", "Matrix")
conflict_prefer("diag", "Matrix")
conflict_prefer("diag<-", "Matrix")
conflict_prefer("diff", "Matrix")
conflict_prefer("drop", "Matrix")
conflict_prefer("format", "Matrix")
conflict_prefer("isSymmetric", "Matrix")
conflict_prefer("norm", "Matrix")
conflict_prefer("qr", "Matrix")
conflict_prefer("qr.coef", "Matrix")
conflict_prefer("qr.fitted", "Matrix")
conflict_prefer("qr.Q", "Matrix")
conflict_prefer("qr.qty", "Matrix")
conflict_prefer("qr.qy", "Matrix")
conflict_prefer("qr.R", "Matrix")
conflict_prefer("qr.resid", "Matrix")
conflict_prefer("rcond", "Matrix")
conflict_prefer("rowMeans", "Matrix")
conflict_prefer("solve", "Matrix")
conflict_prefer("tcrossprod", "Matrix")
conflict_prefer("toeplitz", "Matrix")
conflict_prefer("unname", "Matrix")
conflict_prefer("which", "Matrix")
conflict_prefer("zapsmall", "Matrix")

conflict_prefer("s", "mgcv")
conflict_prefer("t2", "mgcv")

conflict_prefer("qqline", "mgcViz")
conflict_prefer("qqnorm", "mgcViz")
conflict_prefer("qqplot", "mgcViz")
conflict_prefer("zoom", "mgcViz")

conflict_prefer("extract_ranef", "mixedup")
conflict_prefer("extract_vc", "mixedup")

conflict_prefer("penguins", "modeldata")

conflict_prefer("typical", "modelr")

conflict_prefer("escape_latex", "modelsummary")
conflict_prefer("get_estimates", "modelsummary")
conflict_prefer("hush", "modelsummary")

conflict_prefer("partition", "multidplyr")

conflict_prefer("countries110", "rnaturalearth")

conflict_prefer("ACF", "nlme")
conflict_prefer("getData", "nlme")
conflict_prefer("getResponse", "nlme")

conflict_prefer("compare_models", "parameters")

conflict_prefer("bart", "parsnip")
conflict_prefer("fit", "parsnip")
conflict_prefer("get_fit", "parsnip")
conflict_prefer("null_model", "parsnip")
conflict_prefer("pls", "parsnip")
conflict_prefer("prepare_data", "parsnip")

conflict_prefer("align_plots", "patchwork")
conflict_prefer("area", "patchwork")

conflict_prefer("model_performance", "performance")
conflict_prefer("mse", "performance")

conflict_prefer("se", "plotfunctions")

conflict_prefer("forward", "plumber")

conflict_prefer("mad", "posterior")
conflict_prefer("sd", "posterior")
conflict_prefer("var", "posterior")
conflict_prefer("rhat", "posterior")

conflict_prefer("as.factor", "probably")
conflict_prefer("as.ordered", "probably")
conflict_prefer("as_class_pred", "probably")

conflict_prefer("project", "projpred")

conflict_prefer("accumulate", "purrr")
conflict_prefer("cross", "purrr")
conflict_prefer("discard", "purrr")
conflict_prefer("map", "purrr")
conflict_prefer("partial", "purrr")
conflict_prefer("prepend", "purrr")
conflict_prefer("transpose", "purrr")
conflict_prefer("update_list", "purrr")
conflict_prefer("when", "purrr")

conflict_prefer("attach", "R.oo")
conflict_prefer("clone", "R.oo")
conflict_prefer("detach", "R.oo")
conflict_prefer("getClasses", "R.oo")
conflict_prefer("extend", "R.oo")
conflict_prefer("getDescription", "R.oo")
conflict_prefer("getMethods", "R.oo")
conflict_prefer("printStackTrace", "R.oo")
conflict_prefer("save", "R.oo")
conflict_prefer("trim", "R.oo")

conflict_prefer("cat", "R.utils")
conflict_prefer("cleanup", "R.utils")
conflict_prefer("commandArgs", "R.utils")
conflict_prefer("getOption", "R.utils")
conflict_prefer("inherits", "R.utils")
conflict_prefer("isOpen", "R.utils")
conflict_prefer("nullfile", "R.utils")
conflict_prefer("parse", "R.utils")
conflict_prefer("resample", "R.utils")
conflict_prefer("reset", "R.utils")
conflict_prefer("setProgress", "R.utils")
conflict_prefer("validate", "R.utils")
conflict_prefer("timestamp", "R.utils")
conflict_prefer("warnings", "R.utils")

conflict_prefer("LdFlags", "Rcpp")
conflict_prefer("prompt", "Rcpp")

conflict_prefer("fastLmPure", "RcppEigen")

conflict_prefer("bind", "raster")
conflict_prefer("colSums", "raster")
conflict_prefer("cut", "raster")
conflict_prefer("hdr", "raster")
conflict_prefer("labels", "raster")
conflict_prefer("match", "raster")
conflict_prefer("print", "raster")
conflict_prefer("rowSums", "raster")
conflict_prefer("stack", "raster")
conflict_prefer("unstack", "raster")
conflict_prefer("update", "raster")

conflict_prefer("col_character", "readr")
conflict_prefer("col_date", "readr")
conflict_prefer("col_datetime", "readr")
conflict_prefer("col_double", "readr")
conflict_prefer("col_factor", "readr")
conflict_prefer("col_guess", "readr")
conflict_prefer("col_integer", "readr")
conflict_prefer("col_logical", "readr")
conflict_prefer("col_number", "readr")
conflict_prefer("col_skip", "readr")
conflict_prefer("col_time", "readr")
conflict_prefer("cols", "readr")
conflict_prefer("cols_condense", "readr")
conflict_prefer("date_names_lang", "readr")
conflict_prefer("default_locale", "readr")
conflict_prefer("fwf_cols", "readr")
conflict_prefer("fwf_empty", "readr")
conflict_prefer("fwf_positions", "readr")
conflict_prefer("fwf_widths", "readr")
conflict_prefer("guess_encoding", "readr")

conflict_prefer("locale", "readr")
conflict_prefer("output_column", "readr")
conflict_prefer("problems", "readr")
conflict_prefer("spec", "readr")

conflict_prefer("all_nominal", "recipes")
conflict_prefer("all_numeric", "recipes")
conflict_prefer("check", "recipes")
conflict_prefer("fixed", "recipes")
conflict_prefer("has_type", "recipes")
conflict_prefer("step", "recipes")

conflict_prefer("data_addprefix", "report")
conflict_prefer("data_addsuffix", "report")
conflict_prefer("data_findcols", "report")
conflict_prefer("data_remove", "report")
conflict_prefer("data_rename", "report")
conflict_prefer("data_reorder", "report")
conflict_prefer("report", "report")
conflict_prefer("text_concatenate", "report")
conflict_prefer("text_lastchar", "report")
conflict_prefer("text_paste", "report")
conflict_prefer("text_wrap", "report")

conflict_prefer("dcast", "reshape2")
conflict_prefer("melt", "reshape2")

conflict_prefer(":=", "rlang")
conflict_prefer("%@%", "rlang")
conflict_prefer("abort", "rlang")
conflict_prefer("as_function", "rlang")
conflict_prefer("bytes", "rlang")
conflict_prefer("check_dots_empty", "rlang")
conflict_prefer("check_dots_unnamed", "rlang")
conflict_prefer("check_dots_used", "rlang")
conflict_prefer("env", "rlang")
conflict_prefer("flatten", "rlang")
conflict_prefer("flatten_chr", "rlang")
conflict_prefer("flatten_dbl", "rlang")
conflict_prefer("flatten_int", "rlang")
conflict_prefer("flatten_lgl", "rlang")
conflict_prefer("flatten_raw", "rlang")
conflict_prefer("invoke", "rlang")
conflict_prefer("last_warnings", "rlang")
conflict_prefer("list_along", "rlang")
conflict_prefer("ll", "rlang")
conflict_prefer("modify", "rlang")
conflict_prefer("set_names", "rlang")
conflict_prefer("splice", "rlang")
conflict_prefer("string", "rlang")

conflict_prefer("populate", "rsample")

conflict_prefer("ess_bulk", "rstan")
conflict_prefer("ess_tail", "rstan")

conflict_prefer("alpha", "scales")
conflict_prefer("rescale", "scales")

conflict_prefer("merge", "sp")
conflict_prefer("plot", "sp")
conflict_prefer("split", "sp")
conflict_prefer("summary", "sp")

conflict_prefer("%in%", "terra")
conflict_prefer("aggregate", "terra")
conflict_prefer("all.equal", "terra")
conflict_prefer("as.array", "terra")
conflict_prefer("as.data.frame", "terra")
conflict_prefer("as.list", "terra")
conflict_prefer("as.matrix", "terra")
conflict_prefer("as.raster", "terra")
conflict_prefer("atan2", "terra")
conflict_prefer("barplot", "terra")
conflict_prefer("boxplot", "terra")
conflict_prefer("buffer", "terra")
conflict_prefer("contour", "terra")
conflict_prefer("density", "terra")
conflict_prefer("head", "terra")
conflict_prefer("hist", "terra")
conflict_prefer("image", "terra")
conflict_prefer("intersect", "terra")
conflict_prefer("is.factor", "terra")
conflict_prefer("levels", "terra")
conflict_prefer("lines", "terra")
conflict_prefer("mean", "terra")
conflict_prefer("ncol", "terra")
conflict_prefer("nrow", "terra")
conflict_prefer("pairs", "terra")
conflict_prefer("persp", "terra")
conflict_prefer("predict", "terra")
conflict_prefer("quantile", "terra")
conflict_prefer("scale", "terra")
conflict_prefer("shift", "terra")
conflict_prefer("subset", "terra")
conflict_prefer("t", "terra")
conflict_prefer("tail", "terra")
conflict_prefer("text", "terra")
conflict_prefer("union", "terra")
conflict_prefer("unique", "terra")
conflict_prefer("weighted.mean", "terra")
conflict_prefer("which.max", "terra")
conflict_prefer("which.min", "terra")

conflict_prefer("step_downsample", "themis")
conflict_prefer("step_upsample", "themis")

conflict_prefer("find_difference", "tidymv")
conflict_prefer("get_difference", "tidymv")
conflict_prefer("summary_data", "tidymv")

conflict_prefer("complete", "tidyr")
conflict_prefer("expand", "tidyr")
conflict_prefer("pack", "tidyr")
conflict_prefer("smiths", "tidyr")
conflict_prefer("unpack", "tidyr")

conflict_prefer("logit_trans", "tidyposterior")

conflict_prefer("parse_model", "tidypredict")

conflict_prefer("info", "torchaudio")

conflict_prefer("transform_to_tensor", "torchvision")

conflict_prefer("index", "tsibble")
conflict_prefer("key", "tsibble")

conflict_prefer("tune", "tune")

conflict_prefer("data_frame", "vctrs")
conflict_prefer("field", "vctrs")
conflict_prefer("list_of", "vctrs")

conflict_prefer("load_pkgs", "vetiver")

conflict_prefer("vi", "vip")

conflict_prefer("compare", "waldo")

conflict_prefer("accuracy", "yardstick")
conflict_prefer("get_weights", "yardstick")
conflict_prefer("mae", "yardstick")
conflict_prefer("mape", "yardstick")
conflict_prefer("precision", "yardstick")
conflict_prefer("recall", "yardstick")
conflict_prefer("rmse", "yardstick")

################################################################################

library(pillar)

#-------------------------------------------------------------------------------

library(reticulate)

if ("badr" %in% conda_list()$name) {
  use_condaenv(
    condaenv = "badr",
    conda = "auto",
    required = TRUE
  )
}

py_config()

#-------------------------------------------------------------------------------

library(tidyverse)
library(tidymodels)

#-------------------------------------------------------------------------------

library(additive)
library(bayesian)

#-------------------------------------------------------------------------------

library(agua)
library(applicable)
library(baguette)
library(broom)
library(broom.mixed)
library(brulee)
library(butcher)
library(censored)
library(coro)
library(corrr)
library(dials)
library(discrim)
library(embed)
library(dbplyr)
library(dplyr)
library(dtplyr)
library(finetune)
library(forcats)
library(ggplot2)
library(glue)
library(googledrive)
library(googlesheets4)
library(hardhat)
library(infer)
library(haven)
library(hms)
library(lubridate)
library(magrittr)
library(modeldata)
library(modeldb)
library(modelr)
library(multidplyr)
library(multilevelmod)
library(parsnip)
library(plsmod)
library(plumber)
library(probably)
library(poissonreg)
library(purrr)
library(readr)
library(readxl)
library(recipes)
library(reprex)
library(rsample)
library(rules)
library(rvest)
library(sparklyr)
library(spatialsample)
library(stacks)
library(stringr)
library(textrecipes)
library(tibble)
library(tidyr)
library(tidyposterior)
library(tidypredict)
library(tidyselect)
library(tidytext)
library(themis)
library(tune)
library(usemodels)
library(vetiver)
library(vroom)
library(workflows)
library(workflowsets)
library(yardstick)

#-------------------------------------------------------------------------------

library(agua)
library(baguette)
library(bonsai)
library(censored)
library(discrim)
library(plsmod)
library(poissonreg)
library(rules)

#-------------------------------------------------------------------------------

library(fable)
library(fabletools)
library(fable.prophet)
library(fable.tscount)
library(fasster)
library(feasts)
library(tsibble)

#-------------------------------------------------------------------------------

library(keras)
library(tensorflow)

library(tfdatasets)
library(tfdeploy)
library(tfds)
library(tfestimators)
library(tfhub)
library(tfprobability)
library(tfruns)

library(alexnet)
library(gpt2)
library(resnet)
library(unet)
library(wavenet)

#-------------------------------------------------------------------------------

library(cuda.ml)
library(innsight)
library(katex)
library(lltm)
library(brulee)
library(luz)
library(tabnet)
library(tabulate)
library(tft)
library(torch)
library(torchaudio)
library(torchdatasets)
library(torchopt)
library(torchexport)
library(torchsparse)
library(torchtransformers)
# library(torchvision)
# library(torchvisionlib)

#-------------------------------------------------------------------------------

library(easystats)

library(bayestestR)
library(correlation)
library(datawizard)
library(effectsize)
library(insight)
library(modelbased)
library(parameters)
library(performance)
library(report)
library(see)

#-------------------------------------------------------------------------------

library(Matrix)
library(mgcv)

library(dlnm)
library(gammit)
library(gratia)
library(itsadug)
library(mgcViz)
library(mixedup)
library(qgam)
library(splines)
library(splines2)
library(tidymv)
library(visibly)

#-------------------------------------------------------------------------------

library(brms)

library(StanHeaders)
library(rstan)

library(bayesplot)
library(cmdstanr)
library(EpiEstim)
library(EpiInvert)
library(incidence)
library(loo)
library(posterior)
library(projpred)
library(projections)
library(rstanarm)
library(rstantools)
library(SBC)
library(shinystan)
library(tidybayes)

#-------------------------------------------------------------------------------

library(arrow)
library(batchtools)
library(bench)
library(bestNormalize)
library(checkmate)
library(clustermq)
library(data.table)
library(distributional)
library(doFuture)
library(doParallel)
library(emmeans)
library(equatiomatic)
library(ezsummary)
library(forecast)
library(fst)
library(furrr)
library(future)
library(future.apply)
library(future.batchtools)
library(future.callr)
library(globals)
library(gt)
library(HiClimR)
library(humidity)
library(iterators)
library(janitor)
library(kableExtra)
library(knitr)
library(lifecycle)
library(listenv)
library(lobstr)
library(marginaleffects)
library(memuse)
library(metamer)
library(metR)
library(modelsummary)
library(optparse)
library(parallelly)
library(ppsr)
library(prettycode)
library(progress)
library(progressr)
library(R.cache)
library(R.oo)
library(R.utils)
library(RCurl)
library(ranger)
library(rcmip6)
library(Rcpp)
library(RcppArmadillo)
library(RcppCCTZ)
library(RcppEigen)
library(RcppNT2)
library(RcppParallel)
library(rlang)
library(RNetCDF)
library(sessioninfo)
library(skimr)
library(stringdist)
library(tidync)
library(tools)
library(vctrs)
library(vitae)
library(waldo)
library(zoo)

#-------------------------------------------------------------------------------

library(ALEPlot)
library(DALEX)
library(DALEXtra)
library(fastshap)
library(iml)
library(modelDown)
library(modelStudio)
library(pdp)
library(vip)

#-------------------------------------------------------------------------------

library(countrycode)
library(eurostat)
library(ISOcodes)
library(rnaturalearth)
library(rnaturalearthdata)
library(rnaturalearthhires)
library(regions)
library(tidycensus)

#-------------------------------------------------------------------------------

library(raster)
library(rgdal)
library(spdep)

#-------------------------------------------------------------------------------

library(corrplot)
library(cowplot)
library(GGally)
library(ggalt)
library(gganimate)
library(ggdist)
library(ggeffects)
library(gghighlight)
library(ggnewscale)
library(ggpattern)
library(ggperiodic)
library(ggplotify)
library(ggpubr)
library(ggquiver)
library(ggrepel)
library(grid)
library(hrbragg)
library(hrbrthemes)
library(patchwork)
library(RColorBrewer)
library(reshape2)
library(rworldmap)
library(scales)
library(tagger)
library(tmap)
library(tmaptools)
library(tourr)
library(waffle)

#-------------------------------------------------------------------------------

library(targets)
library(tarchetypes)

#-------------------------------------------------------------------------------

if (!exists("%!in%")) {
  `%!in%` <- Negate(`%in%`)
}

#-------------------------------------------------------------------------------

ClosestMatch2 <- function(string, stringVector) {
  stringVector[amatch(string, stringVector, maxDist = Inf)]
}

#-------------------------------------------------------------------------------

pluck_multiple <- function(x, ...) {
  `[`(x, ...)
}

#-------------------------------------------------------------------------------

modify_at_names <- function(x, ...) {
  x |>
    setNames(
      x |>
        names() |>
        modify_at(
          ...
        )
    )
}

str_replace_names <- function(x, ...) {
  x |>
    setNames(
      x |>
        names() |>
        str_replace_all(
          ...
        )
    )
}

################################################################################

conflicted:::conflicts_register()

#-------------------------------------------------------------------------------

conflicts(detail = TRUE)

conflict_scout()

################################################################################

session_info()

################################################################################

# Set the initial seed for random variate generators
# For reproducibility and cross validation
seed <- 2020L
set.seed(seed)

epsilon <- 1e-07

################################################################################

# Plot resolution / ggplot DPI
ggdpi <- 600

# Number of x-date ticks
x_date.num <- 12

theme_custom <- function(theme_color = "white",
                         legend.position = "bottom",
                         legend.direction = "horizontal",
                         base_family = "",
                         base_size = 15,
                         axis.text.angle = c(0, 90),
                         blank_axes = FALSE,
                         blank_axisLabels = FALSE) {
  theme_grey(
    base_size = base_size,
    base_family = base_family
  ) %+replace%
    theme(
      # Specify axis options
      axis.line = element_blank(),
      axis.text.x = `if`(
        blank_axes,
        element_blank(),
        element_text(
          size = base_size |>
            multiply_by(0.8),
          color = if_else(
            theme_color == "black",
            "white",
            "black"
          ),
          angle = axis.text.angle[1],
          lineheight = 0.9,
          margin = margin(5, 5, 0, 0)
        )
      ),
      axis.text.y = `if`(
        blank_axes,
        element_blank(),
        element_text(
          size = base_size |>
            multiply_by(0.8),
          color = if_else(
            theme_color == "black",
            "white",
            "black"
          ),
          angle = axis.text.angle[2],
          lineheight = 0.9,
          margin = margin(0, 5, 0, 0)
        )
      ),
      axis.ticks = `if`(
        blank_axes,
        element_blank(),
        element_line(
          color = if_else(
            theme_color == "black",
            "white",
            "black"
          ),
          size = 0.5
        )
      ),
      axis.title.x = `if`(
        blank_axes | blank_axisLabels,
        element_blank(),
        element_text(
          size = base_size,
          color = if_else(
            theme_color == "black",
            "white",
            "black"
          ),
          margin = margin(10, 10, 0, 0)
        )
      ),
      axis.title.y = `if`(
        blank_axes | blank_axisLabels,
        element_blank(),
        element_text(
          size = base_size,
          color = if_else(
            theme_color == "black",
            "white",
            "black"
          ),
          angle = 90,
          margin = margin(0, 10, 0, 0)
        )
      ),
      axis.ticks.length = unit(0.25, "lines"),
      # Specify legend options
      legend.background = element_rect(
        color = NA,
        fill = theme_color
      ),
      legend.key = element_rect(
        # color = if_else(
        #   theme_color == "black",
        #   "white",
        #   "black"
        # ),
        color = NA,
        fill = theme_color
      ),
      legend.key.size = unit(1.2, "lines"),
      legend.key.height = unit(0.5, "cm"),
      legend.key.width = unit(0.5, "cm"),
      legend.text = element_text(
        size = base_size |>
          multiply_by(0.8),
        color = if_else(
          theme_color == "black",
          "white",
          "black"
        )
      ),
      legend.title = element_text(
        size = base_size * 1.0,
        face = "bold",
        hjust = 0,
        color = if_else(
          theme_color == "black",
          "white",
          "black"
        )
      ),
      legend.position = legend.position,
      legend.text.align = NULL,
      legend.title.align = 0.5,
      legend.direction = legend.direction,
      legend.box = NULL,
      # Specify panel options
      panel.background = `if`(
        blank_axes,
        element_blank(),
        element_rect(
          fill = theme_color,
          color = NA
        )
      ),
      panel.border = `if`(
        blank_axes,
        element_blank(),
        element_rect(
          fill = NA,
          color = if_else(
            theme_color == "black",
            "white",
            "black"
          )
        )
      ),
      panel.grid.major = `if`(
        blank_axes,
        element_blank(),
        element_line(
          color = theme_color
        )
      ),
      panel.grid.minor = `if`(
        blank_axes,
        element_blank(),
        element_line(
          color = theme_color
        )
      ),
      panel.spacing = unit(0.5, "lines"),
      # Specify facetting options
      strip.background = element_rect(
        fill = if_else(
          theme_color == "black",
          "grey30",
          "white"
        ),
        color = if_else(
          theme_color == "black",
          "grey10",
          "black"
        )
      ),
      strip.text.x = element_text(
        size = base_size |>
          multiply_by(0.8),
        color = if_else(
          theme_color == "black",
          "white",
          "black"
        )
      ),
      strip.text.y = element_text(
        size = base_size |>
          multiply_by(0.8),
        color = if_else(
          theme_color == "black",
          "white",
          "black"
        ),
        angle = -90
      ),
      # Specify plot options
      plot.background = element_rect(
        color = theme_color,
        fill = theme_color
      ),
      plot.title = element_text(
        size = base_size |>
          multiply_by(1.2),
        color = if_else(
          theme_color == "black",
          "white",
          "black"
        )
      ),
      plot.margin = unit(
        rep(1, 4),
        "lines"
      )
    )
}

################################################################################

EID.load <- function(opts, binary_factors = FALSE, exclude_countries = NULL) {
  EID.data <- read_delim(
    file = file.path(
      EID.dir,
      "EID",
      "Enterics_shigella_database.csv"
    ),
    col_names = TRUE,
    col_types = cols(
      study = col_character(),
      design = col_character(),
      # zone = col_character(),
      # stratum = col_character(),
      country = col_character(),
      # site = col_character(),
      kid = col_double(),
      # date = col_character(),
      # date = col_date(format = "%d-%b-%y"),
      date = col_date(format = "%d%b%Y"),
      urban = col_character(),
      age = col_double(),
      water = col_character(),
      groundwater = col_character(),
      sanitation = col_character(),
      open_def = col_character(),
      # handwash = col_character(),
      floors = col_character(),
      cattle = col_character(),
      ruminants = col_character(),
      pigs = col_character(),
      monogastrics = col_character(),
      poultry = col_character(),
      mammals = col_character(),
      animals = col_character(),
      crowding = col_character(),
      education = col_character(),
      excl_bf = col_character(),
      weaned = col_character(),
      stunting = col_character(),
      underweight = col_character(),
      wasting = col_character(),
      diarrhea = col_character(),
      vaccine = col_character(),
      # msd = col_character(),
      accessibility = col_double(),
      cattle2 = col_double(),
      cropland = col_double(),
      density = col_double(),
      elevation = col_double(),
      footprint = col_double(),
      growing = col_double(),
      irrigation = col_double(),
      monogastrics2 = col_double(),
      pasture = col_double(),
      pigs2 = col_double(),
      poultry2 = col_double(),
      river_dist = col_double(),
      ruminants2 = col_double(),
      animals2 = col_double(),
      water_dist = col_double(),
      pcp_abs_7day = col_double(),
      pcp_anom_7day = col_double(),
      psurf_abs_7day = col_double(),
      psurf_anom_7day = col_double(),
      rhum_abs_7day = col_double(),
      rhum_anom_7day = col_double(),
      runoff_abs_7day = col_double(),
      runoff_anom_7day = col_double(),
      # runoff_cat = col_character(),
      smst_abs_7day = col_double(),
      smst_anom_7day = col_double(),
      sphum_abs_7day = col_double(),
      sphum_anom_7day = col_double(),
      srad_abs_7day = col_double(),
      srad_anom_7day = col_double(),
      tmed_abs_7day = col_double(),
      tmed_anom_7day = col_double(),
      wind_abs_7day = col_double(),
      wind_anom_7day = col_double(),
      dewptt_abs_7day = col_double(),
      dewptt_anom_7day = col_double(),
      dewptd_abs_7day = col_double(),
      dewptd_anom_7day = col_double(),
      adenovirus = col_character(),
      astrovirus = col_character(),
      norovirus = col_character(),
      rotavirus = col_character(),
      sapovirus = col_character(),
      campylobacter = col_character(),
      etec = col_character(),
      shigella = col_character(),
      cryptosporidium = col_character(),
      giardia = col_character()
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
    num_threads = cores.max,
    progress = FALSE,
    show_col_types = FALSE,
    lazy = FALSE
  ) |>
    filter(
      country %!in% exclude_countries
    ) |>
    mutate(
      date = date |>
        as.Date(
          format = "%d-%b-%y"
        )
    ) |>
    {
      function(.) {
        if (
          opts |>
          pluck("mode") |>
          str_detect(
            pattern = "classification"
          ) |>
          and(binary_factors)
        ) {
          . |>
            mutate(
              across(
                any_of(
                  opts |>
                    pluck("formula") |>
                    pluck("formula") |>
                    find_response(
                      combine = FALSE
                    )
                ),
                function(x) {
                  x |>
                    factor(
                      levels = c(
                        "Negative",
                        "Positive"
                      )
                    )
                }
              )
            )
        } else if (
          opts |>
          pluck("mode") |>
          str_detect(
            pattern = "classification"
          ) |>
          and(!binary_factors)
        ) {
          . |>
            mutate(
              across(
                any_of(
                  opts |>
                    pluck("formula") |>
                    pluck("formula") |>
                    find_response(
                      combine = FALSE
                    )
                ),
                function(x) {
                  x |>
                    fct_recode(
                      "0" = "Negative",
                      "1" = "Positive"
                    )
                }
              )
            )
        } else {
          . |>
            mutate(
              across(
                any_of(
                  opts |>
                    pluck("formula") |>
                    pluck("formula") |>
                    find_response(
                      combine = FALSE
                    )
                ),
                function(x) {
                  x |>
                    recode(
                      "Negative" = 0,
                      "Positive" = 1
                    )
                }
              )
            )
        }
      }
    }() |>
    mutate(
      across(
        any_of(
          c(
            "water",
            "sanitation",
            "floors"
          )
        ),
        function(x) {
          x |>
            factor(
              levels = c(
                "Unimproved",
                "Improved"
              )
            )
        }
      )
    ) |>
    mutate(
      across(
        any_of(
          c(
            "animals",
            "cattle",
            "crowding",
            "education",
            "groundwater",
            "handwash",
            "mammals",
            "monogastrics",
            "open_def",
            "pigs",
            "poultry",
            "ruminants"
          )
        ),
        function(x) {
          x |>
            factor(
              levels = c(
                "No",
                "Yes"
              )
            )
        }
      )
    ) |>
    mutate(
      study = study |>
        factor(
          levels = "MAL" |>
            union(
              study |>
                unique()
            )
        ),
      design = design |>
        recode(
          "CC" = "CS"
        ) |>
        factor(
          levels = c(
            "CS",
            "HF"
          )
        ),
      diarrhea = diarrhea |>
        recode(
          "Surveillance" = "Asymptomatic",
          "Diarrheal" = "Symptomatic"
        ) |>
        factor(
          levels = c(
            "Asymptomatic",
            "Symptomatic"
          )
        ),
      syndrome = case_when(
        diarrhea == "Asymptomatic" & design == "CS" ~ "Asymptomatic_CS",
        diarrhea == "Asymptomatic" & design == "HF" ~ "Asymptomatic_HF",
        diarrhea == "Symptomatic" & design == "CS" ~ "Symptomatic_CS",
        diarrhea == "Symptomatic" & design == "HF" ~ "Symptomatic_HF"
      ) |>
        factor(
          levels = c(
            "Asymptomatic_CS",
            "Asymptomatic_HF",
            "Symptomatic_CS",
            "Symptomatic_HF"
          )
        ),
      urban = urban |>
        factor(
          levels = c(
            "Rural",
            "Peri_urban",
            "Urban"
          )
        ),
      feeding = excl_bf |>
        fct_cross(
          weaned
        ) |>
        recode(
          "Receiving_solids:Fully_weaned" = "Weaned",
          "Receiving_solids:Still_breastfeeding" = "Mixed",
          "Exclusively_breastfed:Still_breastfeeding" = "EBF"
        ),
      excl_bf = excl_bf |>
        factor(
          levels = c(
            "Receiving_solids",
            "Exclusively_breastfed"
          )
        ),
      weaned = weaned |>
        factor(
          levels = c(
            "Still_breastfeeding",
            "Fully_weaned"
          )
        ),
      stunting = stunting |>
        factor(
          levels = c(
            "Not_stunted",
            "Stunted"
          )
        ),
      underweight = underweight |>
        factor(
          levels = c(
            "Not_underweight",
            "Underweight"
          )
        ),
      wasting = wasting |>
        factor(
          levels = c(
            "Not_wasted",
            "Wasted"
          )
        ),
      vaccine = vaccine |>
        factor(
          levels = c(
            "Not_yet_introduced",
            "Introduced"
          )
        )
    ) |>
    mutate(
      age = case_when(
        age >= 0 & age < 12 ~ "[ 0, 12)",
        age >= 12 & age < 24 ~ "[12, 24)",
        age >= 24 & age < 60 ~ "[24, 60)",
        TRUE ~ NA_character_
      ) |>
        factor(
          levels = c(
            "[ 0, 12)",
            "[12, 24)",
            "[24, 60)"
          )
        )
    ) |>
    {
      function(.) {
        if (
          opts |>
          pluck("mode") |>
          str_detect(
            pattern = "classification"
          ) |>
          and(!binary_factors)
        ) {
          . |>
            mutate(
              across(
                any_of(
                  c(
                    "water",
                    "sanitation",
                    "floors"
                  )
                ),
                function(x) {
                  x |>
                    recode(
                      "Unimproved" = 0,
                      "Improved" = 1
                    )
                }
              )
            ) |>
            mutate(
              across(
                any_of(
                  c(
                    "animals",
                    "cattle",
                    "crowding",
                    "education",
                    "groundwater",
                    "handwash",
                    "mammals",
                    "monogastrics",
                    "open_def",
                    "pigs",
                    "poultry",
                    "ruminants"
                  )
                ),
                function(x) {
                  x |>
                    recode(
                      "No" = 0,
                      "Yes" = 1
                    )
                }
              )
            ) |>
            mutate(
              excl_bf = excl_bf |>
                recode(
                  "Receiving_solids" = 0, "Exclusively_breastfed" = 1
                ),
              weaned = weaned |>
                recode(
                  "Still_breastfeeding" = 0, "Fully_weaned" = 1
                ),
              stunting = stunting |>
                recode(
                  "Not_stunted" = 0, "Stunted" = 1
                ),
              underweight = underweight |>
                recode(
                  "Not_underweight" = 0, "Underweight" = 1
                ),
              wasting = wasting |>
                recode(
                  "Not_wasted" = 0, "Wasted" = 1
                ),
              vaccine = vaccine |>
                recode(
                  "Not_yet_introduced" = 0, "Introduced" = 1
                )
            )
        } else {
          .
        }
      }
    }() |>
    select(
      any_of(
        opts |>
          pluck("formula") |>
          pluck("formula") |>
          all.vars()
      ),
      kid
    ) |>
    drop_na() |>
    add_count(
      # kid,
      !!sym(
        opts |>
          pluck("formula") |>
          pluck("formula") |>
          find_response(
            combine = FALSE
          )
      ),
      wt = NULL,
      sort = FALSE,
      name = "n"
    ) |>
    {
      function(df) {
        if (opt_enabled(opts$recipe$weights)) {
          df |>
            mutate(
              case_weights = 1 |>
                divide_by(n) |>
                divide_by_mean() |>
                importance_weights()
            ) |>
            select(
              all_of(
                opts |>
                  pluck("formula") |>
                  pluck("formula") |>
                  all.vars()
              ),
              case_weights
            )
        } else {
          df |>
            select(
              all_of(
                opts |>
                  pluck("formula") |>
                  pluck("formula") |>
                  all.vars()
              )
            )
        }
      }
    }()

  return(EID.data)
}

#-------------------------------------------------------------------------------

EID.variables <- function(TBL) {
  TBL |>
    mutate(
      Category = case_when(
        Variable == "(Intercept)" ~ "Control",
        Variable == "study" ~ "Control",
        Variable == "design" ~ "Control",
        Variable == "age" ~ "Control",
        Variable == "age[ 0, 12)" ~ "Control",
        Variable == "age[12, 24)" ~ "Control",
        Variable == "age[24, 60)" ~ "Control",
        Variable == "diarrhea" ~ "Control",
        Variable == "diarrheaSymptomatic" ~ "Control",
        Variable == "diarrheaAsymptomatic:designHF" ~ "Control",
        Variable == "diarrheaSymptomatic:designHF" ~ "Control",
        Variable == "syndrome" ~ "Control",
        Variable == "syndromeAsymptomatic" ~ "Control",
        Variable == "syndromeAsymptomatic_CS" ~ "Control",
        Variable == "syndromeAsymptomatic_HF" ~ "Control",
        Variable == "syndromeSymptomatic_CS" ~ "Control",
        Variable == "syndromeSymptomatic_HF" ~ "Control",
        Variable == "excl_bf" ~ "Subject-level",
        Variable == "stunting" ~ "Subject-level",
        Variable == "underweight" ~ "Subject-level",
        Variable == "wasting" ~ "Subject-level",
        Variable == "weaned" ~ "Subject-level",
        Variable == "crowding" ~ "Household-level",
        Variable == "education" ~ "Household-level",
        Variable == "floors" ~ "Household-level",
        Variable == "open_def" ~ "Household-level",
        Variable == "sanitation" ~ "Household-level",
        Variable == "water" ~ "Household-level",
        Variable == "accessibility" ~ "Static environmental",
        Variable == "cropland" ~ "Static environmental",
        Variable == "density" ~ "Static environmental",
        Variable == "elevation" ~ "Static environmental",
        Variable == "evi" ~ "Static environmental",
        Variable == "footprint" ~ "Static environmental",
        Variable == "growing" ~ "Static environmental",
        Variable == "irrigation" ~ "Static environmental",
        Variable == "river_dist" ~ "Static environmental",
        Variable == "urban" ~ "Static environmental",
        Variable == "urbanRural" ~ "Static environmental",
        Variable == "urbanPeri_urban" ~ "Static environmental",
        Variable == "urbanUrban" ~ "Static environmental",
        Variable == "pcp_anom_7day" ~ "Hydrometeorological",
        Variable == "psurf_anom_7day" ~ "Hydrometeorological",
        Variable == "rhum_abs_7day" ~ "Hydrometeorological",
        Variable == "runoff_abs_7day" ~ "Hydrometeorological",
        Variable == "smst_abs_7day" ~ "Hydrometeorological",
        Variable == "sphum_abs_7day" ~ "Hydrometeorological",
        Variable == "srad_abs_7day" ~ "Hydrometeorological",
        Variable == "tmed_abs_7day" ~ "Hydrometeorological",
        Variable == "wind_abs_7day" ~ "Hydrometeorological",
        TRUE ~ "Other"
      ),
      Label = case_when(
        Variable == "study" ~ "Study",
        Variable == "design" ~ "Study design",
        Variable == "age" ~ "Child's age",
        Variable == "age[ 0, 12)" ~ "Age  0 - 11 months",
        Variable == "age[12, 24)" ~ "Age 12 - 23 months",
        Variable == "age[24, 60)" ~ "Age 24 - 59 months",
        Variable == "diarrhea" ~ "Symptom status",
        Variable == "diarrheaSymptomatic" ~ "Symptomatic diarrhea",
        Variable == "diarrheaAsymptomatic:designHF" ~ "HF vs. CS Asymptomatic",
        Variable == "diarrheaSymptomatic:designHF" ~ "HF vs. CS Symptomatic",
        Variable == "syndrome" ~ "Symptom status / study design",
        Variable == "syndromeAsymptomatic" ~ "Asymptomatic diarrhea",
        # Variable == "syndromeAsymptomatic_CS" ~ "Community-detected Asymptomatic",
        # Variable == "syndromeAsymptomatic_HF" ~ "Medically-attended Asymptomatic",
        Variable == "syndromeAsymptomatic_CS" ~ "Asymptomatic",
        Variable == "syndromeAsymptomatic_HF" ~ "Asymptomatic (health facility)",
        Variable == "syndromeSymptomatic_CS" ~ "Community-detected diarrhea",
        Variable == "syndromeSymptomatic_HF" ~ "Medically-attended diarrhea",
        Variable == "excl_bf" ~ "Exclusive breastfeeding",
        Variable == "stunting" ~ "Stunting",
        Variable == "underweight" ~ "Underweight",
        Variable == "wasting" ~ "Wasting",
        Variable == "weaned" ~ "Weaning",
        Variable == "crowding" ~ "Household crowding",
        Variable == "education" ~ "Caregiver education",
        Variable == "floors" ~ "Floor material",
        Variable == "open_def" ~ "Open defecation",
        Variable == "sanitation" ~ "Sanitation facility",
        Variable == "water" ~ "Water source",
        Variable == "accessibility" ~ "Accessibility to cities",
        Variable == "cropland" ~ "Cropland areas",
        Variable == "density" ~ "Population density",
        Variable == "elevation" ~ "Elevation",
        Variable == "evi" ~ "Enhanced vegetation index",
        Variable == "footprint" ~ "Human footprint index",
        Variable == "growing" ~ "Growing season length",
        Variable == "irrigation" ~ "Irrigated areas",
        Variable == "river_dist" ~ "Distance to major river",
        Variable == "urban" ~ "Urbanicity",
        Variable == "urbanRural" ~ "Rural areas",
        Variable == "urbanPeri_urban" ~ "Peri-urban areas",
        Variable == "urbanUrban" ~ "Urban areas",
        Variable == "pcp_anom_7day" ~ "Precipitation deviations",
        Variable == "psurf_anom_7day" ~ "Surface pressure deviations",
        Variable == "rhum_abs_7day" ~ "Relative humidity",
        Variable == "runoff_abs_7day" ~ "Surface runoff",
        Variable == "smst_abs_7day" ~ "Soil moisture",
        Variable == "sphum_abs_7day" ~ "Specific humidity",
        Variable == "srad_abs_7day" ~ "Solar radiation",
        Variable == "tmed_abs_7day" ~ "Air temperature",
        Variable == "wind_abs_7day" ~ "Wind speed",
        TRUE ~ Variable
      )
    )
}

################################################################################
################################################################################
################################################################################

Sys.time() - tstart

################################################################################
