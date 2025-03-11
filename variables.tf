variable "subscription_id" {
  description = "The subscription ID for the Azure account"
  type        = string
  default     = "value"
}

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
  default     = "rg-aks-jenkins"
}

variable "aks_cluster_name" {
  description = "Name of the AKS cluster"
  type        = string
  default     = "aks-jenkins"
}

variable "aks_cluster_location" {
  description = "Location of the AKS cluster"
  type        = string
  default     = "North Europe"
}

variable "aks_cluster_node_count" {
  description = "Number of nodes in the AKS cluster"
  type        = number
  default     = 2
}

variable "aks_cluster_node_size" {
  description = "Size of the nodes in the AKS cluster"
  type        = string
  default     = "Standard_DS2_v2"
}

