// TODO:  get my Task showing up in the catalog.  It still does not yet.  Sad.

targetScope = 'resourceGroup'

param dccName string
param dcName string
param kvSecretUri string

resource dc 'Microsoft.DevCenter/devcenters@2024-10-01-preview' existing = {
  name: dcName
}

resource dcc 'Microsoft.DevCenter/devcenters/catalogs@2024-02-01' = {
  name: dccName
  parent: dc
  properties: {
    gitHub: {
      branch: 'main'
      path: '.dev-box-preferences/devbox-admin-level/mycatalog'
      uri: 'https://github.com/kkgthb/az-devbox-01.git'
      secretIdentifier: kvSecretUri
    }
    syncType: 'Scheduled'
  }
}
