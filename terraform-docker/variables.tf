# this is replaced by workspace
# variable "env" {
#   type = string
#   default = "dev"
# }

variable "image" {
  type        = map(any)
  description = "Image for container"
  default = {
    nodered = {
      dev  = "nodered/node-red:latest"
      prod = "nodered/node-red:latest-minimal"
    }
    influxdb = {
      dev  = "quay.io/influxdb/influxdb:v2.0.2"
      prod = "quay.io/influxdb/influxdb:v2.0.2"
    }
    grafana = {
      dev  = "grafana/grafana:latest"
      prod = "grafana/grafana:latest"
    }
  }
}
variable "ext_port" {
  type = map(any)
  #sensitive = true
  # validation {
  #   condition     = min(var.ext_port["dev"]...) <= 65535 && min(var.ext_port["dev"]...) > 1980
  #   error_message = "The external port must be in the valid range 0 - 65535."
  # }

  # validation {
  #   condition     = min(var.ext_port["prod"]...) <= 1980 && min(var.ext_port["prod"]...) > 1879
  #   error_message = "The external port must be in the valid range 0 - 65535."
  # }
}

variable "int_port" {
  type    = number
  default = 1880

  validation {
    condition     = var.int_port == 1880
    error_message = "The internal port must be 1880."
  }
}

# variable "container_count" {
#   type    = number
#   default = 3
# }
