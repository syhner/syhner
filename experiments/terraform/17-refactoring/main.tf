# edit terraform.tfvars.example region
# cp terraform.tfvars.example terraform.tfvars

# terraform init
# terraform apply

# Terraform loads all configuration files within a directory and appends them together, so any resources or providers with the same name in the same directory will cause a validation error. If you were to run a terraform command now, your random_pet resource and provider block would cause errors since they are duplicated across the two files.
# For this reason terraform, provider, and random_pet are left in main.tf but dev and uat resources are moved to their own files
# (naming the bucket with prod caused bucket policy errors probably due to it being public)

# When working with monolithic configuration, you can use the terraform apply command with the -target flag to scope the resources to operate on, but that approach can be risky and is not a sustainable way to manage distinct environments
# There are two primary methods to separate state between environments: directories and workspaces.
# To separate environments with potential configuration differences, use a directory structure. Use workspaces for environments that do not greatly deviate from one another, to avoid duplicating your configurations

# 1. Directiories (e.g. 1-directories/) — cd, init, apply in each directory
# 2. Workspaces

# The following applies from 2-workspaces/

# Workspace-separated environments use the same Terraform code but have different state files, which is useful if you want your environments to stay as similar to each other as possible, for example if you are providing development infrastructure to a team that wants to simulate running in production. However, you must manage your workspaces in the CLI and be aware of the workspace you are working in to avoid accidentally performing operations on the wrong environment.
# All Terraform configurations start out in the default workspace. Type terraform workspace list to have Terraform print out the list of your workspaces with the currently selected one denoted by a *.

# terraform workspace list
# * default

# Now that you have a single main.tf file, initialize your directory to ensure your Terraform configuration is valid.
# terraform init

# terraform workspace new dev — Create dev workspace
# Any previous state files from your default workspace are hidden from your dev workspace, but your directory and file structure do not change.

# terraform init
# terraform apply -var-file=dev.tfvars

# terraform workspace new uat
# terraform apply -var-file=uat.tfvars

# When you use the default workspace with the local backend, your terraform.tfstate file is stored in the root directory of your Terraform project. When you add additional workspaces your state location changes; Terraform internals manage and store state files in the directory terraform.tfstate.d.

# terraform destroy -var-file=uat.tfvars
# terraform workspace select dev
# terraform destroy -var-file=dev.tfvars
