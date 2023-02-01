module "firewall" {
  source = "./modules/security/firewall"

  virtual_network_name           = "brumer-final-terraform-hub-vnet"
  resource_group_name            = "brumer-final-terraform-hub-rg"
  location                       = "West Europe"
  firewall_subnet_address_prefix = ["10.0.1.0/26"]
  firewall_config = {
    name              = "brumer-final-terraform-hub-firewall"
    sku_name          = "AZFW_VNet"
    sku_tier          = "Standard"
    threat_intel_mode = "Alert"
  }

  enable_forced_tunneling                   = true
  firewall_management_subnet_address_prefix = ["10.0.2.0/26"]

  firewall_policy = {
    sku = "Standard"
  }

  network_rules = jsondecode(templatefile("./firewall_policies/network_rules.json", {
    vpn_gateway_subnet_adress_prefix     = "10.11.0.0/24",
    endpoint_subnet_address_prefix       = "10.0.4.0/26",
    workspoke_main_subnet_address_prefix = "10.1.0.0/24",
    monitorspoke_subnet_address_prefix   = "10.2.0.0/24",
    monitorspoke_virtual_machine         = "10.2.0.4"
    }
  ))

  log_analytics_workspace_id = "/subscriptions/d94fe338-52d8-4a44-acd4-4f8301adf2cf/resourcegroups/brumer-final-terraform-hub-rg/providers/microsoft.operationalinsights/workspaces/brumer-final-terraform-hub-log-analytics"
}