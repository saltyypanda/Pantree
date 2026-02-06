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
