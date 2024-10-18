// main.bicep

@description('The name of the resource group')
param resourceGroupName string = 'rg-20241018-githubactionsdemo'

@description('The location of the resource group')
param location string = 'East US'

@description('The name of the App Service plan')
param appServicePlanName string = 'plan-20241018'

@description('The name of the App Service')
param appServiceName string = 'app-20241018'

resource appServicePlan 'Microsoft.Web/serverfarms@2021-02-01' existing = {
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
