##########################################################
# variable 設定
##########################################################
# 変数
variable "project" {}
variable "vpc_id" {}
variable "pb_sub_a_id" {}
variable "sg_id" {}
variable "ec2_profile_name" {}
variable "env" {}

######################################################################
# Webサーバー設定
######################################################################

# 同ディレクトリ内のweb.sh.tplをTerraformで扱えるようdata化
data "template_file" "web_sehll" {
  template = file("${path.module}/web.sh.tpl")
}

# Webサーバーの構築
resource "aws_instance" "web" {

  # [ami.tf]のamiを参照
  ami = data.aws_ami.amzn2.id

  # インスタンスタイプを設定
  instance_type = "t2.micro"

  # [keypair.tf]の鍵を参照
  key_name = aws_key_pair.auth.id

  # [iam.tf]のプロファイルを参照
  iam_instance_profile = var.ec2_profile_name

  # [vpc_subnet.tf]を参照
  subnet_id = var.pb_sub_a_id

  # [vpc_sg.tf]を参照
  vpc_security_group_ids = [
    var.sg_id
  ]

  # EBSのパラメーターを設定
  root_block_device {

    # ボリュームの種類を指定
    # 今回はgp2を選択。以下が選択可能な値
    # "standard", "gp2", "io1", "sc1", "st1"
    volume_type = "gp2"

    # ボリュームの容量を設定
    # 単位はGiB
    volume_size = 8

    # インスタンス削除時にボリューム併せて削除する設定
    delete_on_termination = true
  }

  # タグを設定
  tags = {
    Name = "${var.project}-instance-${var.env}"
  }

  # 初めにdata化したweb.sh.tplを参照
  # 設定をbase64にencodeして格納
  user_data = base64encode(data.template_file.web_sehll.rendered)
}
