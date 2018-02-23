variable "mastercount" {
  description = "This is the number of master nodes to create"
}
variable "infracount" {
  description = "This is the number of infrastructure nodes to create"
}
variable "nodecount" {
  description =  "This is the number of compute nodes to create"
}
variable "create_nfs" {
  description = "If true create an NFS server"
}

provider "aws" {
  region     = "us-east-2"
}


resource "aws_instance" "nfs" {
  count = "${var.create_nfs}"
  ami           = "ami-0b1e356e"
  instance_type = "m4.large"
  key_name = "sandoval-aws"

  ebs_block_device {
    device_name = "/dev/sdb"
    volume_size = 250
    volume_type = "gp2"
    delete_on_termination = true
  }

  tags {
    Name = "workshop-nfs"
  }
}

resource "aws_instance" "masters" {
  count = "${var.mastercount}"
  ami           = "ami-0b1e356e"
  instance_type = "m4.xlarge"
  key_name = "sandoval-aws"

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

  tags {
    Name = "workshop-master-${count.index + 1}"
  }
}

resource "aws_instance" "infras" {
  count = "${var.infracount}"
  ami           = "ami-0b1e356e"
  instance_type = "m4.2xlarge"
  key_name = "sandoval-aws"
 
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

  tags {
    Name = "workshop-infra-${count.index + 1}"
  }
}

resource "aws_instance" "nodes" {
  count = "${var.nodecount}"
  ami           = "ami-0b1e356e"
  instance_type = "m4.2xlarge"
  key_name = "sandoval-aws"
 
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

  tags {
    Name = "workshop-node-${count.index + 1 }"
  }
}

data "aws_route53_zone" "selected" {
  name         = "workshop.osecloud.com."
}


resource "aws_route53_record" "master" {
  count = "${var.mastercount}"
  zone_id = "${data.aws_route53_zone.selected.zone_id}"
  name    = "devday.${data.aws_route53_zone.selected.name}"
  type    = "A"
  ttl     = "300"
  records = ["${aws_instance.masters.*.public_ip[count.index]}"]
}

resource "aws_route53_record" "apps" {
  count = "${var.mastercount}"
  zone_id = "${data.aws_route53_zone.selected.zone_id}"
  name    = "*.apps.${data.aws_route53_zone.selected.name}"
  type    = "A"
  ttl     = "300"
  records = ["${aws_instance.masters.*.public_ip[count.index]}"]
}

output "addresses" {
  value = ["${aws_instance.masters.*.public_ip}"]
}
