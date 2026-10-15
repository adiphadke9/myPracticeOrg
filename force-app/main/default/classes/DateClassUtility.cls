public with sharing class DateClassUtility {
    @InvocableMethod(label='Date Operations' 
                     description='Operations Related to Date Class'
                     category='Date'
                     iconName='slds:standard:date_time')
    public static List<Date> dateUtils(List<InputWrapper> inputs){
        Date outputDate;
        if (inputs!=null && inputs.size()>0) {
            InputWrapper input = inputs.get(0);
            if (input.operationType == 'addDays') {
                outputDate = input.inputDate.addDays(input.numberOfDays);
            } else if (input.operationType == 'addMonths') {
                outputDate = input.inputDate.addMonths(input.numberOfDays);
            }else if (input.operationType == 'addYears') {
                outputDate = input.inputDate.addYears(input.numberOfDays);
            }
        }
        return new List<Date>{outputDate};
    }

    public class InputWrapper{
        @InvocableVariable(label='Provide Date on which you want to perform operation' required=true description='Provide Date on which you want to perform operation')
         public Date inputDate;
        @InvocableVariable(label='Provide Operation that you want to perform' description='Provide Operation that you want to perform' required=true) 
        public String operationType;
        @InvocableVariable(label='Number of Days' description='Number of Days for the Operation' required=true) public Integer numberOfDays;
    }
}