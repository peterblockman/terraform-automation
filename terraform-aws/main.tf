# -- root/main.tf --

module "networking" {
  source           = "./networking"
  vpc_cidr         = local.vpc_cidr
  access_ip        = var.access_ip
  security_groups  = local.security_groups
  public_sn_count  = 2
  private_sn_count = 5
  public_cidrs     = [for i in range(2, 225, 2) : cidrsubnet(local.vpc_cidr, 8, i)]
  private_cidrs    = [for i in range(1, 225, 2) : cidrsubnet(local.vpc_cidr, 8, i)]
  max_subnets      = 20
  db_subnet_group  = true
}


module "database" {
  source                 = "./database"
  db_storage             = 10
  engine_version         = "5.7.22"
  instance_class         = "db.t2.micro"
  dbname                 = var.dbname
  dbuser                 = var.dbuser
  dbpassword             = var.dbpassword
  db_identifier          = "peter-db"
  db_subnet_group_name   = module.networking.db_subnet_group_name[0]
  vpc_security_group_ids = module.networking.db_security_group
  skip_final_snapshot    = true
}


module "loadbalancing" {
  source                = "./loadbalancing"
  public_sg             = module.networking.public_sg
  public_subnets        = module.networking.public_subnets
  tg_port               = 8000
  tg_protocol           = "HTTP"
  vpc_id                = module.networking.vpc_id
  lb_healthy_thresold   = 2
  lb_unhealthy_thresold = 2
  lb_timeout            = 3
  lb_interval           = 30
  listerner_port        = 80
  listerner_protocol    = "HTTP"
}


module "compute" {
  source          = "./compute"
  public_sg       = module.networking.public_sg
  public_subnets  = module.networking.public_subnets
  instance_count  = 1
  instance_type   = "t3.micro"
  vol_size        = 10
  key_name        = "peterkey2"
  public_key_path = "/Users/peter/.ssh/id_rsa.pub"
  user_data_path  = "${path.root}/userdata.tpl"
  dbname          = var.dbname
  dbuser          = var.dbuser
  dbpassword      = var.dbpassword
  db_endpoint     = module.database.db_endpoint
}