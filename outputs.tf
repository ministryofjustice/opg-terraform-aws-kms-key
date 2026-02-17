output "primary_key_arn" {
  value = aws_kms_key.primary.arn
}

output "replica_keys" {
  description = "List of replica KMS keys created in other regions"
  value       = values(aws_kms_replica_key.replica)[*]
}
