#!/bin/sh

wget https://wso2.org/jenkins/view/All%20Builds/job/products/job/product-microgateway/lastSuccessfulBuild/artifact/distribution/target/wso2am-micro-gw-toolkit-3.0.0-beta3-SNAPSHOT.zip

unzip -q wso2am-micro-gw-toolkit-3.0.0-beta3-SNAPSHOT.zip

echo `pwd`

export PATH=${PATH}:$(pwd)/wso2am-micro-gw-toolkit-3.0.0-beta3-SNAPSHOT/bin

echo $PATH

micro-gw build employees