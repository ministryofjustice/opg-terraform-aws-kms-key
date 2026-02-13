variable "administrator_roles" {
  description = "List of Role ARNs allowed to administer the KMS Key"
  type        = list(string)
}

variable "alias" {
  description = "KMS Key Alias"
  type        = string
}
variable "description" {
  description = "KMS Key Description"
  type        = string
}

variable "custom_addition_permissions" {
  description = "JSON BLOB of Additional Custom Permisisons to be merged with the main key policy."
  type        = string
  default     = ""
}

variable "decryption_roles" {
  description = "List of Role ARNs allowed to use the KMS Key for Decryption"
  type        = list(string)
}

variable "encryption_roles" {
  description = "List of Role ARNs allowed to use the KMS Key for Encryption"
  type        = list(string)
}

variable "grant_roles" {
  description = "Principals allowed to create KMS grants for AWS resources using the KMS Key"
  type        = list(string)
}
variable "usage_services" {
  description = "List of AWS Service that allow the usage role to use the KMS key"
  default     = []
  type        = list(string)
}

variable "deletion_window" {
  description = "KMS Key deletion window"
  type        = number
  default     = 7
}

variable "caller_accounts" {
  description = "List of AWS Account IDs allowed to use the KMS Key via AWS Service"
  type        = list(string)
  default     = []
}

variable "admin_decrypt_permission" {
  description = "Allow administrators to have permissions to use the KMS Key for Decryption"
  type        = bool
  default     = false
}

variable "primary_region" {
  description = "The AWS Region e.g. eu-west-1 where primary key is created"
  type        = string
}
variable "enable_replication" {
  description = " Choose whether to create replica keys in other regions"
  type        = bool
  default     = false
}

variable "replicas_to_create" {
  description = "Map of KMS aliases from Primary region to create replica keys in Replica region"
  type = map(object({
    alias  = string # Alias for the KMS Key in the primary region
    policy = string # Policy for the KMS Key in the primary region
  }))
  default = {}
}
