targetScope = 'subscription'

var solutionName = 'ordiboite'
var location = 'centralus'

param envNickname string

module rsrcGrp './100-resourcegroup.bicep' = {
  name: '${solutionName}-rg-${envNickname}'
  scope: subscription()
  params: {
    resourceGroupName: '${solutionName}-rg-${envNickname}'
    resourceGroupLocation: location
  }
}

module dc './200-devcenter.bicep' = {
  name: '${solutionName}-dc-${envNickname}'
  scope: resourceGroup(rsrcGrp.name)
  params: {
    dcName: '${solutionName}-dc-${envNickname}'
    dcLocation: location
  }
}

module dcd './230-devcenterdefinition.bicep' = {
  name: '${solutionName}-dcd-${envNickname}'
  scope: resourceGroup(rsrcGrp.name)
  params: {
    dcdName: '${solutionName}-dcd-${envNickname}'
    dcdLocation: location
    dcName: dc.outputs.dcName
  }
}

module kv './278-keyvault.bicep' = {
  name: '${solutionName}-kv-${envNickname}'
  scope: resourceGroup(rsrcGrp.name)
  params: {
    keyVaultName: '${solutionName}-kv-${envNickname}'
    keyVaultEnvNickname: envNickname
    keyVaultLocation: location
    consumingDevCenterPrincipalId: dc.outputs.dcPrincipalId
    consumingDevCenterName: dc.outputs.dcName
  }
}

module dcc './279-devcentercatalog.bicep' = {
  name: '${solutionName}-dcc-${envNickname}'
  scope: resourceGroup(rsrcGrp.name)
  params: {
    dccName: '${solutionName}-dcc-${envNickname}'
    dcName: dc.outputs.dcName
    kvSecretUri: kv.outputs.secretUri
  }
}
