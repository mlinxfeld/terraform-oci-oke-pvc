resource "oci_core_volume" "FoggyKitchenBlockVolume" {
  provider            = oci.targetregion
  availability_domain = var.availablity_domain_name == "" ? data.oci_identity_availability_domains.ADs.availability_domains[0].name : var.availablity_domain_name
  compartment_id      = oci_identity_compartment.FoggyKitchenCompartment.id
  display_name        = var.block_volume_name
  size_in_gbs         = var.block_volume_size
}
