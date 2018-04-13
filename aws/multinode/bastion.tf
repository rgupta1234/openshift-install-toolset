resource "aws_instance" "bastion" {

  ami           = "${var.ami}"
  instance_type = "t2.large"
  key_name 	= "${var.key_name}"
  security_groups  = ["sandoval-sg"]

  root_block_device {
    volume_size = "30"
    volume_type = "gp2"
    delete_on_termination = true
  }

  provisioner "remote-exec" {
    inline = [
      "sudo /usr/sbin/subscription-manager register --username ${var.rhn_username} --password ${var.rhn_password}",
      "sudo /usr/sbin/subscription-manager attach --pool=${var.rhn_pool}",
      "sudo /usr/sbin/subscription-manager repos --disable=\"*\"",
      "sudo /usr/sbin/subscription-manager repos --enable=\"rhel-7-server-rpms\" --enable=\"rhel-7-server-extras-rpms\" --enable=\"rhel-7-server-ose-3.9-rpms\" --enable=\"rhel-7-fast-datapath-rpms\" --enable=\"rhel-7-server-ansible-2.4-rpms\"",
      "sudo /usr/bin/yum install -y wget git net-tools bind-utils iptables-services bridge-utils bash-completion kexec-tools sos psacct atomic-openshift-utils",
      "git clone git@github.com:robertsandoval/openshift-install-toolset.git"
    ]
  }
  connection {
    type     = "ssh"
    user     = "ec2-user"
    private_key = "${file(var.private_key_path)}"
  }

  provisioner "local-exec" {
    command = "scp -i ${file(var.private_key_path)} ec2-user@${aws_instance.bastion.private_ip}:~""
  }
  tags {
    Name = "rs-bastion"
  }


} 



/*
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
*/
