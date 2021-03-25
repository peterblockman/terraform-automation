resource "docker_volume" "container_volume" {
  count = var.volume_count
  name  = "${var.volume_name}-${count.index}" # volume_name from var 
  lifecycle {
    prevent_destroy = false
  }
  provisioner "local-exec" {
    when       = destroy
    command    = "mkdir ${path.cwd}/../backup/"
    on_failure = continue
  }
  # it seems that this does not work on MAC as MAC does not store volume in /var/lib/docker
  # provisioner "local-exec" {
  #   when = destroy
  #   command = "sudo tar -czvf ${path.cwd}/../backup/${self.name}.tar.gz ${self.mountpoint}/"
  #   on_failure = fail
  # }
}