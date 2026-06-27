trigger ContactChangeTrigger on ContactChangeEvent (after insert) {
    for (ContactChangeEvent con : Trigger.new) {
        EventBus.ChangeEventHeader header = con.ChangeEventHeader;
        String changeEntity = header.entityName;
        String changeOperation = header.changeType;
        if (changeOperation == 'CREATE') {
            System.debug('Contact create'+con.Name);
        }
        if (changeOperation == 'UPDATE') {
            System.debug('Contact Update'+con.Name);
        }
    }
}