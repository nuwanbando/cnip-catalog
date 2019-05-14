import ballerina/log;
import ballerina/http;
import ballerina/config;
import ballerina/time;

import ballerinax/kubernetes;

import wso2/gateway;


    http:Client Swagger_Employees_1_0_0_prod = new (
    gateway:retrieveConfig("1b91c434-609a-41dc-be16-9846c0864a07_prod_endpoint_0","http://empdir-nuwanbando.herokuapp.com"),
    config = { 
    httpVersion: gateway:getHttpVersion()
});








    
    
    
    
    
    

    
    
    
    
    
    






@kubernetes:Deployment {
    
    name:"employee-svc",
    image:"nuwanbando/employees:v1",
    copyFiles:[
      
          {
             source:"/Users/nuwanbando/dev/trunk/micro-gw/toolkit/wso2am-micro-gw-toolkit-3.0.0-beta2/resources/conf/micro-gw.conf", 
             target:"/home/ballerina/conf/micro-gw.conf", 
             isBallerinaConf:true 
          }
      
    ]
}






@http:ServiceConfig {
    basePath: "/v2",
    authConfig:{
    
        authProviders:["jwt","oauth2"]
    
    }
}

@gateway:API {
    publisher:"",
    name:"Swagger Employees",
    apiVersion: "1.0.0" 
}
service Swagger_Employees_1_0_0 on apiListener,
apiSecureListener {


    @http:ResourceConfig {
        methods:["GET"],
        path:"/employees",
        authConfig:{
    
        authProviders:["jwt","oauth2"]
      

        }
    }
    @gateway:RateLimit{policy : ""}
    resource function get_6975dc09_3fe8_401d_8731_728d5b289e35 (http:Caller outboundEp, http:Request req) {
        handleExpectHeaderForSwagger_Employees_1_0_0(outboundEp, req);
    
    
    
    string urlPostfix = untaint req.rawPath.replace("/v2","");
    
        http:Response|error clientResponse;
        http:Response r = new;
        clientResponse = r;
        string destination_attribute;
        runtime:getInvocationContext().attributes["timeStampRequestOut"] = time:currentTime().time;
        
        
            
            
                if("PRODUCTION" == <string>runtime:getInvocationContext().attributes["KEY_TYPE"]) {
                    destination_attribute = "http://empdir-nuwanbando.herokuapp.com";
                
                    clientResponse = Swagger_Employees_1_0_0_prod->forward(urlPostfix, req);
                    runtime:getInvocationContext().attributes["destination"] = destination_attribute;
                
                } else {
                    http:Response res = new;
                    res.statusCode = 403;
                    json payload = {
                        ERROR_CODE: "900901",
                        ERROR_MESSAGE: "Sandbox key offered to the API with no sandbox endpoint"
                    };
                    runtime:getInvocationContext().attributes["error_code"] = "900901";
                    res.setPayload(payload);
                    clientResponse = res;
                }
            
        
        
        runtime:getInvocationContext().attributes["timeStampResponseIn"] = time:currentTime().time;


        if(clientResponse is http:Response) {
            
            
            var outboundResult = outboundEp->respond(clientResponse);
            if (outboundResult is error) {
                log:printError("Error when sending response", err = outboundResult);
            }
        }

        else {
            http:Response res = new;
            res.statusCode = 500;
            string errorMessage = clientResponse.reason();
            int errorCode = 101503;
            string errorDescription = "Error connecting to the back end";

            if(errorMessage.contains("connection timed out") || errorMessage.contains("Idle timeout triggered")) {
                errorCode = 101504;
                errorDescription = "Connection timed out";
            }
            if(errorMessage.contains("Malformed URL")) {
                errorCode = 101505;
                errorDescription = "Malformed URL";
            }
            // Todo: error is not type any -> runtime:getInvocationContext().attributes["error_response"] =  clientResponse;
            runtime:getInvocationContext().attributes["error_response_code"] = errorCode;
            json payload = {fault : {
                code : errorCode,
                message : "Runtime Error",
                description : errorDescription
            }};
            res.setPayload(payload);
            log:printError("Error in client response", err = clientResponse);
            var outboundResult = outboundEp->respond(res);
            if (outboundResult is error) {
                log:printError("Error when sending response", err = outboundResult);
            }
        }
    }


    @http:ResourceConfig {
        methods:["GET"],
        path:"/employees/{employeeId}",
        authConfig:{
    
        authProviders:["jwt","oauth2"]
      

        }
    }
    @gateway:RateLimit{policy : ""}
    resource function get_229807ae_046d_4afa_ab9f_8187b8912d8b (http:Caller outboundEp, http:Request req) {
        handleExpectHeaderForSwagger_Employees_1_0_0(outboundEp, req);
    
    
    
    string urlPostfix = untaint req.rawPath.replace("/v2","");
    
        http:Response|error clientResponse;
        http:Response r = new;
        clientResponse = r;
        string destination_attribute;
        runtime:getInvocationContext().attributes["timeStampRequestOut"] = time:currentTime().time;
        
        
            
            
                if("PRODUCTION" == <string>runtime:getInvocationContext().attributes["KEY_TYPE"]) {
                    destination_attribute = "http://empdir-nuwanbando.herokuapp.com";
                
                    clientResponse = Swagger_Employees_1_0_0_prod->forward(urlPostfix, req);
                    runtime:getInvocationContext().attributes["destination"] = destination_attribute;
                
                } else {
                    http:Response res = new;
                    res.statusCode = 403;
                    json payload = {
                        ERROR_CODE: "900901",
                        ERROR_MESSAGE: "Sandbox key offered to the API with no sandbox endpoint"
                    };
                    runtime:getInvocationContext().attributes["error_code"] = "900901";
                    res.setPayload(payload);
                    clientResponse = res;
                }
            
        
        
        runtime:getInvocationContext().attributes["timeStampResponseIn"] = time:currentTime().time;


        if(clientResponse is http:Response) {
            
            
            var outboundResult = outboundEp->respond(clientResponse);
            if (outboundResult is error) {
                log:printError("Error when sending response", err = outboundResult);
            }
        }

        else {
            http:Response res = new;
            res.statusCode = 500;
            string errorMessage = clientResponse.reason();
            int errorCode = 101503;
            string errorDescription = "Error connecting to the back end";

            if(errorMessage.contains("connection timed out") || errorMessage.contains("Idle timeout triggered")) {
                errorCode = 101504;
                errorDescription = "Connection timed out";
            }
            if(errorMessage.contains("Malformed URL")) {
                errorCode = 101505;
                errorDescription = "Malformed URL";
            }
            // Todo: error is not type any -> runtime:getInvocationContext().attributes["error_response"] =  clientResponse;
            runtime:getInvocationContext().attributes["error_response_code"] = errorCode;
            json payload = {fault : {
                code : errorCode,
                message : "Runtime Error",
                description : errorDescription
            }};
            res.setPayload(payload);
            log:printError("Error in client response", err = clientResponse);
            var outboundResult = outboundEp->respond(res);
            if (outboundResult is error) {
                log:printError("Error when sending response", err = outboundResult);
            }
        }
    }

}

    function handleExpectHeaderForSwagger_Employees_1_0_0 (http:Caller outboundEp, http:Request req ) {
        if (req.expects100Continue()) {
            req.removeHeader("Expect");
            var result = outboundEp->continue();
            if (result is error) {
            log:printError("Error while sending 100 continue response", err = result);
            }
        }
    }