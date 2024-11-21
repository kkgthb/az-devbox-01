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
    dccName: '${solutionName}-dcc-${envNickname}'
  }
}
