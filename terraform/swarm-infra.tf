data "docker_registry_image" "challenge" {
  name = "${var.image_registry}/${var.challenge_image_name}:${var.challenge_image_tag}"
}

data "docker_registry_image" "postgres" {
  name = "postgres:17.2"
}

resource "docker_image" "challenge" {
  name          = data.docker_registry_image.challenge.name
  pull_triggers = [data.docker_registry_image.challenge.sha256_digest]
}

resource "docker_image" "db" {
  name          = data.docker_registry_image.postgres.name
  pull_triggers = [data.docker_registry_image.postgres.sha256_digest]
}
