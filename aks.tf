provider "azurerm" {
  subscription_id = var.subscription_id
  features {
    resource_group { prevent_deletion_if_contains_resources = false }
  }
}

provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"
  }
}


resource "azurerm_kubernetes_cluster" "aks" {
  name                = var.aks_cluster_name
  location            = var.aks_cluster_location
  resource_group_name = var.resource_group_name
  dns_prefix          = "myakscluster"
  default_node_pool {
    name       = "default"
    node_count = var.aks_cluster_node_count
    vm_size    = var.aks_cluster_node_size
  }

  identity {
    type = "SystemAssigned"
  }
  depends_on = [azurerm_subnet.aks_subnet]
}

resource "azurerm_kubernetes_cluster_node_pool" "aks_node_pool" {
  name                  = "aksjenkins"
  kubernetes_cluster_id = azurerm_kubernetes_cluster.aks.id
  vm_size               = var.aks_cluster_node_size
  node_count            = var.aks_cluster_node_count
}

provider "kubernetes" {
  host                   = azurerm_kubernetes_cluster.aks.kube_config.0.host
  client_certificate     = base64decode(azurerm_kubernetes_cluster.aks.kube_config.0.client_certificate)
  client_key             = base64decode(azurerm_kubernetes_cluster.aks.kube_config.0.client_key)
  cluster_ca_certificate = base64decode(azurerm_kubernetes_cluster.aks.kube_config.0.cluster_ca_certificate)  
}



  