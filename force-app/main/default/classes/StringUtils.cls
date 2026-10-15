public with sharing class StringUtils {
    @InvocableMethod(label='Convert String to Array and Vice Versa' 
                     description='Convert String to Array and Vice Versa'
                     category='pantherschools'
                     iconName='slds:custom:custom57')
    public static void StringUtils(List<InputWrapper> inputs){
        if (inputs!=null && inputs.size()>0) {
            InputWrapper input = inputs.get(0);
            String colors = 'Red,Blue,Yellow';
            List<String> colorList = colors.split(',');
            String joinedString = String.join(colorList,',');
        }
    }

     public class InputWrapper{
        @InvocableVariable(label='Provide the String to Convert into array' required=false description='Provide the String to Convert into Array')
         public String inputString;
        @InvocableVariable(label='Provide the List to Convert into String' required=false description='Provide the List to Convert into String')
         public String inputList;
        @InvocableVariable(label='Seperator to Convert String to Array and Vice Versa' required=false description='Seperator to Convert String to Array and Vice Versa')
         public String seperator;
        @InvocableVariable(label='Provide Operation that you want to perform' description='Provide Operation that you want to perform' required=true) 
         public String operationType;
     }
}