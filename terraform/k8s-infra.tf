data "kubectl_path_documents" "docs" {
  pattern = "./k8s_manifests/*.yaml"
}

resource "kubectl_manifest" "kubegres" {
  for_each  = toset(data.kubectl_path_documents.docs.documents)
  yaml_body = each.value
}

resource "kubernetes_secret" "postgres_secret" {
  metadata {
    name      = "postgres-secret"
    labels = {
      app = var.postgres_app_name
    }
  }

  data = {
    # Yes this is bad practice but this isn't super high-risk activity
    superUserPassword       = var.postgres_password
    replicationUserPassword = var.postgres_password
  }

  type = "Opaque"
}

resource "kubernetes_config_map" "postgres" {
  metadata {
    name = "postgres-config"
    labels = {
      app = var.postgres_app_name
    }
  }

  data = {
    POSTGRES_DB   = var.postgres_db
  }
}

# TODO: Migrate all of this to using Kubegres

locals {
  database_url = "postgres://${var.postgres_user}:${var.postgres_password}@postgres:5432/${var.postgres_db}"
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

  type = "Opaque"
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
      port        = var.challenge_port
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
      service_port = kubernetes_service.challenge.spec.0.port.0.port
    }
    rule {
      http {
        path {
          backend {
            service_name = kubernetes_service.challenge.metadata.0.name
            service_port = kubernetes_service.challenge.spec.0.port.0.port
          }

          path = "/*"
        }
      }
    }
  }
}