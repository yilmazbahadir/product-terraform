variable "name" {
  type        = string
  description = "Name of the application"
  default     = "explorer"
}

variable "deploy_name" {
  type        = string
  description = "(Required) Name of the deployment"
}

variable "namespace" {
  type        = string
  description = "(Optional) Namespace in which to create the resources"
  default     = "default"
}

variable "image_repository" {
  description = "(Optional) Docker image repository"
  type        = string
  default     = "symbolplatform/symbol-explorer"
}

variable "image_tag" {
  description = "(Optional) Docker image tag"
  type        = string
  default     = "1.1.6@sha256:6924057dadc3160e123009e21b3c2c7836a271fade553124a6703e2bf70061e6"
}

variable "image_pull_policy" {
  description = "(Optional) Docker image pull policy"
  type        = string
  default     = "IfNotPresent"
}

variable "image_pull_secrets" {
  description = "(Optional) Image pull secrets"
  type        = list(string)
  default     = []
}

variable "replica_count" {
  description = "(Optional) Replica count of deployment pods"
  type        = number
  default     = 1
}

variable "http_port" {
  description = "(Optional) Http port"
  type        = number
  default     = 4000
}

variable "config_endpoints" {
  description = "(Optional) Config endpoints"
  type = object({
    market_data        = string
    statistics_service = string
  })
  default = {
    market_data        = "https://min-api.cryptocompare.com/"
    statistics_service = "https://symbol.services"
  }
}

variable "config_network" {
  description = "(Optional) Config endpoints"
  type = object({
    namespace_name     = string
    mosaic_id          = string
    divisibility       = number
    network_identifier = number
  })
  default = {
    divisibility       = 6
    mosaic_id          = "6BED913FA20223F8"
    namespace_name     = "symbol.xym"
    network_identifier = 104
  }
}

variable "pod_annotations" {
  description = "Annotations for pod"
  type        = map(string)
  default     = {}
}

variable "custom_labels" {
  description = "(Optional) Custom labels for the resources"
  type        = map(string)
  default     = null
}

variable "annotations" {
  description = "(Optional) Annotations for the StatefulSet"
  type        = map(string)
  default     = {}
}

variable "strategy" {
  description = "(Optional) Type of deployment. Can be 'Recreate' or 'RollingUpdate'"
  type        = string
  default     = "RollingUpdate"
}

variable "pod_security_context" {
  description = "(Optional) User id"
  type = object({
    runAsUser  = number
    runAsGroup = number
  })
  default = null
}

variable "liveness_probe_enabled" {
  description = "(Optional) Enable liveness probe for statefulset"
  type        = bool
  default     = true
}

variable "liveness_probe_initial_delay" {
  description = "(Optional) Liveness probe initial delay seconds"
  type        = number
  default     = 60
}

variable "liveness_probe_period" {
  description = "(Optional) Liveness probe period seconds"
  type        = number
  default     = 120
}

variable "readiness_probe_enabled" {
  description = "(Optional) Enable readiness probe for statefulset"
  type        = bool
  default     = true
}

variable "readiness_probe_initial_delay" {
  description = "(Optional) Readiness probe initial delay seconds"
  type        = number
  default     = 60
}

variable "readiness_probe_period" {
  description = "(Optional) Readiness probe period seconds"
  type        = number
  default     = 120
}

variable "resources" {
  description = "(Optional) Resource limits and requests"
  type = object({
    limits   = map(any),
    requests = map(any)
  })
  default = null
}

variable "termination_grace_period" {
  description = "(Optional) The application is given a certain amount of time(seconds) to shutdown before it's terminated forcefully"
  type        = number
  default     = 300
}

variable "ingress_enabled" {
  description = "(Optional) Ingress enabled"
  type        = bool
  default     = false
}

variable "ingress_class_name" {
  description = "(Optional) Ingress class name"
  type        = string
  default     = "nginx"
}

variable "ingress_annotations" {
  description = "(Optional) Ingress annotations"
  type        = list(any)
  default     = []
}

variable "ingress_rules" {
  description = "(Optional) Ingress rules and paths"
  #   type        = list(any)
  type = list(object({
    host = string
    paths = list(object({
      path                 = string
      path_type            = string
      backend_service_port = number
    }))
  }))
  default = [{
    host = "localhost"
    paths = [
      {
        path                 = "/"
        path_type            = "ImplementationSpecific"
        backend_service_port = 4000
      }
    ]
  }]
}

variable "ingress_tls" {
  description = "Ingress TLS parameters"
  type        = list(any)
  default     = []
}
