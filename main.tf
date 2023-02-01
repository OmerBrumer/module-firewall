/**
* # Firewall and Diagnostic Setting module
* There's an option to associate Azure Firewall Policy 
*/

#----------------------------------------------------------
# Firewall Subnet Creation or selection
#----------------------------------------------------------
resource "azurerm_subnet" "firewall_subnet" {
  name                 = var.firewall_subnet_name
  resource_group_name  = var.resource_group_name
  virtual_network_name = var.virtual_network_name
  address_prefixes     = var.firewall_subnet_address_prefix
}

#----------------------------------------------------------
# Firewall Managemnet Subnet Creation
#----------------------------------------------------------
resource "azurerm_subnet" "firewall_mgmt_subnet" {
  count = var.enable_forced_tunneling ? 1 : 0

  name                 = var.firewall_managment_subnet
  resource_group_name  = var.resource_group_name
  virtual_network_name = var.virtual_network_name
  address_prefixes     = var.firewall_management_subnet_address_prefix
}

#------------------------------------------
# Public IP resources for Azure Firewall
#------------------------------------------
resource "azurerm_public_ip" "fw-pip" {
  name                = "${var.firewall_config.name}-pip"
  resource_group_name = var.resource_group_name
  location            = var.location
  allocation_method   = var.firewall_public_ip_allocation_mode
  sku                 = var.firewall_public_ip_sku

  lifecycle {
    ignore_changes = [
      tags
    ]
  }
}

resource "azurerm_public_ip" "firewall_mgmt_pip" {
  count = var.enable_forced_tunneling ? 1 : 0

  name                = "${var.firewall_config.name}-mngmt-pip"
  resource_group_name = var.resource_group_name
  location            = var.location
  allocation_method   = var.firewall_managment_public_ip_allocation_mode
  sku                 = var.firewall_managment_public_ip_sku

  lifecycle {
    ignore_changes = [
      tags
    ]
  }
}

#-----------------
# Azure Firewall 
#-----------------
resource "azurerm_firewall" "main" {
  name                = var.firewall_config.name
  resource_group_name = var.resource_group_name
  location            = var.location
  sku_name            = var.firewall_config.sku_name
  sku_tier            = var.firewall_config.sku_tier
  firewall_policy_id  = coalesce(var.firewall_policy_id, module.firewall_policy[0].id)
  dns_servers         = var.firewall_config.dns_servers
  private_ip_ranges   = var.firewall_config.private_ip_ranges
  threat_intel_mode   = lookup(var.firewall_config, "threat_intel_mode", "Alert")
  zones               = var.firewall_config.zones

  ip_configuration {
    name                 = "configuration"
    subnet_id            = azurerm_subnet.firewall_subnet.id
    public_ip_address_id = azurerm_public_ip.fw-pip.id
  }

  dynamic "management_ip_configuration" {
    for_each = var.enable_forced_tunneling ? [var.enable_forced_tunneling] : []

    content {
      name                 = "forced-tunnel"
      subnet_id            = azurerm_subnet.firewall_mgmt_subnet[0].id
      public_ip_address_id = azurerm_public_ip.firewall_mgmt_pip[0].id
    }
  }

  lifecycle {
    ignore_changes = [
      tags
    ]
  }

  depends_on = [
    module.firewall_policy
  ]
}

module "firewall_policy" {
  source = "git::https://github.com/OmerBrumer/module-firewall-policy.git"
  count  = var.firewall_policy_id == null ? 1 : 0

  resource_group_name = var.resource_group_name
  location            = var.location
  firewall_policy = {
    name = "${var.firewall_config.name}-policy"
    sku  = var.firewall_policy.sku
  }

  network_rules     = var.network_rules
  application_rules = var.application_rules
}

module "diagnostic_settings" {
  source = "git::https://github.com/OmerBrumer/module-diagnostic-setting.git"

  log_analytics_workspace_id = var.log_analytics_workspace_id
  diagonstic_setting_name    = "${azurerm_firewall.main.name}-diagnostic-setting"
  target_resource_id         = azurerm_firewall.main.id
}