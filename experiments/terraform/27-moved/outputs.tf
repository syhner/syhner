output "public_ip" {
  description = "The Public IP address used to access the instance"
  value       = module.ec2_instance.public_ip

}
