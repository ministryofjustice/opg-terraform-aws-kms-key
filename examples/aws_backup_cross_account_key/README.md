# AWS Backup Cross-Account KMS Key (Example)

This example provisions a customer-managed KMS key intended for AWS Backup cross-account copy operations. It allows backups from a primary account to be encrypted and copied into a designated backup account.

## Overview
- Creates a KMS key in the backup account (via provider alias).
- Grants `encrypt`, `decrypt`, and grant permissions to a backup role (e.g., `aurora_backup_role`).
- Limits usage to AWS Backup service principals via `usage_services`.
- Names the key alias using `local.account_name` for clarity across environments.

## Assumptions & Prerequisites
- Providers:
  - A default AWS provider is configured for your primary account/region.
  - An aliased provider `aws.backup` targets the backup account/region.
- Variables:
  - `primary_account_id` and `backup_account_id` are set.
  - A caller account ID variable or data source is available (used for constructing IAM role ARNs).
- IAM:
  - An IAM role resource `aws_iam_role.aurora_backup_role` exists and is referenced.
  - A break-glass admin role `role/breakglass` exists in the account.

Example provider configuration (adjust regions and profiles as needed):
```hcl
provider "aws" {
  region = "eu-west-1"
  # profile = "primary"
}

provider "aws" {
  alias  = "backup"
  region = "eu-west-2"
  # profile = "backup"
}
```

## What It Provisions
- `module "aws_backup_cross_account_key"`: Creates the KMS key using `./modules/kms_key` with:
  - `alias`: `opg-lpa-${local.account_name}-aws-backup-key`
  - `providers`: `{ aws = aws.backup }` to ensure the key is created in the backup account
  - `caller_accounts`: includes both primary and backup account IDs for policy construction
  - IAM permissions for admin (`breakglass`) and the backup role `aurora_backup_role`
  - `usage_services`: `backup.*.amazonaws.com` for service restriction

See inputs in [main.tf](main.tf) for exact role ARNs and variables.

## Usage
```bash
cd examples/aws_backup_cross_account_key
terraform init
terraform plan -var "primary_account_id=111111111111" -var "backup_account_id=222222222222"
terraform apply
```

Ensure any referenced roles (e.g., `aurora_backup_role`) and `local.account_name` are defined in your example or workspace.

## Cleanup
```bash
terraform destroy
```

## Notes
- If your environment uses `data.aws_caller_identity.current.account_id`, adapt the role ARNs accordingly in [main.tf](main.tf).
- `usage_services` restricts usage to AWS Backup, improving blast-radius control for the key.
