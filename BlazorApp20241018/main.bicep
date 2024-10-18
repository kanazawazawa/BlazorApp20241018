// main.bicep

@description('The name of the resource group')
param resourceGroupName string = 'example-resources'

@description('The location of the resource group')
param location string = 'East US'

@description('The name of the App Service plan')
param appServicePlanName string = 'example-appserviceplan'

@description('The name of the App Service')
param appServiceName string = 'example-appservice'

resource resourceGroup 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: resourceGroupName
  location: location
}

resource appServicePlan 'Microsoft.Web/serverfarms@2021-02-01' = {
  name: appServicePlanName
  location: resourceGroup.location
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
  location: resourceGroup.location
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
