import ballerina/io;
import ballerina/runtime;
import ballerina/http;
import ballerina/log;
import wso2/gateway;

stream<gateway:IntermediateStream> s50PerMinintermediateStream = new;
stream<gateway:GlobalThrottleStreamDTO> s50PerMinresultStream = new;
stream<gateway:EligibilityStreamDTO> s50PerMineligibilityStream = new;
stream<gateway:RequestStreamDTO> s50PerMinreqCopy= gateway:requestStream;
stream<gateway:GlobalThrottleStreamDTO> s50PerMinglobalThrotCopy = gateway:globalThrottleStream;

function initApplication50PerMinPolicy() {

    forever {
        from s50PerMinreqCopy
        select s50PerMinreqCopy.messageID as messageID, (s50PerMinreqCopy.appTier == "50PerMin") as
        isEligible, s50PerMinreqCopy.appKey as throttleKey, 0 as expiryTimestamp
        => (gateway:EligibilityStreamDTO[] counts) {
        foreach var c in counts{
            s50PerMineligibilityStream.publish(c);
        }
        }

        from s50PerMineligibilityStream
        throttler:timeBatch(60000)
        where s50PerMineligibilityStream.isEligible == true
        select s50PerMineligibilityStream.throttleKey as throttleKey, count() as eventCount, true as
        stopOnQuota, expiryTimeStamp
        group by s50PerMineligibilityStream.throttleKey
        => (gateway:IntermediateStream[] counts) {
        foreach var c in counts{
            s50PerMinintermediateStream.publish(c);
        }
        }

        from s50PerMinintermediateStream
        select s50PerMinintermediateStream.throttleKey, s50PerMinintermediateStream.eventCount>= 50 as isThrottled,
        s50PerMinintermediateStream.stopOnQuota, s50PerMinintermediateStream.expiryTimeStamp
        group by s50PerMineligibilityStream.throttleKey
        => (gateway:GlobalThrottleStreamDTO[] counts) {
        foreach var c in counts{
            s50PerMinresultStream.publish(c);
        }
        }

        from s50PerMinresultStream
        throttler:emitOnStateChange(s50PerMinresultStream.throttleKey, s50PerMinresultStream.isThrottled)
        select s50PerMinresultStream.throttleKey as throttleKey, s50PerMinresultStream.isThrottled,
        s50PerMinresultStream.stopOnQuota, s50PerMinresultStream.expiryTimeStamp
        => (gateway:GlobalThrottleStreamDTO[] counts) {
        foreach var c in counts{
            s50PerMinglobalThrotCopy.publish(c);
        }
        }
    }
}

