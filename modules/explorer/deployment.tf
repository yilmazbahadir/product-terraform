resource "kubernetes_deployment_v1" "this" {
  metadata {
    name      = local.full_name
    namespace = var.namespace

    labels = local.labels
  }

  spec {
    replicas = var.replica_count

    selector {
      match_labels = local.labels
    }

    template {
      metadata {
        annotations = var.pod_annotations
        # selector_labels?
        labels = local.labels
      }

      spec {
        dynamic "image_pull_secrets" {
          for_each = var.image_pull_secrets

          content {
            name = image_pull_secrets
          }
        }

        dynamic "security_context" {
          for_each = var.pod_security_context != null ? { security_context_enabled = true } : {}
          content {
            run_as_user  = var.pod_security_context.runAsUser
            run_as_group = var.pod_security_context.runAsGroup
          }
        }

        container {
          name              = var.name
          image             = local.image_name
          image_pull_policy = var.image_pull_policy

          port {
            name           = "http"
            container_port = var.http_port
            protocol       = "TCP"
          }

          env_from {
            config_map_ref {
              name = local.full_name
            }
          }

          dynamic "liveness_probe" {
            for_each = var.liveness_probe_enabled ? [1] : []

            content {
              tcp_socket {
                port = "http"
              }

              initial_delay_seconds = var.liveness_probe_initial_delay
              period_seconds        = var.liveness_probe_period
            }
          }

          dynamic "readiness_probe" {
            for_each = var.readiness_probe_enabled ? [1] : []
            content {
              tcp_socket {
                port = "http"
              }

              initial_delay_seconds = var.readiness_probe_initial_delay
              period_seconds        = var.readiness_probe_period
            }
          }
          dynamic "resources" {
            for_each = var.resources != null ? { resources_enabled = true } : {}

            content {
              limits   = var.resources.limits
              requests = var.resources.requests
            }
          }
        }
      }
    }
  }
}
