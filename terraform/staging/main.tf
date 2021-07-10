terraform {
  required_version = ">= 0.14.3"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "= 3.12.0"
    }
  }
}

terraform {
  backend "s3" {
    bucket = "icode-prod-1-terraform"
    key    = "testing-project-staging-terraform-state"
    region = "ap-northeast-1"
  }
}

locals {
  // underscore is prefereble according to official terraform bestpractice, but alb only accepts hyphen based name.
  // Moreover, terraform AWS provider v3.12.0 (via Terraform 0.14) has issue #7987 related to "Provider produced inconsistent final plan".
  // It means that S3 bucket has to be created before referencing it as an argument inside access_logs = { bucket = "bucket-name" }, so this won't work: access_logs = { bucket = module.s3.s3_bucket_id }.
  access_log_bucket_name = replace("${var.name}_access_log", "_", "-")
  pipeline_artifact_name = replace("${var.name}_pipeline_artifact", "_", "-")
}

module "vpc" {
  source              = "../modules/vpc"
  name                = var.name
  cidr                = var.cidr
  azs                 = var.azs
  public_subnets      = var.public_subnets
  database_subnets    = var.database_subnets
  elasticache_subnets = var.elasticache_subnets
}

module "security_group" {
  source   = "../modules/security_group"
  name     = var.name
  vpc_id   = module.vpc.vpc_id
  vpc_cidr = var.cidr
}

module "s3" {
  source                 = "../modules/s3"
  access_log_name        = local.access_log_bucket_name
  pipeline_artifact_name = local.pipeline_artifact_name
}

module "alb" {
  source               = "../modules/alb"
  name                 = var.name
  vpc_id               = module.vpc.vpc_id
  security_groups      = [module.security_group.alb_sg_id]
  subnets              = module.vpc.public_subnets
  access_log_bucket_id = local.access_log_bucket_name
  lb_healthcheck_path  = var.lb_healthcheck_path
  ssl_cert_arn         = var.ssl_cert_arn
}

module "ecs" {
  source                      = "../modules/ecs"
  name                        = var.name
  cloudwatch_log_group_name   = module.cloudwatch.log_group_ecs_name
  image_url                   = module.ecr.web_repository_url
  lb_blue_arn                 = module.alb.target_group_blue_arn
  subnets                     = module.vpc.public_subnets
  security_groups             = [module.security_group.app_sg_id]
  iam_arn                     = module.iam.ecs_tasks_arn
  web_container_name          = var.web_container_name
  database_host_arn           = module.ssm.database_host_arn
  database_password_arn       = module.ssm.database_password_arn
  rails_master_key_arn        = module.ssm.rails_master_key_arn
  env                         = var.env
  redis_address_arn           = module.ssm.redis_address_arn
  database_host_title_arn     = module.ssm.database_host_title_arn
  database_password_title_arn = module.ssm.database_password_arn
  git_token_arn               = module.ssm.git_token_arn
}

module "autoscaling" {
  source               = "../modules/autoscaling"
  name                 = var.name
  ecs_web_service_name = module.ecs.web_service_name
}

module "db" {
  source              = "../modules/db"
  name                = var.name
  env                 = var.env
  database_name       = var.database_name
  user                = var.database_user
  password            = var.database_password
  subnets             = module.vpc.database_subnets
  security_groups     = [module.security_group.database_sg_id]
  # snapshot_identifier = var.snapshot_identifier
}

module "ssm" {
  source                  = "../modules/ssm"
  name                    = var.name
  database_password       = var.database_password
  database_host           = trim(module.db.db_endpoint, ":3306")
  rails_master_key        = var.rails_master_key
  web_container_name      = var.web_container_name
  docker_username         = var.docker_username
  docker_password         = var.docker_password
  subnet                  = module.vpc.public_subnets[0]
  security_group          = module.security_group.app_sg_id
  redis_address           = "redis://${module.sidekiq_redis.cluster_address}:${module.sidekiq_redis.port}"
  git_token               = var.github_token
  database_host_title     = var.database_host_title
  database_password_title = var.database_password_title
}

module "cloudwatch" {
  source = "../modules/cloudwatch"
  name   = var.name
}

module "ecr" {
  source   = "../modules/ecr"
  web_name = var.web_container_name
}

module "iam" {
  source                  = "../modules/iam"
  name                    = var.name
  codepipeline_bucket_arn = module.s3.pipeline_artifact_bucket_arn
  cloudwatch_arn          = module.cloudwatch.log_group_codebuild_arn
  ecr_arn                 = module.ecr.web_arn
}

module "codepipeline" {
  source             = "../modules/codepipeline"
  name               = var.name
  env                = var.env
  web_container_name = var.web_container_name
  iam_arn            = module.iam.codepipeline_arn
  s3_id              = module.s3.pipeline_artifact_bucket_id
  github_account     = var.github_account
  github_repository  = var.github_repository
  github_branch      = var.github_branch
  github_token       = var.github_token
  codedeploy_name    = module.codedeploy.web_name
  codebuild_name     = module.codebuild.web_name
}

module "codebuild" {
  source                    = "../modules/codebuild"
  name                      = var.name
  env                       = var.env
  vpc_id                    = module.vpc.vpc_id
  subnets                   = module.vpc.database_subnets
  security_groups           = [module.security_group.codebuild_sg_id]
  iam_arn                   = module.iam.codebuild_arn
  cloudwatch_log_group_name = module.cloudwatch.log_group_codebuild_name
}

module "codedeploy" {
  source                = "../modules/codedeploy"
  name                  = var.name
  iam_arn               = module.iam.codedeploy_arn
  ecs_web_service_name  = module.ecs.web_service_name
  alb_listner_arns      = module.alb.lb_listener_arns
  alb_target_blue_name  = module.alb.target_group_blue_name
  alb_target_green_name = module.alb.target_group_green_name
}

module "sidekiq_redis" {
  cluster_id          = "${var.redis_name}-sidekiq-redis"
  env                 = var.env
  azs                 = var.azs
  source              = "../modules/redis"
  name                = var.redis_name
  elasticache_subnets = module.vpc.elasticache_subnet_group_name
  security_groups     = [module.security_group.redis_security_group_id]
}
