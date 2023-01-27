resource "kubernetes_service" "this" {
  metadata {
    name      = local.full_name
    labels    = local.labels
    namespace = var.namespace
  }

  spec {
    port {
      name     = "http"
      protocol = "TCP"
      port     = var.http_port
    }

    selector = local.labels
    type     = "ClusterIP"
  }
}
