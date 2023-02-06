##########################################################
# variable 設定
##########################################################
# 変数
variable "project" {}
variable "env" {}
variable "vpc_id" {}

######################################################################
# インターネットゲートウェイ
######################################################################

# VPC インターネットゲートウェイを作成
resource "aws_internet_gateway" "igw" {

  # 作成するVPC IDを設定
  vpc_id = var.vpc_id

  # タグを設定
  tags = {
    Name = "${var.project}-igw-${var.env}"
  }
}

######################################################################
# output 設定
######################################################################
output "igw_id" {
  value = aws_internet_gateway.igw.id
}
