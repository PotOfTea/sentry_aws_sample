data "aws_route53_zone" "base" {
  name = "solohr.co"
}

resource "aws_route53_record" "sentry_p" {
  zone_id = data.aws_route53_zone.base.zone_id
  name    = "sentry"
  type    = "CNAME"
  ttl     = "60"
  records = [aws_elb.ingress.dns_name]
}

resource "aws_route53_zone" "internal" {
  name = "i.${var.cluster_name}"
  
  vpc {
    vpc_id = module.vpc.vpc_id
  }
}

resource "aws_route53_record" "sentry_i" {
  zone_id = aws_route53_zone.internal.zone_id
  name    = "sentry"
  type    = "A"
  ttl     = "60"
  records = [aws_instance.sentry.private_ip]
}

