resource "helm_release" "this" {
  name             = "aws-load-balancer-controller"
  repository       = "https://aws.github.io/eks-charts"
  chart            = "aws-load-balancer-controller"
  version          = "1.14.1"
  namespace        = "kube-system"
  create_namespace = false

  values = [
    yamlencode({
      clusterName = var.cluster_name
      region      = var.region
      vpcId       = var.vpc_id
      serviceAccout = {
        create = false
        name   = kubernetes_service_account.this.metadata[0].name
      }
    })
  ]
  depends_on = [
    kubernetes_service_account.this
  ]

}
