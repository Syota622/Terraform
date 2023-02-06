##########################################################
# variable 設定
##########################################################
# 変数
variable "project" {}
variable "env" {}

######################################################################
# EC2用iam_roleの定義
######################################################################

# instance_profileが参照するIAMを作成
resource "aws_iam_role" "ec2_role" {

  # AWS上での名称を入力
  name = "${var.project}-ec2-role-${var.env}"

  # IAMロールのディレクトリ分けのような機能
  # 本書では厳密に管理する必要がないためデフォルトの/を利用
  path = "/"

  # EC2が他のリソースへ一時的にアクセスするassume_role_policyを設定
  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": "sts:AssumeRole",
            "Principal": {
               "Service": "ec2.amazonaws.com"
            },
            "Effect": "Allow",
            "Sid": ""
        }
    ]
}
EOF
}

######################################################################
# 用意したiam_roleとEC2のinstance_profileを紐付け
######################################################################

# aws_iam_instance_profileが参照するiam_roleを選択
resource "aws_iam_instance_profile" "ec2_profile" {

  # AWS上での名称を入力
  name = "${var.project}-ec2-profile-${var.env}"

  # aws_iam_roleで作成したIAM Roleを参照
  role = aws_iam_role.ec2_role.name
}

######################################################################
# EC2用iam_roleにフルアクセス権限を許可
######################################################################

# EC2の利用するロールにS3を操作する設定を付与
resource "aws_iam_role_policy_attachment" "ec2_s3_fullaccess" {

  # ポリシーを追加するロールを指定
  # 3章で作成したロール
  role = aws_iam_role.ec2_role.name

  # AWSの用意しているポリシーを利用
  # S3に対する全ての操作が可能
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

######################################################################
# RDS用iam_roleにふるアクセス権限を許可
######################################################################

resource "aws_iam_role" "rds_monitoring_role" {
  name               = "${var.project}-rds-monitoring-role-${var.env}"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "monitoring.rds.amazonaws.com"
      },
      "Effect": "Allow"
    }
  ]
}
EOF

  tags = {
    Name = "${var.project}-rds-monitoring-role-${var.env}"
  }
}

# aws_iam_policy_attachment
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy_attachment
resource "aws_iam_policy_attachment" "rds_monitoring_policy" {
  name       = "${var.project}_rds_monitoring_policy_${var.env}"
  roles      = [aws_iam_role.rds_monitoring_role.name] # list
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonRDSEnhancedMonitoringRole"
}

######################################################################
# output 設定
######################################################################
output "ec2_profile_name" {
  value = aws_iam_instance_profile.ec2_profile.name
}