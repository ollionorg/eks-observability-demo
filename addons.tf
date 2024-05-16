module "addons" {
  source  = "aws-ia/eks-blueprints-addons/aws"
  version = "~>1.16"

  cluster_name      = local.eks_cluster_name
  cluster_endpoint  = data.aws_eks_cluster.this.endpoint
  cluster_version   = data.aws_eks_cluster.this.version
  oidc_provider_arn = local.oidc_provider_arn

  eks_addons = {
    coredns = {
      most_recent                 = true
      resolve_conflicts_on_create = "OVERWRITE"
      resolve_conflicts_on_update = "OVERWRITE"
    }
    kube-proxy = {
      most_recent                 = true
      resolve_conflicts_on_create = "OVERWRITE"
      resolve_conflicts_on_update = "OVERWRITE"
    }
    vpc-cni = {
      most_recent                 = true
      resolve_conflicts_on_create = "OVERWRITE"
      resolve_conflicts_on_update = "OVERWRITE"
    }
  }

  enable_aws_load_balancer_controller = true
  aws_load_balancer_controller = {
    chart_version = "1.7.1"
    role_name     = "${local.eks_cluster_name}-alb-controller"
    values = [templatefile(
      "${local.eks_addon_config_path}/alb_controller.yaml",
      {
        vpc_id = data.aws_eks_cluster.this.vpc_config[0].vpc_id
      }
    )]
  }

  ##
  # Nginx Ingress
  ##
  enable_ingress_nginx = true
  ingress_nginx = {
    chart_version = "4.9.1"
    values = [templatefile("${local.eks_addon_config_path}/ingress_nginx.yaml", {
      elb_name   = substr("nginx-${replace(local.eks_cluster_name, "-", "")}", 0, 32)
      elb_scheme = "internal"
    })]
  }
}
