
public function main() {
    
    string[] Swagger_Employees_1_0_0_service = [ "get_9653cee5_6b38_4631_b459_fb5c980eec15"
                                , "get_6c66f63d_480b_481c_aa44_0349c8b1c649"
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
