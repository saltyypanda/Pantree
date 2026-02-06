resource "aws_cognito_user_pool" "pool" {
  name = "user-pool"

  username_attributes = ["email"]
  auto_verified_attributes = ["email"]

  verification_message_template {
    default_email_option = "CONFIRM_WITH_CODE"
    email_subject        = "Welcome to Pantree"
    email_message        = "Use this code to confirm your email: {####}"
  }

  password_policy {
    minimum_length    = 6
    require_uppercase = false
    require_lowercase = false
    require_numbers   = false
    require_symbols   = false
  }
}

resource "aws_cognito_user_pool_client" "client" {
    depends_on = [ aws_cognito_user_pool.pool ]
  name         = "frontend-client"
  user_pool_id = aws_cognito_user_pool.pool.id
  generate_secret = false

  explicit_auth_flows = [  "ALLOW_USER_PASSWORD_AUTH"  ]

  refresh_token_rotation {
    feature                    = "ENABLED"
    retry_grace_period_seconds = 10
  }
}