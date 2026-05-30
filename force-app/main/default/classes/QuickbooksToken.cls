public with sharing class QuickbooksToken {
    public PageReference authorize(){
        qb_Metadata__mdt config = qb_Metadata__mdt.getInstance('QB_Token');
        if (config!=null) {
            String redirect_uri = System.URL.getOrgDomainUrl().toExternalForm()+'/apex/'+ config.pagename__c;
            String authorizeUrl = config.auth_url__c+
            '?client_id='+config.client_id__c+
            '&redirect_uri='+redirect_uri+
            '&response_type=code'+
            '&scope=openid profile email com.intuit.quickbooks.accounting com.intuit.quickbooks.payment'+
            '&state='+UserInfo.getOrganizationId()+redirect_uri;
            System.debug('redirect_uri: ' + redirect_uri);
            System.System.debug('authorizeUrl'+authorizeUrl);
            return new PageReference(authorizeUrl);
        }else{
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.WARNING,'config not found'));
            return null;
        }
    }

    public void getAccessToken(){
       /* https://brave-moose-11911-dev-ed--c.vf.force.com/apex/
       QuickbooksToken?code=XAB11778476536R6xdt9ZMZtqhAOZwCjIy1JkSranDF6iUFcrk
       &state=00D7F000001vyEeUAIhttps%3A%2F%2Fbrave-moose-11911-dev-ed.my.salesforce.com%2Fapex%2FQuickbooksToken&realmId=9341457007528144*/
       qb_Metadata__mdt config = qb_Metadata__mdt.getInstance('QB_Token');
       if (config!=null) {
        String code = ApexPages.currentPage().getParameters().get('code');
        String realmId = ApexPages.currentPage().getParameters().get('realmId');
        String redirect_uri = System.URL.getOrgDomainUrl().toExternalForm()+'/apex/'+ config.pagename__c;
        HttpRequest httpreq = new HttpRequest();
        httpreq.setMethod('POST');
        httpreq.setHeader('Content-Type', 'application/x-www-form-urlencoded');
        httpreq.setHeader('Accept', 'application/json');
        httpreq.setEndpoint(config.token_url__c);
        String tokenBody = 'grant_type=authorization_code&code='+code+
        '&redirect_uri='+redirect_uri+'&client_id='+config.client_id__c+'&client_secret='+config.client_secret__c;
        httpreq.setBody(tokenBody);
        try {
            HttpResponse httpres = (new Http().send(httpreq));
            if (httpres.getStatusCode() == 200 || httpres.getStatusCode() == 201) {
                Map<String,Object> responseMap = (Map<String,Object>) JSON.deserializeUntyped(httpres.getBody());
                String access_token = (String) responseMap.get('access_token');
                String refresh_token = (String) responseMap.get('refresh_token');
                Integer expires_in = (Integer) responseMap.get('expires_in');
                //Prepare map for custom Metadata
                String fullName = 'qb_Metadata.QB_Token';
                String label= 'QB_Token';
                Map<String, Object> fieldWithValuesMap = new Map<String, Object>();
                fieldWithValuesMap.put('access_token__c', access_token);
                fieldWithValuesMap.put('expires_in__c', expires_in);
                fieldWithValuesMap.put('expires_in_time__c', System.now().addSeconds(expires_in));    
                fieldWithValuesMap.put('refresh_token__c', refresh_token);
                fieldWithValuesMap.put('realmId__c', realmId);
                CreateUpdateMetadataUtils.createUpdateMetadata(fullName, label, fieldWithValuesMap);
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM,'Access Token generated and saved successfully.'));
            }else{
                System.debug(httpres.getBody());
                ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR,httpres.getBody()));
            }
        } catch (CalloutException ex) {
             ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR,ex.getMessage()));
        }catch (Exception ex) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR,ex.getMessage()));
        }
       }else{
        ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.WARNING,'config not found'));
       }
    }

    public static Boolean isvalidToken(qb_Metadata__mdt config) {
        Boolean isvalidToken = true;
        if (config.expires_in_time__c < System.now()) {
            isvalidToken = false;
        }
        return isvalidToken;
    }

    public static Map<String,Object> refreshToken(qb_Metadata__mdt config){
        String token_url = config.token_url__c;
        String requestBody = 'grant_type=refresh_token&client_id='+config.client_id__c+'&client_secret='+config.client_secret__c+'&refresh_token='+config.refresh_token__c;
        System.debug('requestBody'+requestBody);
        HttpRequest httpreq = CalloutUtility.prepareRequest(token_url, 'POST', requestBody, 'application/json', 'application/x-www-form-urlencoded');
        Map<String, Object> fieldWithValuesMap = new Map<String,Object>();
        try{
            HttpResponse httpRes = (new Http()).send(httpReq);
        if(httpRes.getStatusCode() == 200 || httpRes.getStatusCode()== 201 ){
            fieldWithValuesMap = prepareMetadata(httpRes.getBody(),'');
        }else{

        }
        }catch(System.CalloutException ex){

        }catch(System.Exception ex){
            
        }
        return fieldWithValuesMap;   
    }

    public static Map<String, Object> prepareMetadata(String requestBody, String realmId){
        Map<String, Object> responseMap = (Map<String,Object>)JSON.deserializeUntyped(requestBody);
        String access_token = (String)responseMap.get('access_token');
        String refresh_token = (String)responseMap.get('refresh_token');
        Integer expires_in = (Integer)responseMap.get('expires_in');
        Map<String, Object> fieldWithValuesMap = new Map<String,Object>();
        fieldWithValuesMap.put('access_token__c', access_token);
        fieldWithValuesMap.put('expires_in__c',expires_in);
        fieldWithValuesMap.put('expires_in_time__c',System.now().addSeconds(expires_in) );
        fieldWithValuesMap.put('refresh_token__c', refresh_token);
        if(!String.isBlank(realmId)){
            fieldWithValuesMap.put('realmId__c', realmId);
        }
        return fieldWithValuesMap;
    }
}