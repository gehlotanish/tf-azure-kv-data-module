variable "key_vault_name" {
  description = "The name of the existing Azure Key Vault."
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group that contains the Key Vault."
  type        = string
}

variable "secrets" {
  description = "A map of secret names to their values and optional content types to be stored in the Key Vault."
  type = map(object({
    value        = string
    content_type = optional(string)
  }))
  default = {}
}

variable "keys" {
  description = "A map of key names to their properties, such as key type, size, and optional key options and curve, to be stored in the Key Vault."
  type = map(object({
    key_type = string
    key_size = optional(number)
    key_opts = optional(list(string))
    curve    = optional(string)
    rotation_policy = optional(object({
      expire_after         = string
      notify_before_expiry = string
      automatic = optional(object({
        time_before_expiry = string
      }))
    }))
  }))
  default = {}
}

variable "certificates" {
  description = "A map of certificate names to their policies, including issuer parameters, key properties, lifetime actions, secret properties, and X.509 certificate properties, to be stored in the Key Vault."
  type = map(object({
    issuer_parameters = object({
      name = string
    })

    key_properties = object({
      exportable = bool
      key_size   = number
      key_type   = string
      reuse_key  = bool
    })

    lifetime_action = object({
      action_type        = string
      days_before_expiry = number
    })

    secret_properties = object({
      content_type = string
    })

    x509_certificate_properties = object({
      extended_key_usage = list(string)
      key_usage          = list(string)
      subject            = string
      validity_in_months = number

      subject_alternative_names = object({
        dns_names = list(string)
      })
    })
  }))
  default = {}
}

variable "certificate_issuers" {
  description = "A map of certificate issuer names to their provider names, organization IDs, account IDs, and passwords, to be used for issuing certificates in the Key Vault."
  type = map(object({
    provider_name = string
    org_id        = optional(string)
    account_id    = string
    password      = string
  }))
  default = {}
}
