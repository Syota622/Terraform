##########################################################
# variable 設定
##########################################################
# 変数
variable "project" {}
variable "env" {}
variable "vpc_id" {}

######################################################################
# Public Subnet(第3オクテットが奇数)
######################################################################

# パブリックサブネット：az-a
resource "aws_subnet" "public_a" {

  # サブネットを構築するVPCのIDを設定
  # [vpc.tf]で記述したVPCを変数で指定
  vpc_id = var.vpc_id

  # サブネットが使用するcidrを設定
  # VPCの範囲内でSubnetに割り当てるCIDRを区切る
  cidr_block = "10.0.1.0/24"

  # サブネットを配置するAvailability Zoneを東京リージョン1aに設定
  availability_zone = "ap-northeast-1a"

  # このサブネットで起動したインスタンスにパブリックIPを割り当てる
  map_public_ip_on_launch = true

  # タグを設定
  tags = {
    Name = "${var.project}-pub-a-${var.env}"
  }
}

# パブリックサブネット：az-c
resource "aws_subnet" "public_c" {

  # サブネットを構築するVPCのIDを設定
  # [vpc.tf]で記述したVPCを変数で指定
  vpc_id = var.vpc_id

  # サブネットが使用するcidrを設定
  # VPCの範囲内でSubnetに割り当てるCIDRを区切る
  cidr_block = "10.0.3.0/24"

  # サブネットを配置するAvailability Zoneを東京リージョン1aに設定
  availability_zone = "ap-northeast-1c"

  # このサブネットで起動したインスタンスにパブリックIPを割り当てる
  map_public_ip_on_launch = true

  # タグを設定
  tags = {
    Name = "${var.project}-pub-c-${var.env}"
  }
}

######################################################################
# Private Subnet(第4オクテットが奇数)
######################################################################

# プライベートサブネット：az-a
resource "aws_subnet" "private_a" {

  # サブネットを構築するVPCのIDを設定
  # [vpc.tf]にて記述したVPCを変数で指定
  vpc_id = var.vpc_id

  # サブネットが使用するcidrを設定
  # VPCの範囲内でSubnetに割り当てるCIDRを区切る
  cidr_block = "10.0.2.0/24"

  # サブネットを配置するAvailability Zoneを東京リージョン1aに設定
  availability_zone = "ap-northeast-1a"

  # タグを設定
  tags = {
    Name = "${var.project}-priv-a-${var.env}"
  }
}

# プライベートサブネット：az-c
resource "aws_subnet" "private_c" {

  # サブネットを構築するVPCのIDを設定
  # [vpc.tf]にて記述したVPCを変数で指定
  vpc_id = var.vpc_id

  # サブネットが使用するcidrを設定
  # VPCの範囲内でSubnetに割り当てるCIDRを区切る
  cidr_block = "10.0.4.0/24"

  # サブネットを配置するAvailability Zoneを東京リージョン1aに設定
  availability_zone = "ap-northeast-1c"

  # タグを設定
  tags = {
    Name = "${var.project}-priv-c-${var.env}"
  }
}

######################################################################
# output 設定
######################################################################
output "pb_sub_a_id" {
  value = aws_subnet.public_a.id
}
output "pb_sub_c_id" {
  value = aws_subnet.public_c.id
}
output "pr_sub_a_id" {
  value = aws_subnet.private_a.id
}
output "pr_sub_c_id" {
  value = aws_subnet.private_c.id
}