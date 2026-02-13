output "eu_west_1" {
  value = aws_kms_key.eu_west_1
}





output "all_key_arns_by_region" {
  description = "Map of AWS regions to their corresponding KMS key ARNs"
  value = merge(
    { (var.primary_region) = aws_kms_key.eu_west_1.arn },
    { for r, k in aws_kms_replica_key.kms_key_replica : r => k.arn }
  )
}
output "replica_key_arns" {
  description = "List of replica KMS key ARNs"
  value       = [for replica in aws_kms_replica_key.kms_key_replica : replica.arn]
}

output "all_key_arns" {
  description = "List of all KMS key ARNs including primary and replicas"
  value = concat(
    [aws_kms_key.eu_west_1.arn],
    values(aws_kms_replica_key.kms_key_replica)[*].arn
  )
}
