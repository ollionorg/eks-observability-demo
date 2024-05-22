variable "cluster_name" {
  description = "EKS cluster name the workspace is deployed for"
  type        = string
}

variable "region" {
  description = "AWS Region being deployed to"
  type        = string
}

variable "global_tags" {
  description = "Map of key,value pairs to tag all resources"
  type        = map(string)
  default = {
    creation-method = "terraform"
    project         = "eks-observability-demo"
  }
}

##
# Grafana
##
variable "grafana_workspace_name" {
  description = "Grafana workspace name"
  type        = string
}

variable "grafana_version" {
  description = "Grafana version"
  type        = string
  default     = "9.4"
}

variable "grafana_enable_alerts" {
  description = "Determines whether IAM permissions for alerting are enabled for the workspace IAM role"
  type        = bool
  default     = true
}

variable "saml_idp_metadata_url" {
  description = "URL of the SAML IdP metadata"
  type        = string
  
}

variable "grafana_admin_groups" {
  description = "List of AWS SSO groups to assign as administrators in Amazon Managed Grafana"
  type        = list(string)
  default     = []
}

variable "grafana_editor_groups" {
  description = "List of AWS SSO groups to assign as editor in Amazon Managed Grafana"
  type        = list(string)
  default     = []
}

variable "grafana_readonly_groups" {
  description = "List of AWS SSO groups to assign as readonly users in Amazon Managed Grafana"
  type        = list(string)
  default     = []
}

##
# Observability Accelerator
##
variable "adot_loglevel" {
  description = "Verbosity level for ADOT Collector"
  type        = string
  default     = "normal"
}

variable "enable_dashboards" {
  description = "Enables or disables curated dashboards. Dashboards are managed by the Grafana Operator"
  type        = bool
  default     = true
}

variable "target_secret_name" {
  description = "Target secret in Kubernetes to store the Grafana API Key Secret"
  type        = string
  default     = "grafana-admin-credentials"
}

variable "target_secret_namespace" {
  description = "Target namespace of secret in Kubernetes to store the Grafana API Key Secret"
  type        = string
  default     = "grafana-operator"
}

variable "alert_email_addresses" {
  description = "Email addressses for Observability alerts"
  type        = list(string)
  default     = []
}
