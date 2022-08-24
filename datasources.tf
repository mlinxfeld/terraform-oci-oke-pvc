data "oci_identity_region_subscriptions" "home_region_subscriptions" {
  tenancy_id = var.tenancy_ocid

  filter {
    name   = "is_home_region"
    values = [true]
  }
}

data "oci_containerengine_cluster_option" "FoggyKitchenOKEClusterOption" {
  provider          = oci.targetregion
  cluster_option_id = "all"
}

data "oci_containerengine_node_pool_option" "FoggyKitchenOKEClusterNodePoolOption" {
  provider            = oci.targetregion
  node_pool_option_id = "all"
}

# Gets a list of Availability Domains
data "oci_identity_availability_domains" "ADs" {
  provider       = oci.targetregion
  compartment_id = var.tenancy_ocid
}

data "oci_core_services" "FoggyKitchenAllOCIServices" {
  provider       = oci.targetregion

  filter {
    name   = "name"
    values = ["All .* Services In Oracle Services Network"]
    regex  = true
  }
}

data "template_file" "storageclass_deployment" {

  template = "${file("${path.module}/templates/storageclass.template.yaml")}"
  vars     = {
      fs_type = var.fs_type
  }
}

data "template_file" "pvc_deployment" {

  template = "${file("${path.module}/templates/pvc.template.yaml")}"
  vars     = {
      block_volume_name       = "${oci_core_volume.FoggyKitchenBlockVolume.display_name}"
      block_volume_id         = "${oci_core_volume.FoggyKitchenBlockVolume.id}"
      block_volume_size       = "${oci_core_volume.FoggyKitchenBlockVolume.size_in_gbs}"
  }
}

data "template_file" "nginx_deployment" {

  template = "${file("${path.module}/templates/nginx.template.yaml")}"
  vars     = {
      block_volume_name = "${oci_core_volume.FoggyKitchenBlockVolume.display_name}"
  }
}
