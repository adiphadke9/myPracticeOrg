public with sharing class OrderTriggerHandler {
    public static void publishEvent(List<Order> neworders){
        List<Order> ordersToPublish = new List<Order>();
        List<OrderStatus__e> ordersEventList = new List<OrderStatus__e>();
        ordersToPublish = [SELECT Id, Name, OrderNumber FROM Order WHERE Id IN :neworders];
        for(Order ord : ordersToPublish){
            OrderStatus__e os = new OrderStatus__e();
            os.Order_Number__c = ord.OrderNumber;
            os.Total_Amount_in_USD__c = 0.00;
            ordersEventList.add(os);
        }
        EventBus.publish(ordersEventList);
    }
}