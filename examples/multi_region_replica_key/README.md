# Multi-Region Replica KMS Key (Example)

This example demonstrates creating customer-managed AWS KMS keys and replicating them to a secondary region.

## Overview
- Creates two keys:
  - `opg-example-app-kms`: for application data (RDS/S3).
  - `opg-example-logs-backup-kms`: for logs and AWS Backup.
- Assigns administrator, encryption, and decryption IAM roles per key.
- Restricts service principals via `usage_services` for safer service-only usage.

## What It Provisions
- `module "primary_app_kms"`: key for app workloads; replication configured in the underlying module.
- `module "logs_backup_kms"`: key for logs and backups; replication configured in the underlying module.

See the module inputs in [main.tf](main.tf) for aliases, descriptions, IAM role ARNs, and allowed services.

## Prerequisites
- AWS credentials with permission to create KMS keys and grants.
- IAM roles referenced in the example exist in the account:
  - `kms-admin`, `example-app`, `logs-writer`, `backup-service-role`, `logs-reader`, `restore-service-role`.
- Default AWS region configured (e.g., `AWS_DEFAULT_REGION`). The module handles replication to the target region.

## Usage
```bash
cd examples/multi_region_replica_key
terraform init
terraform plan
terraform apply
```

Update the role ARNs, aliases, and service principals in [main.tf](main.tf) to fit your environment before applying.

## Cleanup
```bash
terraform destroy
```

## Notes
- Replication target region is set within the `./modules/kms_key` module; adjust module inputs if you need a different destination.
- `usage_services` limits who can use the key to specified AWS services (e.g., `rds.*.amazonaws.com`, `s3.*.amazonaws.com`).
