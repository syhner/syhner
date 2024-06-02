output "ec2_elastic_ip" {
  description = "Elastic IP address for EC2 instance."
  value       = aws_eip.ip.address
}
