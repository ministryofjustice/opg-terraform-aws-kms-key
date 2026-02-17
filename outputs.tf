output "primary_key" {
  value = aws_kms_key.primary
}

output "replica_keys" {
  description = "List of replica KMS keys created in other regions"
  value       = values(aws_kms_replica_key.replica)[*]
}
