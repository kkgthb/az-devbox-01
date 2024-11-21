targetScope = 'resourceGroup'

param keyVaultName string
param keyVaultEnvNickname string
param keyVaultLocation string
param consumingDevCenterPrincipalId string
param consumingDevCenterName string

var secretValue = empty(keyVaultEnvNickname) ? 'mystery' : keyVaultEnvNickname

resource kv 'Microsoft.KeyVault/vaults@2021-11-01-preview' = {
  name: keyVaultName
  location: keyVaultLocation
  properties: {
    sku: {
      name: 'standard'
      family: 'A'
    }
    tenantId: subscription().tenantId
    enableRbacAuthorization: true
    enableSoftDelete: true
    softDeleteRetentionInDays: 7
  }
}

resource secret 'Microsoft.KeyVault/vaults/secrets@2021-11-01-preview' = {
  parent: kv
  name: 'flavor'
  properties: {
    value: secretValue
  }
}

output id string = kv.id

resource kvsuRole 'Microsoft.Authorization/roleDefinitions@2018-01-01-preview' existing = {
  scope: kv
  name: '4633458b-17de-408a-b874-0445c86b69e6' // GUID for 'Key Vault Secrets User'
}

resource rasecretsuser 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  scope: kv
  name: guid(kv.id, consumingDevCenterPrincipalId, kvsuRole.id)
  properties: {
    description: 'Allows ${consumingDevCenterName} to read secrets from ${kv.name}.'
    principalId: consumingDevCenterPrincipalId
    principalType: 'ServicePrincipal'
    roleDefinitionId: kvsuRole.id
  }
}

output secretUri string = secret.properties.secretUri
