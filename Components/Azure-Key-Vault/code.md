# Azure Keyvault Component

| Key | Value |
|--|--|
| ComponentId | azkeyvault |
| ComponentVersion | 1.0.0 |

[[_TOC_]]

## Purpose

This repository contains terraform module that creates Azure key vault, sets its access policy and configures its diagnostic settings.

## Prerequisites

1. Terraform version 14.8+.
2. AzureRM provider version 2.52+.
3. Azure Resource group.
4. Log Analytics Workspace.

## Arguments and defaults

| Name | Type | Default | Required | Description |
|--|--|--|--|--|
| `name` | `string` | Yes | Yes | Specifies the name of the Key Vault. Changing this forces a new resource to be created. |
| `resource_group_name` | `string` | Yes | Yes | The name of the resource group in which to create the Key Vault. Changing this forces a new resource to be created. |
| `location` | `string` | "westeurope" | Yes | Specifies the supported Azure location where the resource exists. Changing this forces a new resource to be created. |
| `la_workspace_id` | `string` | null | By policy | Resource ID of an existing log analytics workspace. Providing ID enables logging |
| `purge_protection_enabled` | `bool` | true | By Policy | Specifies if Purge Protection is enabled for this Key Vault vault. |
| `soft_delete_retention_days` | `number` | 90 | By Policy | The number of days that items should be retained for once soft-deleted. This value can be between 7 and 90 (the default) days. |
| `bypass` | `string` | | By Policy | Parameter is required in network_acls block. Specifies which traffic can bypass the network rules. Possible values are AzureServices and None |
| `default_action` | `string` | | By Policy | Parameter is required in network_acls block. The Default Action to use when no rules match from ip_rules / virtual_network_subnet_ids. Possible values are Allow and Deny |
| `ip_rules` | `list(string)` | | By Policy | Parameter is optional in network_acls block. One or more IP Addresses, or CIDR Blocks which should be able to access the Key Vault. Forbidden range 10.0.0.0–10.255.255.255 (private IP addresses) |
| `virtual_network_subnet_ids` | `list(string)` | | By Policy | Parameter is optional in network_acls block. One or more Subnet ID's which should be able to access this Key Vault. Add Microsoft.KeyVault to subnet's ServiceEndpoints collection before trying to ACL Microsoft.KeyVault resources to these subnets. |
| `sku` | `string` | "standard" | No | Standard/Premium. In most cases Standard is more than enough |
| `enabled_for_deployment` | `bool` | false | No | Allow Virtual Machines to retrieve certificates stored as secrets from the key-vault. |
| `enabled_for_disk_encryption` | `bool` | false | No | Allow Disk Encryption to retrieve secrets from the vault and unwrap keys. |
| `enabled_for_template_deployment` | `bool` | false | No | Allow Resource Manager to retrieve secrets from the key vault. |
| `tags` | `map` | {} | No | Tags for resource |
| `access_policies` | `map` | [] | No | List of access policies for the key-vault. |
| `enable_rbac_authorization` | `bool` | false | No | Boolean flag to specify whether Azure Key Vault uses Role Based Access Control (RBAC) for authorization of data actions. Defaults to false |
| `eventhub_name` | `string` | null | No | Specifies the name of the Event Hub where Diagnostics Data should be sent |
| `evhauthrule` | `string` | null | No | Specifies the ID of an Event Hub Namespace Authorization Rule used to send Diagnostics Data |
| `storid` | `string` | null | No | Specifies the ID of an storage account which should be used to send the logs to |
| `diagnostic_settings` | `string` | { log = [ ["AuditEvent", true, false, 0] ] metric = [ ["AllMetrics", true, false, 0] ] } | No | Contains the diagnostics setting object |

## Usage

Calling module:

```ruby

module "key_vault" {
  source                     = "git@ssh.dev.azure.com:v3/{tenantName}/{projectName}/{KeyVaultModuleRepositoryName}?ref={branch/tag}"
  name                       = "key-vault-name"
  resource_group_name        = "resource-group-name"
  location                   = "westeurope"
  purge_protection_enabled   = true
  soft_delete_retention_days = 90
  la_workspace_id            = "/subscriptions/subscription-id/resourcegroups/resource-group-name/providers/microsoft.operationalinsights/workspaces/log-analytics-workspace-name"

  access_policies = [
    {
      object_id               = "0000-0000-0000"
      secret_permissions      = ["backup", "delete", "get", "list", "purge", "recover", "restore", "set"]
      certificate_permissions = ["backup", "create", "delete", "deleteissuers", "get", "getissuers", "import", "list", "listissuers", "managecontacts", "manageissuers", "purge", "recover", "restore", "setissuers", "update"]
      key_permissions         = ["backup", "create", "decrypt", "delete", "encrypt", "get", "import", "list", "purge", "recover", "restore", "sign", "unwrapKey", "update", "verify", "wrapKey"]
      storage_permissions     = ["backup", "delete", "deletesas", "get", "getsas", "list", "listsas", "purge", "recover", "regeneratekey", "restore", "set", "setsas", "update"]
    },
    {
      object_id               = "0000-0000-0001"
      certificate_permissions = ["create", "get", "list"]
    }
  ]

  network_acls =    {
      bypass         = "AzureServices"
      default_action = "Deny"
      ip_rules       = ["40.121.0.0/16"]
      virtual_network_subnet_ids =  [data.azurerm_subnet.main.id]
    }

  #Optional parameters
  enabled_for_deployment          = false
  enabled_for_disk_encryption     = false
  enabled_for_template_deployment = false
  sku                             = "Standard"

  #Optional Diagnostic settings - LA workspace ID is required for enablement. Other settings are optional.
  eventhub_name     = "event-hub-name"
  evhauthrule = data.azurerm_eventhub_namespace_authorization_rule.main.id
  storid      = "/subscriptions/**********/resourceGroups/resource-group-name/providers/Microsoft.Storage/storageAccounts/storage-account-name"

  #["Category name",  "Diagnostics Enabled(true/false)", "Retention Enabled(true/false)", Retention_period_days] All 4 elements are required. Even if diagnostics enabled is false.
  diagnostic_settings = {
    log = [
      ["AuditEvent", true, false, 0]
    ]
    metric = [
      ["AllMetrics", false, false, 0]
    ]
  }
}

```

Two tags are added by default

```ruby
locals {
 module_tags = {
    "ModuleName" = "AzureKeyVault",
    "ModuleVersion" = "1.0"
  }
}
```

## Outputs

| Name | Description |
|--|--|
| `id` | The ID of the Key Vault. |
| `name` | The name of the Key Vault. |
| `depended_on` | The dependencies of the Key Vault. |
| `vault_uri` | The URI of the Key Vault, used for performing operations on keys and secrets. |
