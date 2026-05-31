variable "role_name" {
  description = "Name of the IAM role"
  type        = string
}

variable "trusted_service" {
  description = "AWS service that can assume this role (e.g. ec2.amazonaws.com)"
  type        = string
  default     = "ec2.amazonaws.com"
}

variable "oidc_provider_arn" {
  description = "ARN of OIDC provider for IRSA (leave empty for service-based trust)"
  type        = string
  default     = ""
}

variable "namespace" {
  description = "Kubernetes namespace for IRSA"
  type        = string
  default     = "default"
}

variable "service_account_name" {
  description = "Kubernetes service account name for IRSA"
  type        = string
  default     = "default"
}

variable "managed_policy_arns" {
  description = "List of managed IAM policy ARNs to attach"
  type        = list(string)
  default     = []
}

variable "inline_policy" {
  description = "Inline policy document JSON (empty string = no inline policy)"
  type        = string
  default     = ""
}

variable "max_session_duration" {
  description = "Maximum session duration in seconds"
  type        = number
  default     = 3600
}

variable "tags" {
  description = "Tags to apply to the role"
  type        = map(string)
  default     = {}
}
