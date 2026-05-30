public with sharing class QB_Item {

    public static void testCreateItem() {

        List<Product2> products = [
            SELECT Id,
                   Name,
                   QBExternalID__c,
                   Synced_With_Quickbooks__c
            FROM Product2
            WHERE QBExternalID__c = NULL
        ];

        List<Product2> productsToUpdate = new List<Product2>();

        for (Product2 prod : products) {

            Product2 updatedProduct = createItemInQB(prod);

            if (updatedProduct != null &&
                updatedProduct.QBExternalID__c != null) {

                productsToUpdate.add(updatedProduct);
            }
        }

        if (!productsToUpdate.isEmpty()) {
            update productsToUpdate;
        }
    }

    public static Product2 createItemInQB(Product2 productRecord) {

        // -------------------------------------------------
        // FETCH CUSTOM METADATA USING SOQL
        // -------------------------------------------------

        qb_Metadata__mdt config;

        try {

            config = [
                SELECT DeveloperName,
                       MasterLabel,
                       access_token__c,
                       refresh_token__c,
                       client_id__c,
                       client_secret__c,
                       realmId__c,
                       sandbox_base_url__c,
                       production_base_url__c,
                       environment__c,
                       minorversion__c,
					   expires_in_time__c
                FROM qb_Metadata__mdt
                WHERE DeveloperName = 'QB_Token'
                LIMIT 1
            ];

        } catch (Exception ex) {

            System.debug(
                'Unable to fetch QB metadata => ' +
                ex.getMessage()
            );

            return productRecord;
        }

        if (config == null) {

            System.debug('QB Metadata not found');

            return productRecord;
        }

        try {

            // -------------------------------------------------
            // TOKEN VALIDATION
            // -------------------------------------------------

            Boolean isValid =
                QuickbooksToken.isvalidToken(config);

            Map<String, Object> fieldWithValuesMap =
                new Map<String, Object>();

            String accessToken =
                config.access_token__c;

            System.debug(
                'Original Token Length => ' +
                (
                    accessToken != null
                    ? accessToken.length()
                    : 0
                )
            );

            // -------------------------------------------------
            // REFRESH TOKEN IF INVALID
            // -------------------------------------------------

            if (!isValid) {

                fieldWithValuesMap =
                    QuickbooksToken.refreshToken(config);

                System.debug(
                    'Refresh Response => ' +
                    JSON.serializePretty(fieldWithValuesMap)
                );

                if (fieldWithValuesMap != null &&
                    fieldWithValuesMap.containsKey('access_token')) {

                    accessToken =
                        (String)
                        fieldWithValuesMap.get('access_token');
                }

                // ---------------------------------------------
                // UPDATE METADATA
                // ---------------------------------------------

                if (!fieldWithValuesMap.isEmpty()) {

                    String fullName =
                        'qb_Metadata.QB_Token';

                    String label =
                        'QB_Token';

                    CreateUpdateMetadataUtils.createUpdateMetadata(
                            fullName,
                            label,
                            fieldWithValuesMap
                        );
                }
            }

            // -------------------------------------------------
            // FINAL TOKEN CHECK
            // -------------------------------------------------

            if (String.isBlank(accessToken)) {

                System.debug(
                    'Access token is blank'
                );

                return productRecord;
            }

            System.debug(
                'Final Token Length => ' +
                accessToken.length()
            );

            System.debug(
                'First 30 chars => ' +
                accessToken.substring(
                    0,
                    Math.min(30, accessToken.length())
                )
            );

            // -------------------------------------------------
            // ENDPOINT
            // -------------------------------------------------

            String endpoint =
                config.production_base_url__c +
                '/v3/company/' +
                config.realmId__c +
                '/item?minorversion=' +
                config.minorversion__c;

            if (config.environment__c == 'Sandbox') {

                endpoint =
                    config.sandbox_base_url__c +
                    '/v3/company/' +
                    config.realmId__c +
                    '/item?minorversion=' +
                    config.minorversion__c;
            }

            System.debug(
                'Endpoint => ' + endpoint
            );

            // -------------------------------------------------
            // RESOLVE CUSTOM LABELS BEFORE USE
            // -------------------------------------------------

            String incomeAccountRefName   = Label.IncomeAccountRefName;
            String incomeAccountRefValue  = Label.IncomeAccountRef_Value;
            String assetAccountRefName    = Label.AssetAccountRefName;
            String assetAccountRefValue   = Label.AssetAccountRef_Value;
            String expenseAccountRefName  = Label.ExpenseAccountRefName;
            String expenseAccountRefValue = Label.ExpenseAccountRef_Value;

            // -------------------------------------------------
            // REQUEST PAYLOAD
            // -------------------------------------------------

            Map<String, Object> payload =
                new Map<String, Object>();

            payload.put(
                'TrackQtyOnHand',
                false
            );

            payload.put(
                'Name',
                productRecord.Name
            );

            payload.put(
                'QtyOnHand',
                10
            );

            payload.put(
                'InvStartDate',
                '2026-01-01'
            );

            payload.put(
                'Type',
                'Service'
            );

            payload.put(
                'IncomeAccountRef',
                new Map<String, Object>{
                    'name'  => incomeAccountRefName,
                    'value' => incomeAccountRefValue
                }
            );

            payload.put(
                'AssetAccountRef',
                new Map<String, Object>{
                    'name'  => assetAccountRefName,
                    'value' => assetAccountRefValue
                }
            );

            payload.put(
                'ExpenseAccountRef',
                new Map<String, Object>{
                    'name'  => expenseAccountRefName,
                    'value' => expenseAccountRefValue
                }
            );

            String requestBody =
                JSON.serialize(payload);

            System.debug(
                'Request Body => ' +
                requestBody
            );

            // -------------------------------------------------
            // HTTP REQUEST
            // -------------------------------------------------

            HttpRequest httpreq =
                new HttpRequest();

            httpreq.setMethod('POST');

            httpreq.setEndpoint(endpoint);

            httpreq.setHeader(
                'Authorization',
                'Bearer ' + accessToken
            );

            httpreq.setHeader(
                'Content-Type',
                'application/json'
            );

            httpreq.setHeader(
                'Accept',
                'application/json'
            );

            httpreq.setBody(requestBody);

            httpreq.setTimeout(120000);

            // -------------------------------------------------
            // SEND REQUEST
            // -------------------------------------------------

            Http http = new Http();

            HttpResponse httpres =
                http.send(httpreq);

            System.debug(
                'Status Code => ' +
                httpres.getStatusCode()
            );

            System.debug(
                'Response => ' +
                httpres.getBody()
            );

            // -------------------------------------------------
            // SUCCESS
            // -------------------------------------------------

            if (httpres.getStatusCode() == 200 ||
                httpres.getStatusCode() == 201) {

                Map<String, Object> responseMap =
                    (Map<String, Object>)
                    JSON.deserializeUntyped(
                        httpres.getBody()
                    );

                Map<String, Object> itemMap =
                    (Map<String, Object>)
                    responseMap.get('Item');

                if (itemMap != null) {

                    String qbItemId =
                        String.valueOf(
                            itemMap.get('Id')
                        );

                    productRecord.QBExternalID__c =
                        qbItemId;

                    productRecord
                        .Synced_With_Quickbooks__c =
                            true;

                    System.debug(
                        'QB Item Created => ' +
                        qbItemId
                    );
                }
            }
            else {

                System.debug(
                    'QB Error Response => ' +
                    httpres.getBody()
                );
            }
        }
        catch (CalloutException ex) {

            System.debug(
                'Callout Exception => ' +
                ex.getMessage()
            );
        }
        catch (Exception ex) {

            System.debug(
                'General Exception => ' +
                ex.getMessage()
            );
        }

        return productRecord;
    }
}