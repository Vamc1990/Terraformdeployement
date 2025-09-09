terraform {
  required_providers {
    azurerm = {
      source  = "azurerm"
      version = "4.40.0"
    }
  }
}
provider "azurerm" {
  features {}
}
resource "azurerm_logic_app_standard" "res-0" {
  app_service_plan_id                      = "/subscriptions/e62a4643-1777-489d-8615-992e6eb09eda/resourceGroups/test-rg01/providers/Microsoft.Web/serverFarms/testplan"
  app_settings                             = {}
  bundle_version                           = ""
  client_affinity_enabled                  = false
  client_certificate_mode                  = ""
  enabled                                  = true
  ftp_publish_basic_authentication_enabled = false
  https_only                               = true
  location                                 = "centralindia"
  name                                     = "testlogicappstandard"
  public_network_access                    = "Enabled"
  resource_group_name                      = "test-rg01"
  scm_publish_basic_authentication_enabled = false
  storage_account_access_key               = "" # Masked sensitive attribute
  storage_account_name                     = ""
  storage_account_share_name               = ""
  tags = {
    "hidden-link: /app-insights-resource-id" = "/subscriptions/e62a4643-1777-489d-8615-992e6eb09eda/resourceGroups/test-rg01/providers/microsoft.insights/components/teststandardLA-012202410141527"
  }
  use_extension_bundle       = false
  version                    = ""
  virtual_network_subnet_id  = ""
  vnet_content_share_enabled = true
  identity {
    identity_ids = ["/subscriptions/e62a4643-1777-489d-8615-992e6eb09eda/resourceGroups/test-rg01/providers/Microsoft.ManagedIdentity/userAssignedIdentities/testuser"]
    type         = "SystemAssigned, UserAssigned"
  }
  site_config {
    always_on                        = false
    app_scale_limit                  = 0
    dotnet_framework_version         = "v6.0"
    elastic_instance_minimum         = 1
    ftps_state                       = "FtpsOnly"
    health_check_path                = ""
    http2_enabled                    = false
    linux_fx_version                 = ""
    min_tls_version                  = "1.2"
    pre_warmed_instance_count        = 1
    public_network_access_enabled    = true
    runtime_scale_monitoring_enabled = true
    scm_min_tls_version              = "1.2"
    scm_type                         = "None"
    scm_use_main_ip_restriction      = false
    use_32_bit_worker_process        = false
    vnet_route_all_enabled           = false
    websockets_enabled               = false
    cors {
      allowed_origins     = ["*"]
      support_credentials = false
    }
  }
}
