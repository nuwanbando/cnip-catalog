#!/bin/sh

wget https://wso2.org/jenkins/view/All%20Builds/job/products/job/product-microgateway/lastSuccessfulBuild/artifact/distribution/target/wso2am-micro-gw-toolkit-3.0.0-beta3-SNAPSHOT.zip

unzip -q wso2am-micro-gw-toolkit-3.0.0-beta3-SNAPSHOT.zip

echo `pwd`

export MGW_HOME=$(pwd)/wso2am-micro-gw-toolkit-3.0.0-beta3-SNAPSHOT

export PATH=${PATH}:${MGW_HOME}/bin

echo $PATH

micro-gw --help

micro-gw build employees

tail -n 1000 ${MGW_HOME}/logs/microgw.log