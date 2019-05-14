
public function main() {
    
    string[] Swagger_Employees_1_0_0_service = [ "get_56106f70_77d1_44d4_84bd_e8379aed5d49"
                                , "get_9ddeaa18_2031_40ad_971b_7e61a72a0cb3"
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
