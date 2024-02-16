# shinyapps-deploy-github-action

GitHub action to automate deployment of shiny applications on <https://shinyapps.io>.

## Example

```yaml
name: Deploy to shinyapps.io
on:

  # run on any push 
  push:

  # run on request (via button in actions menu)
  workflow_dispatch:
      
jobs:
  deploy:
    name: Deploy to shinyapps

    # allow skipping deployment for commits containing '[automated]' or '[no-deploy]' in the commit message
    if: "!contains(github.event.head_commit.message, '[automated]') && !contains(github.event.head_commit.message, '[no-deploy]')"
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - name: deploy
        uses: BDSI-Utwente/shinyapps-deploy-github-action@v1
        with:
          # account and application name (https://<accountName>.shinyapps.io/<appName>)
          appName: your-application-name
          accountName: your-account-name

          # token and secret obtained from https://www.shinyapps.io/admin/#/tokens
          accountToken: ${{ secrets.SHINYAPPS_TOKEN }}
          accountSecret: ${{ secrets.SHINYAPPS_SECRET }}
```

## Inputs

### Required inputs

#### appName

<!-- markdownlint-disable md034 -->
name of the application (typically the last part of the url, e.g. https://\<account\>.shinyapps.io/\<appName\>).
<!-- markdownlint-enable md034 -->

#### accountName

<!-- markdownlint-disable md034 -->
account name on shinyapps.io (typically the first part of the url, e.g. https://\<account\>.shinyapps.io/\<appName\>).
<!-- markdownlint-enable md034 -->

#### accountToken

access token, see <https://www.shinyapps.io/admin/#/tokens>. Generating a new token/secret pair for this action is recommended, so that you can revoke it without affecting other deployments.

#### accountSecret

token secret, see <https://www.shinyapps.io/admin/#/tokens>. Generating a new token/secret pair for this action is recommended, so that you can revoke it without affecting other deployments.

### Optional inputs

#### appDir

_[optional]_
Path to app, relative to repository root. Defaults to `/`, the repository root.

#### appFiles

_[optional]_  comma separated list of files to publish, relative to `appDir`. Overrides `appFileManifest`. If neither `appFiles` or `appFileManifest` are provided, all files in appDir will be published.

example: `app.R,ui.R,server.R,www`

#### appFileManifest

_[optional]_  path to manifest file, relative to `appDir`. Overridden by `appFiles`. The manifest file should contain a list of files to be deployed, one file per line, relative to `appDir`.

#### appTitle

_[optional]_  user-friendly title for the application

#### logLevel

_[optional]_  level of verbosity of rsconnect::deployApp(). Defaults to `normal`, other options are `quiet` or `verbose`.

#### forceUpdate

_[optional]_  If set to 'true', update any previously-deployed app without asking.

## Packages

This action uses the rocker/shiny-verse:latest docker image as a base. This image includes recent versions of most package commonly used in shiny apps and the tidyverse.

If an `renv.lock` file is present in the repository root, `renv::restore()` will be called to install the specific versions of packages recorded in the lockfile. If no lock file is found, `renv::hydrate()` is used to detect used packages and install any missing packages. Note that in the latter case, the most recent versions of packages will be installed.

We highly recommend using renv to manage dependencies.

## Contributing

Any contributions are appreciated. In particular, we would appreciate help implementing the following;

- support for packrat, other R environment management packages
- support for generic rsconnect servers in addition to shinyapps.io
- support for caching of dependencies

## References

This action was inspired by <https://blog.rmhogervorst.nl/blog/2021/02/27/deploy-to-shinyapps-io-from-github-actions/>.
