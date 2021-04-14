# Supported Patterns

## Internet Facing

The Key Vault is accessible from the Internet only. This supports Logic Tiers that are hosted on-premise, in Azure or on the Internet.

![Key Vault](/Components/Key-Vault/InternetFacing.png =700x)

### Resource Group

The Key Vault instance is deployed into the same Resource Group as all other resources associated with the business application. Additional resources located in Resource Groups of the Hub Subscription, such as a central Log Analytics workspace to collect all Azure Activities are not shown.

There is no RBAC defined on Resource Group or Resource level. Access on the management plane is reserved to the Azure Operate team and inherited from the Subscription RBAC. Policies are not applied.

#### Key Vault - Firewall

The firewall of the Key Vault is configured to allow traffic from all networks. However, this applies to the Internet only as there is not accessibility from within the VNET.

#### Key Vault - Access Policies

Access Policies are configured for access by users and the Logic Tier.

#### Logic Tier

Access from the Logic Tier is via the Azure backbone if located in Azure or the Internet if outside of Azure. Authentication is by use of Managed Identity or a Service Principal if hosted outside Azure or in a different Azure AD tenant than the Key Vault.

#### Log Analytics Workspace

The AzureDiagnostics and AzureMetrics are forwarded to the business application specific Log Analytics workspace in the Resource Group.

Azure Activities of all Subscriptions are forwarded to the central Log Analytics workspace in the Hub Subscription (not shown in diagram).

#### Azure Active Directory

In Azure AD a security groups and Service Principals are maintained to grant management plane and data plane access for developers/operations and the Logic Tier.

### VNET Integrated

The Key Vault is accessible from the VNET only, access from the Internet is not permitted. There is no Private Endpoint configured, access using a private IP address is not supported. This supports Logic Tiers that are hosted in Azure VNETs.

![Key Vault](/Components/Key-Vault/VnetIntegrated.png =700x)

Only differences and additions to above design pattern are listed.

#### Key Vault and Logic Tier VNET Integration

The Key Vault is integrated into Subnets using VNET Service Endpoints (Microsoft.KeyVault). This makes the Key Vault accessible to other resources in the VNET - but not to on-premise services.

The Logic Tier needs to be integrated into a VNET to enable access to the Key Vault.

### Private IP

The Key Vault is accessible from the VNET and on-premise, access from the Internet is not permitted. There is a Private Endpoint configured, permitting the use of a private IP address by on-premise resources. This supports Logic Tiers that are hosted in Azure VNETs and on-premise.

![Key Vault](/Components/Key-Vault/PrivateIp.png =700x)

Only differences and additions to above design pattern are listed.

#### Private Endpoint

A Private Endpoint is configured into the Subnet, along with an Azure Private DNS entry. For IaaS or on-premise resources to be able to resolve private DNS entries a DNS Conditional Forwarding for privatelink.vaultcore.azure.net needs to be configured on the on-premise DNS service. An alternate solution would be the configuration of the DNS entry in the on-premise DNS solution.
