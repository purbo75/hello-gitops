provider "azurerm" {
  # Specifying the version is optional
  #version = "=1.24.0"
  # Credentials are specified authenticating to Azure
  client_id = "${var.clientid}"
  client_secret = "${var.clientsecret}"
  tenant_id     = "${var.tenantid}"
  subscription_id = "${var.subscriptionid}"
}

resource"azurerm_resource_group" "rg"{
  # Name/Location of the Resource Group in which the AKS cluster will be created.
  name  = "${var.resource_group_name}"
  location  = "${var.resource_group_location}"
}

resource"azurerm_kubernetes_cluster" "testcluster"{
  name  = "${var.cluster_name}"
  location  = "${var.resource_group_location}"
  kubernetes_version  = "1.24.0"
  resource_group_name = "${azurerm_resource_group.rg.name}"
  dns_prefix  = "${var.cluster_name}"
  agent_pool_profile {
    # Defining details for the 
    name  = "agentpool"
    count = 1
    vm_size = "Standard_D2s_v3"
    os_type = "Linux"
    os_disk_size_gb = 100
  }

  service_principal {
    # Specifying a Service Principal for AKS Cluster
    client_id = "${var.clientid}"
    client_secret = "${var.clientsecret}"
  }
  # Tag's for AKS Cluster's environment along with clustername 
  tags = {
    environment = "test"
    cluster_name  = "${var.cluster_name}"
  }
  # Enable Role Based Access Control
  role_based_access_control {
    enabled = true
  }
}