# OPG-Terraform-AWS-KMS-key

Standard OPG KMS key Module: Managed by opg-org-infra &amp; Terraform

## Introduction

This module creates and manages AWS KMS customer‑managed keys.

It applies least‑privilege policies for admins, encryption, and decryption, and can mirror keys across multiple regions, allocating primary and replica regions according to your usage needs.


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
    var.grant_roles
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
```

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| <a name="input_additional_policy_documents"></a> [additional\_policy\_documents](#input\_additional\_policy\_documents) | Optional additional KMS policies that can be merged with base module policies by using 'source\_policy\_documents' attribute | `string` | `""` | no |
| <a name="input_admin_decrypt_permission"></a> [admin\_decrypt\_permission](#input\_admin\_decrypt\_permission) | Allow administrators to have permissions to use the KMS Key for Decryption | `bool` | `false` | no |
| <a name="input_administrator_roles"></a> [administrator\_roles](#input\_administrator\_roles) | List of Role ARNs allowed to administer the KMS Key | `list(string)` | n/a | yes |
| <a name="input_alias"></a> [alias](#input\_alias) | KMS Key Alias | `string` | n/a | yes |
| <a name="input_caller_accounts"></a> [caller\_accounts](#input\_caller\_accounts) | List of AWS Account IDs allowed to use the KMS Key via AWS Service | `list(string)` | `[]` | no |
| <a name="input_decryption_role_patterns"></a> [decryption\_role\_patterns](#input\_decryption\_role\_patterns) | List of patterns to match Role ARNs allowed to use the KMS Key for Decryption. Example pattern: ecs-api-task-role | `list(string)` | `[]` | no |
| <a name="input_decryption_roles"></a> [decryption\_roles](#input\_decryption\_roles) | List of Role ARNs allowed to use the KMS Key for Decryption | `list(string)` | n/a | yes |
| <a name="input_deletion_window"></a> [deletion\_window](#input\_deletion\_window) | KMS Key deletion window | `number` | `7` | no |
| <a name="input_description"></a> [description](#input\_description) | KMS Key Description | `string` | n/a | yes |
| <a name="input_encryption_role_patterns"></a> [encryption\_role\_patterns](#input\_encryption\_role\_patterns) | List of patterns to match Role ARNs allowed to use the KMS Key for Encryption. Example pattern: ecs-api-task-role | `list(string)` | `[]` | no |
| <a name="input_encryption_roles"></a> [encryption\_roles](#input\_encryption\_roles) | List of Role ARNs allowed to use the KMS Key for Encryption | `list(string)` | n/a | yes |
| <a name="input_grant_roles"></a> [grant\_roles](#input\_grant\_roles) | Principals allowed to create KMS grants for AWS resources using the KMS Key | `list(string)` | `[]` | no |
| <a name="input_primary_region"></a> [primary\_region](#input\_primary\_region) | The AWS Region e.g. eu-west-1 where primary key is created | `string` | n/a | yes |
| <a name="input_replicas_to_create"></a> [replicas\_to\_create](#input\_replicas\_to\_create) | List of regions to create replica keys in | `list(string)` | n/a | yes |
| <a name="input_usage_services"></a> [usage\_services](#input\_usage\_services) | List of AWS Service that allow the usage role to use the KMS key | `list(string)` | `[]` | no |

## Outputs

| Name | Description |
| ---- | ----------- |
| <a name="output_key_alias_name"></a> [key\_alias\_name](#output\_key\_alias\_name) | The KMS key alia name for the primary and all replica keys |
| <a name="output_primary_key"></a> [primary\_key](#output\_primary\_key) | The primary region KMS key with the attributes of aws\_kms\_key |
| <a name="output_replica_keys"></a> [replica\_keys](#output\_replica\_keys) | KMS replica keys created for each region in replicas\_to\_create with the attributes of aws\_kms\_replica\_key |
<!-- END_TF_DOCS -->
