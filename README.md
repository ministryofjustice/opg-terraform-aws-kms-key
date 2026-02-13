
# OPG-Terraform-AWS-KMS-key
Standard OPG KMS key Module: Managed by opg-org-infra &amp; Terraform

- TODO - lint and validate example files


## Introduction
This module creates and manages AWS KMS customer‑managed keys. It applies least‑privilege policies for admins, encryption, and decryption, and can mirror keys across multiple regions, allocating primary and replica regions according to your usage needs.

Multi-region replication is optional and is disabled by default.

- Role‑based access: `administrator_roles`, `encryption_roles`, `decryption_roles`
- Allow‑listed services via `usage_services` (e.g. `backup.*.amazonaws.com`)
- Safe lifecycle controls: deletion window, key rotation


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
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_admin_decrypt_permission"></a> [admin\_decrypt\_permission](#input\_admin\_decrypt\_permission) | Allow administrators to have permissions to use the KMS Key for Decryption | `bool` | `false` | no |
| <a name="input_administrator_roles"></a> [administrator\_roles](#input\_administrator\_roles) | List of Role ARNs allowed to administer the KMS Key | `list(string)` | n/a | yes |
| <a name="input_alias"></a> [alias](#input\_alias) | KMS Key Alias | `string` | n/a | yes |
| <a name="input_caller_accounts"></a> [caller\_accounts](#input\_caller\_accounts) | List of AWS Account IDs allowed to use the KMS Key via AWS Service | `list(string)` | `[]` | no |
| <a name="input_custom_addition_permissions"></a> [custom\_addition\_permissions](#input\_custom\_addition\_permissions) | JSON BLOB of Additional Custom Permisisons to be merged with the main key policy. | `string` | `""` | no |
| <a name="input_decryption_roles"></a> [decryption\_roles](#input\_decryption\_roles) | List of Role ARNs allowed to use the KMS Key for Decryption | `list(string)` | n/a | yes |
| <a name="input_deletion_window"></a> [deletion\_window](#input\_deletion\_window) | KMS Key deletion window | `number` | `7` | no |
| <a name="input_description"></a> [description](#input\_description) | KMS Key Description | `string` | n/a | yes |
| <a name="input_enable_replication"></a> [enable\_replication](#input\_enable\_replication) | Choose whether to create replica keys in other regions | `bool` | `false` | no |
| <a name="input_encryption_roles"></a> [encryption\_roles](#input\_encryption\_roles) | List of Role ARNs allowed to use the KMS Key for Encryption | `list(string)` | n/a | yes |
| <a name="input_grant_roles"></a> [grant\_roles](#input\_grant\_roles) | Principals allowed to create KMS grants for AWS resources using the KMS Key | `list(string)` | n/a | yes |
| <a name="input_primary_region"></a> [primary\_region](#input\_primary\_region) | The AWS Region e.g. eu-west-1 where primary key is created | `string` | n/a | yes |
| <a name="input_replicas_to_create"></a> [replicas\_to\_create](#input\_replicas\_to\_create) | Map of KMS aliases from Primary region to create replica keys in Replica region | <pre>map(object({<br/>    alias  = string # Alias for the KMS Key in the primary region<br/>    policy = string # Policy for the KMS Key in the primary region<br/>  }))</pre> | `{}` | no |
| <a name="input_usage_services"></a> [usage\_services](#input\_usage\_services) | List of AWS Service that allow the usage role to use the KMS key | `list(string)` | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_all_key_arns"></a> [all\_key\_arns](#output\_all\_key\_arns) | List of all KMS key ARNs including primary and replicas |
| <a name="output_all_key_arns_by_region"></a> [all\_key\_arns\_by\_region](#output\_all\_key\_arns\_by\_region) | Map of AWS regions to their corresponding KMS key ARNs |
| <a name="output_eu_west_1"></a> [eu\_west\_1](#output\_eu\_west\_1) | Primary region  |
| <a name="output_replica_key_arns"></a> [replica\_key\_arns](#output\_replica\_key\_arns) | List of replica KMS key ARNs |
<!-- END_TF_DOCS -->
