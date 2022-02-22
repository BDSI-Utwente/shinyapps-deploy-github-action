library(rsconnect, lib.loc = "/usr/local/lib/R/site-library")

defined <- function(name) {
  !is.null(Sys.getenv(name)) && Sys.getenv(name) != ""
}

required <- function(name) {
  if (!defined(name)) {
    stop("input or environment variable '", name, "' not set")
  }
  Sys.getenv(name)
}

optional <- function(name) {
  if (!defined(name)) {
    return(NULL)
  }
  Sys.getenv(name)
}

# resolve app dir
appDir <- ifelse(
  defined("INPUT_APPDIR"),
  required("INPUT_APPDIR"),
  required("GITHUB_WORKSPACE")
)

# required inputs
appName <- required("INPUT_APPNAME")
accountName <- required("INPUT_ACCOUNTNAME")
accountToken <- required("INPUT_ACCOUNTTOKEN")
accountSecret <- required("IUNPUT_ACCOUNTSECRET")

# optional inputs
appFiles <- optional("INPUT_APPFILES")
appFileManifest <- optional("INPUT_APPFILEMANIFEST")
appTitle <- optional("INPUT_APPTITLE")
logLevel <- optional("INPUT_LOGLEVEL")

# process appFiles
if (!is.null(appFiles)) {
  appFiles <- unlist(strsplit(appFiles, ",", TRUE))
}

# set up account
cat("checking account info...")
rsconnect::setAccountInfo(accountName, accountToken, accountSecret)

# deploy application
cat("deploying application...")
rsconnect::deployApp(
  appDir = appDir,
  appFiles = appFiles,
  appFileManifest = appFileManifest,
  appName = appName,
  appTitle = appTitle,
  account = accountName
)