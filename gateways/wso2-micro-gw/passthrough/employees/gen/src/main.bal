
public function main() {
    
    string[] Swagger_Employees_1_0_0_service = [ "get_0b11d9db_5403_4c1b_89d3_542386511364"
                                , "get_f72a5ad2_71d6_42ea_b64c_e6715bde1fba"
                                ];
    gateway:populateAnnotationMaps("Swagger_Employees_1_0_0", Swagger_Employees_1_0_0, Swagger_Employees_1_0_0_service);
    

    initThrottlePolicies();

    map<string> receivedRevokedTokenMap = gateway:getRevokedTokenMap();
    boolean jmsListenerStarted = gateway:initiateTokenRevocationJmsListener();

    boolean useDefault = gateway:getConfigBooleanValue(gateway:PERSISTENT_MESSAGE_INSTANCE_ID,
    gateway:PERSISTENT_USE_DEFAULT, false);

    if (useDefault){
        future<()> initETCDRetriveal = start gateway:etcdRevokedTokenRetrieverTask();
    } else {
        initiatePersistentRevokedTokenRetrieval(receivedRevokedTokenMap);
    }
}
