variable "ami_id" {
  description = "AMI ID for instances"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.small"
}

variable "subnet_ids" {
  description = "Private subnet IDs for the ASG"
  type        = list(string)
}

variable "security_group_ids" {
  description = "Security group IDs for instances"
  type        = list(string)
}

variable "min_size" {
  description = "Minimum instances"
  type        = number
  default     = 2
}

variable "max_size" {
  description = "Maximum instances"
  type        = number
  default     = 6
}

variable "desired_capacity" {
  description = "Desired instances"
  type        = number
  default     = 2
}

variable "target_group_arns" {
  description = "Target group ARNs to attach"
  type        = list(string)
  default     = []
}

variable "key_name" {
  description = "SSH key pair name"
  type        = string
  default     = null
}

variable "iam_instance_profile_name" {
  description = "IAM instance profile name"
  type        = string
  default     = null
}

variable "user_data_base64" {
  description = "Base64-encoded user data"
  type        = string
  default     = null
}

variable "root_volume_size" {
  description = "Root volume size in GB"
  type        = number
  default     = 20
}

variable "scaling_policy_enabled" {
  description = "Whether to create a scaling policy"
  type        = bool
  default     = true
}

variable "scaling_metric_type" {
  description = "Metric for target tracking (ASGAverageCPUUtilization, ALBRequestCountPerTarget)"
  type        = string
  default     = "ASGAverageCPUUtilization"
}

variable "scaling_target_value" {
  description = "Target value for scaling metric"
  type        = number
  default     = 70
}
