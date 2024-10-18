// main.bicep

@description('The name of the resource group')
param resourceGroupName string = 'rg-20241018-githubactionsdemo'

@description('The location of the resource group')
param location string = 'japaneast'

@description('The name of the App Service plan')
param appServicePlanName string = 'plan-20241018'

@description('The name of the App Service')
param appServiceName string = 'app-20241018'

resource appServicePlan 'Microsoft.Web/serverfarms@2021-02-01' = {
  name: appServicePlanName
  location: location
  sku: {
    name: 'S1'
    tier: 'Standard'
  }
  properties: {
    reserved: false // WindowsベースのApp Serviceプラン
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
  kind: 'app' // WindowsベースのApp Service
  identity: {
    type: 'SystemAssigned'
  }
}

output appServiceEndpoint string = appService.properties.defaultHostName
