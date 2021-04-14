variable "environment" {
  type        = string
  default     = "dev"
  description = "Short name of environemt ex.: dev, prod, shared"
}

variable "location" {
  type        = string
  default = "westeurope"
  description = "Azure region for the Key Vault."
}

variable "sku" {
  type        = string
  default     = "standard"
  description = "The name of the SKU used for the Key Vault. The options are: `standard`, `premium`."
}

variable "enabled_for_deployment" {
  type        = bool
  default     = false
  description = "Allow Virtual Machines to retrieve certificates stored as secrets from the key vault."
}

variable "enabled_for_disk_encryption" {
  type        = bool
  default     = false
  description = "Allow Disk Encryption to retrieve secrets from the vault and unwrap keys."
}

variable "purge_protection_enabled" {
  type        = bool
  default     = true
  description = "Specifies if Purge Protection is enabled for this Key Vault"
}

variable "enabled_for_template_deployment" {
  type        = bool
  default     = false
  description = "Allow Resource Manager to retrieve secrets from the key vault."
}

variable "access_policies" {
  type        = any
  default     = []
  description = "List of access policies for the Key Vault."
}

variable "tags" {
  type        = map(any)
  default     = {}
  description = " A mapping of tags to assign to the resource."
}

variable "module_tags" {
  type = map(any)
  default = {
    ModuleName    = "azkeyvault",
    ModuleVersion = " "
  }
  description = "Default module tags"
}

variable "dependencies" {
  type        = list(any)
  default     = []
  description = "Parent resource outputs on which this module depends on"
}

variable "la_workspace_id" {
  type        = string
  default     = null
  description = "Resource ID of an existing log analytics workspace. Providing ID enables logging"
}

variable "eventhub_name" {
  type        = string
  default     = null
  description = "Specifies the name of the Event Hub where Diagnostics Data should be sent"
}

variable "evhauthrule" {
  type        = string
  default     = null
  description = "Specifies the ID of an Event Hub Namespace Authorization Rule used to send Diagnostics Data"
}

variable "storid" {
  type        = string
  default     = null
  description = "With this parameter you can specify a storage account which should be used to send the logs to. Parameter must be a valid Azure Resource ID"
}

variable "diagnostic_settings" {
  default = {
    log = [
      ["AuditEvent", true, false, 0]
    ]
    metric = [
      ["AllMetrics", true, false, 0]
    ]
  }
  description = "Contains the diagnostics setting object"
}

variable "network_acls" {
  type = object({
    bypass                     = string,
    default_action             = string,
    ip_rules                   = list(string),
  })
  default = null
}

variable "soft_delete_retention_days" {
  type        = number
  default     = 90
  description = "The number of days that items should be retained for once soft-deleted. This value can be between 7 and 90 (the default) days."
}

variable "enable_rbac_authorization" {
  type        = bool
  default     = false
  description = " Boolean flag to specify whether Azure Key Vault uses Role Based Access Control (RBAC) for authorization of data actions. Defaults to false"
}

variable "log_analytics_sku" {
  type        = string
  default     = "Free"
  description = "Specifies the Sku of the Log Analytics Workspace. Possible values are Free, PerNode, Premium, Standard, Standalone, Unlimited, CapacityReservation, and PerGB2018 (new Sku as of 2018-04-03). Defaults to PerGB2018."
}

variable "subnet_name" {
  type        = string
  default     = "default"
  description = "Testing subnet"
}

variable "virtual_network_name" {
  type        = string
  default     = "vnet-ccoe-we"
  description = "Testing vnet"
}

variable "vnet_resource_group_name" {
  type        = string
  default     = "rg-vnet-we"
  description = "Testing vnet resource group"
}
