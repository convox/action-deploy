# Convox Deploy Action
If you [Install a Convox Rack](https://github.com/convox/installer) using the cloud provider of your choice and create a [convox.yml](https://docs.convox.com/application/convox-yml) to describe your application and its dependencies you can use this action to automatically [deploy](https://docs.convox.com/introduction/getting-started#deploy-your-application) your app.
The Deploy action performs the functions of combining the [Build](https://github.com/convox/action-build) and [Promote](https://github.com/convox/action-promote) actions but in a single step. If you want to create more advanced workflows you can do so by using our [individual actions](#creating-more-advanced-workflows).

## Inputs
### `rack`
**Required** The name of the [Convox Rack](https://docs.convox.com/introduction/rack) you wish to deploy to.
### `app`
**Required** The name of the [app](https://docs.convox.com/deployment/creating-an-application) you wish to deploy to.
### `password`
**Required** The value of your [Convox Deploy Key](https://docs.convox.com/console/deploy-keys)
### `host`
**Optional** The host name of your [Convox Console](https://docs.convox.com/introduction/console). This defaults to `console.convox.com` and only needs to be overwritten if you have a [self-hosted console](https://docs.convox.com/reference/hipaa-compliance#run-a-private-convox-console)
### `cached`
**Optional** Whether to utilise the docker cache during the build. Defaults to true.
### `manifest`
**Optional** Use a custom path for your convox.yml


## Example Usage
```
uses: convox/action-deploy@v1
with:
  rack: staging
  app: myapp
  password: ${{ secrets.CONVOX_DEPLOY_KEY }}
```

## Creating More Advanced Workflows
Convox provides a full set of Actions to enable a wide variety of deployment workflows. The following actions are available:
### [Login](https://github.com/convox/action-login)
Authenticates your Convox account You should run this action as the first step in your workflow
### [Build](https://github.com/convox/action-build)
Builds an app and creates a release which can be promoted later
### [Run](https://github.com/convox/action-run)
Runs a command (such as a migration) using a previously built release before or after it is promoted
### [Promote](https://github.com/convox/action-promote)
Promotes a release

Example workflow building a Rails app and running migrations before deploying:
```
name: CD

on: [push]

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
    - name: checkout
      id: checkout
      uses: actions/checkout@v1
    - name: login
      id:login
      uses: convox/action-login@v1
      with:
        password: ${{ secrets.CONVOX_DEPLOY_KEY }}
    - name: build
      id: build
      uses: convox/action-build@v1
      with:
        rack: staging
        app: myrailsapp
    - name: migrate
      id:migrate
      uses: convox/action-run@v1
      with:
        rack: staging
        app: myrailsapp
        service: web
        command: rake db:migrate
        release: ${{ steps.build.outputs.release }}
    - name: promote
      id: promote
      uses: convox/action-promote@v1
      with:
        rack: staging
        app: myrailsapp
        release: ${{ steps.build.outputs.release }}


```
