
# OPG-Terraform-AWS-KMS-key
Standard OPG KMS key Module: Managed by opg-org-infra &amp; Terraform

- TODO - Consume a list of replica regions
- TODO - lint and validate example files
- TODO - Make terraform docs template

## Introduction
This module creates and manages AWS KMS customer‑managed keys. It applies least‑privilege policies for admins, encryption, and decryption, and can mirror keys across eu‑west‑1 and eu‑west‑2 with matching aliases.

- Primary key in eu‑west‑1, optional replica in eu‑west‑2
- Role‑based access: `administrator_roles`, `encryption_roles`, `decryption_roles`
- Allow‑listed services via `usage_services` (e.g. `backup.*.amazonaws.com`)
- Safe lifecycle controls: description, deletion window

<!-- BEGIN_TF_DOCS -->

### Example Usage: Cross Account Backup Key

Module being used to enable cross account backups in AWS Backup Service for Make-a-Lasting-Power-of-Attonery.

```hcl
module "aws_backup_cross_account_key" {
  source = "./modules/kms_key"

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
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| administrator_roles | List of Role ARNs allowed to administer the KMS Key | list(string) | n/a | yes |
| alias | KMS Key Alias | string | n/a | yes |
| description | KMS Key Description | string | n/a | yes |
| custom_addition_permissions | JSON BLOB of Additional Custom Permisisons to be merged with the main key policy. | string | "" | no |
| decryption_roles | List of Role ARNs allowed to use the KMS Key for Decryption | list(string) | n/a | yes |
| encryption_roles | List of Role ARNs allowed to use the KMS Key for Encryption | list(string) | n/a | yes |
| grant_roles | Principals allowed to create KMS grants for AWS resources using the KMS Key | list(string) | n/a | yes |
| usage_services | List of AWS Service that allow the usage role to use the KMS key | list(string) | [] | no |
| deletion_window | KMS Key deletion window | number | 7 | no |
| caller_accounts | List of AWS Account IDs allowed to use the KMS Key via AWS Service | list(string) | [] | no |
| primary_account_id | Primary AWS Account ID for multi-region replica KMS key usage | string | n/a | yes |
| backup_account_id | Backup AWS Account ID for cross-account backup KMS key usage | string | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| eu_west_1 | Primary KMS key resource `aws_kms_key.eu_west_1` |
| eu_west_2 | Replica KMS key resource `aws_kms_replica_key.eu_west_2` |

<!-- END_TF_DOCS -->
