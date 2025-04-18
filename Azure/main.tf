provider "azurerm" {
  features {}
    subscription_id = "a0f83009-96b4-4229-b3d4-8eb8568e0d94"
}

data "azurerm_client_config" "current" {}

resource "random_integer" "rand" {
  min = 10000
  max = 99999
}

resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
}

resource "azurerm_storage_account" "webstorage" {
  name                     = "web${random_integer.rand.result}"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  static_website {
    index_document = "index.html"
  }
}

resource "azurerm_storage_blob" "index" {
  name                   = "index.html"
  storage_account_name   = azurerm_storage_account.webstorage.name
  storage_container_name = "$web"
  type                   = "Block"
  source                 = "${path.module}/index.html"
  content_type           = "text/html"
}

resource "azurerm_key_vault" "example" {
  name                        = "kv${random_integer.rand.result}"
  location                    = azurerm_resource_group.rg.location
  resource_group_name         = azurerm_resource_group.rg.name
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  sku_name                    = "standard"
  soft_delete_enabled         = true
  purge_protection_enabled    = false

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    secret_permissions = [
      "get",
      "list",
      "set",
    ]
  }

  depends_on = [azurerm_storage_account.webstorage]
}

resource "azurerm_key_vault_secret" "example" {
  name         = "project-api-key"
  value        = "Password"
  key_vault_id = azurerm_key_vault.example.id
}




