######################################################################
# module 設定
######################################################################
module "iam_ec2_rds" {
  source  = "./modules/app/iam"
  project = var.project
  env     = var.env
}

module "ec2" {
  source  = "./modules/app/ec2"
  project = var.project
  env     = var.env
  vpc_id = module.vpc.vpc_id
  pb_sub_a_id = module.subnet.pb_sub_a_id
  sg_id = module.sg.sg_pub_a_id
  ec2_profile_name = module.iam_ec2_rds.ec2_profile_name
}

module "rds" {
  source  = "./modules/app/rds"
  project = var.project
  env     = var.env
  pr_sub_a_id = module.subnet.pr_sub_a_id
  pr_sub_c_id = module.subnet.pr_sub_c_id
  sg_id = module.sg.sg_rds_id
}

# module "s3" {
#   source  = "./modules/app/s3"
#   project = var.project
#   env     = var.env
# }
