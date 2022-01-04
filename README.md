# sam-auth-coguserpool

Cognitoのuser poolでLambdaの認証を行うサンプル。

一般的な Amazon Cognito シナリオ
の
[ユーザープールと共に API Gateway と Lambda を使用してリソースにアクセスする](https://docs.aws.amazon.com/ja_jp/cognito/latest/developerguide/cognito-scenarios.html#scenario-api-gateway)
に相当する。


# デプロイ

## リソースのデプロイ

SAMなので
```sh
sam build
sam deploy --guided  # --guidedは最初の1回
```

## ユーザの作成

```sh
cp user_template.sh user.sh
vim user.sh
```
でユーザ名(emailアドレス)とパスワード、名前と苗字を編集する。


```sh
./create_and_conferm_a_user.sh
```
を実行すると、ユーザ名(emailアドレス)に
`Your verification code` という題名の

> Your confirmation code is 123456

のようなメールが届くので、この6桁のコードを

> Check the mailbox and Enter verification code:

のプロンプトのところへコピペしてEnter。これでユーザプールに認証済みのユーザができる。


# テスト

## 失敗するテスト

認証無しでlambdaを呼び出す。

```sh
./call_lambda_without_auth.sh
```


## 認証付きテスト

ID Tokenを使ってlambdaを呼び出す。

```sh
./call_lambda.sh
```


# 削除

```sh
sam delete
```
