##########################################################
# variable 設定
##########################################################
# 変数
variable "project" {}
variable "env" {}

######################################################################
# S3 バケット
######################################################################

# データレイク用S3
resource "aws_s3_bucket" "data_lake_s3" {
  
  bucket = "${var.project}-data-lake-${var.env}"

  tags = {
    Name        = "${var.project}-data-lake-${var.env}"
  }
}

# データウェアハウス用S3
resource "aws_s3_bucket" "data_warehouse_s3" {
  
  bucket = "${var.project}-data-warehouse-${var.env}"

  tags = {
    Name        = "${var.project}-data-warehouse-${var.env}"
  }
}

# データマート用S3
resource "aws_s3_bucket" "data_mart_s3" {
  
  bucket = "${var.project}-data-mart-${var.env}"

  tags = {
    Name        = "${var.project}-data-mart-${var.env}"
  }
}

# Athena用
resource "aws_s3_bucket" "athena_log_s3" {
  
  bucket = "${var.project}-athena-log-${var.env}"

  tags = {
    Name        = "${var.project}-athena-log-${var.env}"
  }
}

# ループについて
# https://zenn.dev/wim/articles/terraform_loop

# 暗号化の設定（i：インデックス、id：S3バケット名）
resource "aws_s3_bucket_server_side_encryption_configuration" "s3_encryption" {
  for_each = {
    for i, id in [
      aws_s3_bucket.data_lake_s3.id,
      aws_s3_bucket.data_warehouse_s3.id,
      aws_s3_bucket.data_mart_s3.id,
      aws_s3_bucket.athena_log_s3.id
    ] : i => id
  }

  bucket = each.value

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = "aws/s3"
      sse_algorithm     = "aws:kms"
    }
  }
}

# ブロックパブリックアクセスブロックの設定
resource "aws_s3_bucket_public_access_block" "this" {
  for_each = {
    for i, id in [
      aws_s3_bucket.data_lake_s3.id,
      aws_s3_bucket.data_warehouse_s3.id,
      aws_s3_bucket.data_mart_s3.id,
      aws_s3_bucket.athena_log_s3.id
    ] : i => id
  }

  bucket = each.value

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_acl" "this" {
  for_each = {
    for i, id in [
      aws_s3_bucket.data_lake_s3.id,
      aws_s3_bucket.data_warehouse_s3.id,
      aws_s3_bucket.data_mart_s3.id,
      aws_s3_bucket.athena_log_s3.id
    ] : i => id
  }

  bucket = each.value

  acl    = "private"
}