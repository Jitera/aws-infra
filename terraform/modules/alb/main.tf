locals {
  // underscore is prefereble according to official terraform bestpractice, but alb only accepts hyphen based name.
  resources_name = replace("${var.name}_web", "_", "-")
}

resource "aws_lb" "web" {
  name                       = local.resources_name
  internal                   = false
  load_balancer_type         = "application"
  enable_deletion_protection = false
  security_groups            = var.security_groups
  subnets                    = var.subnets
  access_logs {
    bucket  = var.access_log_bucket_id
    enabled = true
  }
  tags = {
    Terraform = "true"
  }
}

resource "aws_lb_target_group" "blue" {
  name        = "${local.resources_name}-blue"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"
  health_check {
    protocol            = "HTTP"
    path                = var.lb_healthcheck_path
    interval            = 30
    timeout             = 20
    healthy_threshold   = 3
    unhealthy_threshold = 4
    matcher             = 200
  }
  tags = {
    Terraform = "true"
  }
}

resource "aws_lb_target_group" "green" {
  name        = "${local.resources_name}-green"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"
  health_check {
    protocol            = "HTTP"
    path                = var.lb_healthcheck_path
    interval            = 30
    timeout             = 20
    healthy_threshold   = 3
    unhealthy_threshold = 4
    matcher             = 200
  }
  tags = {
    Terraform = "true"
  }
}

resource "aws_lb_listener" "web_http" {
  load_balancer_arn = aws_lb.web.arn
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type = "redirect"
    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

resource "aws_lb_listener" "web_https" {
  load_balancer_arn = aws_lb.web.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = var.ssl_cert_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.blue.arn
  }
  lifecycle {
    ignore_changes = [
      default_action
    ]
  }
}