@RestResource(urlMapping='/v1/ContactManager/*')
global with sharing class ContactManager {
   /* @HttpPost
    global static ResponseWrapper processData(Account accountRecord, Contact contactRecord){
        System.debug(System.LoggingLevel.DEBUG, accountRecord);
        System.debug(System.LoggingLevel.DEBUG, contactRecord);
        List<Contact> contactList = [Select Id, Email, Account.Name FROM Contact where Email=:contactRecord.Email];
        ResponseWrapper wrapper = new ResponseWrapper();
        if (contactList?.size()>0) {
           wrapper.contactRecord = contactRecord;
           wrapper.accountRecord = accountRecord;
           wrapper.status = 'Existing';
           wrapper.message = 'Contact Already Exists with Same Email';
        }else {
            insert accountRecord;
            contactRecord.AccountId = accountRecord.Id;
            insert contactRecord;
            wrapper.contactRecord = contactRecord;
            wrapper.accountRecord = accountRecord;
            wrapper.status = 'New';
            wrapper.message = 'New Contact Created';
        }
        return wrapper;
    }*/

    @HttpPost
    global static ResponseWrapper processData(InputWrapper input){
        List<Contact> contactList = [Select Id, Email, Account.Name FROM Contact where Email=:input.email];
        ResponseWrapper wrapper = new ResponseWrapper();
        if (contactList?.size()>0) {
           wrapper.contactRecord = contactList.get(0);
           wrapper.status = 'Existing';
           wrapper.message = 'Contact Already Exists with Same Email';
        }else {
            Account accountRecord = new Account(Name=input.accountName);
            insert accountRecord;
            Contact contactRecord = new Contact(
                FirstName = input.firstName,
                LastName = input.lastName,
                Email=input.email
            );
            contactRecord.AccountId = accountRecord.Id;
            insert contactRecord;
            wrapper.contactRecord = contactRecord;
            wrapper.accountRecord = accountRecord;
            wrapper.status = 'New';
            wrapper.message = 'New Contact Created';
        }
        return wrapper;
    }

    global class InputWrapper{
        global String accountName;
        global String firstName;
        global String lastName;
        global String email;
    }

    global class ResponseWrapper{
        global Account accountRecord;
        global Contact contactRecord;
        global String status;
        global String message;
    }
}