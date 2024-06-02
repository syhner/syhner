provider "docker" {}

provider "random" {}

provider "time" {}

resource "docker_image" "nginx" {
  name         = "nginx:latest"
  keep_locally = true
}

resource "random_pet" "nginx" {
  length = 2
}

resource "docker_container" "nginx" {
  count = 4 # can use count.index (0-3) with modulo division e.g. subnet_id = module.vpc.private_subnets[count.index % length(module.vpc.private_subnets)] to distribute the resource count over another resource
  image = docker_image.nginx.latest
  name  = "nginx-${random_pet.nginx.id}-${count.index}"

  ports {
    internal = 80
    external = 8000 + count.index
  }
}

# terraform init

# terraform apply — this will:
# 1. Lock your project's state (error if there is an existing lock file .terraform.tfstate.lock.info)
# 2. Create a plan, and wait for you to approve it.
# 3. Execute the steps defined in the plan (will maximise parallelsation)
# 4. Update your project's state file with a snapshot of the current state of your resources
# 5. Unlock state file
# 6. Print out a report of the changes it made, as well as any output values defined in your configuration.

# curl $(terraform output -json nginx_hosts | jq -r '.[0].host')

# If there are errors during apply:
# 1. Logs the error and reports it to the console.
# 2. Updates the state file with any changes to your resources.
# 3. Unlocks the state file.
# 4. Exits.

# Terraform does not support rolling back a partially-completed apply. Because of this, your infrastructure may be in an invalid state after a Terraform apply step errors out. After you resolve the error, you must apply your configuration again to update your infrastructure to the desired state.

# Below code will introduce an error (we will remove docker image during sleep time)

resource "docker_image" "redis" {
  name         = "redis:latest"
  keep_locally = true
}

resource "time_sleep" "wait_60_seconds" {
  depends_on = [docker_image.redis]

  create_duration = "60s"
}

resource "docker_container" "data" {
  depends_on = [time_sleep.wait_60_seconds]
  image      = docker_image.redis.latest
  name       = "data"

  ports {
    internal = 6379
    external = 6379
  }
}

# terraform apply (then run 'docker image rm redis:latest' in another terminal)
# terraform show — prints out Terraform's current understanding of the state of your resources. Does not refresh state.

# The next time you plan a change to this project, Terraform will update the current state of your resources from the underlying APIs using the providers you have installed. Terraform will notice that the image represented by the docker_image.redis resource no longer exists. When you apply your configuration, Terraform will recreate the image resource before creating the docker_container.data container.

# terraform apply

# terraform state list
# terraform apply -replace "docker_container.nginx[1]" — replace the second nginx container

# Use the -replace argument when a resource has become unhealthy or stops working in ways that are outside of Terraform's control. For instance, a misconfiguration in your Docker container's OS configuration could require that the container be replaced. There is no corresponding change to your Terraform configuration, so you want to instruct Terraform to reprovision the resource using the same configuration.

# The second case where you may need to partially apply configuration is when troubleshooting an error that prevents Terraform from applying your entire configuration at once. This type of error may occur when a target API or Terraform provider error leaves your resources in an invalid state that Terraform cannot resolve automatically. Use the -target command line argument when you apply to target individual resources. Refer to the Target resources tutorial for more information.

# terraform destroy
