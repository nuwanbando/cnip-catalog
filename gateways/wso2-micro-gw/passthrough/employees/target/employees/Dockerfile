# Auto Generated Dockerfile

FROM ballerina/ballerina-runtime:0.990.4
LABEL maintainer="dev@ballerina.io"

COPY employees.balx /home/ballerina 

COPY micro-gw.conf /home/ballerina/conf/micro-gw.conf

CMD ballerina run  --config /home/ballerina/conf/micro-gw.conf employees.balx
