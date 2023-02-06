## Terraform コマンド

### tfenv list
インストールされたterraform

### tfenv-remote
インストールできるterraform

### tfenv use ${バージョン指定}
指定したバージョンへの切り替え

### terraform plan
リソース作成前の確認コマンド

### terraform plan　〜destroy
リソース削除前の確認コマンド

### terraform plan -target=aws_vpc.vpc
「-target」オプションでリソース名を指定。

### terraform apply
実行コマンド

### terraform apply -target=aws_vpc.vpc
「-target」オプションでリソース名を指定。

### terraform state list
構築したファイルの一覧を表示

### terraform state show aws_vpc.vpc
リソース名を指定して、AWSリソースの設定値を出力
