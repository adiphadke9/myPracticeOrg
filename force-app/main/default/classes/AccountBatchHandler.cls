public with sharing class AccountBatchHandler implements Database.Batchable<SObject>, Database.RaisesPlatformEvents {
    public Database.QueryLocator start(Database.BatchableContext bc){
        return Database.getQueryLocator('Select Id, Name from Account');
    }

    public void execute(Database.BatchableContext bc, List<Account> records){
        Integer i = 100/0;
    }

    public void finish(Database.BatchableContext bc){

    }
}