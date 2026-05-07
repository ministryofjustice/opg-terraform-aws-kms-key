output "primary_key" {
  description = "The primary region KMS key with the attributes of aws_kms_key"
  value       = aws_kms_key.primary
}

output "key_alias" {
  description = "The KMS key alias for the primary and all replica keys"
  value       = "alias/${var.alias}"
}

output "replica_keys" {
  description = "All KMS replica keys created in other regions with the attributes of aws_kms_replica_key"
  value       = values(aws_kms_replica_key.replica)[*]
}

output "replica_keys_set" {
  description = "All KMS replica keys created in other regions with the attributes of aws_kms_replica_key"
  value       = toset(aws_kms_replica_key.replica[*])
}

output "replica_keys_setoutside" {
  description = "All KMS replica keys created in other regions with the attributes of aws_kms_replica_key"
  value       = toset(aws_kms_replica_key.replica)[*]
}

output "replica_key_for" {
  description = "All KMS replica keys created in other regions with the attributes of aws_kms_replica_key"
  value       = { for region, replica in aws_kms_replica_key.replica[*] : region => replica }
}

output "replica_key_map" {
  description = "All KMS replica keys created in other regions with the attributes of aws_kms_replica_key"
  value = {
    eu-west-1 = aws_kms_replica_key.replica["eu-west-1"]
  }
}
