# nautible-infra-codebuild

## 概要

AWS CodeBuild / AWS CodePipeline を使用したCI/CD環境構築のためのTerraformプロジェクト。

※ nautible標準のCI/CDはGithubActions/ArgoCDの組み合わせで構築していますが、AWSマネージドサービスを活用したCI/CDを検討する場合は本プロジェクトの構成を参考にしてください。

## 前提条件

nautible-infaのTerraformが実行済みであること。（nautible-infaのTerraformに追加構築します）

## 構成

```
$HOME
├ application
│  ├ demoservice           サンプルアプリケーション
│  └ demoservice-manifest  サンプルアプリケーション用マニフェスト
│
└ terraform
   ├ init                  本Terraformの状態管理
   │ ├ main.tf             本プロジェクト用Terraform状態管理設定（状態管理用S3/ロック用DynamoDB）
   │ └ variables.tf        変数定義
   │
   ├ common                アプリケーション共通のCI/CD設定
   │ ├ iam.tf              CodeBuild,CodePipeline実行用ロール/ポリシー設定
   │ ├ s3.tf               CodeBuild,CodePipline実行結果（および実行ログ）を格納するS3設定
   │ ├ security-group.tf   CodeBuildインスタンスに設定するsecurityグループ
   │ ├ output.tf           commonの処理結果出力（applicationモジュールで利用する）
   │ └ variables.tf        変数定義
   │
   └ application           アプリケーション別に用意するCI/CD設定
     ├ codecommit.tf       サンプルアプリケーション用Gitリポジトリ
     ├ codebuild-ci.tf     ビルド用CodeBuild
     ├ codebuild-cd.tf     デプロイ用CodeBuild
     ├ codepipeline-ci.tf  ビルド用CodePipeline
     ├ codepipeline-cd.tf  デプロイ用CodePipeline
     ├ ecr.tf              アプリケーションのコンテナイメージを格納するECR
     └ variables.tf        変数定義
```

## 構築手順

### terraform

ステート保存用S3/DynamoDBを作成

```
$ cd $NAUTIBLE-INFRA-CODEBUILD/terraform/init
$ terraform init
$ terraform plan
$ terraform apply
```

CodeBuild/CodePipelineを使ったCI/CD環境一式を作成

```
$ cd $NAUTIBLE-INFRA-CODEBUILD/terraform/env/dev
$ terraform init
$ terraform plan
$ terraform apply
```

### EKSのRBACとIAM Roleを紐づける

aws-auth ConfigMap にIAM Roleを追加する

```
$ kubectl edit cm aws-auth -n kube-system

# Please edit the object below. Lines beginning with a '#' will be ignored,
# and an empty file will abort the edit. If an error occurs while saving this file will be
# reopened with the relevant failures.
#
apiVersion: v1
data:
  mapRoles: |
    - groups:
      - system:bootstrappers
      - system:nodes
      rolearn: arn:aws:iam::<アカウントID>:role/nautible-cluster
      username: system:node:{{EC2PrivateDNSName}}
### add start
    - groups:
      - system:masters
      rolearn: arn:aws:iam::<アカウントID>:role/nautible_app_build_role
      username: codebuild
### add end
  mapUsers: |
    []
kind: ConfigMap
metadata:
  creationTimestamp: "2021-05-13T01:01:34Z"
  name: aws-auth
  namespace: kube-system
  resourceVersion: "xxxxxxxx"
  selfLink: /api/v1/namespaces/kube-system/configmaps/aws-auth
  uid: xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx
```

### サンプルアプリケーションの準備

TerraformでCodeCommitにdemo-codebuild,demo-codebuild-manifestのリポジトリを作成しているので、application/demoservice,application/demoservice-manifestの内容をそれぞれリポジトリに登録する。

### サンプルアプリケーションのビルド（CI）

application/demoserviceのソースコードをPushしたら自動でCIが実行される。

また、CIが成功するとdemoservice-manifestにプルリクエストが生成される。

### サンプルアプリケーションのデプロイ（CD）

CI実行後PullRequestをマージするとCDが実行され、Kubernetesにサンプルアプリケーションがデプロイされる。

### 注意事項

本プロジェクトはサンプルのため手順上はmasterブランチにコミットしたらCI/CDが動作するようになっています。実際のプロジェクトでは適宜ブランチを作成の上、マージをトリガーにCI/CDが起動するようにしてください。


