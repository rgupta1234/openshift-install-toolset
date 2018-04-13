


provider "aws" {
  region     = "us-west-2"
}

resource "aws_instance" "testserver" {

  ami           = "ami-0b1e356e"
  instance_type = "t1.micro"
  key_name = "${var.key_name}"

  tags {
    Name = "rs-testbox"
  }
}
