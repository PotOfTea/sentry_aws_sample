module "sentry" {
  source       = "../modules/sentry"
  env          = var.env
  cidr_block   = var.cidr_block
  cluster_name = var.cluster_name
  aws_key_name = var.aws_key_name
  sentry_pass  = var.sentry_pass
  sentry_email = var.sentry_email
}