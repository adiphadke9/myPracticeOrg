public with sharing class AccountController {
  @AuraEnabled(cacheable=true)
    public static List<Account> getAllActiveAccounts() {
      List<Account> accList = [SELECT Id,Name,Active__c, Phone, Type, Industry, CreatedDate FROM Account ORDER BY CreatedDate DESC LIMIT 10];

      if (!accList.isEmpty() && accList!=null) {
        return accList;
      }else {
        {return null;}
      }
    }

    @AuraEnabled
    public static void updateAccount(String recordId){
      try {
        Account accRecord = new Account(Id = recordId);
        accRecord.Industry = 'Education';
        update accRecord;
      } catch (Exception e) {
        throw new AuraHandledException(e.getMessage());
      }
    }
  }