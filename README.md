# template-terraform
Template repository for all terraform module repositories

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.5 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | ~> 4.25.0 |
## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | 4.25.0 |
## Modules

No modules.
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_certificate_issuers"></a> [certificate\_issuers](#input\_certificate\_issuers) | A map of certificate issuer names to their provider names, organization IDs, account IDs, and passwords, to be used for issuing certificates in the Key Vault. | <pre>map(object({<br>    provider_name = string<br>    org_id        = optional(string)<br>    account_id    = string<br>    password      = string<br>  }))</pre> | `{}` | no |
| <a name="input_certificates"></a> [certificates](#input\_certificates) | A map of certificate names to their policies, including issuer parameters, key properties, lifetime actions, secret properties, and X.509 certificate properties, to be stored in the Key Vault. | <pre>map(object({<br>    issuer_parameters = object({<br>      name = string<br>    })<br><br>    key_properties = object({<br>      exportable = bool<br>      key_size   = number<br>      key_type   = string<br>      reuse_key  = bool<br>    })<br><br>    lifetime_action = object({<br>      action_type        = string<br>      days_before_expiry = number<br>    })<br><br>    secret_properties = object({<br>      content_type = string<br>    })<br><br>    x509_certificate_properties = object({<br>      extended_key_usage = list(string)<br>      key_usage          = list(string)<br>      subject            = string<br>      validity_in_months = number<br><br>      subject_alternative_names = object({<br>        dns_names = list(string)<br>      })<br>    })<br>  }))</pre> | `{}` | no |
| <a name="input_key_vault_name"></a> [key\_vault\_name](#input\_key\_vault\_name) | The name of the existing Azure Key Vault. | `string` | n/a | yes |
| <a name="input_keys"></a> [keys](#input\_keys) | A map of key names to their properties, such as key type, size, and optional key options and curve, to be stored in the Key Vault. | <pre>map(object({<br>    key_type = string<br>    key_size = optional(number)<br>    key_opts = optional(list(string))<br>    curve    = optional(string)<br>    rotation_policy = optional(object({<br>      expire_after         = string<br>      notify_before_expiry = string<br>      automatic = optional(object({<br>        time_before_expiry = string<br>      }))<br>    }))<br>  }))</pre> | `{}` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | The name of the resource group that contains the Key Vault. | `string` | n/a | yes |
| <a name="input_secrets"></a> [secrets](#input\_secrets) | A map of secret names to their values and optional content types to be stored in the Key Vault. | <pre>map(object({<br>    value        = string<br>    content_type = optional(string)<br>  }))</pre> | `{}` | no |  
## Outputs

| Name | Description |
|------|-------------|
| <a name="output_key_vault_uri"></a> [key\_vault\_uri](#output\_key\_vault\_uri) | key vault uri |
<!-- END_TF_DOCS -->

## Usage

```tfvars
# terraform.tfvars

# Key Vault Details
key_vault_name     = "my-keyvault"
resource_group_name = "my-resource-group"

# Secrets to be stored in the Key Vault
secrets = {
  "my-secret" = {
    value        = "supersecretvalue"
    content_type = "text/plain"
  },
  "another-secret" = {
    value = "anothersecretvalue"
  }
}

# Keys to be stored in the Key Vault
keys = {
  "my-key" = {
    key_type = "RSA"
    key_size = 2048
    key_opts = ["decrypt", "encrypt", "sign"]
    curve    = null
    rotation_policy = {
      expire_after         = "P90D"
      notify_before_expiry = "P29D"
      automatic = {
        time_before_expiry = "P30D"
      }
    }
  },
  "another-key" = {
    key_type = "EC"
    key_size = null
    key_opts = ["sign", "verify"]
    curve    = "P-256"
    rotation_policy = null
  }
}

# Certificates to be stored in the Key Vault
certificates = {
  "my-certificate" = {
    issuer_parameters = {
      name = "Self"
    }
    key_properties = {
      exportable = true
      key_size   = 2048
      key_type   = "RSA"
      reuse_key  = true
    }
    lifetime_action = {
      action_type        = "AutoRenew"
      days_before_expiry = 30
    }
    secret_properties = {
      content_type = "application/x-pkcs12"
    }
    x509_certificate_properties = {
      extended_key_usage = ["1.3.6.1.5.5.7.3.1"]
      key_usage          = ["digitalSignature", "keyEncipherment"]
      subject            = "CN=example.com"
      validity_in_months = 12
      subject_alternative_names = {
        dns_names = ["example.com", "www.example.com"]
      }
    }
  }
}

# Certificate Issuers for the Key Vault
certificate_issuers = {
  "my-issuer" = {
    provider_name = "DigiCert"
    org_id        = "12345"
    account_id    = "67890"
    password      = "issuerpassword"
  }
}

```