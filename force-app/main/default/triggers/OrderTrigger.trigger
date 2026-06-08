trigger OrderTrigger on Order (after insert) {
    OrderTriggerHandler.publishEvent(Trigger.new);
}