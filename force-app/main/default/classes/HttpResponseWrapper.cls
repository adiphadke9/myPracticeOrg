public with sharing class HttpResponseWrapper {
    @AuraEnabled public Integer stautsCode;
    @AuraEnabled public String message;
    @AuraEnabled public String errorMessage;
    @AuraEnabled public Boolean isSuccess;
}