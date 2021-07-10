
name = "testing_project"

env = "production"
# Only some AWS accounts are available ap-northeast-1b azs
# We are using Asia/Tokyo , you can set timezone different or as variable from here

azs = ["ap-northeast-1a", "ap-northeast-1c", "ap-northeast-1d"]


cidr = ""

public_subnets = ["Some CIDR Blocks Comma Seperated"]

database_subnets = ["Some CIDR Blocks"]

elasticache_subnets = ["Some CIDR Blocks"]


lb_healthcheck_path = "/health"
# health check path it will use in blue/green deployment and try to restart if health down

database_name = ""

database_user = ""

database_password = ""

github_account = "Iruuza"

github_repository = ""

github_branch = ""

// Depends on "name" variable
web_container_name = "testing_project_web"

ssl_cert_arn = ""


database_host_title = ""
database_password_title = ""

docker_username = ""
docker_password = ""

redis_name = "testing-project-staging"
