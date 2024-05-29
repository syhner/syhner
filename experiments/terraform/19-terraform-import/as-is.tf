# docker_container.as-is:
resource "docker_container" "as-is" {
  attach = false
  command = [
    "nginx",
    "-g",
    "daemon off;",
  ]
  cpu_shares = 0
  dns        = []
  dns_opts   = []
  dns_search = []
  entrypoint = [
    "/docker-entrypoint.sh",
  ]
  env               = []
  group_add         = []
  hostname          = "374ed3e84264"
  image             = "sha256:9e7e7b26c784556498f584508123ae46da82b4915e262975893be4c8ec8009a5"
  init              = false
  ipc_mode          = "private"
  log_driver        = "json-file"
  log_opts          = {}
  logs              = false
  max_retry_count   = 0
  memory            = 0
  memory_swap       = 0
  must_run          = true
  name              = "as-is"
  network_mode      = "default"
  privileged        = false
  publish_all_ports = false
  read_only         = false
  remove_volumes    = true
  restart           = "no"
  rm                = false
  security_opts     = []
  shm_size          = 64
  start             = true
  stdin_open        = false
  storage_opts      = {}
  sysctls           = {}
  tmpfs             = {}
  tty               = false

  ports {
    external = 8080
    internal = 80
    ip       = "0.0.0.0"
    protocol = "tcp"
  }
}

# 1. terraform show -no-color > example.tf — copy the Terraform state for the imported resource into a configuration file
# 2. terraform plan, identify and remove read-only (and optionally, deprecated) configuration arguments from example.tf
# 3. terraform plan, confirm the configuration is correct (in this case, container will be replaced since env attribute is not set)

# add 'env = []' to docker resource
# terraform plan — verify the changes, now the update will be in-place

# 4. terraform apply — finish synchronizing your infrastructure, state, and configuration

# Since the approach shown here loads all of the attributes represented in Terraform state, your configuration includes optional attributes whose values are the same as their defaults. Which attributes are optional, and their default values, will vary from provider to provider, and can be found in the provider documentation.
# Provider documentation may not indicate if a change is safe. You must understand the lifecycle of the underlying resource in order to know if a given change is safe to apply.
# Optionally, we can remove all of these attributes, keeping only the required attributes and any that are specific to your container. At this point, running terraform plan or terraform apply will show no changes, since the configuration only includes the minimum set of attributes needed to recreate the container example as if we went through the cherry-picked route.

/*
resource "docker_container" "example" {
    image = "sha256:9e7e7b26c784556498f584508123ae46da82b4915e262975893be4c8ec8009a5"
    name  = "example"

    env = []

    ports {
      external = 8080
      internal = 80
    }
}
*/

# now the resource will end up matching the cherry-picked example
