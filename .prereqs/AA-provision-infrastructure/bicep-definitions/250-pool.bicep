targetScope = 'resourceGroup'

param dcplName string
param dcplLocation string
param dcprName string
param dcdName string

// https://learn.microsoft.com/en-us/dotnet/api/microsoft.azure.management.compute.models.virtualmachine.licensetype?view=azure-dotnet-legacy
// There's just client and server; this seems fine.
var licenseType = 'Windows_Client'


resource dcpr 'Microsoft.DevCenter/projects@2024-02-01' existing = {
  name: dcprName
}

resource dcpl 'Microsoft.DevCenter/projects/pools@2024-02-01' = {
  parent: dcpr
  name: dcplName
  location: dcplLocation
  properties: {
    devBoxDefinitionName: dcdName
    licenseType: licenseType
    // localAdministrator: 'Enabled' // Unsure what the right thing to do here is
  }
}
