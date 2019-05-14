
public function main() {
    
    string[] Swagger_Employees_1_0_0_service = [ "get_b38756ce_2873_43e7_bed9_a81e8058d238"
                                , "get_a4549ed0_c410_4ca6_845f_5f16ce288c4d"
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
