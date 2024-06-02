resource "docker_container" "cherry-picked" {
  name  = "cherry-picked"
  image = "sha256:9e7e7b26c784556498f584508123ae46da82b4915e262975893be4c8ec8009a5"

  env = []

  ports {
    external = 8000
    internal = 80
  }
}


# To cherry-pick the configuration for your Docker container, you will add the missing required attributes which caused the errors in your plan. Terraform cannot generate a plan without all of the required attributes for your resource.

# 1. terraform show, find & add the missing arguments to the resource (image and name)
# 2. terraform plan, copy attributes that force replacements (env and ports) to the resource but skip optional attributes (ports.ip and ports.protocol) (as known from the provider documentation)
# 3. terraform plan — verify the changes, now the update will be in-place
# 4. terraform apply — finish synchronizing your infrastructure, state, and configuration
