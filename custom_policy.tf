# # Merge the module's defined key policies with any local custom key policies provided by the user.
# Set to null if no custom policies are provided.
data "aws_iam_policy_document" "kms_key_custom_policies" {
  source_policy_documents = concat(
    [data.aws_iam_policy_document.kms_key_module_policies.json],
    var.custom_policy_document,
  )
}
