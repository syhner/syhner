# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

provider "docker" {
  host = "unix:///var/run/docker.sock"
}

# You can use the import command to migrate existing resources into your Terraform state file. The import command does not currently generate the configuration for the imported resource, so you must write the corresponding configuration block to map the imported resource to it.

# Importing infrastructure involves five steps:
# 1. Identify the existing infrastructure you will import.
# 2. Import infrastructure into your Terraform state file.
# 3. Write Terraform configuration that matches that infrastructure.
# 4. Review the Terraform plan to ensure the configuration matches the expected state and infrastructure.
# 5. Apply the configuration to update your Terraform state.

# Importing infrastructure manipulates Terraform state and can corrupt the state file for existing projects. Make a backup of your terraform.tfstate file and .terraform directory before using Terraform import on a real Terraform project, and store them securely.

# Create the infrastructure
# docker run --name example --detach --publish 8080:80 nginx:latest — create and run the container
# docker ps --filter="name=example" — check if container is running

# terraform init

# Represent the docker container
# echo 'resource "docker_container" "example" {}' > example.tf

# terraform import docker_container.example $(docker inspect --format="{{.ID}}" example) — Attach the existing Docker container to the docker_container.example resource. Terraform import requires this Terraform resource ID and the full Docker container ID. The ID terraform import requires varies by resource type. You can find the required ID in the provider documentation for the resource you wish to import.
# terraform show — importing the container pulled all of the displayed data about the resource into the state file under the resource ID specified (docker_container.example). However, Terraform import does not create the configuration for the resource.

# terraform plan — there will be missing arguments or changes since the configuration doesn't match the imported state, so either:
# 1. Accept entire current state example. This approach is often faster, but can lead to overly verbose configuration since not all attributes in state are necessary in the configuration.
# 2. Cherry-pick required attributes into configuration one at a time. This creates a more manageable configuration, but requires understanding which attributes are required.

# See as-is.tf and cherry-picked.tf for examples of the two approaches.

# If an update is in-place, then the container will keep running during an apply. The updates in these examples will be to add 'attach', 'logs', 'must_run' and 'start' attributes. Terraform uses these attributes to create Docker containers, but Docker does not store them. As a result, terraform import did not load their values into state. When you plan and apply your configuration, the Docker provider will assign the default values for these attributes and save them in state, but they will not affect the running container.

# Create another docker resource under docker.tf with the cherry-picked approach
# Check image id (sha256:9e7e7b26) from docker.tf
# docker image inspect sha256:9e7e7b26 -f {{.RepoTags}} — image's tag name (nginx:latest)
# echo 'resource "docker_image" "nginx" { name = "nginx:latest" }' >> docker.tf
# terraform apply — create image resource in state (using the image in the docker_container.web resource will force a replacement since the image is not in state)
# Now we can use the image resource as the container resource's image (in docker.tf)
# terraform apply — no changes sinced ocker_image.nginx.latest will match the hardcoded image ID that was replaced

# terraform destroy
# Since you added both the image and the container to your Terraform configuration, Terraform will remove both from Docker. If there were another container using the same image, the destroy step would fail. Remember that importing a resource into Terraform means that Terraform will manage the entire lifecycle of the resource, including destruction.

# Terraform import uses the current state of your infrastructure reported by the Terraform provider. It cannot determine the health of the infrastructure, the intent of the infrastructure, or changes made to the infrastructure that are not in Terraform's control, such as the state of a Docker container's filesystem.
# Terraform import does not detect or generate relationships between infrastructure.
# Importing involves manual steps which can be error prone, especially if the operator lacks context about the purpose and history of the infrastructure.
# Not all providers and resources support Terraform import
# Importing a resource into Terraform does not mean that Terraform can destroy and recreate it. For example, the imported infrastructure could rely on other unmanaged infrastructure or configuration
# If you store your state in a remote backend, you may need to set local variables equivalent to the remote workspace variables. The import command always runs locally and cannot access data from the remote backend, unlike commands like apply, which run inside your Terraform Cloud environment.
