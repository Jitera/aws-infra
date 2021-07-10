# AWS Infrastructure

### config

This folder is just a small part of rails application, you can copy the env modification so that your are able to monitor logs in Cloudwatch

### ecs

It contains buildspec, appspec, taskdef.json this will be used by Codebuild, CodePipeline for deployment automation

### production/staging

It contains docker file, can be 1 docker file or sometimes seperate files for env specific configurations which may differ, you can use as per your need

### terraform

It contains terraform code,actual code used for building infra

# Contributing to this repository only Issue Accepted for now, no PR accepted

Before you raise new issue, check to see if an [issue exists](https://github.com/Iruuza/aws-infra/issues) already for the change you want to make.

### Don't see your issue? Open one

If you spot something new, open an issue using a [template](https://github.com/Iruuza/aws-infra/issues/new/choose). We'll use the issue to have a conversation about the problem you want to fix.
