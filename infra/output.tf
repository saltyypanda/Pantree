# -----------------------
# Cognito outputs
# -----------------------

output "user_pool_id" {
  value      = aws_cognito_user_pool.pool.id
}

output "user_pool_client_id" {
  value       = aws_cognito_user_pool_client.client.id
}

# -----------------------
# RDS / Postgres outputs
# -----------------------

output "db_name" {
  value = aws_db_instance.database.db_name
}

output "db_endpoint" {
  value = aws_db_instance.database.address
}

output "db_port" {
  value = aws_db_instance.database.port
}

output "db_secret_arn" {
  value = aws_db_instance.database.master_user_secret[0].secret_arn
}

# -----------------------
# Lambda outputs
# -----------------------

output "me_lambda_arn" {
  value = aws_lambda_function.me.arn
}
