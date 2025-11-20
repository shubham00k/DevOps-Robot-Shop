variable "cluster_name" {
  type        = string
  description = "EKS Cluster Name"
}

variable "cluster_version" {
  type        = string
  description = "Kubernetes version"
  default     = "1.30"
}

variable "vpc_id" {
  type        = string
  description = "VPC ID"
}

variable "subnet_ids" {
  type        = list(string)
  description = "Subnet IDs"
}

variable "node_groups" {
  description = "Node group configuration"
  type = map(object({
    instance_types = list(string)
    capacity_type  = string
    scaling_config = object({
      desired_size = number
      max_size     = number
      min_size     = number
    })
  }))
}

variable "oidc_thumbprint" {
  type    = string
  default = "9e99a48a9960b14926bb7f3b02e22da0afd9e9d8"
}

variable "region" {
  type    = string
  default = "ap-south-1"
}
