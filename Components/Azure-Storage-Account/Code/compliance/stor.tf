resource "random_string" "randomstringstor" {
  length = 10
  special = false
}

module "rg-stor" {
  source     = "git@ssh.dev.azure.com:v3/energinet/CCoE/azure-rg-module?ref=1.5"
  name       = "rg-stor-${random_string.randomstringstor.result}"
  location   = var.location
  deletelock = false
  tags       = local.management-tags
}

module "stor" { 
  source                   = "git@ssh.dev.azure.com:v3/energinet/CCoE/azure-stor-module?ref=1.3"
  name                     = lower("storageaccount${random_string.randomstringstor.result}")
  resource_group_name      = module.rg-stor.resource-group-name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  access_tier              = "Cool"
  is_hns_enabled           = false
  dependencies             = ["${module.rg-stor.depended_on}"]
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
  queues = ["examplequeue1", "examplequeue2"]
  tables = ["exampletable1", "exampletable2"]
}

data "null_data_source" "output_and_dependency_test" {
  depends_on = [module.stor.depended_on]

  inputs = {
    id = module.stor.id,
    name = module.stor.name,
    primary_connection_string = module.stor.primary_connection_string,
    primary_access_key = module.stor.primary_access_key,
    primary_blob_endpoint = module.stor.primary_blob_endpoint,
    shares = module.stor.shares["example-share"].id,
    containers = module.stor.containers["example-container"].id,
    tables = module.stor.tables["exampletable1"],
  }
}