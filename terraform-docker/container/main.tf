
resource "random_string" "random" {
  count   = var.count_in
  length  = 4
  special = false
  upper   = false
}


resource "docker_container" "app_container" {
  count = var.count_in
  name  = join("-", [var.name_in, random_string.random[count.index].result])
  image = var.image_in
  ports {
    internal = var.int_port_in
    external = var.ext_port_in[count.index]
  }
  dynamic "volumes" {
    for_each = var.volumes_in
    content {
      container_path = volumes.value["container_path_each"]
      # host_path      = var.host_path_in volume replace this
      # volume_name = docker_volume.container_volume[volumes.key].name
      volume_name = module.volume[count.index].volume_output[volumes.key] # module is defined below

    }
  }
  # provisioner "local-exec" {
  #   when = destroy
  #   command = "echo ${self.name}: ${self.ip_address}:${join("", [for x in self.ports["*"]["external"]: x])}} >> containers.txt"
  # }
}

module "volume" {
  source = "./volume"
  count = var.count_in
  volume_count = length(var.volumes_in)
  volume_name = "${var.name_in}-${terraform.workspace}-${random_string.random[count.index].result}-volume"
}