output "key_vault_uri" {
  description = "key vault uri"
  value       = data.azurerm_key_vault.this.vault_uri
}
