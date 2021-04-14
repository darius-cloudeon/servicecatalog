terraform {
  required_version = ">= __terraformversion__"
  backend "azurerm" {
    resource_group_name  = "__backendresourcegroup__"
    storage_account_name = "__backendstorageaccount__"
    container_name       = "__backendcontainername__"
  }
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">=__provider_azurerm_ver__"
    }
    random = {
      source  = "hashicorp/random"
      version = ">=__provider_random_ver__"
    }
  }
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {}
}
