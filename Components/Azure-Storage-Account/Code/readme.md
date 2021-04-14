# Azure Storage Component

**Component Id:** azstorageaccount  
**Version:** [1.0](https://dev.azure.com/{tenantName}/CCoE/_git/azure-stor-module?version=GT1.0)  
![Azure pipeline succeeded.](./../images/azurepipelinessucceeded.png)

## Purpose

This repo contains a terraform module that creates a Storage account. Multiple instances of containers, blobs, queues and table storage kind are supported.

## Prerequisites

1. Terraform version 13.3+
2. AzureRM provider version 2.29+
3. Resource group

## Arguments and defaults

| Name | Type | Default | Description |
| --------------------------------- | -------- | -------- | ------------------------------------------------------------------------------------------- |
| `name` | `string` |  | **Required**  Specifies the name of the storage account. Changing this forces a new resource to be created. This must be unique across the entire Azure service, not just within the resource group. |
| `resource_group_name` | `string` |          | **Required** The name of the resource group in which to create the storage account. Changing this forces a new resource to be created.     |
| `location` | `string` |         | **Required** Specifies the supported Azure location where the resource exists. Changing this forces a new resource to be created. |
| `account_tier` | `string` | "Standard" | Defines the Tier to use for this storage account. Valid options are Standard and Premium. For BlockBlobStorage and FileStorage accounts only Premium is valid. Changing this forces a new resource to be created. |
| `account_replication_type`          | `string`   | "LRS"   | Defines the type of replication to use for this storage account. Valid options are LRS, GRS, RAGRS, ZRS, GZRS and RAGZRS.       |
| `access_tier`     | `string`   | "Hot"    | Defines the access tier for BlobStorage, FileStorage and StorageV2 accounts. Valid options are Hot and Cool, defaults to Hot.                   |
| `account_kind` | `string`   | "StorageV2"    | Defines the Kind of account. Valid options are BlobStorage, BlockBlobStorage, FileStorage, Storage and StorageV2. Changing this forces a new resource to be created. Defaults to StorageV2. |
| `is_hns_enabled` | `bool`   | false  | Is Hierarchical Namespace enabled? This can be used with Azure Data Lake Storage Gen 2 (see here for more information). Changing this forces a new resource to be created.|
| `tags`                            | `map`    |    {}      | Tags for resource |
| `https_only`                 | `bool`    |      true    | HTTPS protocol only.                                                  |
| `dependencies`                    | `list`   | null     | Parent resource outputs on which this module depends on                                     |
| `assign_identity`                 | `bool` | true     | Assign a system identity.            |
| `blobs` | `list(any)` | []     | A list of blobs. |
| `blob_retention_days` | `integer` | 0 | Number of delete retention days |
| `containers`                     | `list(object({ name = string access_type = string })` | []     | List of container objects. |
| `queues`                          | `list(string)` | []    | List of queues. |
| `shares`             | `list(object({ name = string quota = number }))` |     []     | List of shares objects. |
| `tables`             | `list(string)` |     []     | List of tables. |

## Usage

Calling module:

```ruby

module "blob-example" { 
  source                   = "git@ssh.dev.azure.com:v3/{tenantName}/CCoE/azure-stor-module?ref=1.4"
  name                     = "storexampleunique12345" 
  resource_group_name      = "rg-example"
  account_tier             = "Standard"
  account_replication_type = "LRS"
  access_tier              = "Cool"
  blob_retention_days      = 7
  containers = [
    {
      name        = "example-container"
      access_type = "private"
    }
  ]
  shares = [
    {
      name  = "example-share"
      quota = 1
    }
  ]
  blobs = [
    {
      name           = "example-blob"
      container_name = "example-container"
    }
  ]
  queues = ["example-queue1", "example-queue2"]
  table = ["example-table1", "example-table2"]
}

module "container-DLG2-example" { 
  source                   = "git@ssh.dev.azure.com:v3/{tenantName}/CCoE/azure-stor-module?ref=1.4"
  name                     = "storexampleunique12345" 
  resource_group_name      = "rg-example"
  account_tier             = "Standard"
  account_replication_type = "LRS"
  access_tier              = "Cool"
  is_hns_enabled           = true
  containers = [
    {
      name        = "example-container"
      access_type = "private"
    }
  ]
}

```

Two tags are added by default:

```powershell
    "ModuleName" = "AzureStorageAccount", 
    "ModuleVersion" = "1.4" 
}
```

Minumum TLS version is by default 1.2.

## Outputs

| Name                      | Description                                                                                               |
|---------------------------|-----------------------------------------------------------------------------------------------------------|
| `id` | The SQL Server ID. |
| `name` | The SQL Server name. |
| `depended_on` | The SQL Server dependencies. |
| `primary_connection_string` | The connection string associated with the primary location. |
| `primary_access_key` | The primary access key for the storage account. |
| `primary_blob_endpoint` | The endpoint URL for blob storage in the primary location. |
| `containers` | The `azurerm_storage_container` in the blob storage. |
| `shares` | The `azurerm_storage_share` in the blob storage. |
| `tables` | The `azurerm_storage_table` in the blob storage. |
