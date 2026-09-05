trigger OrderTrigger on Order (after insert) {
    //OrderTriggerHandler.publishEvent(Trigger.new);
    if (Trigger.isInsert) {
        if(Trigger.isInsert && !System.isBatch() && !System.isFuture() && !System.isQueueable()){
            OrderTriggerHandler.createFolderInsideBucket(Trigger.new.get(0));
        }
    }
}