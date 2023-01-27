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
        image_pull_secrets = var.image_pull_secrets
        security_context {
          count = var.pod_security_context.runAsUser != null ? 1 : 0

          run_as_user  = var.pod_security_context.runAsUser
          run_as_group = var.pod_security_context.runAsGroup
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
            config_map_ref = local.full_name
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
          resources {
            limits   = var.resources.limits
            requests = var.resources.requestes
          }
        }
      }
    }
  }
}
