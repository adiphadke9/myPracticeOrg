public class OpportunityBulkCreator {

    public static void createOpportunities(Integer recordCount) {
        
        // Validation
        if(recordCount == null || recordCount <= 0){
            throw new AuraHandledException('Please provide a valid number of opportunities to create.');
        }

        List<Opportunity> oppList = new List<Opportunity>();

        // (Optional) Get a default Account (Required for Opportunity)
        Account acc = [SELECT Id FROM Account LIMIT 1];

        for(Integer i = 0; i < recordCount; i++){
            Opportunity opp = new Opportunity();
            opp.Name = 'Auto Opportunity ' + i;
            opp.StageName = 'Prospecting';
            opp.CloseDate = Date.today().addDays(30);
            opp.AccountId = acc.Id;

            oppList.add(opp);
        }

        // Single DML operation (Bulk Safe)
        if(!oppList.isEmpty()){
            insert oppList;
        }
    }
}