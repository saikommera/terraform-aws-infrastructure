variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
}

variable "cluster_version" {
  description = "Kubernetes version"
  type        = string
  default     = "1.29"
}

variable "vpc_id" {
  description = "VPC ID where the cluster is deployed"
  type        = string
}

variable "subnet_ids" {
  description = "List of subnet IDs for the cluster and node groups"
  type        = list(string)
}

variable "node_groups" {
  description = "Map of node group configurations"
  type = map(object({
    desired_capacity = number
    min_capacity     = number
    max_capacity     = number
    instance_types   = list(string)
    labels           = optional(map(string), {})
  }))
  default = {}
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
}
