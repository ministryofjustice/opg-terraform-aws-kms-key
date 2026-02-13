# content: |-
module "aws_backup_cross_account_key" {
  source = "git@github.com:ministryofjustice/terraform-aws-kms-key.git?ref=main"

  description = "Encryption keys for Make an LPA backups copied into the backup account"
  alias       = "opg-lpa-${local.account_name}-aws-backup-key"
  providers = {
    aws = aws.backup
  }
  caller_accounts = [
    var.primary_account_id,
    var.backup_account_id
  ]

  administrator_roles = [
    "arn:aws:iam::${var.aws_caller_identity.current.account_id}:role/breakglass",
  ]
  decryption_roles = [
    "arn:aws:iam::${var.aws_caller_identity.current.account_id}:role/breakglass",
    aws_iam_role.aurora_backup_role.arn,
  ]
  encryption_roles = [
    "arn:aws:iam::${var.aws_caller_identity.current.account_id}:role/breakglass",
    aws_iam_role.aurora_backup_role.arn,
  ]
  grant_roles = [
    aws_iam_role.aurora_backup_role.arn,
  ]
  usage_services = ["backup.*.amazonaws.com"]
}

variable "primary_account_id" {
  description = " Primary AWS Account ID for multi-region replica KMS key usage"
  type        = string
}

variable "backup_account_id" {
  description = " Backup AWS Account ID for cross-account backup KMS key usage"
  type        = string
}
