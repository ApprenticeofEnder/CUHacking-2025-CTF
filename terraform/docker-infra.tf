resource "docker_image" "challenge" {
  name = "zoo"
  build {
    context = "${path.module}/../challenge"
  }
  triggers = {
    dir_sha1 = sha1(join("", [for f in fileset(path.module, "../challenge/*") : filesha1(f)]))
  }
}

data "docker_registry_image" "postgres" {
  name = "postgres:17"
}

resource "docker_image" "db" {
  name          = data.docker_registry_image.postgres.name
  pull_triggers = [data.docker_registry_image.postgres.sha256_digest]
}

resource "docker_volume" "db_volume" {
  name = "db-volume"
}

resource "docker_service" "db" {
  name = "database"

  task_spec {
    container_spec {
      image = docker_image.db.name

      env = {
        POSTGRES_PASSWORD = var.postgres_password
      }

      mounts {
        target    = "/var/lib/postgresql/data"
        source    = docker_volume.db_volume.name
        type      = "bind"
        read_only = false

        bind_options {
          propagation = "rprivate"
        }

      }
    }
    placement {
      constraints = [
        "node.role==manager",
      ]

      prefs = [
        "spread=node.role.manager",
      ]

      max_replicas = 1
    }
  }

  endpoint_spec {
    ports {
      target_port    = "5432"
      published_port = "5432"
    }
  }
}

