# -----------------------
# Database resources
# -----------------------

resource "aws_security_group" "db" {
  name        = "${var.name}-db-sg"
  description = "DB security group for ${var.name}"
  vpc_id      = data.aws_vpc.default_vpc.id

  # Allow Postgres ONLY from the current public IP
  ingress {
    description = "Postgres from my public IP"
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = [local.my_ip_cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.name}-db-sg"
  }
}

resource "aws_db_subnet_group" "db" {
  name       = "${var.name}-db-subnet-group"
  subnet_ids = data.aws_subnets.default_subnets.ids

  tags = {
    Name = "${var.name}-db-subnet-group"
  }
}

# -----------------------
# Lambda resources
# -----------------------

resource "aws_security_group" "lambda" {
  name        = "${var.name}-lambda-sg"
  description = "Security group for lambdas"
  vpc_id      = data.aws_vpc.default_vpc.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group_rule" "db_ingress_from_lambda" {
  type                     = "ingress"
  security_group_id        = aws_security_group.db.id
  from_port                = 5432
  to_port                  = 5432
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.lambda.id
}

# Allows API gateway to invoke the me lambda
resource "aws_lambda_permission" "allow_apigw_invoke_me" {
  statement_id  = "AllowInvokeFromAPIGatewayMe"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.me.function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_apigatewayv2_api.api.execution_arn}/*/*"
}

# -----------------------
# VPC resources
# -----------------------

resource "aws_security_group" "vpce" {
  name   = "${var.name}-vpce-sg"
  vpc_id = data.aws_vpc.default_vpc.id

  ingress {
    from_port                = 443
    to_port                  = 443
    protocol                 = "tcp"
    security_groups = [ aws_security_group.lambda.id ]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_vpc_endpoint" "secretsmanager" {
  vpc_id              = data.aws_vpc.default_vpc.id
  vpc_endpoint_type   = "Interface"
  service_name        = "com.amazonaws.${var.aws_region}.secretsmanager"

  subnet_ids          = aws_db_subnet_group.db.subnet_ids
  security_group_ids  = [aws_security_group.vpce.id]

  private_dns_enabled = true
}