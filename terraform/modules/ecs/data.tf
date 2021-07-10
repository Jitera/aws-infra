data "template_file" "environment_variables_rails" {
  template = <<EOF
  [
    { "name": "NODE_ENV", "value": "production" },
    { "name": "RAILS_ENV", "value": "${var.env}" },
    { "name": "RAILS_MAX_THREADS", "value" : "16" },
    { "name": "TZ", "value": "Asia/Tokyo" }
  ]
  EOF
}
data "template_file" "enviorment_secrets" {
  template = <<EOF
  [
      {
        "name": "${var.database_host_title_arn}",
        "valueFrom": "${var.database_host_arn}"
      },
      {
        "name": "${var.database_password_title_arn}",
        "valueFrom": "${var.database_password_arn}"
      },
      {
        "name": "RAILS_MASTER_KEY",
        "valueFrom": "${var.rails_master_key_arn}"
      },
      {
        "name":  "REDIS_URL",
        "valueFrom": "${var.redis_address_arn}"

      },
      {
        "name": "GIT_TOKEN",
        "valueFrom": "${var.git_token_arn}"
      }
  ]
  EOF
}
