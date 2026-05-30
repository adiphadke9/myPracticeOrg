trigger AccountTrigger on Account (before insert, before update, before delete, after insert, after update, after delete,  after undelete) {
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