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
 # Use environment variables for credentials
  subscription_id = var.ARM_SUBSCRIPTION_ID
  client_id       = var.ARM_CLIENT_ID
  tenant_id       = var.ARM_TENANT_ID
}

resource "azurerm_logic_app_workflow" "res-0" {
  enabled                            = true
  location                           = "centralindia"
  name                               = "DNSzonereport"
  parameters = {
    "$connections" = "{\"office365\":{\"connectionId\":\"/subscriptions/e62a4643-1777-489d-8615-992e6eb09eda/resourceGroups/test-rg01/providers/Microsoft.Web/connections/office365-3\",\"connectionName\":\"office365-3\",\"id\":\"/subscriptions/e62a4643-1777-489d-8615-992e6eb09eda/providers/Microsoft.Web/locations/centralindia/managedApis/office365\"}}"
  }
  resource_group_name = "test-rg01"
  tags                = {}
  workflow_parameters = {
    "$connections" = "{\"defaultValue\":{},\"type\":\"Object\"}"
  }
  workflow_schema  = "https://schema.management.azure.com/providers/Microsoft.Logic/schemas/2016-06-01/workflowdefinition.json#"
  workflow_version = "1.0.0.0"
}
resource "azurerm_logic_app_action_custom" "res-1" {
  body = jsonencode({
    inputs = "<html>\n  <head>\n    <style>\n      body {\n        font-family: Arial, sans-serif;\n        background-color: #f9f9f9;\n        padding: 20px;\n      }\n      h2 {\n        color: #2e6c80;\n      }\n      table {\n        width: 100%;\n        border-collapse: collapse;\n        margin-top: 20px;\n      }\n      th, td {\n        border: 1px solid #ccc;\n        padding: 10px;\n        text-align: left;\n      }\n      th {\n        background-color: #e0f0ff;\n        color: #333;\n      }\n      tr:nth-child(even) {\n        background-color: #f2f2f2;\n      }\n      .footer {\n        margin-top: 30px;\n        font-size: 12px;\n        color: #777;\n      }\n    </style>\n  </head>\n  <body>\n    <h2>📡 Monthly DNS Zone Report</h2>\n    <p>Here’s a summary of all DNS zones and their name servers in your subscription:</p>\n\n    @{body('Create_CSV_table')}\n\n    <div class=\"footer\">\n      This report was generated automatically by Azure Logic Apps.\n    </div>\n  </body>\n</html>\n"
    runAfter = {
      Create_CSV_table = ["Succeeded"]
    }
    type = "Compose"
  })
  logic_app_id = azurerm_logic_app_workflow.res-0.id
  name         = "Compose"
}
resource "azurerm_logic_app_action_custom" "res-2" {
  body = jsonencode({
    inputs = {
      format = "CSV"
      from   = "@body('Select')"
    }
    runAfter = {
      Select = ["Succeeded"]
    }
    type = "Table"
  })
  logic_app_id = azurerm_logic_app_workflow.res-0.id
  name         = "Create_CSV_table"
}
resource "azurerm_logic_app_action_http" "res-3" {
  headers = {
    Content-Type = "application/json"
  }
  logic_app_id = azurerm_logic_app_workflow.res-0.id
  method       = "GET"
  name         = "HTTP"
  uri          = "https://management.azure.com/subscriptions/e62a4643-1777-489d-8615-992e6eb09eda/resourceGroups/test-rg01/providers/Microsoft.Network/dnszones?api-version=2023-07-01-preview"
}
resource "azurerm_logic_app_action_custom" "res-4" {
  body = jsonencode({
    inputs = {
      content = "@body('HTTP')"
      schema = {
        properties = {
          body = {
            properties = {
              value = {
                items = {
                  properties = {
                    etag = {
                      type = "string"
                    }
                    id = {
                      type = "string"
                    }
                    location = {
                      type = "string"
                    }
                    name = {
                      type = "string"
                    }
                    tags = {
                      properties = {}
                      type       = "object"
                    }
                    type = {
                      type = "string"
                    }
                  }
                  required = ["id", "name", "type", "etag", "location", "tags"]
                  type     = "object"
                }
                type = "array"
              }
            }
            type = "object"
          }
        }
        type = "object"
      }
    }
    runAfter = {
      HTTP = ["Succeeded"]
    }
    type = "ParseJson"
  })
  logic_app_id = azurerm_logic_app_workflow.res-0.id
  name         = "Parse_JSON"
}
resource "azurerm_logic_app_action_custom" "res-5" {
  body = jsonencode({
    inputs = {
      from = "@body('HTTP')?['value']\r\n"
      select = {
        "Name Servers"     = "@join(item()['properties']['nameServers'], ', ')"
        Zone               = "@item()?['name']"
        numberOfRecordSets = "@item()?['properties']?['numberOfRecordSets']"
      }
    }
    runAfter = {
      Parse_JSON = ["Succeeded"]
    }
    type = "Select"
  })
  logic_app_id = azurerm_logic_app_workflow.res-0.id
  name         = "Select"
}
resource "azurerm_logic_app_action_custom" "res-6" {
  body = jsonencode({
    inputs = {
      body = {
        Attachments = [{
          ContentBytes = "@base64(body('Create_CSV_table'))"
          Name         = "dns-report-@{formatDateTime(utcNow(),'yyyy-MM-dd')}.csv"
        }]
        Body       = "<p class=\"editor-paragraph\">@{outputs('Compose')}</p>"
        Importance = "Normal"
        Subject    = "DNAZone Monthly report"
        To         = "v-vmandasaty@microsoft.com"
      }
      host = {
        connection = {
          name = "@parameters('$connections')['office365']['connectionId']"
        }
      }
      method = "post"
      path   = "/v2/Mail"
    }
    runAfter = {
      Compose = ["Succeeded"]
    }
    type = "ApiConnection"
  })
  logic_app_id = azurerm_logic_app_workflow.res-0.id
  name         = "Send_an_email_(V2)"
}
resource "azurerm_logic_app_trigger_recurrence" "res-7" {
  frequency    = "Month"
  interval     = 1
  logic_app_id = azurerm_logic_app_workflow.res-0.id
  name         = "Recurrence"
}
