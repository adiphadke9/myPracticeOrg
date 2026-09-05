public with sharing class AccountTriggerHandler {
    public static void createBucket(List<Account> newRecords){
        for (Account acc : newRecords) {
            createBucket(acc.Name, acc.Id, 'eu-north-1');  
        }
    }

    @future(callout=true)
    public static void createBucket(String bucketName,String recordId,String region){
        AWSS3Manager.createBucket(bucketName, recordId, region);
    }
}