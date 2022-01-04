#!/bin/sh -ue

## required tomlq in yq. Try `apt install jq` and `pip3 install yq`
STACK_NAME=$(tomlq -r .default.deploy.parameters.stack_name samconfig.toml)
AWS_REGION=$(tomlq -r .default.deploy.parameters.region samconfig.toml)
export AWS_REGION
export AWS_PAGER=""

stackOutputs=$(aws cloudformation describe-stacks --stack-name "$STACK_NAME" | jq -c ".Stacks[0].Outputs")
export stackOutputs

getStackOutput() {
	query=".[]|select(.OutputKey==\"$1\").OutputValue"
	echo "$stackOutputs" | jq -r "$query"
}

userPoolId=$(getStackOutput 'UserPoolId')
clientId=$(getStackOutput 'ClientId')
helloApi=$(getStackOutput 'HelloApi')

. ./user.sh

# ここがadmin権限がないと動かないのでややインチキ
# 参照: https://docs.aws.amazon.com/ja_jp/cognito/latest/developerguide/amazon-cognito-user-pools-authentication-flow.html#amazon-cognito-user-pools-server-side-authentication-flow
tokens=$(aws cognito-idp admin-initiate-auth \
  --user-pool-id ${userPoolId} \
  --client-id ${clientId} \
  --auth-flow "ADMIN_USER_PASSWORD_AUTH" \
  --auth-parameters USERNAME=${userName},PASSWORD=${password})

idToken=$(echo "$tokens"|jq -r .AuthenticationResult.IdToken)

curl "$helloApi" -H "Authorization:$idToken"
