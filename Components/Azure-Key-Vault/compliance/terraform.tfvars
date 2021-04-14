location                        = "__location__"
enabled_for_deployment          = "__enabled_for_deployment__"
enabled_for_disk_encryption     = "__enabled_for_disk_encryption__"
enabled_for_template_deployment = "__enabled_for_template_deployment__"
purge_protection_enabled        = "__purge_protection_enabled__"
soft_delete_retention_days        = "__soft_delete_retention_days__"
enable_rbac_authorization        = "__enable_rbac_authorization__"
network_acls = {
    bypass                     = "__bypass__"
    default_action             = "__default_action__"
    ip_rules                   = ["__ip_rules__"]
}
tags = {
  owner       = "__resource_owner__"
  costcenter  = "__cost_center_id__"
  owner_email = "__owner_email__"
}

log_analytics_sku = "__log_analytics_sku__"

subnet_name = "__subnet_name__"
virtual_network_name = "__virtual_network_name__"
vnet_resource_group_name  = "__vnet_resource_group_name__"
