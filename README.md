# OPG-Terraform-AWS-KMS-key

Standard OPG KMS key Module: Managed by opg-org-infra &amp; Terraform

## Introduction

This module creates and manages AWS KMS customer‑managed keys.

It applies least‑privilege policies for admins, encryption, and decryption, and can mirror keys across multiple regions, allocating primary and replica regions according to your usage needs.

<!-- BEGIN_TF_DOCS -->

- Role‑based access: `administrator_roles`, `grant_roles`, `encryption_roles`, `decryption_roles`
- Allow‑listed services via `usage_services` (e.g. `backup.*.amazonaws.com`)
- Allow‑listed caller accounts via `caller_accounts` (e.g. `backup_account_id`)
- Restrict which roles can call `"kms:CreateGrant"` via `grant_roles`
- Match Role ARNs allowed to use the KMS Key by specifying '`encryption_role_patterns` and `decryption_role_patterns`

- Merge module and custom policies into one final JSON policy document
  Define one optional custom policy document locally by utilising the `additional_policy_documents` variable and the `source_policy_documents` datasource. The module merges the base policy with the optional custom policy and produces a single final JSON policy document at `data.aws_iam_policy_document.combined_kms_key_policies.json`, which is then attached to both the primary and replica keys.

```hcl
# content: |-
  data "aws_iam_policy_document""combined_kms_key_policies" {
  source_policy_documents = concat(
    [data.aws_iam_policy_document.kms_key_module_policy.json],
    var.additional_policy_documents != "" ? [var.additional_policy_documents] : [],
  )
}
```

- Safe lifecycle controls: deletion window, key rotation

## Examples

Practical examples and instructions on how to consume the module can be found under [examples](examples):

- AWS Backup Cross‑Account:
  [examples/aws_backup_cross_account_key](examples/aws_backup_cross_account_key)
- Multi‑Region Replica:
  [examples/multi_region_replica_key](examples/multi_region_replica_key)
- Replicated Secrets Manager Secret:
  [examples/replicated_secret](examples/replicated_secret)

<!-- BEGIN_TF_DOCS -->

## Example Usage

```hcl
# content: |-
module "aws_backup_cross_account_key" {
  source         = "git@github.com:ministryofjustice/terraform-aws-kms-key.git?ref=main"
  alias          = "opg-lpa-${local.account_name}-aws-backup-key"
  description    = "Encryption keys for Make an LPA backups copied into the backup account"
  primary_region = "eu-west-1"

  replicas_to_create = [
    "eu-west-2"
  ]

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
    var.grant_roles
  ]
  usage_services = ["backup.*.amazonaws.com"]
  providers = {
    aws = aws.backup
  }
}

variable "primary_account_id" {
  description = " Primary AWS Account ID for multi-region replica KMS key usage"
  type        = string
}

variable "backup_account_id" {
  description = " Backup AWS Account ID for cross-account backup KMS key usage"
  type        = string
}

locals {
  primary_key_arn = module.aws_backup_cross_account_key.primary_key.arn
  replica_key_arn = module.aws_backup_cross_account_key.replica_keys.eu-west-2.arn
}
```

## Inputs

| Name                                                                                                               | Description                                                                                                                                                                                                                              | Type           | Default | Required |
| ------------------------------------------------------------------------------------------------------------------ | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | -------------- | ------- | :------: |
| <a name="input_admin_decrypt_permission"></a> [admin_decrypt_permission](#input_admin_decrypt_permission)          | Allow administrators to have permissions to use the KMS Key for Decryption                                                                                                                                                               | `bool`         | `false` |    no    |
| <a name="input_administrator_roles"></a> [administrator_roles](#input_administrator_roles)                         | List of Role ARNs allowed to administer the KMS Key                                                                                                                                                                                      | `list(string)` | n/a     |   yes    |
| <a name="input_alias"></a> [alias](#input_alias)                                                                   | KMS Key Alias                                                                                                                                                                                                                            | `string`       | n/a     |   yes    |
| <a name="input_caller_accounts"></a> [caller_accounts](#input_caller_accounts)                                     | List of AWS Account IDs allowed to use the KMS Key via AWS Service                                                                                                                                                                       | `list(string)` | `[]`    |    no    |
| <a name="input_additional_policy_documents"></a> [additional_policy_documents](#input_additional_policy_documents) | Optional custom policy document JSON to merge with the module-defined policy. The merged result is rendered as one final JSON policy in `data.aws_iam_policy_document.combined_kms_key_policies.json`. Ensure statement SIDs are unique. | `string`       | `""`    |    no    |
| <a name="input_decryption_roles"></a> [decryption_roles](#input_decryption_roles)                                  | List of Role ARNs allowed to use the KMS Key for Decryption                                                                                                                                                                              | `list(string)` | n/a     |   yes    |
| <a name="input_deletion_window"></a> [deletion_window](#input_deletion_window)                                     | KMS Key deletion window                                                                                                                                                                                                                  | `number`       | `7`     |    no    |
| <a name="input_description"></a> [description](#input_description)                                                 | KMS Key Description                                                                                                                                                                                                                      | `string`       | n/a     |   yes    |
| <a name="input_encryption_role_patterns"></a> [encryption_role_patterns](#input_encryption_role_patterns)          | List of patterns to match Role ARNs allowed to use the KMS Key for Encryption. Example pattern: ecs-api-task-role                                                                                                                        | `list(string)` | `[]`    |    no    |
| <a name="input_encryption_roles"></a> [encryption_roles](#input_encryption_roles)                                  | List of Role ARNs allowed to use the KMS Key for Encryption                                                                                                                                                                              | `list(string)` | n/a     |   yes    |
| <a name="input_grant_roles"></a> [grant_roles](#input_grant_roles)                                                 | Principals allowed to create KMS grants for AWS resources using the KMS Key                                                                                                                                                              | `list(string)` | `[]`    |    no    |
| <a name="input_primary_region"></a> [primary_region](#input_primary_region)                                        | The AWS Region e.g. eu-west-1 where primary key is created                                                                                                                                                                               | `string`       | n/a     |   yes    |
| <a name="input_replicas_to_create"></a> [replicas_to_create](#input_replicas_to_create)                            | List of regions to create replica keys in                                                                                                                                                                                                | `list(string)` | n/a     |   yes    |
| <a name="input_usage_services"></a> [usage_services](#input_usage_services)                                        | List of AWS Service that allow the usage role to use the KMS key                                                                                                                                                                         | `list(string)` | `[]`    |    no    |

## Outputs

| Name                                                                    | Description                                                                                               |
| ----------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------- |
| <a name="output_primary_key"></a> [primary_key](#output_primary_key)    | The primary region KMS key with the attributes of aws_kms_key                                             |
| <a name="output_key_alias"></a> [key_alias](#output_key_alias)          | The KMS key alias for the primary and all replica keys                                                    |
| <a name="output_replica_keys"></a> [replica_keys](#output_replica_keys) | KMS replica keys created for each region in replicas_to_create with the attributes of aws_kms_replica_key |

<!-- END_TF_DOCS -->
