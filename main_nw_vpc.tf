######################################################################
# module 設定
######################################################################
module "vpc" {
  source  = "./modules/nw/vpc"
  project = var.project
  env     = var.env
  cidr    = "10.0.0.0/16"
}

module "subnet" {
  source  = "./modules/nw/subnet"
  project = var.project
  env     = var.env
  vpc_id  = module.vpc.vpc_id
}

module "gw" {
  source  = "./modules/nw/gw"
  project = var.project
  env     = var.env
  vpc_id  = module.vpc.vpc_id
}

module "route" {
  source      = "./modules/nw/route"
  project     = var.project
  env         = var.env
  vpc_id      = module.vpc.vpc_id
  igw_id      = module.gw.igw_id
  pb_sub_a_id = module.subnet.pb_sub_a_id
  pb_sub_c_id = module.subnet.pb_sub_c_id
  pr_sub_a_id = module.subnet.pr_sub_a_id
  pr_sub_c_id = module.subnet.pr_sub_c_id
}

module "sg" {
  source  = "./modules/nw/sg"
  project = var.project
  env     = var.env
  vpc_id  = module.vpc.vpc_id
}
