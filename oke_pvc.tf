resource "local_file" "pvc_deployment" {
  content  = data.template_file.pvc_deployment.rendered
  filename = "${path.module}/pvc.yaml"
}

resource "null_resource" "deploy_oke_pvc" {
  depends_on = [
  oci_containerengine_cluster.FoggyKitchenOKECluster, 
  oci_containerengine_node_pool.FoggyKitchenOKENodePool, 
  local_file.pvc_deployment]

  provisioner "local-exec" {
    command = "oci ce cluster create-kubeconfig --region ${var.region} --cluster-id ${oci_containerengine_cluster.FoggyKitchenOKECluster.id}"
  }

  provisioner "local-exec" {
    command = "kubectl apply -f ${local_file.pvc_deployment.filename}"
  }

  provisioner "local-exec" {
    command = "sleep 120"
  }

  provisioner "local-exec" {
    command = "kubectl get pvc"
  }
}