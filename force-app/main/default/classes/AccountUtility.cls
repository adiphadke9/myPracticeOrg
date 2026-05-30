public with sharing class AccountUtility {
    public static void createAccount(String name,String rating) {
        sfdc_Config__mdt config = sfdc_Config__mdt.getInstance(System.Label.Salesforce_Tpken_Label);
        if(config != null) {
            Boolean isValid = SalesforceTokenController.isvalidToken(config);
            Map<String, Object> fieldWithValuesMap = new Map<String, Object>();
            String accessToken = config.accesstoken__c;
            if (!isValid) {
                fieldWithValuesMap= SalesforceTokenController.refreshToken(config);
                accessToken = (String)fieldWithValuesMap.get('accesstoken__c');
            }
            String endPoint = config.instanceurl__c+ '/services/data/v65.0/sobjects/Account';
            String body = '{'+
		'    "Name" : "'+name+'",'+
		'    "Rating":"'+rating+'",'+
		'    "Phone":"1234567890",'+
		'    "Industry":"Education"'+
		'}';
            HttpRequest httpreq = CalloutUtility.prepareRequest(endPoint, 'POST', body, 'application/json', 'application/json');
            httpreq.setHeader('Authorization', 'Bearer ' + accessToken);
            try {
                HttpResponse httpRes = (new http()).send(httpreq);
                if (httpRes.getStatusCode() == 201 || httpRes.getStatusCode() == 200) {
                    System.debug('Account Created Successfully: ' + httpRes.getBody());
                }else {
                    System.debug('Failed to create Account. Status: ' + httpRes.getStatus() + ', Body: ' + httpRes.getBody());
                }
            } catch (Exception e) {
                
            }
            //Update New Access Token
            if (fieldWithValuesMap.size()>0) {
                String fullName = 'sfdc_Config.'+System.Label.Salesforce_Tpken_Label;
                String label= System.Label.Salesforce_Tpken_Label;
                CreateUpdateMetadataUtils.createUpdateMetadata(fullName, label, fieldWithValuesMap);
            }
        }
    }
}