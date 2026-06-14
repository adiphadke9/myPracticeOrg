public with sharing class PE_SuccessHandler implements EventBus.EventPublishSuccessCallback, EventBus.EventPublishFailureCallback {
    public void onSuccess(eventbus.SuccessResult result){
        System.debug('Success');
        System.debug(result.getEventUuids());
    }

    public void onFailure(eventbus.FailureResult result){
        System.debug('Failure');
        System.debug(result.getEventUuids());
    }
}