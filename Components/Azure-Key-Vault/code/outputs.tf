output "id" {
  value       = azurerm_key_vault.main.id
  description = "The ID of the Key Vault."
}

output "name" {
  value       = azurerm_key_vault.main.name
  description = "The name of the Key Vault."
}

output "vault_uri" {
  value       = azurerm_key_vault.main.vault_uri
  description = "The URI of the Key Vault."
}

output "access_policy" {
  value = azurerm_key_vault_access_policy.main
  description = "Azure Key Vault Access Policy"
}