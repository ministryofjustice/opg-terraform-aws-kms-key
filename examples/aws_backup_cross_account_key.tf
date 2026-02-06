# module "aws_backup_cross_account_key" {
#   source = "./modules/kms_key"

#   administrator_roles = [
#     "arn:aws:iam::${var.aws_caller_identity.current.account_id}:role/breakglass",
#   ]
#   decryption_roles = [
#     "arn:aws:iam::${var.aws_caller_identity.current.account_id}:role/breakglass",
#     aws_iam_role.aurora_backup_role.arn,
#   ]
#   encryption_roles = [
#     "arn:aws:iam::${var.aws_caller_identity.current.account_id}:role/breakglass",
#     aws_iam_role.aurora_backup_role.arn,
#   ]
#   usage_services = ["backup.*.amazonaws.com"]
#   description    = "Encryption keys for Make an LPA backups copied into the backup account"
#   alias          = "opg-lpa-${local.account_name}-aws-backup-key"
#   providers = {
#     aws = aws.backup
#   }
# }
