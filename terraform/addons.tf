# ------------------------------------
# Data sources to read the created cluster (cluster must exist)
# ------------------------------------
data "aws_eks_cluster_auth" "cluster" {
  name = module.eks.cluster_name
}

provider "kubernetes" {
  host                   = module.eks.cluster_endpoint
  cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)
  token                  = data.aws_eks_cluster_auth.cluster.token
}

provider "helm" {
  kubernetes = {
    host                   = module.eks.cluster_endpoint
    token                  = data.aws_eks_cluster_auth.cluster.token
    cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)
  }
}

# Create the service account in kube-system (that will be IRSA linked)
resource "kubernetes_service_account" "ebs_sa" {
  metadata {
    name      = "ebs-csi-controller-sa"
    namespace = "kube-system"
    annotations = {
      "eks.amazonaws.com/role-arn" = module.eks.ebs_csi_irsa_arn
    }
  }

  depends_on = [module.eks]
}


# Install aws-ebs-csi-driver through Helm


resource "helm_release" "ebs_csi" {
  name       = "aws-ebs-csi-driver"
  repository = "https://kubernetes-sigs.github.io/aws-ebs-csi-driver"
  chart      = "aws-ebs-csi-driver"
  namespace  = "kube-system"

  values = [
    yamlencode({
      controller = {
        serviceAccount = {
          create = false
          name   = "ebs-csi-controller-sa"
          annotations = {
            "eks.amazonaws.com/role-arn" = module.eks.ebs_csi_irsa_arn
          }
        }
      }
    })
  ]

  depends_on = [
    kubernetes_service_account.ebs_sa
  ]
}
