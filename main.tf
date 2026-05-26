module "launch_template" {
  source = "git::https://github.com/PlatformStackPulse/tf-atom-launch-template-aws.git?ref=v1.1.0"

  enabled   = module.this.enabled
  namespace = var.namespace
  name      = var.name
  stage     = var.stage
  tags      = var.tags

  image_id      = var.ami_id
  instance_type = var.instance_type
  key_name      = var.key_name

  network_interface = {
    associate_public_ip_address = false
    security_groups             = var.security_group_ids
  }

  iam_instance_profile_name = var.iam_instance_profile_name
  user_data_base64          = var.user_data_base64
  root_volume_size          = var.root_volume_size
}

module "autoscaling_group" {
  source = "git::https://github.com/PlatformStackPulse/tf-atom-autoscaling-group-aws.git?ref=v1.1.0"

  enabled   = module.this.enabled
  namespace = var.namespace
  name      = var.name
  stage     = var.stage
  tags      = var.tags

  launch_template_id      = module.launch_template.id
  launch_template_version = "$Latest"
  subnet_ids              = var.subnet_ids
  min_size                = var.min_size
  max_size                = var.max_size
  desired_capacity        = var.desired_capacity
  health_check_type       = length(var.target_group_arns) > 0 ? "ELB" : "EC2"
  target_group_arns       = var.target_group_arns
}

module "scaling_policy" {
  source = "git::https://github.com/PlatformStackPulse/tf-atom-autoscaling-policy-aws.git?ref=v1.1.0"

  enabled   = module.this.enabled && var.scaling_policy_enabled
  namespace = var.namespace
  name      = "${var.name}-scale"
  stage     = var.stage
  tags      = var.tags

  autoscaling_group_name = module.autoscaling_group.name
  policy_type            = "TargetTrackingScaling"
  predefined_metric_type = var.scaling_metric_type
  target_value           = var.scaling_target_value
}
