resource "kubernetes_config_map" "configmap" {
  metadata {
    name      = local.full_name
    labels    = local.labels
    namespace = var.namespace
  }

  data = {
    "endpoints"     = "${local.config_endpoints_json}"
    "networkConfig" = "${local.config_network_json}"
  }
}
