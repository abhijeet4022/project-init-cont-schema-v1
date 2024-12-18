#!/bin/bash
git clone "https://github.com/abhijeet4022/${COMPONENT}-v1"
cd "${COMPONENT}-v1/schema"


# Function to retrieve AWS SSM parameters
get_parameter() {
  aws ssm get-parameter  --name $1 --with-decryption | jq .Parameter.Value | sed -e 's/"//g'
}

if [ "$DB_TYPE" == "mysql" ]; then
  mysql -h$(get_parameter shipping.${ENV}.DB_HOST) -u$(get_parameter rds.${ENV}.master_username) -p$(get_parameter rds.${ENV}.master_password) <$COMPONENT.sql
fi

if [ "$DB_TYPE" == "docdb" ]; then
  curl -o rds-combined-ca-bundle.pem https://truststore.pki.rds.amazonaws.com/global/global-bundle.pem
  mongo --ssl --host $(get_parameter docdb.${ENV}.endpoint):27017 --sslCAFile rds-combined-ca-bundle.pem --username $(get_parameter docdb.${ENV}.master_username) --password $(get_parameter docdb.${ENV}.master_password) <${COMPONENT}.js
fi