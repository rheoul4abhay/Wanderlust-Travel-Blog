output "ec2_public_ids" {
  description = "Wanderlust EC2 Instance IP Address"
  value       = aws_instance.wanderlust-master-ec2[*].id
}

output "ec2_public_ips" {
  description = "Wanderlust EC2 Instance IP Address"
  value       = aws_instance.wanderlust-master-ec2[*].public_ip
}