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

    public static void createFolderInsideBucket(Order order){
        List<Account> accList = [SELECT Id, Name,SyncwithS3__c,S3BucketName__c
        FROM Account
        WHERE Id = :order.AccountId Limit 1
        ];
        if (accList?.size()>0 && accList.get(0).SyncwithS3__c && String.isNotBlank(accList.get(0).S3BucketName__c)) {
            createFolderInsideBucket(accList.get(0).S3BucketName__c,'orders',order.OrderNumber.toLowerCase());
        }
    }

    @future(callout=true)
    public static void createFolderInsideBucket(String bucketPath, String folderPath, String folderName){
        AWSS3Manager.createFolderInsideBucketFolder(bucketPath, folderPath,folderName);
    }
}