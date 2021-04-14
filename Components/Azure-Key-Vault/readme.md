# Azure Key Vault

[[_TOC_]]

* [code](code.md)
* [compliance](compliance.md)

## Authenticaion

Management plane access is via the Portal or corresponding [API](https://docs.microsoft.com/en-us/rest/api/keyvault/). Authentication is performed using Azure RBAC. Access to the management plane doesn't provide access to the artifacts, the data plane is used for that purpose.

The data plane is used to create, change, retrieve and delete artifacts in Key Vault. The authentication can be configured using bother [Access Policies](https://docs.microsoft.com/en-us/azure/key-vault/general/assign-access-policy-portal) or [Azure RBAC](https://docs.microsoft.com/en-us/azure/key-vault/general/rbac-guide). Access Policies allow for a [more granular configuration](https://docs.microsoft.com/en-us/azure/key-vault/general/rbac-migration#access-policies-templates-to-azure-roles-mapping) than the Azure RBAC built-in roles.

The data plane doesn't support the configuration of access control for individual artifacts. The most granular configuration possible is an artifact type (keys, secrets, certificates). This is one of the reason a Key Vault instance is required for each application.

|**Authentication Type**|**Support**|
|---|---|
|**Management Plane**<br/>Resource Native Users (not in AAD)<br/>AAD Users/Groups<br/>AAD Service Principals<br/>Access Keys<br/>Shared Access Signature (SAS) Tokens<br/>Managed Identities<br/>Certificates |  <br/>Not supported<br/>Supported<br/>Supported<br/>Not supported<br/>Not supported<br/>Supported<br/>Not supported |
|**Data Plane**<br/>Resource Native Users (not in AAD)<br/>AAD Users/Groups<br/>AAD Service Principals<br/>Access Keys<br/>Shared Access Signature (SAS) Tokens<br/>Managed Identities<br/> Certificates|  <br/>Not supported<br/>Supported<br/>Supported<br/>Not supported<br/>Not supported<br/>Supported<br/>Not supported |

## Backup

Key Vault offers the capability to [backup and restore individual artefacts](https://docs.microsoft.com/en-us/azure/key-vault/general/backup). The downloaded backup file is encrypted and can only be restored to a Key Vault in the same Subscription.

Key Vault has built-in [DR capabilities](https://docs.microsoft.com/en-us/azure/key-vault/general/disaster-recovery-guidance) and offers a [Soft Delete feature](https://docs.microsoft.com/en-us/azure/key-vault/general/soft-delete-overview). This should offer ample protection and thus making the need for backups obsolete. Also, a backed-up artifact is a snapshot at a given point in time. The backup looses its validity as soon as the artifact in Key Vault is change, e.g. by Key Rotation.

## Data and Encryption

## Capturing and Storage of Data

Artifacts can be managed in Key Vault using the Azure Portal or programmatically using REST APIs. For all MACD on artifacts, data plane access is required.  

[Customer Lockbox](https://docs.microsoft.com/en-us/azure/security/fundamentals/customer-lockbox-overview) is not supported for Key Vault.

### Encryption in Transit

Access to Key Vault is by use of TLS only.

### Encryption at rest

Secrets and keys are safeguarded by Azure, using industry-standard algorithms, key lengths, and hardware security modules (HSMs). The HSMs used are Federal Information Processing Standards (FIPS) 140-2 Level 2 validated.

## Role Based Access Control

Both the management plane and the data plane support Azure RBAC. In addition the data plane also supports Key Vault policies that are configured on operations level and are more granular compared to Azure RBAC.

### Available Roles

|Type | Management Plane | Data Plane |
|--|--|--|
|Azure Roles - built-in | [Key Vault Contributor](https://docs.microsoft.com/en-us/azure/role-based-access-control/built-in-roles#key-vault-contributor) | [KeyVault Administrator]( https://docs.microsoft.com/en-us/azure/role-based-access-control/built-in-roles#key-vault-administrator-preview) <BR/>[KeyVault Certificates Officer]( https://docs.microsoft.com/en-us/azure/role-based-access-control/built-in-roles#key-vault-certificates-officer-preview) <BR/>[KeyVault Crypto Officer]( https://docs.microsoft.com/en-us/azure/role-based-access-control/built-in-roles#key-vault-crypto-officer-preview) <BR/>[KeyVault Crypto Service Encryption User]( https://docs.microsoft.com/en-us/azure/role-based-access-control/built-in-roles#key-vault-crypto-service-encryption-preview) <BR/>[KeyVault Crypto User]( https://docs.microsoft.com/en-us/azure/role-based-access-control/built-in-roles#key-vault-crypto-user-preview) <BR/>[KeyVault Reader]( https://docs.microsoft.com/en-us/azure/role-based-access-control/built-in-roles#key-vault-reader-preview) <BR/>[KeyVault Secrets Officer]( https://docs.microsoft.com/en-us/azure/role-based-access-control/built-in-roles#key-vault-secrets-officer-preview) <BR/>[KeyVault Secrets User]( https://docs.microsoft.com/en-us/azure/role-based-access-control/built-in-roles#key-vault-secrets-user-preview) |
|Azure Roles - custom | - | - |
|Resource Native Roles | - | [Key Vault Access Control Policies](https://docs.microsoft.com/en-us/azure/key-vault/key-vault-group-permissions-for-apps) |

[Resource Provider Operations](https://docs.microsoft.com/en-us/azure/role-based-access-control/resource-provider-operations#microsoftkeyvault).

## Network Connectivity

There are multiple options to implement [network access control](https://docs.microsoft.com/en-us/azure/key-vault/general/network-security) for Key Vault.

### Access from Internet

By default, access from the Internet to Key Vault is permitted. Optionally, a range of public IP addresses can be granted access to the Key Vault.

### Access from VNET using Service Endpoints

If a Microsoft.KeyVault VNET Service Endpoint is enabled on a subnet, traffic from that subnet will switch the source address from the public to the private IP. However, access to the Key Vault is possible only if that same Subnet is also configured on the firewall. If this is not the case, connectivity can't be established.

### Access from VNET and on-premise using Private Endpoints

Access from on-premise resources using the private address space requires the configuration of a Private Endpoint. This will essentially create a NIC with a private IP and a DNS entry. Depending on the DNS setup for resources in Azure, the Azure private DNS can be used or an entry is created in the on-premise DNS service.

| Connectivity Option | Support Status |
| -- | -- |
| Internet | Supported |
| Internet with Firewall | Supported |
| [VNET Injection](https://docs.microsoft.com/en-us/azure/virtual-network/virtual-network-for-azure-services) | Not supported |
| [VNET Service Endpoints](https://docs.microsoft.com/en-us/azure/virtual-network/virtual-network-service-endpoints-overview) | Supported |
| [VNET Service Endpoint with Policies](https://docs.microsoft.com/en-us/azure/virtual-network/virtual-network-service-endpoint-policies-overview) | Not supported |
| [Private Endpoint](https://docs.microsoft.com/en-us/azure/private-link/private-endpoint-overview) | Supported |

## Monitoring

### Security

[Audit Events](https://docs.microsoft.com/en-us/azure/key-vault/key-vault-logging) are forwarded to a Log Analytics workspace.

### Expiration

Monitor expiration of Key, Certificates and Secrets.

### Backup Monitoring

There is not automated backup to be monitored. Backup is essentially a manual export of the artifacts.

### Availability

Key Vault is replicated to the paired Azure Region. In case of a failure, the Azure Operate team will initiate the failover. There is no interaction to be performed by Azure users, the same Key Vault URLs remain valid.
