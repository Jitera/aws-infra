
resource "aws_ecs_cluster" "this" {
  name               = var.name
  capacity_providers = ["FARGATE", "FARGATE_SPOT"]
  default_capacity_provider_strategy {
    capacity_provider = "FARGATE"
    weight            = 1
    base              = 1
  }
  setting {
    name  = "containerInsights"
    value = "enabled"
  }
  tags = {
    Terraform = "true"
  }
}

resource "aws_ecs_task_definition" "web" {
  family                   = var.name
  network_mode             = "awsvpc"
  execution_role_arn       = var.iam_arn
  requires_compatibilities = ["FARGATE"]
  cpu                      = 1024
  memory                   = 2048

  container_definitions = <<EOF
[
  {
    "name": "${var.name}_web",
    "image": "${var.image_url}:latest",
    "essential": true,
    "command": ["bundle", "exec", "rails", "server", "-b", "0.0.0.0", "-p", "80"],
    "portMappings": [
      {
        "protocol": "tcp",
        "containerPort": 80,
        "hostPort": 80
      }
    ],
    "environment": ${data.template_file.environment_variables_rails.rendered},
    "secrets": ${data.template_file.enviorment_secrets.rendered},
    "logConfiguration": {
      "logDriver": "awslogs",
      "options": {
        "awslogs-region": "ap-northeast-1",
        "awslogs-group": "${var.cloudwatch_log_group_name}",
        "awslogs-stream-prefix": "${var.name}"
      }
    }
  }
]
EOF
}

resource "aws_ecs_service" "web" {
  name                               = "${var.name}_web"
  task_definition                    = aws_ecs_task_definition.web.arn
  cluster                            = aws_ecs_cluster.this.id
  desired_count                      = 1
  health_check_grace_period_seconds  = 20
  enable_ecs_managed_tags            = true
  deployment_minimum_healthy_percent = 100
  deployment_maximum_percent         = 200
  scheduling_strategy                = "REPLICA"

  network_configuration {
    subnets          = var.subnets
    security_groups  = var.security_groups
    assign_public_ip = true
  }

  deployment_controller {
    type = "CODE_DEPLOY"
  }

  capacity_provider_strategy {
    capacity_provider = "FARGATE"
    weight            = 1
    base              = 1
  }

  capacity_provider_strategy {
    capacity_provider = "FARGATE_SPOT"
    weight            = 1
    base              = 0
  }

  load_balancer {
    target_group_arn = var.lb_blue_arn
    container_name   = var.web_container_name
    container_port   = 80
  }

  lifecycle {
    ignore_changes = [
      desired_count,
      task_definition,
      load_balancer
    ]
  }
}

resource "aws_ecs_service" "ssh_service" {
  name                    = "${var.name}_ssh_service"
  cluster                 = aws_ecs_cluster.this.id
  task_definition         = aws_ecs_task_definition.ssh_task.arn
  desired_count           = 1
  enable_ecs_managed_tags = true
  scheduling_strategy     = "REPLICA"
  force_new_deployment    = true
  network_configuration {
    subnets          = var.subnets
    security_groups  = var.security_groups
    assign_public_ip = true
  }
  capacity_provider_strategy {
    base              = 1
    capacity_provider = "FARGATE"
    weight            = 1
  }
  deployment_controller {
    type = "ECS"
  }
  lifecycle {
    ignore_changes = [
      health_check_grace_period_seconds,
      propagate_tags,
      tags
    ]
  }
}

