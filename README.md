# terraform-azurerm-static-website

A module to add allowed cors origins. This is a workaround until <https://github.com/terraform-providers/terraform-provider-azurerm/issues/1374> is resolved.

## Limitations

1. You need a valid session in the Azure CLI (even when you Authenticating terrafrom not with the Azure CLI)
2. A destroy does not remove the origin. You must remove the by other ways.
3. Changes outside terraform are not detected will not result into a reapply.

## Example

```terraform
resource "azurerm_resource_group" "test" {
  name     = "resourceGroupName"
  location = "westus"
}

resource "azurerm_storage_account" "test" {
  name                = "storageaccountname"
  resource_group_name = azurerm_resource_group.test.name
  location            = "westus"

  account_tier             = "Standard"
  account_kind             = "StorageV2"
  account_replication_type = "GRS"
}

resource "azurerm_app_service_plan" "test" {
  name                = "azure-functions-test-service-plan"
  location            = azurerm_resource_group.test.location
  resource_group_name = azurerm_resource_group.test.name
  kind                = "FunctionApp"

  sku {
    tier = "Dynamic"
    size = "Y1"
  }
}

resource "azurerm_function_app" "test" {
  name                      = "test-azure-functions"
  location                  = azurerm_resource_group.test.location
  resource_group_name       = azurerm_resource_group.test.name
  app_service_plan_id       = azurerm_app_service_plan.test.id
  storage_connection_string = azurerm_storage_account.test.primary_connection_string
}

module "function-cors" {
  source              = "github.com/StefanSchoof/terraform-azurerm-function-cors"
  resource_group_name = azurerm_resource_group.test.name
  allowed_origins     = list("https://example.com", "https://sub.example.com")
  function_app_name   = azurerm_function_app.test.name
}
```
