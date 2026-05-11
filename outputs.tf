output "primary_key" {
  description = "The primary region KMS key with the attributes of aws_kms_key"
  value       = aws_kms_key.primary
}

output "key_alias_name" {
  description = "The KMS key alia name for the primary and all replica keys"
  value       = aws_kms_alias.primary.name
}

output "replica_keys" {
  description = "KMS replica keys created for each region in replicas_to_create with the attributes of aws_kms_replica_key"
  value       = aws_kms_replica_key.replica
}
