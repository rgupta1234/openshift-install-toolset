output "public dns" {
  value = "${aws_instance.bastion.public_dns}"
}

output "public address" {
  value = "${aws_instance.bastion.public_ip}"
}

output "private address" {
  value = "${aws_instance.bastion.private_ip}"
}

