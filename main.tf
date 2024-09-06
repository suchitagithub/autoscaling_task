provider "aws" {
  region = var.aws_region
}
 
 # Auto Scaling Launch Configuration
resource "aws_launch_configuration" "app" {
  name_prefix          = "app-"
  image_id             = var.ami_id
  instance_type        = var.instance_type
  security_groups      = [aws_security_group.app_sg.id]
  user_data            = var.user_data
 
  lifecycle {
    create_before_destroy = true
  }
}
 
# Auto Scaling Group
resource "aws_autoscaling_group" "app" {
  launch_configuration = aws_launch_configuration.app.id
  vpc_zone_identifier = var.subnet_ids
  min_size             = var.min_size
  max_size             = var.max_size
  desired_capacity     = var.desired_capacity
 
  tag {
    key                 = "Name"
    value               = "app-instance"
    propagate_at_launch = true
  }
 
  # Attach the Auto Scaling Group to the target group
  target_group_arns = var.target_group_arns
}
 
# Auto Scaling Policy for Scaling Out
resource "aws_autoscaling_policy" "scale_out" {
  name                   = "scale-out"
  scaling_adjustment     = 1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 60
  autoscaling_group_name = aws_autoscaling_group.app.name
}
 
# Auto Scaling Policy for Scaling In
resource "aws_autoscaling_policy" "scale_in" {
  name                   = "scale-in"
  scaling_adjustment     = -1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 60
  autoscaling_group_name = aws_autoscaling_group.app.name
}
