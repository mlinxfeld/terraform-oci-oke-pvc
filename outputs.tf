output "cluster_instruction" {
value = <<EOT
1.  Open OCI Cloud Shell.

2.  Execute below command to setup OKE cluster access:

$ oci ce cluster create-kubeconfig --region ${var.region} --cluster-id ${oci_containerengine_cluster.FoggyKitchenOKECluster.id}

3.  Obtain the PVC created by the automation

$ kubectl get pvc  

4.  Obtain NGINX POD description with attached PVC

$ kubectl describe pod nginx

EOT
}

#output "oracle_linux_images" {
#  value = local.oracle_linux_images
#}

#output "oracle_linux_images2" {
#  value = local.oracle_linux_service_names
#}
