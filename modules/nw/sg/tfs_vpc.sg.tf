##########################################################
# variable 設定
##########################################################
# 変数
variable "project" {}
variable "env" {}
variable "vpc_id" {}

######################################################################
# Webサーバーが端末のグローバルIPからSSH/SFTPとHTTPを受け入れるSG設定（EC2）
######################################################################

# WebサーバーがSSHとHTTPを受け付けるSGの構築
resource "aws_security_group" "pub_a" {

  # セキュリティグループ名を設定
  name = "${var.project}-sg_pub_a-${var.env}"

  # セキュリティグループを構築するVPCのIDを設定
  vpc_id = var.vpc_id

  # タグを設定
  tags = {
    Name = "${var.project}-sg-pub-a-${var.env}"
  }
}

# アウトバウンド：フルアクセス
resource "aws_security_group_rule" "egress_pub_a" {

  # このリソースが通信を受け入れる設定であることを定義
  # egressを設定
  type = "egress"

  # ポートの範囲設定
  # 全てのトラフィックを許可する場合いずれも0で設定
  from_port = 0
  to_port   = 0

  # プロトコル設定
  # 以下は全てのIPv4トラフィックを許容する設定
  protocol = "-1"

  # 許可するIPの範囲を設定
  # 以下は全てのIPv4トラフィックを許容する設定
  cidr_blocks = ["0.0.0.0/0"]

  # このルールを付与するセキュリティグループを設定
  security_group_id = aws_security_group.pub_a.id
}

# インバウンド：SSH/SFTPを受け入れる設定
resource "aws_security_group_rule" "ingress_pub_a_22" {

  # このリソースが通信を受け入れる設定であることを定義
  # ingressを設定
  type = "ingress"

  # ポートの範囲設定
  from_port = "22"
  to_port   = "22"

  # プロトコルはtcpを設定
  protocol = "tcp"

  # 許可するIPの範囲を設定
  # 自身のグローバルIPを記入してください
  cidr_blocks = ["0.0.0.0/0"]

  # このルールを付与するセキュリティグループを設定
  security_group_id = aws_security_group.pub_a.id
}

# インバウンド：HTTPを受け入れる設定
resource "aws_security_group_rule" "ingress_pub_a_80" {

  # このリソースが通信を受け入れる設定であることを定義
  # ingressを設定
  type = "ingress"

  # ポートの範囲設定
  from_port = "80"
  to_port   = "80"

  # プロトコルはtcpを設定
  protocol = "tcp"

  # 許可するIPの範囲を設定
  # 自身のグローバルIPを記入してください
  cidr_blocks = ["0.0.0.0/0"]

  # このルールを付与するセキュリティグループを設定
  security_group_id = aws_security_group.pub_a.id
}

######################################################################
# APサーバーがWebサーバーからVPC内部IPを利用しSSHを受け入れるSG設定（Fargate）
######################################################################

# APサーバーがWebサーバーからSSHを受け付けるSGの構築
resource "aws_security_group" "priv_a" {

  # セキュリティグループ名を設定
  name = "${var.project}-sg_priv_a-${var.env}"

  # セキュリティグループを構築するVPCのIDを設定
  vpc_id = var.vpc_id

  # タグを設定
  tags = {
    Name = "${var.project}-sg-priv-a-${var.env}"
  }

}

# 出て行く通信の設定
resource "aws_security_group_rule" "egress_priv_a" {

  # このリソースが通信を受け入れる設定であることを定義
  # egressを設定
  type = "egress"

  # ポートの範囲設定
  # 全てのトラフィックを許可する場合いずれも0で設定
  from_port = 0
  to_port   = 0

  # プロトコル設定
  # 以下は全てのIPv4トラフィックを許容する設定
  protocol = "-1"

  # 許可するIPの範囲を設定
  # 以下は全てのIPv4トラフィックを許容する設定
  cidr_blocks = ["0.0.0.0/0"]

  # このルールを付与するセキュリティグループを設定
  security_group_id = aws_security_group.priv_a.id
}

# SSHを受け入れる設定
resource "aws_security_group_rule" "ingress_priv_a_22" {

  # このリソースが通信を受け入れる設定であることを定義
  # ingressを設定
  type = "ingress"

  # ポートの範囲設定
  from_port = "22"
  to_port   = "22"

  # プロトコルはtcpを設定
  protocol = "tcp"

  # 許可するIPの範囲を設定
  # Webサーバーを配置しているサブネットのCIDRを設定
  cidr_blocks = ["10.0.1.0/24"]

  # このルールを付与するセキュリティグループを設定
  security_group_id = aws_security_group.priv_a.id
}

######################################################################
# RDSがAPサーバーから3306ポートを利用した通信を受け入れるSG設定（RDS）
######################################################################

# RDSがAPサーバーから3306ポートを利用した通信を受け付けるSGの構築
resource "aws_security_group" "rds_sg" {

  # セキュリティグループ名を設定
  name = "${var.project}-rds-sg-${var.env}"

  # セキュリティグループを構築するVPCのIDを設定
  vpc_id = var.vpc_id

  # タグを設定
  tags = {
    Name = "${var.project}-rds-sg-${var.env}"
  }

}

# 出て行く通信の設定
resource "aws_security_group_rule" "egress_rds_sg" {

  # このリソースが通信の出て行く先を設定することを定義
  # egressを設定
  type = "egress"

  # ポートの範囲設定
  # 全てのトラフィックを許可する場合いずれも0で設定
  from_port = 0
  to_port   = 0

  # プロトコル設定
  # 以下は全てのIPv4トラフィックを許容する設定
  protocol = "-1"

  # 許可するIPの範囲を設定
  # 以下は全てのIPv4トラフィックを許容する設定
  cidr_blocks = ["0.0.0.0/0"]

  # このルールを付与するセキュリティグループを設定
  security_group_id = aws_security_group.rds_sg.id
}

# 3306ポートを受け入れる設定
resource "aws_security_group_rule" "ingress_rds_3306" {

  # このリソースが通信を受け入れる設定であることを定義
  # ingressを設定
  type = "ingress"

  # ポートの範囲設定
  # 今回利用するAmazon Aurora MySQLはデフォルトで3306
  # 3306のみ利用するよう、from_portとto_portに記述
  from_port = "3306"
  to_port   = "3306"

  # プロトコルはtcpを設定
  protocol = "tcp"

  # 許可するIPの範囲を設定
  # Webサーバーを配置しているサブネットのCIDRを設定
  cidr_blocks = ["0.0.0.0/0"]

  # このルールを付与するセキュリティグループを設定
  security_group_id = aws_security_group.rds_sg.id
}

######################################################################
# output 設定
######################################################################
output "sg_pub_a_id" {
  value = aws_security_group.pub_a.id
}
output "sg_priv_a_id" {
  value = aws_security_group.priv_a.id
}
output "sg_rds_id" {
  value = aws_security_group.rds_sg.id
}
