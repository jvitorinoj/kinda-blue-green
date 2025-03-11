output "bluegreen_service_ip" {
  value = kubernetes_service.bluegreen-svc.status[0].load_balancer[0].ingress[0].ip
}


