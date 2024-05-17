# EKS Observability Demo

Deploy EKS Observability resources.

## Demonstration

### Prerequisites

1. Access to an AWS account.
1. An operational EKS cluster created in your account and appropriate access.
   - EKS security groups should allow HTTPS ingress from your Cloud9 instance.
1. IAM Identity Center is configured in the account with a user and group.
1. A running Cloud9 environment with Administrator access for the instance IAM role.

### Setup

1. Go to AWS Cloud9 and connect to your environment
1. Disable AWS managed temporary credentials in Cloud9. They do not play nice with EKS.
   1. In the Cloud9 IDE, click on the cog icon at the top right of the IDE
   1. Scroll down to `AWS Settings`
   1. Turn off `AWS managed temporary credentials`
1. Connect to your EKS cluster and confirm access
   ```bash
   aws eks update-kubeconfig --name <your-cluster-arn> --alias <optional-kube-context-alias>
   kubectl get all -A
   ```

### Deploy AWS Observability Accelerator

1. Populate your `terraform.tfvars` file with your EKS cluster name and region
1. Deploy your Terraform template
   ```bash
   terraform init
   terraform apply
   ```
1. Verify 


#### Grafana Charts

Baseline charts are deployed from the [Observability Accelerator artifacts repository](https://github.com/aws-observability/aws-observability-accelerator/tree/main/artifacts).

### Deploy Sample App

Deploy one of the sample applications provided by AWS.

https://github.com/aws-observability/aws-observability-accelerator/blob/main/artifacts/k8s-deployment-manifest-templates/nginx/nginx-traffic-sample.yaml

1. Pull the example application from github.
   ```bash
   curl https://raw.githubusercontent.com/aws-observability/aws-observability-accelerator/main/artifacts/k8s-deployment-manifest-templates/nginx/nginx-traffic-sample.yaml > nginx-traffic-sample.yaml
   ```
1. Replace all occurrances of `{{namespace}}` with a valid namespace name
   ```bash
   sed -i 's/{{namespace}}/sample-app/g' nginx-traffic-sample.yaml
   ```
1. Retrieve the load balancer DNS name from the Ingress resource in your new namespace
   ```bash
   sed -i "s/{{external_ip}}/$(kubectl -n ingress-nginx get svc ingress-nginx-controller -o 'jsonpath={$.status.loadBalancer.ingress[0].hostname}')/g" nginx-traffic-sample.yaml
   ```
1. Deploy the sample application manifest
   ```
   kubectl apply -f nginx-traffic-sample.yaml
   ```
1. Verify template deployed resources
   ```bash
   kubectl get ingress,pod,svc -n sample-app
   ```

   You should see similar output to the following
   ```
   NAME                    READY   STATUS    RESTARTS   AGE
   pod/apple-app           1/1     Running   0          2m53s
   pod/banana-app          1/1     Running   0          2m53s
   pod/traffic-generator   1/1     Running   0          2m53s

   NAME                     TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)    AGE
   service/apple-service    ClusterIP   172.20.37.121   <none>        5678/TCP   2m53s
   service/banana-service   ClusterIP   172.20.42.197   <none>        5678/TCP   2m53s

   NAME                                           CLASS   HOSTS                                                                 ADDRESS                                                               PORTS   AGE
   ingress.networking.k8s.io/ingress-nginx-demo   nginx   nginx-eksblueprintblue-82fc84117349e7fb.elb.us-west-2.amazonaws.com   nginx-eksblueprintblue-82fc84117349e7fb.elb.us-west-2.amazonaws.com   80      2m53s
   ```


<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.7 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 5.49 |
| <a name="requirement_helm"></a> [helm](#requirement\_helm) | ~> 2.13 |
| <a name="requirement_kubectl"></a> [kubectl](#requirement\_kubectl) | ~> 2.0 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | ~> 2.30 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 5.49 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_addons"></a> [addons](#module\_addons) | aws-ia/eks-blueprints-addons/aws | ~>1.16 |
| <a name="module_eks_monitoring"></a> [eks\_monitoring](#module\_eks\_monitoring) | github.com/aws-observability/terraform-aws-observability-accelerator//modules/eks-monitoring | v2.12.2 |
| <a name="module_managed_grafana"></a> [managed\_grafana](#module\_managed\_grafana) | terraform-aws-modules/managed-service-grafana/aws | ~>2.1 |

## Resources

| Name | Type |
|------|------|
| [aws_sns_topic.prometheus_alerts_topic](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sns_topic) | resource |
| [aws_sns_topic_subscription.grafana_alert_sub](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sns_topic_subscription) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_eks_cluster.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/eks_cluster) | data source |
| [aws_eks_cluster_auth.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/eks_cluster_auth) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | EKS cluster name the workspace is deployed for | `string` | n/a | yes |
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
| <a name="input_grafana_version"></a> [grafana\_version](#input\_grafana\_version) | Grafana version | `string` | `"9.4"` | no |
| <a name="input_target_secret_name"></a> [target\_secret\_name](#input\_target\_secret\_name) | Target secret in Kubernetes to store the Grafana API Key Secret | `string` | `"grafana-admin-credentials"` | no |
| <a name="input_target_secret_namespace"></a> [target\_secret\_namespace](#input\_target\_secret\_namespace) | Target namespace of secret in Kubernetes to store the Grafana API Key Secret | `string` | `"grafana-operator"` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->
