locals {
  eks_cluster_name      = data.aws_eks_cluster.this.name
  eks_addon_config_path = "${path.root}/files"

  account_id = data.aws_caller_identity.current.account_id

  oidc_endpoint     = data.aws_eks_cluster.this.endpoint
  oidc_provider_id  = split(".", split("//", local.oidc_endpoint)[1])[0]
  oidc_provider_arn = "arn:aws:iam::${local.account_id}:oidc-provider/oidc.eks.${var.region}.amazonaws.com/id/${local.oidc_provider_id}"
}
