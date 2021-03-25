
# output "container-name" {
#   value       = docker_container.nodered_container.name
#   description = "The name of the container"
# }

# output "ip-address" {
#   value = [for i in docker_container.nodered_container[*] : join(":", [i.ip_address], [i.ports[0]["external"]])]
#   # value = join(":", [docker_container.nodered_container.ip_address, docker_container.nodered_container.ports[0].external])
#   description = "The IP address and external port of the container"
#   #sensitive = true
# }


output "application_access" {
  value = { for i in docker_container.app_container[*] : i.name => join(":", [i.ip_address], [i.ports[0]["external"]]) }
}
