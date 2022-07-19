locals {

  compute_flexible_shapes = [
    "VM.Standard.E3.Flex",
    "VM.Standard.E4.Flex",
    "VM.Standard.A1.Flex",
    "VM.Optimized3.Flex"
  ]
  is_flexible_node_shape                  = contains(local.compute_flexible_shapes, var.shape)
  
  http_port_number                        = "80"
  https_port_number                       = "443"
  oke_api_endpoint_port_number            = "6443"
  oke_nodes_to_control_plane_port_number  = "12250"
  ssh_port_number                         = "22"
  tcp_protocol_number                     = "6"
  icmp_protocol_number                    = "1"
  all_protocols                           = "all"

  all_sources         = data.oci_containerengine_node_pool_option.FoggyKitchenOKEClusterNodePoolOption.sources
  oracle_linux_images = [for source in local.all_sources : source.image_id if length(regexall("Oracle-Linux-[0-9]*.[0-9]*-20[0-9]*", source.source_name)) > 0]
}