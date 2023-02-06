######################################################################
# module 設定
######################################################################
module "s3" {
  source  = "./modules/bigdata/s3"
  project = var.project
  env     = var.env
}

module "sg_bigdate" {
  source  = "./modules/bigdata/sg"
  project = var.project
  env     = var.env
  vpc_id  = module.vpc.vpc_id
}
