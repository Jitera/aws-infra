

resource "aws_cloudwatch_log_group" "codebuild" {
  name              = "${var.name}_codebuild"
  retention_in_days = 14
}

resource "aws_cloudwatch_log_group" "ecs" {
  name              = "${var.name}_ecs_web"
  retention_in_days = 14
}