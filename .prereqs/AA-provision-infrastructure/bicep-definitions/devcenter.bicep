targetScope = 'resourceGroup'

param dcName string
param dcLocation string

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

output dcPrincipalId string = dc.identity.principalId
output dcName string = dc.name
