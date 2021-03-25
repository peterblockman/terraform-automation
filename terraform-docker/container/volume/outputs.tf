output "volume_output" {
  value = docker_volume.container_volume[*].name
  #where does the docker_volume come from? from main.tf
  # this expose to outside world
}