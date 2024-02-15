.libPaths("/usr/local/lib/R/site-library")
cat("loading packages from:", paste("\n - ", .libPaths(), collapse = ""), "\n\n")

# use renv to detect and install required packages.
if (file.exists("renv.lock")) {
  renv::restore(prompt = FALSE)
} else {
  renv::hydrate()
}

# set up some helper functions for fetching environment variables
defined <- function(name) {
  !is.null(Sys.getenv(name)) && Sys.getenv(name) != ""
}
required <- function(name) {
  if (!defined(name)) {
    stop("!!! input or environment variable '", name, "' not set")
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
# Note that we are likely already executing from the app dir, as
# github sets the working directory to the workspace path on starting
# the docker image.
appDir <- ifelse(
  defined("INPUT_APPDIR"),
  required("INPUT_APPDIR"),
  required("GITHUB_WORKSPACE")
)

# required inputs
appName <- required("INPUT_APPNAME")
accountName <- required("INPUT_ACCOUNTNAME")
accountToken <- required("INPUT_ACCOUNTTOKEN")
accountSecret <- required("INPUT_ACCOUNTSECRET")

# optional inputs
appFiles <- optional("INPUT_APPFILES")
appFileManifest <- optional("INPUT_APPFILEMANIFEST")
appTitle <- optional("INPUT_APPTITLE")
logLevel <- optional("INPUT_LOGLEVEL")
forceUpdate <- optional("INPUT_FORCEUPDATE")

# process appFiles
if (!is.null(appFiles)) {
  appFiles <- unlist(strsplit(appFiles, ",", TRUE))
}

# check if this is a forced update
if (forceUpdate == 'true') {
    forceUpdate = TRUE
} else {
    forceUpdate = FALSE
}

# set up account
cat("checking account info...")
rsconnect::setAccountInfo(accountName, accountToken, accountSecret)
cat(" [OK]\n")

# deploy application
rsconnect::deployApp(
  appDir = appDir,
  appFiles = appFiles,
  appFileManifest = appFileManifest,
  appName = appName,
  appTitle = appTitle,
  account = accountName,
  forceUpdate = forceUpdate
)
