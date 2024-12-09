// Pool:  "a collection of dev boxes that have the same settings (e.g. same dev box definition, same network connection, etc.)

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
    localAdministrator: 'Enabled' // "Indicates whether owners of Dev Boxes in this pool are added as local administrators on the Dev Box."  https://azuresdkdocs.blob.core.windows.net/$web/java/azure-resourcemanager-devcenter/1.0.0-beta.1/com/azure/resourcemanager/devcenter/models/Pool.html#localAdministrator()
  }
}
