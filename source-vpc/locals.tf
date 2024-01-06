locals {
  vpc_name                = "onprem-VPC"
  vpc_cidr                = "172.16.0.0/16"
  public_cidr             = "172.16.10.0/24"
  private_cidr            = "172.16.20.0/24"
  webserver_sg_name       = "onprem-ws-SG"
  database_server_sg_name = "onprem-dbs-SG"
  region                  = "eu-central-1"
  project_name            = "CAPCI-Isabelle"
  environment             = "Development"
  challenge               = "migration-rehost"
  ubuntu_ami_name                = "ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"
  ubuntu_ami_owner = "099720109477"
  instance_type_db ="m5.large"
  instance_type_ws ="t3.medium"

  tags = {
    ProjectName = local.project_name
    Environment = local.environment
    Challenge   = local.challenge
  }
}
