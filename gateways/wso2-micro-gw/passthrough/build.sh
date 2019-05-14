#!/bin/sh

wget https://github.com/wso2/product-microgateway/releases/download/v3.0.0-beta2/wso2am-micro-gw-toolkit-3.0.0-beta2.zip

unzip -q wso2am-micro-gw-toolkit-3.0.0-beta2.zip

export MGW_HOME=$(pwd)/wso2am-micro-gw-toolkit-3.0.0-beta2

export PATH=${PATH}:${MGW_HOME}/bin

echo 'initializing the employees project'

micro-gw init employees

echo 'copying API artifacts'

cp employees-api/api_definitions/employees.yaml employees/api_definitions/
cp employees-api/conf/deployment-config.toml employees/conf/

echo 'building the gateway with employees api'
micro-gw build employees

echo 'Displaying local docker images'
docker images