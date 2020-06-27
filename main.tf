variable "aws_access_key" {}
variable "aws_secret_key" {}
variable "region" {
  default = "ap-northeast-1"
}

provider "aws" {
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
  region     = var.region
}

resource "aws_lightsail_static_ip" "playground-eip" {
  name = "playground-eip"
}

resource "aws_lightsail_instance" "playground-lightsail" {
  name              = "playground"
  availability_zone = "ap-northeast-1c"
  blueprint_id      = "ubuntu_18_04"
  bundle_id         = "micro_2_0"
  key_pair_name     = "aws_id_rsa"
  provisioner "local-exec" {
    command = "aws lightsail put-instance-public-ports --instance-name=playground --port-infos fromPort=22,toPort=22,protocol=tcp,cidrs=14.8.17.33/32 fromPort=80,toPort=80,protocol=tcp,cidrs=14.8.17.33/32"
  }
}

resource "aws_lightsail_static_ip_attachment" "playground-attachment" {
  static_ip_name = aws_lightsail_static_ip.playground-eip.name
  instance_name  = aws_lightsail_instance.playground-lightsail.name
}
