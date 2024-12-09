targetScope = 'resourceGroup'

param dcprName string
param dcprLocation string
param dcId string

resource dcpr 'Microsoft.DevCenter/projects@2024-02-01' = {
  name: dcprName
  location: dcprLocation
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    devCenterId: dcId
    maxDevBoxesPerUser: 2
  }
}

output dcprName string = dcpr.name
