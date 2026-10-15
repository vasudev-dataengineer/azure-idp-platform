
resource "azurerm_kubernetes_cluster" "idp" {
  name                = "aks-ai-idp-dev"
  location            = azurerm_resource_group.idp.location
  resource_group_name = azurerm_resource_group.idp.name
  dns_prefix          = "aks-ai-idp-dev"

  sku_tier = "Free"

  default_node_pool {
    name                 = "system"
    vm_size              = "Standard_D2s_v4"
    node_count           = 2
    vnet_subnet_id       = azurerm_subnet.aks.id
    os_disk_size_gb      = 64
    type                 = "VirtualMachineScaleSets"
    auto_scaling_enabled = false
  }

  identity {
    type = "SystemAssigned"
  }

  oidc_issuer_enabled       = true
  workload_identity_enabled = true

  network_profile {
    network_plugin = "azure"
    network_policy = "azure"
  }

  tags = {
    project     = "ai-powered-idp"
    environment = "dev"
    managed_by  = "terraform"
  }
}

# Allow AKS to pull Docker images from ACR
resource "azurerm_role_assignment" "aks_acr_pull" {
  scope                = azurerm_container_registry.idp.id
  role_definition_name = "AcrPull"
  principal_id         = azurerm_kubernetes_cluster.idp.kubelet_identity[0].object_id
}
