#!/bin/sh

wget https://github.com/wso2/product-microgateway/releases/download/v3.0.0-beta2/wso2am-micro-gw-toolkit-3.0.0-beta2.zip

unzip -q wso2am-micro-gw-toolkit-3.0.0-beta2.zip

echo `pwd`

export MGW_HOME=$(pwd)/wso2am-micro-gw-toolkit-3.0.0-beta2

export PATH=${PATH}:${MGW_HOME}/bin

echo $PATH

micro-gw --help


micro-gw init employees

cp employees-api/api_definitions/employees.yaml employees/api_definitions/
cp employees-api/conf/deployment-config.toml employees/conf/

micro-gw build employees

tail -n 1000 ${MGW_HOME}/logs/microgw.log

docker images