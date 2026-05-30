public with sharing class SalesforceTokenController {
    public PageReference getAuthCode(){
        sfdc_Config__mdt config = sfdc_Config__mdt.getInstance(System.Label.Salesforce_Tpken_Label);
        if (config!=null) {
       /* https://login.salesforce.com/services/oauth2/authorize
        ?response_type=code
        &client_id=3MVG9d8..z.hDcPI6j9v6W2pX0AnAqkzZOTQ19HTYF8mSwXXEPj41dDYSCPC0Skr8hcPZEDXUcVLJo32WH.JQ
        &redirect_uri=https://webhook.site/c37e7ec3-c69d-4449-835e-1b1fc7c18a23*/

            List<String> codeVerifierChallenge = PKCEAuthController.getDetails();

            String  orgUrl = config.Environment__c == 'Production' ? 'https://login.salesforce.com' : 'https://test.salesforce.com';
            String clientId = config.clientid__c;
            String sfdcBaseURL = URL.getOrgDomainURL().toExternalForm()+'/apex/'+config.PageName__c;
            String baseUrl = orgUrl+config.authurl__c+'?client_id='+clientId+'&redirect_uri='+sfdcBaseURL+'&response_type=code&response_type=code&code_challenge='+codeVerifierChallenge.get(1);
            System.debug('baseUrl: '+baseUrl);
            Cart__c helper = new Cart__c();
            helper.Active__c = true;
            helper.User__c = UserInfo.getUserId();
             helper.Coupon__c = 'a0jGA00000rf4mCYAQ';
            helper.code_challenge__c = codeVerifierChallenge.get(1);
            helper.code_verifier__c =  codeVerifierChallenge.get(0);
            insert helper;
            return new PageReference(baseUrl);
        }else {
            return null;
        }
    }

    public void getAccessToken(){
        sfdc_Config__mdt config = sfdc_Config__mdt.getInstance(System.Label.Salesforce_Tpken_Label);
        String code=ApexPages.currentPage().getParameters().get('code');
        System.debug('code: '+code);
        if (config!=null) {
            Cart__c helper = [Select id, Name, code_verifier__c from Cart__c where Active__c = true AND User__c =: UserInfo.getUserId() LIMIT 1];
            String  orgUrl = config.Environment__c == 'Production' ? 'https://login.salesforce.com' : 'https://test.salesforce.com';
            String tokenUrl = orgUrl+config.tokenurl__c;
            String redirect_uri = URL.getOrgDomainURL().toExternalForm()+'/apex/'+config.PageName__c;
            String body = 'code='+code+'&grant_type=authorization_code&client_id='+config.clientid__c+'&client_secret='+config.clientsecret__c+'&redirect_uri='+redirect_uri+'&code_verifier='+helper.code_verifier__c;
            System.debug('body: '+body);
            HttpRequest httpreq = new HttpRequest();
            httpreq.setEndpoint(tokenUrl);
            httpreq.setMethod('POST');
            httpreq.setBody(body);
            httpreq.setHeader('Content-Type', 'application/x-www-form-urlencoded');
            httpreq.setHeader('Accept', 'application/json');
            Http http = new Http();
            try {
                HttpResponse httpresp = http.send(httpreq);
                if (httpresp.getStatusCode() == 200) {
                    System.debug('Response: '+httpresp.getBody());
                    SalesforceTokenWrapper wrapper = (SalesforceTokenWrapper) System.JSON.deserialize(httpresp.getBody(), SalesforceTokenWrapper.class);
                    String fullName = 'sfdc_Config.'+System.Label.Salesforce_Tpken_Label;
                    String label= System.Label.Salesforce_Tpken_Label;
                    //String fullName = 'sfdc_Config.'+'SFDC_TOKEN';
                    //String label= 'Salesforce Token';
                    Map<String, Object> fieldWithValuesMap = new Map<String, Object>();
                    fieldWithValuesMap.put('accesstoken__c', wrapper.access_token);
                    fieldWithValuesMap.put('expires_in_time__c', System.now().addHours(2));
                    fieldWithValuesMap.put('instanceurl__c', wrapper.instance_url);
                    fieldWithValuesMap.put('refreshtoken__c', wrapper.refresh_token);
                    fieldWithValuesMap.put('scope__c', wrapper.scope);
                    fieldWithValuesMap.put('clientid__c', config.clientid__c);
                    fieldWithValuesMap.put('clientsecret__c', config.clientsecret__c);
                    CreateUpdateMetadataUtils.createUpdateMetadata(fullName, label, fieldWithValuesMap);
                    helper.Active__c = false;
                    update helper;
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM,'Access Token generated and saved successfully.'));
                }else {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Failed to get Access Token. Status: '+httpresp.getStatus()));
                }
            }catch(System.Exception e){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Failed to get Access Token. Status: '+e.getMessage()));
            }
        }
    }

    public static Boolean isvalidToken(sfdc_Config__mdt config) {
        Boolean isvalidToken = true;
        if (config.expires_in_time__c < System.now()) {
            isvalidToken = false;
        }
        return isvalidToken;
    }

    public static Map<String, Object> refreshToken(sfdc_Config__mdt config){
        String  orgUrl = config.Environment__c == 'Production' ? 'https://login.salesforce.com' : 'https://test.salesforce.com';
        String tokenUrl = orgUrl+config.tokenurl__c;
        String body = 'grant_type=refresh_token&client_id='+config.clientid__c+'&client_secret='+config.clientsecret__c+'&refresh_token='+config.refreshtoken__c;
        Map<String, Object> fieldWithValuesMap = new Map<String, Object>();
        HttpRequest httpreq = CalloutUtility.prepareRequest(tokenUrl, 'POST', body, 'application/json', 'application/x-www-form-urlencoded');
            try {
                HttpResponse httpRes = (new http()).send(httpreq);
                if (httpRes.getStatusCode() == 201 || httpRes.getStatusCode() == 200) {
                    SalesforceTokenWrapper wrapper = (SalesforceTokenWrapper) System.JSON.deserialize(httpRes.getBody(), SalesforceTokenWrapper.class);
                    fieldWithValuesMap.put('accesstoken__c', wrapper.access_token);
                    fieldWithValuesMap.put('expires_in_time__c', System.now().addHours(2));
                    //CreateUpdateMetadataUtils.createUpdateMetadata(fullName, label, fieldWithValuesMap);
                }else {
                    
                }
            } catch (Exception e) {
                
            }
            return fieldWithValuesMap;
    }
}