import ballerina/io;
import ballerina/runtime;
import ballerina/http;
import ballerina/log;
import wso2/gateway;

stream<gateway:IntermediateStream> s20kPerMinintermediateStream = new;
stream<gateway:GlobalThrottleStreamDTO> s20kPerMinresultStream = new;
stream<gateway:EligibilityStreamDTO> s20kPerMineligibilityStream = new;
stream<gateway:RequestStreamDTO> s20kPerMinreqCopy= gateway:requestStream;
stream<gateway:GlobalThrottleStreamDTO> s20kPerMinglobalThrotCopy = gateway:globalThrottleStream;

function initResource20kPerMinPolicy() {

    forever {
        from s20kPerMinreqCopy
        select s20kPerMinreqCopy.messageID as messageID, (s20kPerMinreqCopy.resourceTier == "20kPerMin") as
        isEligible, s20kPerMinreqCopy.resourceKey as throttleKey, 0 as expiryTimestamp
        => (gateway:EligibilityStreamDTO[] counts) {
        foreach var c in counts{
            s20kPerMineligibilityStream.publish(c);
        }
        }

        from s20kPerMineligibilityStream
        throttler:timeBatch(60000)
        where s20kPerMineligibilityStream.isEligible == true
        select s20kPerMineligibilityStream.throttleKey as throttleKey, count() as eventCount, true as
        stopOnQuota, expiryTimeStamp
        group by s20kPerMineligibilityStream.throttleKey
        => (gateway:IntermediateStream[] counts) {
        foreach var c in counts{
            s20kPerMinintermediateStream.publish(c);
        }
        }

        from s20kPerMinintermediateStream
        select s20kPerMinintermediateStream.throttleKey, s20kPerMinintermediateStream.eventCount>= 20000 as isThrottled,
        s20kPerMinintermediateStream.stopOnQuota, s20kPerMinintermediateStream.expiryTimeStamp
        group by s20kPerMineligibilityStream.throttleKey
        => (gateway:GlobalThrottleStreamDTO[] counts) {
        foreach var c in counts{
            s20kPerMinresultStream.publish(c);
        }
        }

        from s20kPerMinresultStream
        throttler:emitOnStateChange(s20kPerMinresultStream.throttleKey, s20kPerMinresultStream.isThrottled)
        select s20kPerMinresultStream.throttleKey as throttleKey, s20kPerMinresultStream.isThrottled,
        s20kPerMinresultStream.stopOnQuota, s20kPerMinresultStream.expiryTimeStamp
        => (gateway:GlobalThrottleStreamDTO[] counts) {
        foreach var c in counts{
            s20kPerMinglobalThrotCopy.publish(c);
        }
        }
    }
}

