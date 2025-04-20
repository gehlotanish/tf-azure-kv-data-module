resource "azurerm_key_vault_secret" "main" {
  for_each     = var.secrets
  name         = each.key
  value        = each.value.value
  key_vault_id = data.azurerm_key_vault.main.id
  content_type = try(each.value.content_type, null)
}

resource "azurerm_key_vault_key" "main" {
  for_each     = var.keys
  name         = each.key
  key_vault_id = data.azurerm_key_vault.main.id

  key_type = each.value.key_type
  key_size = try(each.value.key_size, null)
  key_opts = try(each.value.key_opts, null)
  curve    = try(each.value.curve, null)

  dynamic "rotation_policy" {
    for_each = each.value.rotation_policy != null ? [each.value.rotation_policy] : []
    content {
      expire_after         = rotation_policy.value.expire_after
      notify_before_expiry = rotation_policy.value.notify_before_expiry

      dynamic "automatic" {
        for_each = rotation_policy.value.automatic != null ? [rotation_policy.value.automatic] : []
        content {
          time_before_expiry = automatic.value.time_before_expiry
        }
      }
    }
  }
}


resource "azurerm_key_vault_certificate" "main" {
  for_each     = var.certificates
  name         = each.key
  key_vault_id = data.azurerm_key_vault.main.id

  certificate_policy {
    issuer_parameters {
      name = each.value.issuer_parameters.name
    }

    key_properties {
      exportable = each.value.key_properties.exportable
      key_size   = each.value.key_properties.key_size
      key_type   = each.value.key_properties.key_type
      reuse_key  = each.value.key_properties.reuse_key
    }

    lifetime_action {
      action {
        action_type = each.value.lifetime_action.action_type
      }

      trigger {
        days_before_expiry = each.value.lifetime_action.days_before_expiry
      }
    }

    secret_properties {
      content_type = each.value.secret_properties.content_type
    }

    x509_certificate_properties {
      extended_key_usage = each.value.x509_certificate_properties.extended_key_usage
      key_usage          = each.value.x509_certificate_properties.key_usage
      subject            = each.value.x509_certificate_properties.subject
      validity_in_months = each.value.x509_certificate_properties.validity_in_months

      subject_alternative_names {
        dns_names = each.value.x509_certificate_properties.subject_alternative_names.dns_names
      }
    }
  }
}


resource "azurerm_key_vault_certificate_issuer" "main" {
  for_each      = var.certificate_issuers
  name          = each.key
  key_vault_id  = data.azurerm_key_vault.main.id
  provider_name = each.value.provider_name
  org_id        = try(each.value.org_id, null)
  account_id    = each.value.account_id
  password      = each.value.password
}
