# terraform plan -var 'env=prod'
# terraform apply -var 'env=prod' -auto-approve

variable "project" {
  default = "tfs"
}

variable "env" {}

# variable "env" {
#   default = "prod"
# }
