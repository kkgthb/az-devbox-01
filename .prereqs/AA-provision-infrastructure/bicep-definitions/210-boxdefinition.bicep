// https://learn.microsoft.com/en-us/azure/dev-box/how-to-manage-dev-box-definitions
// "A dev box definition is a Microsoft Dev Box resource that specifies the source image, compute size, and storage size for a dev box."

targetScope = 'resourceGroup'

param dcdName string
param dcdLocation string
param dcName string

// https://github.com/PieterbasNagengast/Azure-DevBox?tab=readme-ov-file#supported-builtin-images-by-dev-box
// 'microsoftwindowsdesktop_windows-ent-cpc_win11-21h2-ent-cpc-os'
// 'microsoftwindowsdesktop_windows-ent-cpc_win11-21h2-ent-cpc-m365'
// 'microsoftwindowsdesktop_windows-ent-cpc_win10-21h2-ent-cpc-os-g2'
// 'microsoftwindowsdesktop_windows-ent-cpc_win10-21h2-ent-cpc-m365-g2'
// 'microsoftwindowsdesktop_windows-ent-cpc_21h1-ent-cpc-os-g2'
// 'microsoftwindowsdesktop_windows-ent-cpc_21h1-ent-cpc-m365-g2'
// 'microsoftwindowsdesktop_windows-ent-cpc_20h2-ent-cpc-os-g2'
// 'microsoftwindowsdesktop_windows-ent-cpc_20h2-ent-cpc-m365-g2'
// 'microsoftwindowsdesktop_windows-ent-cpc_win11-22h2-ent-cpc-os'
// 'microsoftwindowsdesktop_windows-ent-cpc_win11-22h2-ent-cpc-m365'
// 'microsoftwindowsdesktop_windows-ent-cpc_win10-22h2-ent-cpc-os'
// 'microsoftwindowsdesktop_windows-ent-cpc_win10-22h2-ent-cpc-m365'
// 'microsoftvisualstudio_visualstudio2019plustools_vs-2019-ent-general-win11-m365-gen2'
// 'microsoftvisualstudio_visualstudio2019plustools_vs-2019-pro-general-win11-m365-gen2'
// 'microsoftvisualstudio_visualstudioplustools_vs-2022-ent-general-win11-m365-gen2'
// 'microsoftvisualstudio_visualstudioplustools_vs-2022-pro-general-win11-m365-gen2'
// 'microsoftvisualstudio_visualstudio2019plustools_vs-2019-ent-general-win10-m365-gen2'
// 'microsoftvisualstudio_visualstudio2019plustools_vs-2019-pro-general-win10-m365-gen2'
// 'microsoftvisualstudio_visualstudioplustools_vs-2022-ent-general-win10-m365-gen2'
// 'microsoftvisualstudio_visualstudioplustools_vs-2022-pro-general-win10-m365-gen2'
var imageId = 'microsoftvisualstudio_visualstudioplustools_vs-2022-ent-general-win11-m365-gen2' // Okay, yeah, this seems like a good one, if that's really the valid list.

// https://learn.microsoft.com/en-us/python/api/azure-developer-devcenter/azure.developer.devcenter.models.hardwareprofile?view=azure-python
// Valid strings
// https://azure.microsoft.com/en-us/pricing/details/dev-box/
// "8 vCPU, 32 GB RAM, 256 GB Storage" is the cheapest as of 12/9/2024
// https://gist.github.com/colbylwilliams/175e33349bf09afdf1456d515bb79c1d
// Looks like I don't need a separate "osStorageType" below because it's already in the "sku" string.
var skuName = 'general_i_8c32gb256ssd_v2' // Looks good -- seems to match the description of the cheapest option.

resource dc 'Microsoft.DevCenter/devcenters@2024-10-01-preview' existing = {
  name: dcName
}

resource dcd 'Microsoft.DevCenter/devcenters/devboxdefinitions@2024-02-01' = {
  name: dcdName
  parent: dc
  location: dcdLocation
  properties: {
    imageReference: {
      id: '${dc.id}/galleries/default/images/${imageId}'
    }
    sku: {
      name: skuName
    }
    hibernateSupport: 'Disabled'
  }
}

output dcdName string = dcd.name
