output "primary_key_arn" {
  value = aws_kms_key.eu_west_1
}

output "replica_keys" {
  description = "List of replica KMS keys created in other regions"
  value       = [for replica in aws_kms_replica_key.kms_key_replica : replica]
}
