output "eu_west_1" {
  value = aws_kms_key.eu_west_1
}
output "all_key_arns" {
  description = "List of all KMS key ARNs including primary and replicas"
  value = concat(
    [aws_kms_key.eu_west_1.arn],
    values(aws_kms_replica_key.kms_key_replica)[*].arn
  )
}
