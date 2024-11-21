targetScope = 'subscription'

var solutionName = 'ordiboite'
var location = 'centralus'

param envNickname string

module rsrcGrp './resourcegroup.bicep' = {
  name: '${solutionName}-rg-${envNickname}'
  scope: subscription()
  params: {
    resourceGroupName: '${solutionName}-rg-${envNickname}'
    resourceGroupLocation: location
  }
}

module dc './devcenter.bicep' = {
  name: '${solutionName}-dc-${envNickname}'
  scope: resourceGroup(rsrcGrp.name)
  params: {
    dcName: '${solutionName}${envNickname}'
    dcLocation: location
  }
}

module kv './keyvault.bicep' = {
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

module dcc './devcentercatalog.bicep' = {
  name: '${solutionName}-dcc-${envNickname}'
  scope: resourceGroup(rsrcGrp.name)
  params: {
    dccName: '${solutionName}-dcc-${envNickname}'
    dcName: dc.outputs.dcName
    kvSecretUri: kv.outputs.secretUri
  }
}
