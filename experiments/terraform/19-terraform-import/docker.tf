resource "docker_container" "web" {
  name  = "hashicorp-learn"
  image = docker_image.nginx.latest

  env = []

  ports {
    external = 8081
    internal = 80
  }
}

resource "docker_image" "nginx" {
  name = "nginx:latest"
}
