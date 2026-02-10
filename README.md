# opg-terraform-aws-kms-key
Standard OPG AWS KMS key Module: Managed by opg-org-infra &amp; Terraform
<!-- BEGIN_TF_DOCS -->
## Requirements

| Name                                                                      | Version   |
| ------------------------------------------------------------------------- | --------- |
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.7.3  |
| <a name="requirement_aws"></a> [aws](#requirement\_aws)                   | >= 6.28.0 |

## Providers

| Name                                              | Version |
| ------------------------------------------------- | ------- |
| <a name="provider_aws"></a> [aws](#provider\_aws) | 6.31.0  |

## Modules

No modules.

## Resources

| Name                                                                                                                                  | Type        |
| ------------------------------------------------------------------------------------------------------------------------------------- | ----------- |
| [aws_kms_alias.eu_west_1](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_alias)                      | resource    |
| [aws_kms_alias.eu_west_2](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_alias)                      | resource    |
| [aws_kms_key.eu_west_1](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key)                          | resource    |
| [aws_kms_replica_key.eu_west_2](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_replica_key)          | resource    |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity)         | data source |
| [aws_iam_policy_document.kms_key](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |

## Inputs

| Name                                                                                                                    | Description                                                                       | Type           | Default | Required |
| ----------------------------------------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------- | -------------- | ------- | :------: |
| <a name="input_administrator_roles"></a> [administrator\_roles](#input\_administrator\_roles)                           | List of Role ARNs allowed to administer the KMS Key                               | `list(string)` | n/a     |   yes    |
| <a name="input_alias"></a> [alias](#input\_alias)                                                                       | KMS Key Alias                                                                     | `string`       | n/a     |   yes    |
| <a name="input_custom_addition_permissions"></a> [custom\_addition\_permissions](#input\_custom\_addition\_permissions) | JSON BLOB of Additional Custom Permisisons to be merged with the main key policy. | `string`       | `""`    |    no    |
| <a name="input_decryption_roles"></a> [decryption\_roles](#input\_decryption\_roles)                                    | List of Role ARNs allowed to use the KMS Key for Decryption                       | `list(string)` | n/a     |   yes    |
| <a name="input_deletion_window"></a> [deletion\_window](#input\_deletion\_window)                                       | KMS Key deletion window                                                           | `number`       | `7`     |    no    |
| <a name="input_description"></a> [description](#input\_description)                                                     | KMS Key Description                                                               | `string`       | n/a     |   yes    |
| <a name="input_encryption_roles"></a> [encryption\_roles](#input\_encryption\_roles)                                    | List of Role ARNs allowed to use the KMS Key for Encryption                       | `list(string)` | n/a     |   yes    |
| <a name="input_usage_services"></a> [usage\_services](#input\_usage\_services)                                          | List of AWS Service that the usage roles can use the KMS                          | `list(string)` | `[]`    |    no    |

## Outputs

| Name                                                                | Description |
| ------------------------------------------------------------------- | ----------- |
| <a name="output_eu_west_1"></a> [eu\_west\_1](#output\_eu\_west\_1) | n/a         |
| <a name="output_eu_west_2"></a> [eu\_west\_2](#output\_eu\_west\_2) | n/a         |

<!-- END_TF_DOCS -->
