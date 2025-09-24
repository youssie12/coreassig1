variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "eu-central-1"
}

variable "admin_cidr" {
  description = "CIDR to allow admin/SSH access to monitoring instance. Restrict in prod!"
  type        = string
  default     = "0.0.0.0/0"
}

variable "db_username" {
  description = "DB admin username"
  type        = string
  default     = "admin"
}

variable "db_password" {
  description = "DB admin password (use secrets in CI)"
  type        = string
  sensitive   = true
  default     = "password123!"
}
