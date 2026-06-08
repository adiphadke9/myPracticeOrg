// Use .apex files to store anonymous Apex.
// You can execute anonymous Apex in VS Code by selecting the
//     apex text and running the command:
//     SFDX: Execute Anonymous Apex with Currently Selected Text
// You can also execute the entire file by running the command:
//     SFDX: Execute Anonymous Apex with Editor Contents

OrderStatus__e os = new OrderStatus__e();
os.Order_Number__c = 'ORD-12345';
os.Total_Amount_in_USD__c = 9876.1233;
EventBus.publish(os);