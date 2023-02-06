####################################################
# tfstateファイルの管理
####################################################

# S3
# backendの設定
terraform {
  backend "s3" {
    bucket  = "tfs-s3-backend-terraform" # 作成したS3バケット
    region  = "ap-northeast-1"
    key     = "terraform.tfstate"
    encrypt = true
    # dynamodb_table = "terraform_and_rails_state_lock"
  }
}

# DynamoDB
# resource "aws_dynamodb_table" "terraform_and_rails_state_lock" {
#   name         = "${var.project}_dynamodb_backend_terraform_${var.env}"
#   billing_mode = "PAY_PER_REQUEST"
#   hash_key     = "LockID" # 値はLockIDである必要がある
#   attribute {
#     name = "LockID" # 値はLockIDである必要がある
#     type = "S"
#   }
#   tags = {
#     Terraform = "true"
#     Name      = "terraform"
#   }
# }
