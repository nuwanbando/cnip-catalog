import ballerina/io;
import ballerina/runtime;
import ballerina/http;
import ballerina/log;
import wso2/gateway;

stream<gateway:IntermediateStream> s10kPerMinintermediateStream = new;
stream<gateway:GlobalThrottleStreamDTO> s10kPerMinresultStream = new;
stream<gateway:EligibilityStreamDTO> s10kPerMineligibilityStream = new;
stream<gateway:RequestStreamDTO> s10kPerMinreqCopy= gateway:requestStream;
stream<gateway:GlobalThrottleStreamDTO> s10kPerMinglobalThrotCopy = gateway:globalThrottleStream;

function initResource10kPerMinPolicy() {

    forever {
        from s10kPerMinreqCopy
        select s10kPerMinreqCopy.messageID as messageID, (s10kPerMinreqCopy.resourceTier == "10kPerMin") as
        isEligible, s10kPerMinreqCopy.resourceKey as throttleKey, 0 as expiryTimestamp
        => (gateway:EligibilityStreamDTO[] counts) {
        foreach var c in counts{
            s10kPerMineligibilityStream.publish(c);
        }
        }

        from s10kPerMineligibilityStream
        throttler:timeBatch(60000)
        where s10kPerMineligibilityStream.isEligible == true
        select s10kPerMineligibilityStream.throttleKey as throttleKey, count() as eventCount, true as
        stopOnQuota, expiryTimeStamp
        group by s10kPerMineligibilityStream.throttleKey
        => (gateway:IntermediateStream[] counts) {
        foreach var c in counts{
            s10kPerMinintermediateStream.publish(c);
        }
        }

        from s10kPerMinintermediateStream
        select s10kPerMinintermediateStream.throttleKey, s10kPerMinintermediateStream.eventCount>= 10000 as isThrottled,
        s10kPerMinintermediateStream.stopOnQuota, s10kPerMinintermediateStream.expiryTimeStamp
        group by s10kPerMineligibilityStream.throttleKey
        => (gateway:GlobalThrottleStreamDTO[] counts) {
        foreach var c in counts{
            s10kPerMinresultStream.publish(c);
        }
        }

        from s10kPerMinresultStream
        throttler:emitOnStateChange(s10kPerMinresultStream.throttleKey, s10kPerMinresultStream.isThrottled)
        select s10kPerMinresultStream.throttleKey as throttleKey, s10kPerMinresultStream.isThrottled,
        s10kPerMinresultStream.stopOnQuota, s10kPerMinresultStream.expiryTimeStamp
        => (gateway:GlobalThrottleStreamDTO[] counts) {
        foreach var c in counts{
            s10kPerMinglobalThrotCopy.publish(c);
        }
        }
    }
}

