#!/bin/sh -ue

## required tomlq in yq. Try `apt install jq` and `pip3 install yq`
STACK_NAME=$(tomlq -r .default.deploy.parameters.stack_name samconfig.toml)
AWS_REGION=$(tomlq -r .default.deploy.parameters.region samconfig.toml)
export AWS_REGION
export AWS_PAGER=""

getStackOutput() {
	query=".Stacks[0].Outputs[]|select(.OutputKey==\"$1\").OutputValue"
	aws cloudformation describe-stacks --stack-name "$STACK_NAME" | jq -r "$query"
}

clientId=$(getStackOutput 'ClientId')

. ./user.sh

aws cognito-idp sign-up \
  --client-id "$clientId" \
  --username "$userName" \
  --password "$password" \
  --user-attributes "$attributes"

echo -n "Check the mailbox and Enter verification code: "
read CONF_CODE

aws cognito-idp confirm-sign-up \
    --client-id "$clientId" \
    --username="$userName" \
    --confirmation-code "$CONF_CODE"
