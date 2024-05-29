# Terraform loads all files in the current directory ending in .tf, so you can name your configuration files however you choose

variable "instance_name" {
  description = "Value of the Name tag for the EC2 instance"
  type        = string
  default     = "ExampleAppServerInstance"
}
