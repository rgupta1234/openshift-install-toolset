data "aws_route53_zone" "selected" {
  name         = "rs.osecloud.com."
}

resource "aws_route53_record" "master" {
  count = "${var.master["count"]}"
  zone_id = "${data.aws_route53_zone.selected.zone_id}"
  name    = "devday.${data.aws_route53_zone.selected.name}"
  type    = "A"
  ttl     = "300"
  records = ["${aws_instance.master.*.public_ip[count.index]}"]
}

resource "aws_route53_record" "apps" {
  count = "${var.master["count"]}"
  zone_id = "${data.aws_route53_zone.selected.zone_id}"
  name    = "*.apps.${data.aws_route53_zone.selected.name}"
  type    = "A"
  ttl     = "300"
  records = ["${aws_instance.master.*.public_ip[count.index]}"]
}

