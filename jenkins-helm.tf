resource "helm_release" "jenkins" {
  name             = "jenkins"
  repository       = "https://charts.jenkins.io"
  chart            = "jenkins"
  version          = "5.8.17"
  namespace        = "jenkins"
  create_namespace = true

  set {
    name  = "controller.admin.usename"
    value = "admin"
  }

  set {
    name  = "controller.admin.password"
    value = "secretpassword"
  }
  set {
    name  = "controller.serviceType"
    value = "LoadBalancer"
  }

// TODO: Create a custom image of the jenkins agent and the kubectl
//  set { 
//    name = "agent.image"
//    value = "bitname/kubectl"
//  }

// set {
//  name = "agent.tags"
//  value  = "1.32"
// }
  set {
    name  = "controller.ingress.enabled"
    value = "true"
  }
  depends_on = [azurerm_kubernetes_cluster.aks]
}
