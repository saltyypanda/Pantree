resource "aws_db_instance" "database" {
  identifier = "${var.name}-postgres"

  engine         = "postgres"
  engine_version = "17.6"

  instance_class = "db.t3.micro"

  allocated_storage = 20
  storage_type      = "gp2"
  storage_encrypted = true

  db_name  = var.db_name
  username = var.master_username

  # AWS generates and stores the password in Secrets Manager
  manage_master_user_password = true

  multi_az            = false
  publicly_accessible = true

  db_subnet_group_name   = aws_db_subnet_group.db.name
  vpc_security_group_ids = [aws_security_group.db.id]

  deletion_protection = false
  skip_final_snapshot = true

  # Reduce extras (but lose point-in-time recovery)
  backup_retention_period = 0
}
