variable "name" {
  description = "Base name for resources"
  type        = string
  default     = "pantree"
}

variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

# variable "vpc_id" {
#   description = "VPC ID where the DB will live"
#   type        = string
# }

# variable "subnet_ids" {
#   description = "Subnets for the DB subnet group (usually private subnets)"
#   type        = list(string)
# }

# variable "allowed_ingress_security_group_ids" {
#   description = "Security groups allowed to connect to Postgres (e.g. Lambda SG)"
#   type        = list(string)
# }

variable "db_name" {
  description = "Database name"
  type        = string
  default     = "pantree_db"
}

variable "master_username" {
  description = "Master DB username (password is AWS-managed (: ))"
  type        = string
  default     = "postgres"
}
