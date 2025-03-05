#!/usr/bin/env bash

function get_aws_id(){
  cf_aws_id_page_id="87884519"
  cf_aws_id_page_url="https://weather.atlassian.net/wiki/spaces/CF/pages/${cf_aws_id_page_id}/AWS+Account+Numbers"
  cf_aws_id_api_url="https://weather.atlassian.net/wiki/rest/api/content/${cf_aws_id_page_id}?expand=body.storage"
  cf_aws_id_page_content=$(curl -s \
    -u "${TWC_EMAIL}:${ATLASSIAN_API_TOKEN}" \
    -H "Accept: application/json" \
    "$cf_aws_id_api_url" \
    | jq -r '.body.storage.value' \
    | pup 'table' \
    |  tr -d '\n' \
    | sed -E 's/<tr[^>]*>/\n/g' \
    | sed -E 's/<td[^>]*>/|/g' \
    | sed -E 's/<[^>]*>//g' \
    | awk -F'|' '{print $3, $2}')

  while read -r id name; do
    if [[ "${id}" != "" && "${name}" != "" ]]; then
      echo "id: $id, name: $name"
    fi
  done <<< "${cf_aws_id_page_content}"
}

policy_principals=$(yq eval '.spec.policy' twc*.yaml | jq -r '
  .Statement[] |
  select(.Principal != null) |
  select(.Principal.AWS != null) |
  .Principal.AWS |
  if type == "array" then .[] else . end')

get_aws_id
exit;
cf_ids=""

while read -r arn; do
  account_id=$(echo $arn | awk -F':' '{print $5}')
#  name=$(echo $arn | awk -F'/' '{print $NF}' | tr -d '"')
#  type=$(echo $arn | awk -F':' '{print $6}' | cut -d'/' -f1 | tr -d '"')
#  echo "name: ${name}"
  echo "arn: $arn"
  echo "account: $account_id"

  if [[ "${type}" == "root" ]]; then
    echo "type: ${Red}${type}${Reset}"
  fi

  # Get account information
  aws organizations describe-account --account-id "${account_id}"

done <<< "${policy_principals}"
