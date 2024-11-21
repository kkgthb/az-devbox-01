targetScope = 'resourceGroup'

param dcName string
param dcLocation string
param dccName string

resource dc 'Microsoft.DevCenter/devcenters@2024-10-01-preview' = {
  name: dcName
  location: dcLocation
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    projectCatalogSettings: {
      catalogItemSyncEnableStatus: 'Enabled'
    }
    networkSettings: {
      microsoftHostedNetworkEnableStatus: 'Enabled'
    }
    devBoxProvisioningSettings: {
      installAzureMonitorAgentEnableStatus: 'Enabled'
    }
  }
}

resource dcc 'Microsoft.DevCenter/devcenters/catalogs@2024-02-01' = {
  name: dccName
  parent: dc
  properties: {
    gitHub: {
      branch: 'main'
      path: '.dev-box-preferences/devbox-admin-level/mycatalog'
      uri: 'https://github.com/kkgthb/az-devbox-01.git'
    }
    syncType: 'Scheduled'
  }
}
