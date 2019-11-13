# Convox Deploy Action
This Action [Deploys](https://docs.convox.com/introduction/getting-started#deploy-your-application) an app based on a [convox.yml](https://docs.convox.com/application/convox-yml) to Convox. The Deploy action performs the functions of combining the [Build](https://github.com/convox/action-build) and [Promote](https://github.com/convox/action-promote) actions but in a single step.

## Inputs
### `rack`
**Required** The name of the [Convox Rack](https://docs.convox.com/introduction/rack) you wish to deploy to.
### `app`
**Required** The name of the [app](https://docs.convox.com/deployment/creating-an-application) you wish to deploy to.

## Example usage
```
uses: convox/actions/deploy@v1
with:
  rack: staging
  app: myapp
```