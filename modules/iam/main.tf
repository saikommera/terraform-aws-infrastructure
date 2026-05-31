# Least-privilege IAM role with IRSA support
resource "aws_iam_role" "this" {
  name                 = var.role_name
  max_session_duration = var.max_session_duration

  assume_role_policy = var.oidc_provider_arn != "" ? jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = { Federated = var.oidc_provider_arn }
      Action    = "sts:AssumeRoleWithWebIdentity"
      Condition = {
        StringEquals = {
          "${replace(var.oidc_provider_arn, "/^(.*provider\/)/", "")}:sub" = "system:serviceaccount:${var.namespace}:${var.service_account_name}"
        }
      }
    }]
  }) : jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect    = "Allow"
      Principal = { Service = var.trusted_service }
      Action    = "sts:AssumeRole"
    }]
  })

  tags = var.tags
}

resource "aws_iam_role_policy" "inline" {
  count  = var.inline_policy != "" ? 1 : 0
  name   = "${var.role_name}-inline"
  role   = aws_iam_role.this.id
  policy = var.inline_policy
}

resource "aws_iam_role_policy_attachment" "managed" {
  for_each   = toset(var.managed_policy_arns)
  role       = aws_iam_role.this.name
  policy_arn = each.value
}
