output "primary_key" {
  value = aws_kms_key.primary
}

output "replica_keys" {
  description = "List of replica KMS keys created in other regions"
  value       = [for replica in aws_kms_replica_key.kms_key_replica : replica]
}
