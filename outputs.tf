output "autoscaling_group_name" {
  description = "Name of the ASG"
  value       = module.autoscaling_group.name
}

output "autoscaling_group_arn" {
  description = "ARN of the ASG"
  value       = module.autoscaling_group.arn
}

output "launch_template_id" {
  description = "ID of the launch template"
  value       = module.launch_template.id
}

output "launch_template_latest_version" {
  description = "Latest version of the launch template"
  value       = module.launch_template.latest_version
}
