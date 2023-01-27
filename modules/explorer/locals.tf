locals {
  full_name = "${var.name}-${var.deploy_name}"
  labels = var.custom_labels == null ? { "app.kubernetes.io/instance" = var.deploy_name
  "app.kubernetes.io/name" = var.name } : var.custom_labels
  image_name = "${var.image_repository}:${var.image_tag}"
  config_endpoints_json = json_encode({
    "marketData"        = var.config_endpoints.market_data
    "statisticsService" = var.config_endpoints.statistics_service
  })
  config_network_json = json_encode({
    "namespaceName"     = var.config_network.namespace_name
    "mosaicId"          = var.config_network.mosaic_id
    "divisibility"      = var.config_network.divisibility
    "networkIdentifier" = var.config_network.network_identifier
  })
}
