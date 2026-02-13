# content: |-

# Primary app KMS key replicated to eu-west-2
module "primary_app_kms" {
  source = "git@github.com:ministryofjustice/terraform-aws-kms-key.git?ref=main"

  description = "Customer-managed KMS key for Example App; replicated to eu-west-2"
  alias       = "opg-example-app-kms"

  administrator_roles = [
    "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/kms-admin",
  ]

  encryption_roles = [
    "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/example-app",
  ]

  decryption_roles = [
    "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/example-app",
  ]

  usage_services = [
    "rds.*.amazonaws.com",
    "s3.*.amazonaws.com",
  ]
}

# Separate key for logs/backup use
module "logs_backup_kms" {
  source = "git@github.com:ministryofjustice/terraform-aws-kms-key.git"

  description = "KMS key for logs and backups; replicated to eu-west-2"
  alias       = "opg-example-logs-backup-kms"

  administrator_roles = [
    "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/kms-admin",
  ]

  encryption_roles = [
    "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/logs-writer",
    "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/backup-service-role",
  ]

  decryption_roles = [
    "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/logs-reader",
    "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/restore-service-role",
  ]

  usage_services = [
    "backup.*.amazonaws.com",
    "logs.*.amazonaws.com",
  ]
}

variable "replica_regions" {
  description = "List of AWS Regions to create KMS Key replicas in"
  type        = list(string)
  default     = []
}
