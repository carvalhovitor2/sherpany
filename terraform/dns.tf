resource "aws_route53_record" "sherpany_cname" {
  zone_id = data.aws_route53_zone.vitorcarvalho.zone_id
  name    = "sherpany.vitorcarvalho.es"
  type    = "CNAME"
  ttl     = "300"
  records = [module.nlb.lb_dns_name]
}
