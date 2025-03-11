resource "kubernetes_deployment" "blue" {
  metadata {
    name      = "blue"
    namespace = "default"
    labels = {
      app     = "app"
      version = "blue"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app     = "myapp"
        version = "blue"
      }
    }

    template {
      metadata {
        labels = {
          app     = "myapp"
          version = "blue"
        }
      }

      spec {
        container {
          name  = "myapp-blue"
          image = "nginx:1.27"

          port {
            container_port = 80
          }
        }
      }
    }
  }
}

resource "kubernetes_deployment" "green" {
  metadata {
    name      = "green"
    namespace = "default"
    labels = {
      app     = "app"
      version = "green"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app     = "myapp"
        version = "green"
      }
    }

    template {
      metadata {
        labels = {
          app     = "myapp"
          version = "green"
        }
      }

      spec {
        container {
          name  = "myapp-green"
          image = "nginx:1.14-alpine"

          port {
            container_port = 80
          }
        }
      }
    }
  }
}


/// Service
resource "kubernetes_service" "bluegreen-svc" {
  metadata {
    name      = "myapp-blue"
    namespace = "default"
    labels = {
      app     = "myapp"
      version = "online"
    }
  }

  spec {
    selector = {
      app     = "myapp"
      version = "blue"
    }

    port {
      port        = 80
      target_port = 80
    }

    type = "LoadBalancer"
  }
  depends_on = [azurerm_kubernetes_cluster.aks]
}


  
