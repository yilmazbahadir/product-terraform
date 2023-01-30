resource "kubernetes_namespace" "this" {
  count = var.namespace == "default" ? 0 : 1
  metadata {
    name = var.namespace
  }
}
