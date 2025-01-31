resource "kubernetes_config_map" "postgres" {
  metadata {
    name = "postgres-config"
    labels = {
      app = var.postgres_app_name
    }
  }

  data = {
    POSTGRES_DB   = var.postgres_db
    POSTGRES_USER = var.postgres_user
  }
}

resource "kubernetes_secret" "postgres_password" {
  metadata {
    name = "postgres-password"
    labels = {
      app = var.postgres_app_name
    }
  }
  data = {
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

          env {
            name = "POSTGRES_PASSWORD"
            value_from {
              secret_key_ref {
                name = kubernetes_secret.postgres_password.metadata.0.name
                key  = "POSTGRES_PASSWORD"
              }
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
    name = "postgres-service"
    labels = {
      app = var.postgres_app_name
    }
  }

  spec {
    type = "LoadBalancer"
    selector = {
      app = var.postgres_app_name
    }
    port {
      port = 5432
    }
  }
}

locals {
  database_url = "postgres://${var.postgres_user}:${var.postgres_password}@postgres-service:5432/${var.postgres_db}"
}

resource "kubernetes_config_map" "challenge" {
  metadata {
    name = "challenge-config"
    labels = {
      app = var.challenge_app_name
    }
  }

  data = {
    NODE_ENV = "dev"
  }
}

resource "kubernetes_secret" "challenge_db_url" {
  metadata {
    name = "challenge-db-url"
    labels = {
      app = var.challenge_app_name
    }
  }

  data = {
    DATABASE_URL = local.database_url
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
    replicas = 3

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
          name  = "challenge"
          image = local.challenge_image
          env_from {
            config_map_ref {
              name = kubernetes_config_map.challenge.metadata.0.name
            }
          }

          env {
            name = "DATABASE_URL"
            value_from {
              secret_key_ref {
                name = kubernetes_secret.challenge_db_url.metadata.0.name
                key  = "DATABASE_URL"
              }
            }
          }

          resources {
            limits = {
              memory = "256Mi"
            }
            requests = {
              memory = "256Mi"
              cpu    = "100m"
            }
          }
          port {
            name           = "http"
            container_port = var.challenge_port
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "challenge" {
  metadata {
    name = "challenge-service"
  }

  spec {
    type = "LoadBalancer"
    selector = {
      app = var.challenge_app_name
    }
    port {
      port        = 80
      target_port = var.challenge_port
    }
  }
}

resource "kubernetes_ingress" "challenge" {
  metadata {
    name = "challenge-ingress"
  }

  spec {
    backend {
      service_name = kubernetes_service.challenge.metadata.0.name
      service_port = kubernetes_service.challenge.spec.0.port.port
    }
    rule {
      http {
        path {
          backend {
            service_name = kubernetes_service.challenge.metadata.0.name
            service_port = kubernetes_service.challenge.spec.0.port.port
          }

          path = "/*"
        }
      }
    }
  }
}