output "vpc_id" {
  value = aws_vpc.main.id
}

output "public_subnet" {
  value = aws_subnet.public.id
}

output "app_subnet" {
  value = aws_subnet.app.id
}

output "monitoring_subnet" {
  value = aws_subnet.monitoring.id
}

output "data_subnet" {
  value = aws_subnet.data.id
}
