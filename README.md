<!-- BEGIN_TF_DOCS -->

# Firewall and Diagnostic Setting module
There's an option to associate Azure Firewall Policy

## Examples
```hcl
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
```

#### Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | n/a |

#### Outputs

| Name | Description |
|------|-------------|
| <a name="output_id"></a> [id](#output\_id) | Id of firewall. |
| <a name="output_mgmt_private_ip_id"></a> [mgmt\_private\_ip\_id](#output\_mgmt\_private\_ip\_id) | Id of firewall management private ip |
| <a name="output_mgmt_private_ip_name"></a> [mgmt\_private\_ip\_name](#output\_mgmt\_private\_ip\_name) | Name of firewall management private ip. |
| <a name="output_mgmt_private_ip_object"></a> [mgmt\_private\_ip\_object](#output\_mgmt\_private\_ip\_object) | Object of firewall management private ip. |
| <a name="output_mgmt_subnet_id"></a> [mgmt\_subnet\_id](#output\_mgmt\_subnet\_id) | Id of firewall management subnet |
| <a name="output_mgmt_subnet_name"></a> [mgmt\_subnet\_name](#output\_mgmt\_subnet\_name) | Name of firewall management subnet |
| <a name="output_mgmt_subnet_object"></a> [mgmt\_subnet\_object](#output\_mgmt\_subnet\_object) | Object of firewall management subnet |
| <a name="output_name"></a> [name](#output\_name) | Name of firewall. |
| <a name="output_object"></a> [object](#output\_object) | Object of firewall. |
| <a name="output_private_ip_id"></a> [private\_ip\_id](#output\_private\_ip\_id) | Id of firewall private ip |
| <a name="output_private_ip_name"></a> [private\_ip\_name](#output\_private\_ip\_name) | Name of firewall private ip |
| <a name="output_private_ip_object"></a> [private\_ip\_object](#output\_private\_ip\_object) | Ojbect of firewall private ip |
| <a name="output_subnet_id"></a> [subnet\_id](#output\_subnet\_id) | Id of firewall subnet |
| <a name="output_subnet_name"></a> [subnet\_name](#output\_subnet\_name) | Name of firewall subnet |
| <a name="output_subnet_object"></a> [subnet\_object](#output\_subnet\_object) | Object of firewall subnet |

#### Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_firewall_config"></a> [firewall\_config](#input\_firewall\_config) | (Required)Manages an Azure Firewall configuration. | <pre>object({<br>    name              = string<br>    sku_name          = optional(string)<br>    sku_tier          = optional(string)<br>    dns_servers       = optional(list(string))<br>    private_ip_ranges = optional(list(string))<br>    threat_intel_mode = optional(string)<br>    zones             = optional(list(string))<br>  })</pre> | n/a | yes |
| <a name="input_firewall_subnet_address_prefix"></a> [firewall\_subnet\_address\_prefix](#input\_firewall\_subnet\_address\_prefix) | (Required)The address prefix to use for the Firewall subnet.The Subnet used for the Firewall must have the name AzureFirewallSubnet and the subnet mask must be at least a /26. | `list(string)` | n/a | yes |
| <a name="input_location"></a> [location](#input\_location) | (Required)The location to keep all your network resources. To get the list of all locations with table format from azure cli, run 'az account list-locations -o table'. | `string` | n/a | yes |
| <a name="input_log_analytics_workspace_id"></a> [log\_analytics\_workspace\_id](#input\_log\_analytics\_workspace\_id) | (Required)Log analytics workspace id to send logs from the current resource. | `string` | n/a | yes |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | (Required)A container that holds related resources for an Azure solution. | `string` | n/a | yes |
| <a name="input_virtual_network_name"></a> [virtual\_network\_name](#input\_virtual\_network\_name) | (Required)Name of your Azure Virtual Network. | `string` | n/a | yes |
| <a name="input_application_rules"></a> [application\_rules](#input\_application\_rules) | (Optional)List of application rules. | <pre>map(object({<br>    name     = string<br>    priority = number<br>    application_rule_collections = list(object({<br>      name     = string<br>      priority = number<br>      action   = string<br>      application_rules = list(object({<br>        name                  = string<br>        destination_fqdns     = list(string)<br>        destination_fqdn_tags = list(string)<br>        source_addresses      = list(string)<br>        terminate_tls         = bool<br>        web_categories        = list(string)<br>        source_ip_groups      = list(string)<br>        destination_addresses = list(string)<br>        description           = optional(string)<br>        protocols = list(object({<br>          type = string<br>          port = number<br>        }))<br>      }))<br>    }))<br>  }))</pre> | `null` | no |
| <a name="input_enable_forced_tunneling"></a> [enable\_forced\_tunneling](#input\_enable\_forced\_tunneling) | (Optional)Route all Internet-bound traffic to a designated next hop instead of going directly to the Internet. | `bool` | `false` | no |
| <a name="input_firewall_management_public_ip_allocation_mode"></a> [firewall\_management\_public\_ip\_allocation\_mode](#input\_firewall\_management\_public\_ip\_allocation\_mode) | (Optional)Firewall management public ip allocation mode. | `string` | `"Static"` | no |
| <a name="input_firewall_management_public_ip_sku"></a> [firewall\_management\_public\_ip\_sku](#input\_firewall\_management\_public\_ip\_sku) | (Optional)Firewall management public ip sku. | `string` | `"Standard"` | no |
| <a name="input_firewall_management_subnet_address_prefix"></a> [firewall\_management\_subnet\_address\_prefix](#input\_firewall\_management\_subnet\_address\_prefix) | (Optional)The address prefix to use for Firewall managemement subnet to enable forced tunnelling. The Management Subnet used for the Firewall must have the name `AzureFirewallManagementSubnet` and the subnet mask must be at least a `/26`. | `list(string)` | `null` | no |
| <a name="input_firewall_managment_public_ip_allocation_mode"></a> [firewall\_managment\_public\_ip\_allocation\_mode](#input\_firewall\_managment\_public\_ip\_allocation\_mode) | (Optional)Firewall Management public ip allocation mode. | `string` | `"Static"` | no |
| <a name="input_firewall_managment_public_ip_sku"></a> [firewall\_managment\_public\_ip\_sku](#input\_firewall\_managment\_public\_ip\_sku) | (Optional)Firewall managment public ip sku. | `string` | `"Standard"` | no |
| <a name="input_firewall_managment_subnet"></a> [firewall\_managment\_subnet](#input\_firewall\_managment\_subnet) | (Optional)Firewall mangement subnet name. | `string` | `"AzureFirewallManagementSubnet"` | no |
| <a name="input_firewall_policy"></a> [firewall\_policy](#input\_firewall\_policy) | (Optional)Manages a Firewall Policy resource that contains NAT, network, and application rule collections, and Threat Intelligence settings. | <pre>object({<br>    name                     = optional(string)<br>    sku                      = optional(string)<br>    base_policy_id           = optional(string)<br>    threat_intelligence_mode = optional(string)<br>    dns = optional(object({<br>      servers       = list(string)<br>      proxy_enabled = bool<br>    }))<br>    threat_intelligence_allowlist = optional(object({<br>      ip_addresses = list(string)<br>      fqdns        = list(string)<br>    }))<br>  })</pre> | `null` | no |
| <a name="input_firewall_policy_id"></a> [firewall\_policy\_id](#input\_firewall\_policy\_id) | (Optional)Firewall Policy Id. | `string` | `null` | no |
| <a name="input_firewall_public_ip_allocation_mode"></a> [firewall\_public\_ip\_allocation\_mode](#input\_firewall\_public\_ip\_allocation\_mode) | (Optional)Firewall public ip allocation mode. | `string` | `"Static"` | no |
| <a name="input_firewall_public_ip_sku"></a> [firewall\_public\_ip\_sku](#input\_firewall\_public\_ip\_sku) | (Optional)Firewall public ip sku | `string` | `"Standard"` | no |
| <a name="input_firewall_subnet_name"></a> [firewall\_subnet\_name](#input\_firewall\_subnet\_name) | (Optional)Firewall subnet name. | `string` | `"AzureFirewallSubnet"` | no |
| <a name="input_nat_rules"></a> [nat\_rules](#input\_nat\_rules) | (Optional)List of nat rules to apply to firewall. | <pre>map(object({<br>    name                  = string<br>    description           = optional(string)<br>    action                = string<br>    source_addresses      = optional(list(string))<br>    destination_ports     = list(string)<br>    destination_addresses = list(string)<br>    protocols             = list(string)<br>    translated_address    = string<br>    translated_port       = string<br>  }))</pre> | `null` | no |
| <a name="input_network_rules"></a> [network\_rules](#input\_network\_rules) | (Optional)List of network rules to apply to firewall. | <pre>map(object({<br>    name     = string<br>    priority = number<br>    network_rule_collections = list(object({<br>      name     = string<br>      priority = number<br>      action   = string<br>      network_rules = list(object({<br>        name                  = string<br>        protocols             = list(string)<br>        source_addresses      = list(string)<br>        source_ip_groups      = list(string)<br>        destination_ports     = list(string)<br>        destination_addresses = list(string)<br>        destination_ip_groups = list(string)<br>        destination_fqdns     = list(string)<br>      }))<br>    }))<br>  }))</pre> | `null` | no |



# Authors
Originally created by Omer Brumer
<!-- END_TF_DOCS -->