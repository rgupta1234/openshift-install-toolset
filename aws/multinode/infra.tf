resource "aws_instance" "infras" {
  count = "${var.infra["count"]}"
  ami           = "ami-0b1e356e"
  instance_type = "m4.2xlarge"
  key_name = "${var.key_name}"

  root_block_device {
    volume_size = "30"
    volume_type = "gp2"
    delete_on_termination = true
  }

  ebs_block_device {
    device_name = "/dev/sdb"
    volume_size = 50
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
    ]
  }
  connection {
    type     = "ssh"
    user     = "ec2-user"
    private_key = "${file(var.private_key_path)}"
  }

  tags {
    Name = "workshop-infra-${count.index + 1}"
  }
}
