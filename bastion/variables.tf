variable "key_name" {
  description = "AWS Keyname"
  default = "sandoval-aws"
}
variable "ami" {
  description = "ami image"
  default = "ami-03291866"
}

variable "private_key_path" {
  description = "private key path"
  default = "/root/aws/sandoval-aws.pem"
}

variable "rhn_username" {
  description = "RHN username"
  default = "rsandova@redhat.com"
}

variable "rhn_password" {
  description = "RHN password"
}
