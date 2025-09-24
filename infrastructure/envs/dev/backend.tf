# Web SG must exist (defined in frontend.tf). DB SG allows connections from web SG.
resource "aws_security_group" "db_sg" {
  name   = "db-sg"
  vpc_id = module.vpc.vpc_id

  description = "Allow MySQL from web servers"
  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.web_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# RDS Subnet Group (simple: single data subnet)
resource "aws_db_subnet_group" "db_subnet_group" {
  name       = "db-subnet-group"
  subnet_ids = [module.vpc.data_subnet]
  tags = { Name = "db-subnet-group" }
}

# RDS instance (private)
resource "aws_db_instance" "backend_db" {
  allocated_storage    = 20
  engine               = "mysql"
  engine_version       = "8.0"
  instance_class       = "db.t3.micro"
  name                 = "backenddb"
  username             = var.db_username
  password             = var.db_password
  db_subnet_group_name = aws_db_subnet_group.db_subnet_group.name
  vpc_security_group_ids = [aws_security_group.db_sg.id]
  skip_final_snapshot  = true
  publicly_accessible  = false
  tags = { Name = "backend-rds" }
}

# Route53 private zone for internal names
resource "aws_route53_zone" "private" {
  name = "internal.local"
  vpc {
    vpc_id = module.vpc.vpc_id
  }
}

# Create a CNAME record pointing to RDS endpoint (RDS address is available after creation)
resource "aws_route53_record" "db" {
  zone_id = aws_route53_zone.private.zone_id
  name    = "db.internal.local"
  type    = "CNAME"
  ttl     = 300
  records = [aws_db_instance.backend_db.address]
}
