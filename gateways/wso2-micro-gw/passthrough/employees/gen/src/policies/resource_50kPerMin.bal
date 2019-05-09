import ballerina/io;
import ballerina/runtime;
import ballerina/http;
import ballerina/log;
import wso2/gateway;

stream<gateway:IntermediateStream> s50kPerMinintermediateStream = new;
stream<gateway:GlobalThrottleStreamDTO> s50kPerMinresultStream = new;
stream<gateway:EligibilityStreamDTO> s50kPerMineligibilityStream = new;
stream<gateway:RequestStreamDTO> s50kPerMinreqCopy= gateway:requestStream;
stream<gateway:GlobalThrottleStreamDTO> s50kPerMinglobalThrotCopy = gateway:globalThrottleStream;

function initResource50kPerMinPolicy() {

    forever {
        from s50kPerMinreqCopy
        select s50kPerMinreqCopy.messageID as messageID, (s50kPerMinreqCopy.resourceTier == "50kPerMin") as
        isEligible, s50kPerMinreqCopy.resourceKey as throttleKey, 0 as expiryTimestamp
        => (gateway:EligibilityStreamDTO[] counts) {
        foreach var c in counts{
            s50kPerMineligibilityStream.publish(c);
        }
        }

        from s50kPerMineligibilityStream
        throttler:timeBatch(60000)
        where s50kPerMineligibilityStream.isEligible == true
        select s50kPerMineligibilityStream.throttleKey as throttleKey, count() as eventCount, true as
        stopOnQuota, expiryTimeStamp
        group by s50kPerMineligibilityStream.throttleKey
        => (gateway:IntermediateStream[] counts) {
        foreach var c in counts{
            s50kPerMinintermediateStream.publish(c);
        }
        }

        from s50kPerMinintermediateStream
        select s50kPerMinintermediateStream.throttleKey, s50kPerMinintermediateStream.eventCount>= 50000 as isThrottled,
        s50kPerMinintermediateStream.stopOnQuota, s50kPerMinintermediateStream.expiryTimeStamp
        group by s50kPerMineligibilityStream.throttleKey
        => (gateway:GlobalThrottleStreamDTO[] counts) {
        foreach var c in counts{
            s50kPerMinresultStream.publish(c);
        }
        }

        from s50kPerMinresultStream
        throttler:emitOnStateChange(s50kPerMinresultStream.throttleKey, s50kPerMinresultStream.isThrottled)
        select s50kPerMinresultStream.throttleKey as throttleKey, s50kPerMinresultStream.isThrottled,
        s50kPerMinresultStream.stopOnQuota, s50kPerMinresultStream.expiryTimeStamp
        => (gateway:GlobalThrottleStreamDTO[] counts) {
        foreach var c in counts{
            s50kPerMinglobalThrotCopy.publish(c);
        }
        }
    }
}

