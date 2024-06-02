provider "docker" {}
provider "random" {}

resource "docker_image" "nginx" {
  name         = "nginx:latest"
  keep_locally = false
}

resource "docker_container" "nginx" {
  image = docker_image.nginx.latest
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

module "hello" {
  source  = "joatmon08/hello/random"
  version = "3.1.0"

  hello        = random_pet.dog.id
  second_hello = random_pet.dog.id

  secret_key = "secret"
}

# terraform init — will do the following:
# 1. modules downloaded — hello module is a remote module so it downloads from public Terraform Registry
# 2. initialise backend — terraform block has no cloud or backend configuration so it uses local backend
# 3. download providers — prefer lockfile > required_providers > latest
# 4. create lock file — consitent versions, and .terraform/ — store project providers and modules (do not modify manually)
# To upgrade remote modules use terraform init -upgrade (local module changes are automatically detected)
# .terraform/providers/[hostname]/[namespace]/[name]/[version]/[os_arch]

# terraform validate

# Change module hello version 3.0.1 -> 3.1.0, and random provider 3.1.0 -> 3.0.1
# terraform init — will fail due to lock file
# terraform init -upgrade (not working for m1 macs)
# terraform validate
