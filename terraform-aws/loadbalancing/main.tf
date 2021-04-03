# -- loadbalancing/main.tf --

resource "aws_lb" "peter_lb" {
  name = "peter-loadbalancer"
  # internal           = false
  # load_balancer_type = "application"
  subnets         = var.public_subnets
  security_groups = var.public_sg
  idle_timeout    = 400
  # enable_deletion_protection = true

  # access_logs {
  #   bucket  = aws_s3_bucket.lb_logs.bucket
  #   prefix  = "test-lb"
  #   enabled = true
  # }

  # tags = {
  #   Environment = "production"
  # }
}

resource "aws_lb_target_group" "peter_tg" {
  name     = "peter-lb-tg-${substr(uuid(), 0, 3)}"
  port     = var.tg_port
  protocol = var.tg_protocol
  vpc_id   = var.vpc_id
  lifecycle {
    ignore_changes        = [name]
    create_before_destroy = true
  }
  health_check {
    healthy_threshold   = var.lb_healthy_thresold
    unhealthy_threshold = var.lb_unhealthy_thresold
    timeout             = var.lb_timeout
    interval            = var.lb_interval
  }
}

resource "aws_lb_listener" "peter_lb_listener" {
  load_balancer_arn = aws_lb.peter_lb.arn
  port              = var.listerner_port
  protocol          = var.listerner_protocol

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.peter_tg.arn
  }
}