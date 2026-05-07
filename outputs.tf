output "primary_key" {
  description = "The primary region KMS key with the attributes of aws_kms_key"
  value       = aws_kms_key.primary
}

output "replica_keys" {
  description = "All KMS replica keys created in other regions with the attributes of aws_kms_replica_key"
  value       = toset(aws_kms_replica_key.replica[*])
}

output "replica_key_arns" {
  description = "All KMS replica keys created in other regions with the attributes of aws_kms_replica_key"
  value       = { for k, v in aws_kms_replica_key.replica : k => v }
}
