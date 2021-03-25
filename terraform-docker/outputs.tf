# output "IP-Address" {
#   value = flatten(module.container[*].container-name)
#   # value = join(":", [docker_container.nodered_container.ip_address, docker_container.nodered_container.ports[0].external])
#   description = "The IP address and external port of the container"
#   #sensitive = true
# }

# output "container-name" {
#   value       = module.container[*].ip-address
#   description = "The name of the container"
# }


output "application_access" {
  # value = [for i in module.container[*]: i]
  # since we are not manipulation the outputs, the for loop is not neccesary, you 
  # can just use module.container for simplicity
  value       = module.container
  description = "The name and socker for each application"
}