provider "azurerm" {
  version = "=2.35.0"
  features {}
}

resource "azurerm_resource_group" "global-apim" {
  name     = "kp-global-apim-rg"
  location = "westus2"
}

resource "azurerm_api_management" "global-apim" {
  name                = "kp-global-apim"
  location            = azurerm_resource_group.global-apim.location
  resource_group_name = azurerm_resource_group.global-apim.name
  publisher_name      = "Kallum Parr"
  publisher_email     = "kallum_parr@hotmail.com"

  sku_name = "Developer_1"

  policy {
    xml_content = <<XML
    <policies>
      <inbound>
        <rate-limit-by-key  calls="5"
              renewal-period="60"
              increment-condition="@(context.Response.StatusCode == 200)"
              counter-key="@(context.Request.IpAddress)"/>
      </inbound>
	  <backend>
		<forward-request timeout="60"/>
	  </backend>
      <outbound />
      <on-error />
    </policies>
XML

  }
}