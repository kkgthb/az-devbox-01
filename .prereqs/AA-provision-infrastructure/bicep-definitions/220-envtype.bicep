targetScope = 'resourceGroup'

param dcetName string
param dcName string

resource dc 'Microsoft.DevCenter/devcenters@2024-10-01-preview' existing = {
  name: dcName
}

resource devcenters_devexperience_devbox_name_Developer 'Microsoft.DevCenter/devcenters/environmentTypes@2024-02-01' = {
  parent: dc
  name: dcetName
}
