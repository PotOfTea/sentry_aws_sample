output "sentry_email" {
    value = var.sentry_email
}

output "sentry_password" {
    value = var.sentry_pass
}

output "dns_elb" {
    value = aws_elb.ingress.dns_name
}

output "dns_ec2_sentry_internal" {
    value = aws_route53_record.sentry_i.fqdn
}

output "dns_sentry_public" {
    value = aws_route53_record.sentry_p.fqdn
}