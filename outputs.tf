output "primary_key" {
  description = "ARN of the primary region KMS key"
  value       = aws_kms_key.primary
}

output "replica_keys" {
  description = "Set of replica KMS keys created in other regions"
  value       = aws_kms_replica_key.replica[*]
}
