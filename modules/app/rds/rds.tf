##########################################################
# variable 設定
##########################################################
# 変数
variable "project" {}
variable "env" {}
variable "pr_sub_a_id" {}
variable "pr_sub_c_id" {}
variable "sg_id" {}

######################################################################
# DB Subnet Group設定
######################################################################

# DB用のサブネットグループを構築
resource "aws_db_subnet_group" "db_subgrp" {

  # サブネットグループ名を設定
  name = "${var.project}-db-subgrp-${var.env}"

  # サブネットのIDを設定
  # [vpc.tf]で定義したDB用のサブネットを参照する設定
  subnet_ids = [var.pr_sub_a_id, var.pr_sub_c_id]

  # タグを設定
  tags = {
    Name = "${var.project}-db-subgrp-${var.env}"
  }
}

######################################################################
# RDS Parameter Group設定
######################################################################

# RDSクラスター用のパラメーターグループを構築
resource "aws_db_parameter_group" "db_pmtgrp" {

  # パラメーターグループ名を設定
  name = "db-pmtgrp"

  # DBエンジンの種類とバージョンに応じて設定
  family = "mysql8.0"

  # nameに指定したパラメーターの設定値を決定
  # character_set_serverをutf8に設定
  parameter {
    name  = "character_set_server"
    value = "utf8"
  }

  # nameに指定したパラメーターの設定値を決定
  # character_set_clientをutf8に設定
  parameter {
    name  = "character_set_client"
    value = "utf8"
  }

  # nameに指定したパラメーターの設定値を決定
  # time_zoneをAsia/Tokyoに設定
  parameter {
    name  = "time_zone"
    value = "Asia/Tokyo"

    # 直ぐに変更できるパラメーターは以下の記述で即時適用が可能
    apply_method = "immediate"
  }
}

######################################################################
# RDS Instance 設定
######################################################################

# RDSインスタンスを構築
resource "aws_db_instance" "rds_instance" {

  # RDSインスタンスの識別子を設定
  # count.indexでインスタンスに対応する個別のインデックス番号を付与
  # インスタンス1台目は0、インスタンス2台目は1とcountに応じて増減
  identifier = "${var.project}-rds-instance-${var.env}"

  # インスタンスのクラスを設定
  # db.t2.micr
  instance_class = "db.t2.micro"

  # データベースの変更をすぐに適用するか、次のメンテナンス期間中に適用するかを指定
  # デフォルトはfalse
  apply_immediately = false

  # RDS インスタンスで利用するデータベースのエンジンを設定
  engine = "mysql"

  # aurora-mysqlのバージョンを設定
  engine_version = "8.0.28"

  # ディスク量
  allocated_storage = 20

  # データベース名
  db_name = "db"

  # 管理者ユーザー
  username = "root"

  # パスワード
  password = "Password1"

  # セキュリティグループ
  vpc_security_group_ids = [
    var.sg_id
  ]

  # RDS削除時にスナップショットを作成しないようにする
  skip_final_snapshot = "true"

  # 利用するDBサブネットの名称を設定
  # aws_db_subnet_groupで定義したサブネットグループをインスタンスに設定
  db_subnet_group_name = aws_db_subnet_group.db_subgrp.name

  # aws_db_parameter_groupで定義したパラメーターグループをインスタンスに設定
  parameter_group_name = aws_db_parameter_group.db_pmtgrp.name

  # タグを設定
  tags = {
    Name = "${var.project}-rds-instance-${var.env}"
  }
}

# # RDSクラスターの書き込み用エンドポイントを出力
# output "rds-entpoint" {
#   value = aws_rds_cluster.aurora_clstr.endpoint
# }
# # RDSクラスターの読み込み用エンドポイントを出力
# output "rds-entpoint-ro" {
#   value = aws_rds_cluster.aurora_clstr.reader_endpoint
# }
