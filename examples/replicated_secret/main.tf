module "secrets_manager_encryption_key" {
  source             = "git@github.com:ministryofjustice/terraform-aws-kms-key.git?ref==v0.0.10"
  description        = "Customer managed encryption key for Secrets Manager"
  alias              = "opg-example-app-kms"
  usage_services     = []
  primary_region     = "eu-west-1"
  replicas_to_create = ["eu-west-2"]

  administrator_roles = [
    "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/kms-admin",
  ]
  decryption_roles = [
    "*",
  ]
  encryption_roles = [
    "*",
  ]
  grant_roles = [
    "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/kms-admin",
  ]

  encryption_role_patterns = [
    "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/secret-writer",
  ]
  decryption_role_patterns = [
    "execution-role-ecs-cluster",
    "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/secret-reader",
  ]
  caller_accounts = [
    data.aws_caller_identity.current.account_id,
  ]
}

resource "aws_secretsmanager_secret" "example" {
  name                           = "example"
  kms_key_id                     = module.secrets_manager_encryption_key.primary_key.arn
  force_overwrite_replica_secret = true

  replica {
    region     = "eu-west-2"
    kms_key_id = module.secrets_manager_encryption_key.replica_keys.eu-west-2.arn
  }
}
