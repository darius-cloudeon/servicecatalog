data "azurerm_client_config" "main" {}

resource "azurerm_key_vault" "main" {
  name                       = var.name
  location                   = var.location
  resource_group_name        = var.resource_group_name
  tenant_id                  = data.azurerm_client_config.main.tenant_id
  purge_protection_enabled   = var.purge_protection_enabled
  soft_delete_retention_days = var.soft_delete_retention_days
  enable_rbac_authorization  = var.enable_rbac_authorization

  enabled_for_deployment          = var.enabled_for_deployment
  enabled_for_disk_encryption     = var.enabled_for_disk_encryption
  enabled_for_template_deployment = var.enabled_for_template_deployment

  sku_name = var.sku
  tags     = merge(var.tags, var.module_tags)

  dynamic "network_acls" {
    for_each = var.network_acls == null ? [] : list(var.network_acls)
    iterator = acl
    content {
      bypass                     = coalesce(acl.value.bypass, "None")
      default_action             = coalesce(acl.value.default_action, "Deny")
      ip_rules                   = acl.value.ip_rules
      virtual_network_subnet_ids = acl.value.virtual_network_subnet_ids
    }
  }
}

resource "azurerm_key_vault_access_policy" "main" {
  depends_on   = [azurerm_key_vault.main]
  count        = length(var.access_policies)
  key_vault_id = azurerm_key_vault.main.id
  tenant_id    = data.azurerm_client_config.main.tenant_id
  object_id    = var.access_policies[count.index].object_id

  secret_permissions      = var.access_policies[count.index].secret_permissions
  key_permissions         = var.access_policies[count.index].key_permissions
  certificate_permissions = var.access_policies[count.index].certificate_permissions
  storage_permissions     = var.access_policies[count.index].storage_permissions
}

resource "azurerm_monitor_diagnostic_setting" "main" {
  depends_on                     = [azurerm_key_vault.main]
  name                           = format("%s-analytics", var.name)
  target_resource_id             = azurerm_key_vault.main.id
  log_analytics_workspace_id     = var.la_workspace_id
  eventhub_name                  = var.eventhub_name
  eventhub_authorization_rule_id = var.evhauthrule
  storage_account_id             = var.storid

  dynamic "log" {
    for_each = var.diagnostic_settings.log
    content {
      category = log.value[0]
      enabled  = log.value[1]
      retention_policy {
        enabled = log.value[2]
        days    = log.value[3]
      }
    }
  }

  dynamic "metric" {
    for_each = var.diagnostic_settings.metric
    content {
      category = metric.value[0]
      enabled  = metric.value[1]
      retention_policy {
        enabled = metric.value[2]
        days    = metric.value[3]
      }
    }
  }
}
