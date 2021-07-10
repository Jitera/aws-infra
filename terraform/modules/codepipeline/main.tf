

resource "aws_codepipeline" "web" {
  name     = "${var.name}_web"
  role_arn = var.iam_arn

  artifact_store {
    type     = "S3"
    location = var.s3_id
  }

  stage {
    name = "Source"
    action {
      name             = "Source"
      category         = "Source"
      owner            = "ThirdParty"
      provider         = "GitHub"
      version          = "1"
      run_order        = 1
      output_artifacts = ["source"]
      configuration = {
        Owner      = var.github_account
        Repo       = var.github_repository
        Branch     = var.github_branch
        OAuthToken = var.github_token
      }
    }
  }

  stage {
    name = "Build"
    action {
      name             = "Build"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      version          = "1"
      run_order        = 2
      input_artifacts  = ["source"]
      output_artifacts = ["build"]
      configuration = {
        ProjectName = var.codebuild_name
      }
    }
  }

  stage {
    name = "Deploy"
    action {
      name            = "Deploy"
      category        = "Deploy"
      owner           = "AWS"
      provider        = "CodeDeployToECS"
      version         = "1"
      run_order       = 3
      input_artifacts = ["build"]
      configuration = {
        ApplicationName                = var.codedeploy_name
        DeploymentGroupName            = var.codedeploy_name
        TaskDefinitionTemplateArtifact = "build"
        TaskDefinitionTemplatePath     = "ecs/${var.env}/taskdef.json"
        AppSpecTemplateArtifact        = "build"
        AppSpecTemplatePath            = "ecs/${var.env}/appspec.yaml"
        Image1ArtifactName             = "build"
        Image1ContainerName            = "IMAGE1_NAME"
      }
    }
  }

  tags = {
    Terraform = "true"
  }
}