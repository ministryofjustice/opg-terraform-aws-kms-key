resource "aws_kms_key" "primary" {
  description             = var.description
  deletion_window_in_days = var.deletion_window
  enable_key_rotation     = true
  policy                  = data.aws_iam_policy_document.kms_key.json
  multi_region            = true
  region                  = var.primary_region
}
resource "aws_kms_alias" "primary" {
  name          = "alias/${var.alias}"
  target_key_id = aws_kms_key.primary.key_id
  region        = var.primary_region
}

resource "aws_kms_replica_key" "replica" {
  for_each                = toset(var.replicas_to_create)
  region                  = each.value
  primary_key_arn         = aws_kms_key.primary.arn
  description             = "Multi-Region replica key for ${each.value} region"
  deletion_window_in_days = var.deletion_window
  policy                  = data.aws_iam_policy_document.kms_key.json
}

resource "aws_kms_alias" "replica_alias" {
  for_each      = toset(var.replicas_to_create)
  region        = each.value
  name          = "alias/${var.alias}"
  target_key_id = aws_kms_replica_key.replica[each.value].key_id
}
