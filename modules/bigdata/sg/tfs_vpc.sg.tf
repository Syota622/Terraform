##########################################################
# variable 設定
##########################################################
# 変数
variable "project" {}
variable "env" {}
variable "vpc_id" {}

######################################################################
# Glue Connectionに付与するセキュリティグループ（フルアクセス設定）
######################################################################

# Glue Connectionで設定するSGの構築
resource "aws_security_group" "glue_pri_a" {

  # セキュリティグループ名を設定
  name = "${var.project}-sg-glue-pri-a-${var.env}"

  # セキュリティグループを構築するVPCのIDを設定
  vpc_id = var.vpc_id

  # タグを設定
  tags = {
    Name = "${var.project}-sg-glue-pri-a-${var.env}"
  }
}

# アウトバウンド：フルアクセス
resource "aws_security_group_rule" "egress_glue_pri_a" {

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
  security_group_id = aws_security_group.glue_pri_a.id
}

# インバウンド：フルアクセス
resource "aws_security_group_rule" "ingress_glue_pri_a_22" {

  # このリソースが通信を受け入れる設定であることを定義
  # ingressを設定
  type = "ingress"

  # ポートの範囲設定
  # 全てのトラフィックを許可する場合いずれも0で設定
  from_port = 0
  to_port   = 0

  # プロトコルはtcpを設定
  protocol = "-1"

  # 許可するIPの範囲を設定
  # 自身のグローバルIPを記入してください
  cidr_blocks = ["0.0.0.0/0"]

  # このルールを付与するセキュリティグループを設定
  security_group_id = aws_security_group.glue_pri_a.id
}
