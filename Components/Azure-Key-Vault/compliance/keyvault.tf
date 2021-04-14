resource "random_id" "randomidkv" {
  byte_length = 4
}

data "azurerm_client_config" "main" {}

data "azurerm_subnet" "main" {
  name                 = var.subnet_name
  virtual_network_name = var.virtual_network_name
  resource_group_name  = var.vnet_resource_group_name
}

module "resource_group" {
  source   = "git@ssh.dev.azure.com:v3/__tenant__/__project_name__/__resource_group_module_name__?ref=__resource_group_module_branch__"
  name     = "rg-key-vault-${random_id.randomidkv.hex}"
  location = var.location
  tags     = var.tags
}

module "log_analytics_workspace" {
  source              = "git@ssh.dev.azure.com:v3/__tenant__/__project_name__/__log_analytics_workspace_module_name__?ref=__log_analytics_workspace_module_branch__"
  name                = "la-key-vault-${random_id.randomidkv.hex}"
  resource_group_name = module.resource_group.name
  location            = var.location
  tags                = var.tags
  sku                 = var.log_analytics_sku
}

module "key_vault" {
  source                          = "git@ssh.dev.azure.com:v3/__tenant__/__project_name__/__key_vault_module_name__?ref=__key_vault_module_branch__"
  name                            = "key-vault-${random_id.randomidkv.hex}"
  resource_group_name             = module.resource_group.name
  location                        = var.location
  enabled_for_deployment          = var.enabled_for_deployment
  enabled_for_disk_encryption     = var.enabled_for_disk_encryption
  enabled_for_template_deployment = var.enabled_for_template_deployment
  purge_protection_enabled        = var.purge_protection_enabled
  soft_delete_retention_days      = var.soft_delete_retention_days
  tags                            = var.tags
  la_workspace_id                 = module.log_analytics_workspace.id
  enable_rbac_authorization       = var.enable_rbac_authorization

  access_policies = [
    {
      object_id               = data.azurerm_client_config.main.object_id
      secret_permissions      = ["backup", "delete", "get", "list", "purge", "recover", "restore", "set"]
      certificate_permissions = ["backup", "create", "delete", "deleteissuers", "get", "getissuers", "import", "list", "listissuers", "managecontacts", "manageissuers", "purge", "recover", "restore", "setissuers", "update"]
      key_permissions         = ["backup", "create", "decrypt", "delete", "encrypt", "get", "import", "list", "purge", "recover", "restore", "sign", "unwrapKey", "update", "verify", "wrapKey"]
      storage_permissions     = ["backup", "delete", "deletesas", "get", "getsas", "list", "listsas", "purge", "recover", "regeneratekey", "restore", "set", "setsas", "update"]
    }
  ]

  network_acls = merge(var.network_acls, { "virtual_network_subnet_ids" = [data.azurerm_subnet.main.id] })

}

