resource "oci_containerengine_cluster" "FoggyKitchenOKECluster" {
  provider           = oci.targetregion
  depends_on         = [oci_identity_policy.FoggyKitchenOKEClusterAutoscalerPolicy1, oci_identity_policy.FoggyKitchenOKEClusterAutoscalerPolicy2]
  compartment_id     = oci_identity_compartment.FoggyKitchenCompartment.id
  kubernetes_version = var.kubernetes_version
  name               = var.cluster_name
  vcn_id             = oci_core_virtual_network.FoggyKitchenVCN.id

  endpoint_config {
    is_public_ip_enabled = true
    subnet_id            = oci_core_subnet.FoggyKitchenOKEAPIEndpointSubnet.id
    nsg_ids              = [oci_core_network_security_group.FoggyKitchenNSG.id]
  }

  options {
    service_lb_subnet_ids = [oci_core_subnet.FoggyKitchenOKELBSubnet.id]

    add_ons {
      is_kubernetes_dashboard_enabled = true
      is_tiller_enabled               = true
    }

    kubernetes_network_config {
      pods_cidr        = lookup(var.network_cidrs, "PODS-CIDR")
      services_cidr    = lookup(var.network_cidrs, "KUBERNETES-SERVICE-CIDR")
    }
  }

}

resource "oci_containerengine_node_pool" "FoggyKitchenOKENodePool" {
  provider           = oci.targetregion
  depends_on         = [oci_identity_policy.FoggyKitchenOKEClusterAutoscalerPolicy1, oci_identity_policy.FoggyKitchenOKEClusterAutoscalerPolicy2]
  cluster_id         = oci_containerengine_cluster.FoggyKitchenOKECluster.id
  compartment_id     = oci_identity_compartment.FoggyKitchenCompartment.id
  kubernetes_version = var.kubernetes_version
  name               = "FoggyKitchenOKENodePool"
  node_shape         = var.shape

  node_source_details {
    image_id    = data.oci_core_images.InstanceImageOCID.images[0].id
    source_type = "IMAGE"
  }

  dynamic "node_shape_config" {
    for_each = local.is_flexible_node_shape ? [1] : []
    content {
      memory_in_gbs = var.flex_shape_memory
      ocpus         = var.flex_shape_ocpus
    }
  }

  node_config_details {
    dynamic "placement_configs" {
      iterator = pc_iter
      for_each = data.oci_identity_availability_domains.ADs.availability_domains
      content {
        availability_domain = pc_iter.value.name
        subnet_id           = oci_core_subnet.FoggyKitchenOKENodesSubnet.id
      }
    }
    size = var.node_pool_size
  }
  
  initial_node_labels {
    key   = "key"
    value = "value"
  }

  ssh_public_key = tls_private_key.public_private_key_pair.public_key_openssh
}

