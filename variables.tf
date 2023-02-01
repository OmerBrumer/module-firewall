variable "resource_group_name" {
  description = "(Required)A container that holds related resources for an Azure solution."
  type        = string
}

variable "location" {
  description = "(Required)The location to keep all your network resources. To get the list of all locations with table format from azure cli, run 'az account list-locations -o table'."
  type        = string
}

variable "virtual_network_name" {
  description = "(Required)Name of your Azure Virtual Network."
  type        = string
}

variable "firewall_config" {
  description = "(Required)Manages an Azure Firewall configuration."
  type = object({
    name              = string
    sku_name          = optional(string)
    sku_tier          = optional(string)
    dns_servers       = optional(list(string))
    private_ip_ranges = optional(list(string))
    threat_intel_mode = optional(string)
    zones             = optional(list(string))
  })
}

variable "firewall_subnet_address_prefix" {
  description = "(Required)The address prefix to use for the Firewall subnet.The Subnet used for the Firewall must have the name AzureFirewallSubnet and the subnet mask must be at least a /26."
  type        = list(string)
}

variable "log_analytics_workspace_id" {
  description = "(Required)Log analytics workspace id to send logs from the current resource."
  type        = string
}

variable "firewall_subnet_name" {
  description = "(Optional)Firewall subnet name."
  type        = string
  default     = "AzureFirewallSubnet"
}

variable "firewall_public_ip_allocation_mode" {
  description = "(Optional)Firewall public ip allocation mode."
  type        = string
  default     = "Static"
}

variable "firewall_public_ip_sku" {
  description = "(Optional)Firewall public ip sku."
  type        = string
  default     = "Standard"
}

variable "firewall_management_public_ip_allocation_mode" {
  description = "(Optional)Firewall management public ip allocation mode."
  type        = string
  default     = "Static"
}

variable "firewall_management_public_ip_sku" {
  description = "(Optional)Firewall management public ip sku."
  type        = string
  default     = "Standard"
}

variable "firewall_managment_subnet" {
  description = "(Optional)Firewall mangement subnet name."
  type        = string
  default     = "AzureFirewallManagementSubnet"
}


variable "firewall_management_subnet_address_prefix" {
  description = "(Optional)The address prefix to use for Firewall managemement subnet to enable forced tunnelling. The Management Subnet used for the Firewall must have the name `AzureFirewallManagementSubnet` and the subnet mask must be at least a `/26`."
  type        = list(string)
  default     = null
}


variable "enable_forced_tunneling" {
  description = "(Optional)Route all Internet-bound traffic to a designated next hop instead of going directly to the Internet."
  type        = bool
  default     = false
}

variable "firewall_managment_public_ip_allocation_mode" {
  description = "(Optional)Firewall Management public ip allocation mode."
  type        = string
  default     = "Static"
}

variable "firewall_managment_public_ip_sku" {
  description = "(Optional)Firewall managment public ip sku."
  type        = string
  default     = "Standard"
}

variable "firewall_policy_id" {
  description = "(Optional)Firewall Policy Id."
  type        = string
  default     = null
}

variable "firewall_policy" {
  description = "(Optional)Manages a Firewall Policy resource that contains NAT, network, and application rule collections, and Threat Intelligence settings."
  type = object({
    name                     = optional(string)
    sku                      = optional(string)
    base_policy_id           = optional(string)
    threat_intelligence_mode = optional(string)
    dns = optional(object({
      servers       = list(string)
      proxy_enabled = bool
    }))
    threat_intelligence_allowlist = optional(object({
      ip_addresses = list(string)
      fqdns        = list(string)
    }))
  })
  default = null
}

variable "network_rules" {
  description = "(Optional)List of network rules to apply to firewall."
  type = map(object({
    name     = string
    priority = number
    network_rule_collections = list(object({
      name     = string
      priority = number
      action   = string
      network_rules = list(object({
        name                  = string
        protocols             = list(string)
        source_addresses      = list(string)
        source_ip_groups      = list(string)
        destination_ports     = list(string)
        destination_addresses = list(string)
        destination_ip_groups = list(string)
        destination_fqdns     = list(string)
      }))
    }))
  }))
  default = null
}

variable "application_rules" {
  description = "(Optional)List of application rules."
  type = map(object({
    name     = string
    priority = number
    application_rule_collections = list(object({
      name     = string
      priority = number
      action   = string
      application_rules = list(object({
        name                  = string
        destination_fqdns     = list(string)
        destination_fqdn_tags = list(string)
        source_addresses      = list(string)
        terminate_tls         = bool
        web_categories        = list(string)
        source_ip_groups      = list(string)
        destination_addresses = list(string)
        description           = optional(string)
        protocols = list(object({
          type = string
          port = number
        }))
      }))
    }))
  }))
  default = null
}

variable "nat_rules" {
  description = "(Optional)List of nat rules to apply to firewall."
  type = map(object({
    name                  = string
    description           = optional(string)
    action                = string
    source_addresses      = optional(list(string))
    destination_ports     = list(string)
    destination_addresses = list(string)
    protocols             = list(string)
    translated_address    = string
    translated_port       = string
  }))
  default = null
}