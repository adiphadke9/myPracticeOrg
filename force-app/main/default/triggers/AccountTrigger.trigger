trigger AccountTrigger on Account (after insert, after update) {
    if (Trigger.isAfter) {
        if(Trigger.isInsert && !System.isBatch() && !System.isFuture() && !System.isQueueable()){
            Account acc = Trigger.new.get(0);
            if (acc.SyncwithS3__c == true && String.isBlank(acc.S3BucketName__c)) {
                AccountTriggerHandler.createBucket(new List<Account>{acc}); 
            }
        }
        if(Trigger.isUpdate && !System.isBatch() && !System.isFuture() && !System.isQueueable()){
            Account acc = Trigger.new.get(0);
            Account oldRecord = Trigger.oldMap.get(acc.Id);
            if (acc.SyncwithS3__c!=oldRecord.SyncwithS3__c && acc.SyncwithS3__c == true && String.isBlank(acc.S3BucketName__c)) {
               AccountTriggerHandler.createBucket(new List<Account>{acc}); 
            }
        }
    }
    /*if (Trigger.isBefore && Trigger.isInsert) {
        AccountTriggerHandler.CreateAccounts(Trigger.New);
    }*/
    
    /*for(Account acc:Trigger.new){
        AccountCalloutService.getAccountRatingFromAPI(acc.Id);
    }*/
    
    /*if(Trigger.isUpdate){
        if(Trigger.isAfter){
            Map<id,Account> accMap = new Map<id,Account>();
            for(account acc:trigger.new){
                if(acc.BillingState != trigger.oldMap.get(acc.Id).BillingState){
                    accMap.put(acc.Id,acc);
                }
            }
            
            List<contact> conToUpdate = new List<contact>();
            for(contact con : [select id, title, accountId from Contact where accountId IN:accMap.keySet()]){
                con.Account_State__c = accMap.get(con.accountId).BillingState;
                conToUpdate.add(con);
            }
            if(conToUpdate.size()>0) update conToUpdate;
        }
    }*/
}