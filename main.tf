# AWS Provider
provider "aws" {
  region     = var.aws_region
  access_key = var.access_key
  secret_key = var.secret_key
}

resource "aws_iam_server_certificate" "loadbalancer_cert" {
  name = "LBCert"
  certificate_body = file("certificates/elb.crt")
  private_key = file("certificates/elb.key")
}

resource "aws_key_pair" "mykeys" {
  key_name = "mykeys"
  public_key = file("${var.key_path}")
}

module "network" {
  source = "./modules/network/"
}
module "app" {
  source = "./modules/app/"
  vpc_id = module.network.vpcid
  appserver_subnet_id = module.network.appserver_subnet_id
  primary_public_subnet_id = module.network.primary_public_subnet_id
  secondary_public_subnet_id = module.network.secondary_public_subnet_id
  public_subnet_sg = module.network.public_subnet_sg
  appserver_sg = module.network.appserver_sg
  loadbalancer_cert = aws_iam_server_certificate.loadbalancer_cert.arn
  key_pair = aws_key_pair.mykeys.id
}

module "worker" {
    source = "./modules/worker/"
    workerserver_subnet_id = module.network.workerserver_subnet_id
}

module "aurora" {
    source = "./modules/functional/aurora/"
    vpc_id = module.network.vpcid
    aurora_sg = module.network.aurora_sg
    mysql_user = var.mysql_user
    aurora_cluster_name = var.aurora_cluster_name
    aurora_db_name = var.aurora_db_name
    appserver_subnet_id = module.network.appserver_subnet_id
}

module "memcached" {
    source = "./modules/functional/memcached"
    appserver_subnet_id = module.network.appserver_subnet_id
}

module "redis" {
    source = "./modules/functional/redis"
    
}