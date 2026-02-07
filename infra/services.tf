resource "aws_lambda_function" "me" {
  function_name = "${var.name}-me"
  role          = aws_iam_role.me_lambda_role.arn

  runtime = "nodejs20.x"
  handler = "handler.handler" # file is handler.js, export is handler

  filename         = "${path.module}/../services/me/dist/me.zip"
  source_code_hash = filebase64sha256("${path.module}/../services/me/dist/me.zip")

  timeout     = 10
  memory_size = 256

  # Put Lambda in the VPC so it can reach RDS privately
  vpc_config {
    subnet_ids         = aws_db_subnet_group.db.subnet_ids
    security_group_ids = [aws_security_group.lambda.id]
  }

  environment {
    variables = {
      DB_NAME       = var.db_name
      DB_HOST       = aws_db_instance.database.address
      DB_PORT       = "5432"
      DB_SECRET_ARN = aws_db_instance.database.master_user_secret[0].secret_arn
      DB_SSL        = "true"
    }
  }
}
