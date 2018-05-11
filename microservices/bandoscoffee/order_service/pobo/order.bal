import ballerina/io;
import ballerina/math;
import ballerina/time;
import ballerina/system;

//creating a plain old b7a class for the order
public type Order object {
    public {
        string orderId;
        string drinkName;
        string additions;
        float cost;
        boolean locked;
        float timestamp;
    }

    //init the order object
    public new (drinkName, additions) {
        orderId = system:uuid();
        timestamp = <float>time:currentTime().time;
        cost = calculateCost(additions);
    }

    public function calculateCost(string additions) returns (float);
};

//calculating the price for the order
//TODO: need to provide a propler impl based on a price book
public function Order::calculateCost(string additions) returns (float) {
        float price = 0;
        if (<boolean>additions) {
            price = math:randomInRange(10, 15) + 2.50;
        } else {
            price = math:randomInRange(10, 15);
        }

        return price;
}