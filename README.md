# EKS Observability Demo

Deploy EKS Observability resources.

## Demonstration

### Prerequisites

1. AWS EKS cluster stood up in your account.

### Deploy AWS Observability Accelerator

Talk about Managed Grafana and Observability accelerator modules

#### Grafana Charts

Baseline charts are deployed from the [Observability Accelerator artifacts repository](https://github.com/aws-observability/aws-observability-accelerator/tree/main/artifacts).

### Deploy Sample App

https://github.com/aws-observability/aws-observability-accelerator/blob/main/artifacts/k8s-deployment-manifest-templates/nginx/nginx-traffic-sample.yaml



<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.7 |
| <a name="requirement_kubectl"></a> [kubectl](#requirement\_kubectl) | >= 2.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_eks_monitoring"></a> [eks\_monitoring](#module\_eks\_monitoring) | github.com/aws-observability/terraform-aws-observability-accelerator//modules/eks-monitoring | v2.12.2 |
| <a name="module_managed_grafana"></a> [managed\_grafana](#module\_managed\_grafana) | terraform-aws-modules/managed-service-grafana/aws | ~>2.1 |

## Resources

| Name | Type |
|------|------|
| [aws_sns_topic.prometheus_alerts_topic](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sns_topic) | resource |
| [aws_sns_topic_subscription.grafana_alert_sub](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sns_topic_subscription) | resource |
| [aws_eks_cluster.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/eks_cluster) | data source |
| [aws_eks_cluster_auth.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/eks_cluster_auth) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | EKS cluster name the workspace is deployed for | `string` | n/a | yes |
| <a name="input_grafana_private_subnet_ids"></a> [grafana\_private\_subnet\_ids](#input\_grafana\_private\_subnet\_ids) | List of cluster subnet group VPC subnets | `list(string)` | n/a | yes |
| <a name="input_grafana_workspace_name"></a> [grafana\_workspace\_name](#input\_grafana\_workspace\_name) | Grafana workspace name | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | AWS Region being deployed to | `string` | n/a | yes |
| <a name="input_adot_loglevel"></a> [adot\_loglevel](#input\_adot\_loglevel) | Verbosity level for ADOT Collector | `string` | `"normal"` | no |
| <a name="input_alert_email_addresses"></a> [alert\_email\_addresses](#input\_alert\_email\_addresses) | Email addressses for Observability alerts | `list(string)` | `[]` | no |
| <a name="input_enable_dashboards"></a> [enable\_dashboards](#input\_enable\_dashboards) | Enables or disables curated dashboards. Dashboards are managed by the Grafana Operator | `bool` | `true` | no |
| <a name="input_global_tags"></a> [global\_tags](#input\_global\_tags) | Map of key,value pairs to tag all resources | `map(string)` | <pre>{<br>  "creation-method": "terraform",<br>  "project": "eks-observability-demo"<br>}</pre> | no |
| <a name="input_grafana_admin_groups"></a> [grafana\_admin\_groups](#input\_grafana\_admin\_groups) | List of AWS SSO groups to assign as administrators in Amazon Managed Grafana | `list(string)` | `[]` | no |
| <a name="input_grafana_editor_groups"></a> [grafana\_editor\_groups](#input\_grafana\_editor\_groups) | List of AWS SSO groups to assign as editor in Amazon Managed Grafana | `list(string)` | `[]` | no |
| <a name="input_grafana_enable_alerts"></a> [grafana\_enable\_alerts](#input\_grafana\_enable\_alerts) | Determines whether IAM permissions for alerting are enabled for the workspace IAM role | `bool` | `true` | no |
| <a name="input_grafana_readonly_groups"></a> [grafana\_readonly\_groups](#input\_grafana\_readonly\_groups) | List of AWS SSO groups to assign as readonly users in Amazon Managed Grafana | `list(string)` | `[]` | no |
| <a name="input_grafana_security_group_ids"></a> [grafana\_security\_group\_ids](#input\_grafana\_security\_group\_ids) | Cluster VPC Security groups for Grafana access | `list(string)` | `[]` | no |
| <a name="input_grafana_version"></a> [grafana\_version](#input\_grafana\_version) | Grafana version | `string` | `"9.4"` | no |
| <a name="input_irsa_iam_role_path"></a> [irsa\_iam\_role\_path](#input\_irsa\_iam\_role\_path) | IAM Role path for IRSA | `string` | `"/"` | no |
| <a name="input_target_secret_name"></a> [target\_secret\_name](#input\_target\_secret\_name) | Target secret in Kubernetes to store the Grafana API Key Secret | `string` | `"grafana-admin-credentials"` | no |
| <a name="input_target_secret_namespace"></a> [target\_secret\_namespace](#input\_target\_secret\_namespace) | Target namespace of secret in Kubernetes to store the Grafana API Key Secret | `string` | `"grafana-operator"` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->
