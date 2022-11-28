locals {

  compute_flexible_shapes = [
    "VM.Standard.E3.Flex",
    "VM.Standard.E4.Flex",
    "VM.Standard.A1.Flex",
    "VM.Optimized3.Flex"
  ]

  compute_arm_shapes = [
    "VM.Standard.A1.Flex",
    "BM.Standard.A1"  
  ]

  is_flexible_node_shape                  = contains(local.compute_flexible_shapes, var.oke_node_shape)
  is_arm_node_shape                       = contains(local.compute_arm_shapes, var.oke_node_shape)  
  
  http_port_number                        = "80"
  https_port_number                       = "443"
  oke_api_endpoint_port_number            = "6443"
  oke_nodes_to_control_plane_port_number  = "12250"
  ssh_port_number                         = "22"
  tcp_protocol_number                     = "6"
  icmp_protocol_number                    = "1"
  all_protocols                           = "all"
  oke_nodes_min_port                      = "30000"
  oke_nodes_max_port                      = "32767"
  lb_listener_port                        = var.lb_listener_port == "" ? "80" : var.lb_listener_port

  all_sources                = data.oci_containerengine_node_pool_option.FoggyKitchenOKEClusterNodePoolOption.sources
  arm_node_shape             = local.is_arm_node_shape ? "aarch64-" : ""
  kubernetes_version         = substr(var.kubernetes_version,1,6)

  oracle_linux_images        = [
    for source in local.all_sources : source.image_id if length(regexall("Oracle-Linux-${var.oke_node_os_version}-${local.arm_node_shape}.+-OKE-${local.kubernetes_version}-[0-9]+", source.source_name)) > 0
  ]
}

