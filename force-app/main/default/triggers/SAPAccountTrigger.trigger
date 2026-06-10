trigger SAPAccountTrigger on SAP_Account__e (after insert) {
    System.debug('SAPAccountTrigger fired');
    System.debug('SAPAccountTrigger data'+JSON.serializePretty(Trigger.new));
}