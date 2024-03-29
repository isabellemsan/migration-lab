module "vpc" {
  source = "terraform-aws-modules/vpc/aws"
  name = local.vpc_name
  cidr = local.vpc_cidr
  azs             = ["eu-central-1a", "eu-central-1ab", "eu-central-1ac"]
  private_subnets = [local.private_cidr]
  public_subnets  = [local.public_cidr]
  enable_nat_gateway = true
  enable_vpn_gateway = true

}

resource "aws_security_group" "webserver" {
  name        = local.webserver_sg_name
  description = "Security group for webserver"
  vpc_id      = module.vpc.vpc_id
  ingress {
    description = "http connection into the server"
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 80
    protocol    = "tcp"
    to_port     = 80
  }
  ingress {
    description = "http connection into the server"
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 443
    protocol    = "tcp"
    to_port     = 443
  }
  egress {
    description = "egress open"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
resource "aws_security_group" "database_server" {
  name        = local.database_server_sg_name
  description = "security group for database server"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description     = "database connection into the server"
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [aws_security_group.webserver.id]
  }
  egress {
    description = "egress open"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

#EC2 instances

resource "aws_instance" "webserver" {
    ami = data.aws_ami.ubuntu_image.id
    instance_type = local.instance_type_ws
    subnet_id = module.vpc.public_subnets[0]
    vpc_security_group_ids =  [aws_security_group.webserver.id]
    user_data = file("${path.module}/scripts/webserver.sh")
    monitoring = true 
    ebs_optimized = true  

     root_block_device {
    encrypted = true
  }

}

 resource "aws_instance" "database" {
    ami = data.aws_ami.ubuntu_image.id
    instance_type = local.instance_type_db
    subnet_id = module.vpc.private_subnets[0]
    vpc_security_group_ids = [ aws_security_group.database_server ]
    user_data = file("${path.module}/scripts/db_userdata.sh")
    monitoring = true 
    ebs_optimized = true 
} 