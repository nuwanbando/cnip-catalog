
public function main() {
    
    string[] Swagger_Employees_1_0_0_service = [ "get_6975dc09_3fe8_401d_8731_728d5b289e35"
                                , "get_229807ae_046d_4afa_ab9f_8187b8912d8b"
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
