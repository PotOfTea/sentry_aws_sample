terraform {
  extra_arguments "common_vars" {
    commands = get_terraform_commands_that_need_vars()

    arguments = [
      "-var-file=../common.tfvars",
    ]
  }
}

remote_state {
  backend = "s3"
  

  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
  config = {
    region = "eu-central-1"
    bucket = "testing-reinis-as"
    key  = "terraform/${path_relative_to_include()}"
  }
}
