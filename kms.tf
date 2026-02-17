resource "aws_kms_key" "eu_west_1" {
  description             = var.description
  deletion_window_in_days = var.deletion_window
  enable_key_rotation     = true
  policy                  = data.aws_iam_policy_document.kms_key.json
  multi_region            = true
  region                  = "eu-west-1"
}
resource "aws_kms_alias" "eu_west_1" {
  name          = "alias/${var.alias}"
  target_key_id = aws_kms_key.eu_west_1.key_id
  region        = "eu-west-1"
}

resource "aws_kms_replica_key" "kms_key_replica" {
  for_each                = toset(var.replicas_to_create)
  region                  = each.value
  primary_key_arn         = aws_kms_key.eu_west_1.arn
  description             = "Multi-Region replica key for ${each.value} region"
  deletion_window_in_days = var.deletion_window
  policy                  = data.aws_iam_policy_document.kms_key.json
}

resource "aws_kms_alias" "kms_replica_alias" {
  for_each      = toset(var.replicas_to_create)
  region        = each.value
  name          = "alias/${var.alias}"
  target_key_id = aws_kms_replica_key.kms_key_replica[each.key].key_id
}
