
// -------------- For public loadbalancer --------------
resource "aws_security_group" "web_lb" {
  vpc_id      = var.vpc_id
  name        = "${var.name}_alb"
  description = "Security group for ${var.name}_alb accepting public HTTP requests."
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Terraform = "true"
  }
}

resource "aws_security_group_rule" "web_all_http" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.web_lb.id
}

resource "aws_security_group_rule" "web_all_https" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.web_lb.id
}


// -------------- For internal app servers --------------
resource "aws_security_group" "web_app" {
  vpc_id      = var.vpc_id
  name        = "${var.name}_app"
  description = "Security group for ${var.name}_app accepting requests from ${var.name}_alb."
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Terraform = "true"
  }
}

resource "aws_security_group_rule" "from_web_lb_http_to_web_app" {
  type                     = "ingress"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.web_lb.id
  security_group_id        = aws_security_group.web_app.id
}


resource "aws_security_group_rule" "from_all_ssh_to_web_app" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.web_app.id
}

// -------------- For internal databases --------------
resource "aws_security_group" "web_db" {
  vpc_id      = var.vpc_id
  name        = "${var.name}_database"
  description = "Security group for ${var.name}_app accepting requests from ${var.name}_app."
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Terraform = "true"
  }
}

resource "aws_security_group_rule" "from_web_app_mysql_to_web_db" {
  type                     = "ingress"
  from_port                = 3306
  to_port                  = 3306
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.web_app.id
  security_group_id        = aws_security_group.web_db.id
}


// -------------- For internal redis --------------
resource "aws_security_group" "web_redis" {
  vpc_id      = var.vpc_id
  name        = "${var.name}_redis"
  description = "Security group for ${var.name}_redis accepting requests from ${var.name}_app."
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Terraform = "true"
  }
}

resource "aws_security_group_rule" "from_web_app_to_web_redis" {
  type                     = "ingress"
  from_port                = 6379
  to_port                  = 6379
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.web_app.id
  security_group_id        = aws_security_group.web_redis.id
}

// -------------- For codebuild --------------
resource "aws_security_group" "codebuild" {
  vpc_id      = var.vpc_id
  name        = "${var.name}_codebuild"
  description = "Security group for ${var.name}_app codebuild."
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Terraform = "true"
  }
}
resource "aws_security_group_rule" "from_codebuild_to_db" {
  type                     = "ingress"
  from_port                = 3306
  to_port                  = 3306
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.codebuild.id
  security_group_id        = aws_security_group.web_db.id
}

resource "aws_security_group_rule" "from_codebuild_to_app" {
  type                     = "ingress"
  from_port                = 0
  to_port                  = 0
  protocol                 = "-1"
  source_security_group_id = aws_security_group.codebuild.id
  security_group_id        = aws_security_group.web_app.id
}
