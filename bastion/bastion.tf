provider "aws" {
  region     = "us-west-2"
}

resource "aws_instance" "bastion" {

  ami           = "ami-223f945a"
  instance_type = "t2.large"
  key_name = "sandoval-aws"
  root_block_device {
    volume_size = "30"
    volume_type = "gp2"
    delete_on_termination = true
  }

  tags {
    Name = "rs-bastion"
  }
 /* 
  provisioner "local-exec" {
    command = ""
  }
*/

} 
data "aws_route53_zone" "selected" {
  name         = "rs.osecloud.com."
}

resource "aws_route53_record" "bastian" {
  zone_id = "${data.aws_route53_zone.selected.zone_id}"
  name    = "bastion.${data.aws_route53_zone.selected.name}"
  type    = "A"
  ttl     = "300"
  records = ["${aws_instance.bastion.public_ip}"]
}

