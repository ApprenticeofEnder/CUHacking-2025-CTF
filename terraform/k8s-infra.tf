resource "kubernetes_config_map" "postgres" {
  metadata {
    name = "postgres-secret"
    labels = {
      app = var.postgres_app_name
    }
  }

  data = {
    POSTGRES_DB       = var.postgres_db
    POSTGRES_USER     = var.postgres_user
    POSTGRES_PASSWORD = var.postgres_password
  }
}

resource "kubernetes_persistent_volume" "postgres" {
  metadata {
    name = "postgres-volume"
    labels = {
      type = "local"
      app  = var.postgres_app_name
    }
  }
  spec {
    capacity = {
      storage = "${var.postgres_capacity}"
    }
    access_modes = ["ReadWriteMany"]
    persistent_volume_source {
      vsphere_volume {
        volume_path = "/data/postgresql"
      }
    }
  }
}

resource "kubernetes_persistent_volume_claim" "postgres" {
  metadata {
    name = "postgres-volume-claim"
    labels = {
      app = var.postgres_app_name
    }
  }
  spec {
    access_modes = ["ReadWriteMany"]
    resources {
      requests = {
        storage = "${var.postgres_capacity}"
      }
    }
    volume_name = kubernetes_persistent_volume.postgres.metadata.0.name
  }
}

resource "kubernetes_deployment" "postgres" {
  metadata {
    name = "postgres"
    labels = {
      app = var.postgres_app_name
    }
  }

  spec {
    replicas = 3

    selector {
      match_labels = {
        app = var.postgres_app_name
      }
    }

    template {
      metadata {
        labels = {
          app = var.postgres_app_name
        }
      }

      spec {
        container {
          image = "postgres:17"
          name  = "db"

          image_pull_policy = "IfNotPresent"

          port {
            container_port = 5432
          }

          env_from {
            config_map_ref {
              name = kubernetes_config_map.postgres.metadata.0.name
            }
          }

          volume_mount {
            mount_path = "/var/lib/postgresql/data"
            name       = "postgres_data"
          }
        }

        volume {
          name = "postgres_data"
          persistent_volume_claim {
            claim_name = kubernetes_persistent_volume_claim.postgres.metadata.0.name
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "postgres" {
  metadata {
    name = "postgres"
    labels = {
      app = var.postgres_app_name
    }
  }

  spec {
    type = "NodePort"
    selector = {
      app = var.postgres_app_name
    }
    port {
      port = 5432
    }
  }
}

locals {
  database_url = "postgres://${var.postgres_user}:${var.postgres_password}@${var.postgres_app_name}:5432/${var.postgres_db}"
}

resource "kubernetes_config_map" "challenge" {
  metadata {
    name = "challenge-secret"
    labels = {
      app = var.challenge_app_name
    }
  }

  data = {
    DATABASE_URL = local.database_url
    NODE_ENV     = "dev"
  }
}

locals {
  challenge_image = "${var.image_registry}/${var.challenge_image_name}:${var.challenge_image_tag}"
}

resource "kubernetes_deployment" "challenge" {
  metadata {
    name = "challenge"
    labels = {
      app = var.challenge_app_name
    }
  }

  spec {
    selector {
      match_labels = {
        app = var.challenge_app_name
      }
    }

    template {
      metadata {
        labels = {
          app = var.challenge_app_name
        }
      }
      spec {
        image_pull_secrets {
          name = "docker-registry-creds"
        }
        container {
          name = "challenge"
          image = local.challenge_image
          env_from {
            config_map_ref {
              name = kubernetes_config_map.challenge.metadata.0.name
            }
          }
          resources {
            limits = {
              memory = "256Mi"
            }
            requests = {
              memory = "256Mi"
              cpu= "100m"
            }
          }
          port {
            name = "http"
            container_port = var.challenge_port
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "challenge" {
  metadata {
    name = "challenge"
  }

  spec {
    selector = {
      app = var.challenge_app_name
    }
    port {
      port = 80
      target_port = var.challenge_port
    }
  }
}

