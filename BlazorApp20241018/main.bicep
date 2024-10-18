// main.bicep

@description('The name of the resource group')
param resourceGroupName string = 'rg-20241018-githubactionsdemo'

@description('The location of the resource group')
param location string = 'japaneast'

@description('The name of the App Service plan')
param appServicePlanName string = 'example-appserviceplan'

@description('The name of the App Service')
param appServiceName string = 'example-appservice'

resource appServicePlan 'Microsoft.Web/serverfarms@2021-02-01' = {
  name: appServicePlanName
  location: location
  sku: {
    name: 'S1'
    tier: 'Standard'
  }
  properties: {
    reserved: true
  }
}

resource appService 'Microsoft.Web/sites@2021-02-01' = {
  name: appServiceName
  location: location
  properties: {
    serverFarmId: appServicePlan.id
    siteConfig: {
      netFrameworkVersion: 'v8.0'
    }
  }
  kind: 'app'
  identity: {
    type: 'SystemAssigned'
  }
}

output appServiceEndpoint string = appService.properties.defaultHostName

