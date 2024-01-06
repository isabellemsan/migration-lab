data "aws_ami" "ubuntu_image" {
  most_recent = true
  owners =[local.ubuntu_ami_owner]

  filter {
    name   = "name"
    values = [local.ubuntu_ami_name]
  }
  
}