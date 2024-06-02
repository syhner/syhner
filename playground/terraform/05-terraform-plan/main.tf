provider "docker" {}
provider "random" {}

resource "docker_image" "nginx" {
  name = "nginx:latest"
}

resource "docker_container" "nginx" {
  image = docker_image.nginx.image_id
  name  = "hello-terraform"

  ports {
    internal = 80
    external = 8000
  }
}

resource "random_pet" "dog" {
  length = 2
}

module "nginx-pet" {
  source = "./nginx"

  container_name = "hello-${random_pet.dog.id}"
  nginx_port     = 8001
}

# module "hello" {
#   source  = "joatmon08/hello/random"
#   version = "6.0.0"

#   hellos = {
#     hello        = random_pet.dog.id
#     second_hello = "World"
#   }

#   some_key = "NOTSECRET"
# }

# terraform init

# If you do not pass a saved plan to the apply command, then it will perform all of the functions of plan and prompt you for approval before making the changes.

# terraform plan -out tfplan — output plan to file
# terraform show -json tfplan | jq > tfplan.json — convert plan to json and make human readable

# jq '.terraform_version, .format_version' tfplan.json — show terraform version and format version
# jq '.configuration.provider_config' tfplan.json — show provider config
# jq '.configuration.root_module.resources' tfplan.json — show resources at root module
# jq '.configuration.root_module.module_calls' tfplan.json — show module calls at root module
# jq '.configuration.root_module.resources[0].expressions.image.references' tfplan.json — show references to image resource which helps Terraform to understand the order of operations

# jq '.resource_changes[] | select( .address == "docker_image.nginx")' tfplan.json
# The action field captures the action taken for this resource, in this case create.
# The before field captures the resource state prior to the run. In this case, the value is null because the resource does not yet exist.
# The after field captures the state to define for the resource.
# The after_unknown field captures the list of values that will be computed or determined through the operation and sets them to true.
# The before_sensitive and after_sensitive fields capture a list of any values marked sensitive. Terraform will use these lists to determine which output values to redact when you apply your configuration.

# jq '.planned_values' tfplan.json — differences between the "before" and "after" values of your resources
# jq '.planned_values.root_module.child_modules' tfplan.json — resources created by child modules

# terraform apply tfplan — no prompt for approval and instead immediately execute the changes, since this workflow is primarily used in automation

module "hello" {
  source  = "joatmon08/hello/random"
  version = "6.0.0"

  hellos = {
    hello        = random_pet.dog.id
    second_hello = "World"
  }

  some_key = var.secret_key
}

# terraform plan -out tfplan-input-vars
# terraform show -json tfplan-input-vars | jq > tfplan-input-vars.json
# jq '.variables' tfplan-input-vars.json

# jq '.prior_state' tfplan-input-vars.json
# Unlike the first run's plan file, this file now contains a prior_state object, which captures the state file exactly as it was prior to the plan action

# To determine whether state drift occurred, Terraform performs a refresh operation before it begins to build an execution plan. This refresh step pulls the actual state of all of the resources currently tracked in your state file. Terraform does not update your actual state file, but captures the refreshed state in the plan file.
# jq '.resource_drift' tfplan-input-vars.json
# Notice that the action listed is an update, which instructs Terraform to modify the state to reflect the detected state drift

# jq '.resource_changes[] | select( .address == "module.hello.random_pet.server")' tfplan-input-vars.json

# terraform destroy
