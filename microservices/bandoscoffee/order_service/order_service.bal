import ballerina/http;
import ballerina/io;
import pobo;

endpoint http:Listener listener {
    //service will start on port 9090
    port:9090
};

//to hold the oders in memory in a map
//TODO: implement persistence
map<pobo:Order> ordersMap;

@http:ServiceConfig {
    basePath: "/ordersvc"
}
service<http:Service> orderService bind listener {

    //create orders with pending status for fulfilment
    @http:ResourceConfig {
        methods: ["POST"],
        path: "/order"
    }
    createOrder(endpoint client, http:Request req) {
        json orderReq = check req.getJsonPayload();
        
        pobo:Order orderObj = new pobo:Order(orderReq.drinkName.toString(), orderReq.additions.toString());

        ordersMap[orderObj.orderId] = orderObj;

        // Create response message.
        json payload = { status: "Order Created.", orderId: orderObj.orderId };
        http:Response response;
        response.setJsonPayload(payload);

        // Set 201 Created status code in the response message.
        response.statusCode = 201;
        // Set 'Location' header in the response message.
        // This can be used by the client to locate the newly added order.
        response.setHeader("Location", "http://localhost:9090/ordersvc/order/" +
                orderObj.orderId);

        // Send response to the client.
        _ = client->respond(response);
    }

    //returns a spesific order from orderId
    @http:ResourceConfig {
        methods: ["GET"],
        path: "/order/{orderId}"
    }
    getOrder(endpoint client, http:Request req, string orderId) {
        // Find the requested order from the map and retrieve it in JSON format.
        pobo:Order? orderObj = ordersMap[orderId];
        http:Response response;
        json? payload = check <json>orderObj;

        if (payload == null) {
            payload = "Order : " + orderId + " cannot be found.";
        }

        // Set the JSON payload in the outgoing response message.
        response.setJsonPayload(payload);

        // Send response to the client.
        _ = client->respond(response);
    }

    //return all pending orders
    @http:ResourceConfig {
        methods: ["GET"],
        path: "/order/pending"
    }
    getPending(endpoint client, http:Request req, string orderId) {
        json[] orderObjs;
        int c = 0;
        foreach orderObj in ordersMap {
            if(!orderObj.locked){
                orderObjs[c] = check <json>orderObj;
                c++;
            }
            
        }
        if (orderObjs == null) {
            orderObjs[0] = "No pending orders.";
        }

        http:Response response;
        // Set the JSON payload in the outgoing response message.
        response.setJsonPayload(orderObjs);

        // Send response to the client.
        _ = client->respond(response);

    }
}