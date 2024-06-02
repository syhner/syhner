provider "aws" {
  region = var.region
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_instance" "ubuntu" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instance_type

  tags = {
    Name = var.instance_name
  }
}

# update terraform.tf organisation name
# terraform login
# terraform init — and due to cloud block, creates a workspace in Terraform Cloud (if it doesn’t exist already)
# AWS variables set globally or in workspace
# Terraform variables (instance_name and instance_type) can be set in workspace
# terraform apply — can view plan and confirm in Terraform Cloud
# terraform apply -var="instance_type=t2.small" — override workspace var (TF Cloud will not save the var unless updated through the UI)

# Beginning VCS driven workflow
# remove cloud block

# Speculative plans are non-destructive, plan-only runs that show you the changes Terraform will make to your infrastructure if you merge a pull request. The runs will not appear in your Terraform Cloud logs and you can only access them through a direct link, which Terraform Cloud will attach to your pull request.
# You cannot apply speculative plans, since your infrastructure would differ from the configuration on your main branch of your connected repository. You must merge the pull request to apply this change.

# connect workspace to github (enabled speculative plans)
# discarded plan in TF Cloud
# removed instance_type var from workspace
# echo 'instance_type = "t2.micro"' >> terraform.auto.tfvars
# created PR to main branch with tfvars file
# speculative plan runs
# merged PR
# plan runs due to merge, and then choose to confirm & apply

# workspace settings > destruction and deletion:
# 1. Queue destroy plan destroys all infrastructure managed by the workspace.
# 2. Delete from Terraform Cloud deletes your workspace from Terraform Cloud without destroying the infrastructure the workspace manages.

# queued destroy plan, confirm & apply
# optional delete workspace (unlimited workspaces so this is just for cleanup)
