output "cluster_instruction" {
value = <<EOT
1.  Open OCI Cloud Shell.

2.  Execute below command to setup OKE cluster access:

$ oci ce cluster create-kubeconfig --region ${var.region} --cluster-id ${oci_containerengine_cluster.FoggyKitchenOKECluster.id}

3.  Obtain the PVC created by the automation

$ kubectl get pvc  

4.  Obtain NGINX POD description with attached PVC

$ kubectl describe pod nginx

5.  Get services

$ kubectl get services

EOT
}


