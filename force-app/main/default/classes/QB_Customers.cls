public with sharing class QB_Customers {

	public static void testCreateCustomer(){
		
		QB_CustomerInput customer = new QB_CustomerInput();
		customer.CompanyName = 'SimpleSchools';
		customer.DisplayName = 'SimpleSchools';
		customer.FamilyName = 'singh';
		customer.FullyQualifiedName = 'SimpleSchools-Amit Singh';
		customer.GivenName = 'Amit';
		customer.MiddleName = '';
		customer.Notes = 'Testing from Apex Class';
		customer.Suffix = 'Jr';
		customer.Title = 'Mr';
		
		QB_CustomerInput.PrimaryEmailAddr email = new QB_CustomerInput.PrimaryEmailAddr();
		email.Address = 'text@example.com';
		customer.PrimaryEmailAddr = email;

		QB_CustomerInput.PrimaryPhone phone = new QB_CustomerInput.PrimaryPhone();
		phone.FreeFormNumber = '555-444-333';
		customer.PrimaryPhone = phone;

		createCustomer(customer);
	}
    public static void createCustomer(QB_CustomerInput customer){
		List<qb_Metadata__mdt> configList = [SELECT Id, DeveloperName, MasterLabel, Language, NamespacePrefix, Label, QualifiedApiName, SystemModstamp, access_token__c, auth_url__c, client_id__c, client_secret__c, company_info__c, create_bill__c, create_customer__c, create_estimate__c, create_invoice__c, create_payment__c, create_vendor__c, customer_url__c, environment__c, expires_in__c, expires_in_time__c, minorversion__c, pagename__c, production_base_url__c, realmId__c, refresh_token__c, sandbox_base_url__c, token_type__c, token_url__c FROM qb_Metadata__mdt WHERE DeveloperName = 'QB_Token' LIMIT 1];
    	//qb_Metadata__mdt config = qb_Metadata__mdt.getInstance('QB_Token');
		if (configList.size()>0) {
			qb_Metadata__mdt config = configList.get(0);
			Boolean isvalid = QuickbooksToken.isvalidToken(config);
			Map<String, Object> fieldWithValuesMap = new Map<String, Object>();
			String accessToken = config.access_token__c;
			if (isvalid == false) {
				fieldWithValuesMap = QuickbooksToken.refreshToken(config);
				accessToken = (String) fieldWithValuesMap.get('access_token__c'); 
			}
			System.debug(JSON.serializePretty(fieldWithValuesMap));
			HttpRequest httpreq = new HttpRequest();
			httpreq.setMethod('POST');
			//httpreq.setHeader('Authorization', 'Bearer '+accessToken);
			httpreq.setHeader('Authorization','Bearer eyJhbGciOiJkaXIiLCJlbmMiOiJBMTI4Q0JDLUhTMjU2IiwieC5vcmciOiJIMCJ9..C311saOQq8nRvkg4ZAAsAg.VQvUeoRsb0uwYT5c9yw9NmYkyisQQdE3WLsM63T9ASofAsm1EBW6rZNkozDzzCaUi9_fI9oPGrw2i5kuNUEvLy1K2JWFH6qQ-Qop68-KqbxiOj601JJHWlP7gExYgIyBqUSeZ5IcCvGqql_wXGyU4cryzYk_Iku1unUOWD2xxmQ7MbKwuf3sD6DkzS_ty52zGnaokk3O5J6Jj9NQSCVmJefcw0tpJMDmAj6vbuaQt-cjYlHyao4URWkTo3eCe4KTrPSF3KSQp8KHALSblWBXzD7R7IfkX-XpnR_S1uHiX1D5II1W64Y4zetLncZuMjjAoWR30VZL9bkug-CqlpePtW0cdnYgmTwQbW7TEYMVvRh5SbuOr3Ia_WANDTu1AhRUuD9BdKI3nK8URTfJWhn9wF3TGbZhteotwb2CYcfBFJrwQEcNGNXYAn56MVwDaBtY8wHaifwYp0lcB5Pi8O32u6MnmWEWE8i7j4p6Ed0fmuYQR3ClCX6aEDBCxleGc2ybWAbHRIAsUSgbt3E8l6UPPPpaOktIgolUcdSlvfg5fgBbQEGdUmkBp_0wfCMH0keI0J_crbU7RInNTfpmnCUVHTnKAon_WXQq8ssrwjIST4U.KZmLkxUDjvBVH0wIheBTPg');
			httpreq.setHeader('Content-Type', 'application/json');
			httpreq.setHeader('Accept', 'application/json');
			String Endpoint = config.production_base_url__c+'/v3/company/'+config.realmId__c+'/customer?minorversion='+config.minorversion__c;
			if (config.environment__c.equals('Sandbox')) {
				Endpoint = config.sandbox_base_url__c+'/v3/company/'+config.realmId__c+'/customer?minorversion='+config.minorversion__c;
			}
			httpreq.setEndpoint(Endpoint);
			String requestBody = System.JSON.serialize(customer);
			httpreq.setBody(requestBody);
			try {
				HttpResponse httpres = (new Http()).send(httpreq);
				if (httpres.getStatusCode() == 200 || httpres.getStatusCode() == 201) {
					System.debug('body'+httpres.getBody());
					System.debug('status'+httpres.getStatusCode());
				}else {
					System.debug('body'+httpres.getBody());
					System.debug('status'+httpres.getStatusCode());
				}
			} catch (CalloutException ex) {
				System.debug('Callout Exception '+ex.getMessage());
			}catch (Exception ex) {
				System.debug('Exception '+ex.getMessage());
			}
			if (fieldWithValuesMap.size()>0) {
				String fullName = 'qb_Metadata.QB_Token';
                String label= 'QB_Token';
				CreateUpdateMetadataUtils.createUpdateMetadata(fullName, label, fieldWithValuesMap);
			}
		}
    }
}