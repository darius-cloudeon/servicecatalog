terraform {
  required_version = ">= 0.13.3"
  backend "azurerm" {
    resource_group_name  = "rg-terraform"
    storage_account_name = ""
    container_name       = "platform"
  }
}
provider "azurerm" {
  version = "=2.29.0"
  features {}
  subscription_id = var.subscription_id == "null" ? null : var.subscription_id
}
provider "random" {
  version = "=2.3.0"
}