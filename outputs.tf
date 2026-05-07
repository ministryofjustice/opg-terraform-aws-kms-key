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
  value       = aws_kms_replica_key.replica
}
