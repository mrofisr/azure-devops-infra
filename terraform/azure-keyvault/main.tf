data "azurerm_client_config" "current" {}

resource "random_string" "key_vault_suffix" {
  length  = 4
  upper   = false
  lower   = true
  numeric = false
  special = false
}

resource "azurerm_key_vault" "key_vault" {
  name                       = "dev-kv-${random_string.key_vault_suffix.result}"
  location                   = var.resource_group_location
  resource_group_name        = var.resource_group_name
  tenant_id                  = data.azurerm_client_config.current.tenant_id
  sku_name                   = "standard"
  soft_delete_retention_days = 7

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    certificate_permissions = [
      "Create",
      "Delete",
      "DeleteIssuers",
      "Get",
      "GetIssuers",
      "Import",
      "List",
      "ListIssuers",
      "ManageContacts",
      "ManageIssuers",
      "SetIssuers",
      "Update",
    ]

    key_permissions = [
      "Backup",
      "Create",
      "Decrypt",
      "Delete",
      "Encrypt",
      "Get",
      "Import",
      "List",
      "Purge",
      "Recover",
      "Restore",
      "Sign",
      "UnwrapKey",
      "Update",
      "Verify",
      "WrapKey",
    ]

    secret_permissions = [
      "Backup",
      "Delete",
      "Get",
      "List",
      "Purge",
      "Recover",
      "Restore",
      "Set",
    ]
  }
}

resource "azurerm_key_vault_secret" "key_vault_secret" {
  name         = var.secret_name
  value        = jsonencode(var.secret_value)
  key_vault_id = azurerm_key_vault.key_vault.id
  depends_on   = [azurerm_key_vault.key_vault]
}

# resource "azurerm_key_vault_certificate" "key_vault_certificate" {
#   name = "dev-cert"
#   certificate_policy {
#     issuer_parameters {
#       name = "Unknown"
#     }
#     key_properties {
#       exportable = true
#       key_size   = 2048
#       key_type   = "RSA"
#       reuse_key  = false
#     }
#     secret_properties {
#       content_type = "application/x-pkcs12"
#     }
#   }
#   certificate {
#     contents = filebase64("${path.module}/cert.pem")
#     password = "P@ssw0rd"
#   }
#   key_vault_id = azurerm_key_vault.key_vault.id
#   depends_on   = [azurerm_key_vault.key_vault]
# }
