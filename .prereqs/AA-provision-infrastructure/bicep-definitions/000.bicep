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

module kv './203-keyvault.bicep' = {
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

module dcc './204-catalog.bicep' = {
  name: '${solutionName}-dcc-${envNickname}'
  scope: resourceGroup(rsrcGrp.name)
  params: {
    dccName: '${solutionName}-dcc-${envNickname}'
    dcName: dc.outputs.dcName
    kvSecretUri: kv.outputs.secretUri
  }
}

module dcd './210-boxdefinition.bicep' = {
  name: '${solutionName}-dcd-${envNickname}'
  scope: resourceGroup(rsrcGrp.name)
  params: {
    dcdName: '${solutionName}-dcd-${envNickname}'
    dcdLocation: location
    dcName: dc.outputs.dcName
  }
}

module dcet './220-envtype.bicep' = {
  name: '${solutionName}-dcet-${envNickname}'
  scope: resourceGroup(rsrcGrp.name)
  params: {
    dcetName: '${solutionName}-dcet-${envNickname}'
    dcName: dc.outputs.dcName
  }
}

module dcpr './240-project.bicep' = {
  name: '${solutionName}-dcpr-${envNickname}'
  scope: resourceGroup(rsrcGrp.name)
  params: {
    dcprName: '${solutionName}-dcpr-${envNickname}'
    dcprLocation: location
    dcId: dc.outputs.dcId
  }
}

module dcpl './250-pool.bicep' = {
  name: '${solutionName}-dcpl-${envNickname}'
  scope: resourceGroup(rsrcGrp.name)
  params: {
    dcplName: '${solutionName}-dcpl-${envNickname}'
    dcplLocation: location
    dcdName: dcd.outputs.dcdName
    dcprName: dcpr.outputs.dcprName
  }
}
