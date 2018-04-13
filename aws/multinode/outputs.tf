output "addresses" {
  value = ["${aws_instance.master.*.public_ip}"]
}