resource "aws_ecs_task_definition" "ssh_task" {
  task_role_arn            = var.iam_arn
  family                   = "${var.name}_ssh"
  network_mode             = "awsvpc"
  execution_role_arn       = var.iam_arn
  requires_compatibilities = ["FARGATE"]
  cpu                      = 512
  memory                   = 1024
  container_definitions    = <<EOF
  [
  {
    "name": "${var.name}_ssh",
    "image": "${var.image_url}:latest",
    "essential": true,
    "command": ["sleep", "3600"],
    "portMappings": [
      {
        "protocol": "tcp",
        "containerPort": 22,
        "hostPort": 22
      }
    ],
    "linuxParameters": {
      "initProcessEnabled": true
    },
    "environment": ${data.template_file.environment_variables_rails.rendered},
    "secrets": ${data.template_file.enviorment_secrets.rendered},
    "logConfiguration": {
      "logDriver": "awslogs",
      "options": {
        "awslogs-region": "ap-northeast-1",
        "awslogs-group": "${var.cloudwatch_log_group_name}",
        "awslogs-stream-prefix": "${var.name}_ssh"
      }
    }
  }
  ]
  EOF
}
# standalone task with no service
# https://docs.aws.amazon.com/AmazonECS/latest/developerguide/ecs_run_task.html
resource "aws_ecs_task_definition" "db_setup" {
  task_role_arn            = var.iam_arn
  family                   = "${var.name}_db_setup"
  network_mode             = "awsvpc"
  execution_role_arn       = var.iam_arn
  requires_compatibilities = ["FARGATE"]
  cpu                      = 512
  memory                   = 1024
  container_definitions    = <<EOF
  [
  {
    "name": "${var.name}_db_setup",
    "image": "${var.image_url}:latest",
    "essential": true,
    "command": ["bundle", "exec", "rails", "db:create","db:migrate"],
    "portMappings": [
      {
        "protocol": "tcp",
        "containerPort": 22,
        "hostPort": 22
      }
    ],
    "environment": ${data.template_file.environment_variables_rails.rendered},
    "secrets": ${data.template_file.enviorment_secrets.rendered},
    "logConfiguration": {
      "logDriver": "awslogs",
      "options": {
        "awslogs-region": "ap-northeast-1",
        "awslogs-group": "${var.cloudwatch_log_group_name}",
        "awslogs-stream-prefix": "${var.name}_db_setup"
      }
    },
    "awsvpcConfiguration": {
      "subnets": "${var.subnets[0]}",
      "securityGroups": "${var.security_groups[0]}",
      "assignPublicIp": "ENABLED"
    }
  }
  ]
  EOF
}
resource "aws_ecs_service" "sidekiq" {
  name                    = "${var.name}_sidekiq"
  cluster                 = aws_ecs_cluster.this.id
  task_definition         = aws_ecs_task_definition.sidekiq_task.arn
  desired_count           = 1
  enable_ecs_managed_tags = true
  scheduling_strategy     = "REPLICA"
  force_new_deployment    = true
  network_configuration {
    subnets          = var.subnets
    security_groups  = var.security_groups
    assign_public_ip = true
  }
  capacity_provider_strategy {
    base              = 1
    capacity_provider = "FARGATE"
    weight            = 1
  }
  deployment_controller {
    type = "ECS"
  }
  lifecycle {
    ignore_changes = [
      health_check_grace_period_seconds,
      propagate_tags,
      tags
    ]
  }
}

resource "aws_ecs_task_definition" "sidekiq_task" {
  task_role_arn            = var.iam_arn
  family                   = "${var.name}_sidekiq"
  network_mode             = "awsvpc"
  execution_role_arn       = var.iam_arn
  requires_compatibilities = ["FARGATE"]
  cpu                      = 512
  memory                   = 1024
  container_definitions    = <<EOF
  [
  {
    "name": "${var.name}_sidekiq",
    "image": "${var.image_url}:latest",
    "essential": true,
    "command": ["bundle", "exec", "sidekiq"],
    "portMappings": [
      {
        "protocol": "tcp",
        "containerPort": 22,
        "hostPort": 22
      }
    ],
    "linuxParameters": {
      "initProcessEnabled": true
    },
    "environment": ${data.template_file.environment_variables_rails.rendered},
    "secrets": ${data.template_file.enviorment_secrets.rendered},
    "logConfiguration": {
      "logDriver": "awslogs",
      "options": {
        "awslogs-region": "ap-northeast-1",
        "awslogs-group": "${var.cloudwatch_log_group_name}",
        "awslogs-stream-prefix": "${var.name}_sidekiq"
      }
    }
  }
  ]
  EOF
}
