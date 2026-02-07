resource "aws_iam_role" "me_lambda_role" {
  name = "${var.name}-me-lambda-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Action = "sts:AssumeRole"
      Principal = { Service = "lambda.amazonaws.com" }
    }]
  })
}

# Basic CloudWatch logs permissions (so console.log works)
resource "aws_iam_role_policy_attachment" "me_lambda_basic_logs" {
  role       = aws_iam_role.me_lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

# Allow reading your RDS-generated secret
resource "aws_iam_policy" "me_lambda_secrets_policy" {
  name = "${var.name}-me-lambda-secrets"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect   = "Allow"
      Action   = ["secretsmanager:GetSecretValue"]
      Resource = aws_db_instance.database.master_user_secret[0].secret_arn
    }]
  })
}

resource "aws_iam_role_policy_attachment" "me_lambda_secrets_attach" {
  role       = aws_iam_role.me_lambda_role.name
  policy_arn = aws_iam_policy.me_lambda_secrets_policy.arn
}
