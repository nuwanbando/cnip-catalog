#!/bin/sh

wget https://github.com/wso2/product-microgateway/releases/download/v3.0.0-beta2/wso2am-micro-gw-toolkit-3.0.0-beta2.zip

unzip -q wso2am-micro-gw-toolkit-3.0.0-beta2.zip

echo `pwd`

export MGW_HOME=$(pwd)/wso2am-micro-gw-toolkit-3.0.0-beta2

export PATH=${PATH}:${MGW_HOME}/bin

echo $PATH

micro-gw --help

#micro-gw build employees

micro-gw init emp

cp employees/api_definitions/employees.yaml emp/api_definitions/

micro-gw build emp

tail -n 1000 ${MGW_HOME}/logs/microgw.log

docker images