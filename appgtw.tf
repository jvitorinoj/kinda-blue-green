resource "azurerm_application_gateway" "gtw" {
  depends_on = [ kubernetes_service.bluegreen-svc ]
  name                = "appgateway"
  resource_group_name = var.resource_group_name
  location            = var.aks_cluster_location
  sku {
    name     = "Standard_v2"
    tier     = "Standard_v2"
    capacity = 2
  }

  gateway_ip_configuration {
    name      = "appgateway-ip-config"
    subnet_id = azurerm_subnet.appgw_subnet.id
  }

  frontend_ip_configuration {
    name                 = "appgateway-frontend-ip"
    public_ip_address_id = azurerm_public_ip.public_ip.id
  }

  frontend_port {
    name = "http-blue"
    port = 80
  }

  frontend_port {
    name = "http-green"
    port = 8080
  }

  backend_address_pool {
    name = "blue-backend-pool"    
  }

  backend_address_pool {
    name = "green-backend-pool"
  }

  backend_http_settings {
    name                  = "http-settings"
    cookie_based_affinity = "Disabled"
    port                  = 80
    protocol              = "Http"
    request_timeout       = 20
  }

  http_listener {
    name                           = "http-listener-blue"
    frontend_ip_configuration_name = "appgateway-frontend-ip"
    frontend_port_name             = "http-blue"
    protocol                       = "Http"
  }

  http_listener {
    name                           = "http-listener-green"
    frontend_ip_configuration_name = "appgateway-frontend-ip"
    frontend_port_name             = "http-green"
    protocol                       = "Http"
  }

  request_routing_rule {
    name                       = "routing-rule-blue"
    rule_type                  = "Basic"
    http_listener_name         = "http-listener-blue"
    backend_address_pool_name  = "blue-backend-pool"
    backend_http_settings_name = "http-settings"
    priority                   = 100
  }

  request_routing_rule {
    name                       = "routing-rule-green"
    rule_type                  = "Basic"
    http_listener_name         = "http-listener-green"
    backend_address_pool_name  = "green-backend-pool"
    backend_http_settings_name = "http-settings"
    priority                   = 200
  }
}