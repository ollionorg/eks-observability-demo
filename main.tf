module "managed_grafana" {
  source  = "terraform-aws-modules/managed-service-grafana/aws"
  version = "~>2.1"

  name                      = var.grafana_workspace_name
  associate_license         = false
  description               = "AWS Managed Grafana service for ${var.grafana_workspace_name}"
  permission_type           = "SERVICE_MANAGED"
  data_sources              = ["CLOUDWATCH", "PROMETHEUS", "XRAY"]
  authentication_providers  = ["SAML"]
  notification_destinations = ["SNS"]
  stack_set_name            = var.grafana_workspace_name
  grafana_version           = var.grafana_version
  enable_alerts             = var.grafana_enable_alerts

  configuration = jsonencode({
    unifiedAlerting = {
      enabled = true
    },
    plugins = {
      pluginAdminEnabled = true
    }
  })

  # Workspace API keys
  workspace_api_keys = {
    viewer = {
      key_name        = "viewer"
      key_role        = "VIEWER"
      seconds_to_live = 3600
    }
    editor = {
      key_name        = "editor"
      key_role        = "EDITOR"
      seconds_to_live = 3600
    }
    admin = {
      key_name        = "admin"
      key_role        = "ADMIN"
      seconds_to_live = 3600
    }
    cluster = {
      key_name        = "cluster"
      key_role        = "ADMIN"
      seconds_to_live = 3600
    }
  }

  # Workspace IAM role
  create_iam_role                = true
  iam_role_name                  = var.grafana_workspace_name
  use_iam_role_name_prefix       = true
  iam_role_description           = "${var.grafana_workspace_name} Managed Grafana role"
  iam_role_path                  = "/grafana/"
  iam_role_force_detach_policies = true
  iam_role_max_session_duration  = 7200

  role_associations = merge(
    length(var.grafana_admin_groups) > 0 ? {
      ADMIN = {
        group_ids = var.grafana_admin_groups
      }
    } : {},
    length(var.grafana_editor_groups) > 0 ? {
      EDITOR = {
        group_ids = var.grafana_editor_groups
      }
    } : {},
    length(var.grafana_admin_groups) > 0 ? {
      VIEWER = {
        group_ids = var.grafana_readonly_groups
      }
    } : {},
  )
}

module "eks_monitoring" {
  source = "github.com/aws-observability/terraform-aws-observability-accelerator//modules/eks-monitoring?ref=v2.12.2"

  eks_cluster_id     = data.aws_eks_cluster.this.id
  irsa_iam_role_name = "${local.eks_cluster_name}-adot-role-irsa"

  enable_alertmanager       = true
  enable_managed_prometheus = true
  # deploys AWS Distro for OpenTelemetry operator into the cluster
  enable_amazon_eks_adot          = true
  adot_loglevel                   = var.adot_loglevel
  adot_service_telemetry_loglevel = "DEBUG"
  enable_adotcollector_metrics    = true

  enable_cert_manager = true

  enable_kube_state_metrics   = true
  enable_apiserver_monitoring = true
  enable_alerting_rules       = true
  enable_recording_rules      = true
  enable_nginx                = true
  enable_logs                 = true

  enable_grafana_operator = true
  enable_external_secrets = true
  enable_fluxcd           = true
  grafana_api_key         = module.managed_grafana.workspace_api_keys.cluster.key
  target_secret_name      = var.target_secret_name
  target_secret_namespace = var.target_secret_namespace
  grafana_url             = "https://${module.managed_grafana.workspace_endpoint}"

  # control the publishing of dashboards by specifying the boolean value for the variable 'enable_dashboards', default is 'true'
  enable_dashboards = var.enable_dashboards

  # optional, defaults to 60s interval and 15s timeout
  prometheus_config = {
    global_scrape_interval = "60s"
    global_scrape_timeout  = "15s"
  }

  ne_config = {
    helm_settings = {
      "tolerations[0].operator" = "Exists"
    }
  }

  nginx_config = {
    scrape_sample_limit = 10000
  }

  depends_on = [module.managed_grafana]
}

resource "aws_sns_topic" "prometheus_alerts_topic" {
  name = "grafana-alerts-${local.eks_cluster_name}"
}

resource "aws_sns_topic_subscription" "grafana_alert_sub" {
  for_each  = toset(var.alert_email_addresses)
  topic_arn = aws_sns_topic.prometheus_alerts_topic.arn
  protocol  = "email"
  endpoint  = each.value
}
