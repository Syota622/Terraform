##########################################################
# variable 設定
##########################################################
# 変数
variable "project" {}
variable "env" {}
variable "vpc_id" {}
variable "igw_id" {}
variable "pb_sub_a_id" {}
variable "pb_sub_c_id" {}
variable "pr_sub_a_id" {}
variable "pr_sub_c_id" {}

######################################################################
# Public Subnet用Route Table
######################################################################

# パブリックサブネット用のルートテーブルを定義
resource "aws_route_table" "public_a" {

  # ルートテーブルを構築するVPCのIDを設定
  # [vpc.tf]にて記述したVPCを変数で指定
  vpc_id = var.vpc_id

  # 通信経路の設定
  # [vpc_gw.tf]にて記述したインターネットゲートウェイを利用
  # このインターネットゲートウェイを経由する全てのIPv4をルーティング
  route {
    gateway_id = var.igw_id
    cidr_block = "0.0.0.0/0"
  }

  # タグを設定
  tags = {
    Name = "${var.project}-rtb-pub-a-${var.env}"
  }
}

# パブリックサブネット用のルートテーブルを定義
resource "aws_route_table" "public_c" {

  # ルートテーブルを構築するVPCのIDを設定
  # [vpc.tf]にて記述したVPCを変数で指定
  vpc_id = var.vpc_id

  # 通信経路の設定
  # [vpc_gw.tf]にて記述したインターネットゲートウェイを利用
  # このインターネットゲートウェイを経由する全てのIPv4をルーティング
  route {
    gateway_id = var.igw_id
    cidr_block = "0.0.0.0/0"
  }

  # タグを設定
  tags = {
    Name = "${var.project}-rtb-pub-c-${var.env}"
  }
}

# パブリックサブネットとルートテーブルを紐付け
resource "aws_route_table_association" "public_a" {

  # 紐付けたいサブネットのIDを設定
  # [vpc_subnet.tf]にて記述したパブリックサブネットのIDを設定
  subnet_id = var.pb_sub_a_id

  # 用意したルートテーブルのIDを設定
  route_table_id = aws_route_table.public_a.id
}

# パブリックサブネットとルートテーブルを紐付け
resource "aws_route_table_association" "public_c" {

  # 紐付けたいサブネットのIDを設定
  # [vpc_subnet.tf]にて記述したパブリックサブネットのIDを設定
  subnet_id = var.pb_sub_c_id

  # 用意したルートテーブルのIDを設定
  route_table_id = aws_route_table.public_c.id
}

######################################################################
# Private Subnet用Route Table
######################################################################

# プライベートサブネット用のルートテーブルを定義
resource "aws_route_table" "private_a" {

  # ルートテーブルを構築するVPCのIDを設定
  # [vpc.tf]にて記述したVPCを変数で指定
  vpc_id = var.vpc_id

  # タグを設定
  tags = {
    Name = "${var.project}-rtb-priv-a-${var.env}"
  }
}

# プライベートサブネット用のルートテーブルを定義
resource "aws_route_table" "private_c" {

  # ルートテーブルを構築するVPCのIDを設定
  # [vpc.tf]にて記述したVPCを変数で指定
  vpc_id = var.vpc_id

  # タグを設定
  tags = {
    Name = "${var.project}-rtb-priv-c-${var.env}"
  }
}

# プライベートサブネットとルートテーブルを紐付け
resource "aws_route_table_association" "private_a" {

  # 紐付けたいサブネットのIDを設定
  # [vpc_subnet.tf]にて記述したプライベートサブネットのIDを設定
  subnet_id = var.pr_sub_a_id

  # 用意したルートテーブルのIDを設定
  route_table_id = aws_route_table.private_a.id
}

# プライベートサブネットとルートテーブルを紐付け
resource "aws_route_table_association" "private_c" {

  # 紐付けたいサブネットのIDを設定
  # [vpc_subnet.tf]にて記述したプライベートサブネットのIDを設定
  subnet_id = var.pr_sub_c_id

  # 用意したルートテーブルのIDを設定
  route_table_id = aws_route_table.private_c.id
}
