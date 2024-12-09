// https://github.com/RogerBestMsft/BFYO-Development/blob/76711930adedb74250f107ce62e9bd0b1f857850/DevCenterManagement/infrastructure/Shared/newGallery.bicep

targetScope = 'resourceGroup'

param galName string
param galLocation string

resource gal 'Microsoft.Compute/galleries@2024-03-03' = {
  name: galName
  location: galLocation
  identity: {
    type: 'SystemAssigned'
  }
}
