#Firewall
output "id" {
  description = "Id of firewall."
  value       = azurerm_firewall.main.id
}

output "name" {
  description = "Name of firewall."
  value       = azurerm_firewall.main.name
}

output "object" {
  description = "Object of firewall."
  value       = azurerm_firewall.main
}

#Firewall subnet
output "subnet_id" {
  description = "Id of firewall subnet."
  value       = azurerm_subnet.firewall_subnet.id
}

output "subnet_name" {
  description = "Name of firewall subnet."
  value       = azurerm_subnet.firewall_subnet.name
}

output "subnet_object" {
  description = "Object of firewall subnet."
  value       = azurerm_subnet.firewall_subnet
}

#Firewall mgmt subnet
output "mgmt_subnet_id" {
  description = "Id of firewall management subnet."
  value       = try(azurerm_subnet.firewall_mgmt_subnet[0].id, null)
}

output "mgmt_subnet_name" {
  description = "Name of firewall management subnet."
  value       = try(azurerm_subnet.firewall_mgmt_subnet[0].name, null)
}

output "mgmt_subnet_object" {
  description = "Object of firewall management subnet."
  value       = try(azurerm_subnet.firewall_mgmt_subnet[0], null)
}

#Firewall pip
output "private_ip_id" {
  description = "Id of firewall private ip."
  value       = azurerm_public_ip.fw-pip.id
}

output "private_ip_name" {
  description = "Name of firewall private ip."
  value       = azurerm_public_ip.fw-pip.name
}

output "private_ip_object" {
  description = "Ojbect of firewall private ip."
  value       = azurerm_public_ip.fw-pip
}

#Firewall mgmt pip
output "mgmt_private_ip_id" {
  description = "Id of firewall management private ip."
  value       = try(azurerm_public_ip.firewall_mgmt_pip[0].id, null)
}

output "mgmt_private_ip_name" {
  description = "Name of firewall management private ip."
  value       = try(azurerm_public_ip.firewall_mgmt_pip[0].name, null)
}

output "mgmt_private_ip_object" {
  description = "Object of firewall management private ip."
  value       = try(azurerm_public_ip.firewall_mgmt_pip[0], null)
}