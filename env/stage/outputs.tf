output "sentry_email" {
    value = var.sentry_email
}

output "sentry_password" {
    value = var.sentry_pass
}

output "dns_elb" {
    value = module.sentry.dns_elb
}

output "dns_sentry_public" {
    value = module.sentry.dns_sentry_public
}


output "dns_ec2_sentry_internal" {
    value = module.sentry.dns_ec2_sentry_internal
}