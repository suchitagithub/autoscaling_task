output "autoscaling_group_name" {
  description = "The name of the Auto Scaling Group"
  value       = aws_autoscaling_group.app.name
}

output "scale_out_policy_arn" {
  description = "ARN of the Scale Out policy"
  value       = aws_autoscaling_policy.scale_out.arn
}

output "scale_in_policy_arn" {
  description = "ARN of the Scale In policy"
  value       = aws_autoscaling_policy.scale_in.arn
}
