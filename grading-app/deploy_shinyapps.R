#!/usr/bin/env Rscript

# Minimal helper to deploy the app to shinyapps.io
# Defaults to the FA25 UI (`app-fa25.R`) and the ph-142-fa25 account.

if (!requireNamespace("rsconnect", quietly = TRUE)) {
  stop("rsconnect package is required. Install with install.packages('rsconnect').", call. = FALSE)
}
rsconnect::setAccountInfo(name='ph-142-fa25', token='EDB426D0F0F084090FD897B2871AC585', secret='3ns7qb3eFo8xOBOuo+iBpTHDsRst2/AMUf/CyWTF')
# Determine script directory for both Rscript and source()
script_dir <- {
  args <- commandArgs(trailingOnly = FALSE)
  file_arg <- args[grepl("^--file=", args)]
  if (length(file_arg) == 1) {
    dirname(normalizePath(sub("^--file=", "", file_arg)))
  } else if (!is.null(sys.frames()[[1]]$ofile)) {
    dirname(normalizePath(sys.frames()[[1]]$ofile))
  } else {
    getwd()
  }
}
setwd(script_dir)

# Configurable parameters (override by setting env vars before running)
app_file <- Sys.getenv("SHINY_APP_FILE", unset = "app-fa25.R")
app_name <- Sys.getenv("SHINY_APP_NAME", unset = "grading-app")
account  <- Sys.getenv("SHINY_APP_ACCOUNT", unset = "ph-142-fa25")

message("Deploying ", app_file, " to shinyapps.io as ", account, "/", app_name, " ...")

rsconnect::deployApp(
  appDir  = script_dir,
  appPrimaryDoc = app_file,
  appName = app_name,
  account = account,
  server  = "shinyapps.io"
)

message("Deployment finished.")
