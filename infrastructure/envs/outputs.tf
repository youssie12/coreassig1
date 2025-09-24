output "alb_dns" {
  description = "ALB DNS name"
  value       = aws_lb.alb.dns_name
}

output "rds_endpoint" {
  description = "RDS endpoint"
  value       = aws_db_instance.backend_db.address
}

output "monitoring_instance_id" {
  description = "Monitoring EC2 instance id"
  value       = aws_instance.monitoring.id
}
