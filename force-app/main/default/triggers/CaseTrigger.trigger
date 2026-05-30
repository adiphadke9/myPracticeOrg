trigger CaseTrigger on Case (after insert) {
    CaseTriggerHandler.handleAfterInsert(Trigger.new);
}