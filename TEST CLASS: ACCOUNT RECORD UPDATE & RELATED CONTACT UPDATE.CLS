/*
As soon as phone number is updated on Account record then the same number should be updated in all related contact record
*/

@isTest
private class TestUpdateRelatedContactsHandler {
    @isTest static void testPhoneNumberUpdate() {
        // Create a test account
        Account testAccount = new Account(Name='Test Account', Phone='1234567890');
        insert testAccount;

        // Create a test contact related to the test account
        Contact testContact = new Contact(LastName='Test Contact', AccountId=testAccount.Id);
        insert testContact;

        // Change the phone number of the test account
        testAccount.Phone = '0987654321';
        update testAccount;

        // Retrieve the updated contact
        testContact = [SELECT Phone FROM Contact WHERE Id=:testContact.Id];

        // Assert that the contact's phone number was updated
        System.assertEquals('0987654321', testContact.Phone, 'The contact phone number should be updated to match the account phone number.');
    }
}

/*
Defining the Test Class
@isTest
private class TestUpdateRelatedContactsHandler {

@isTest: This annotation indicates that this class is a test class, used exclusively for testing your code. Test classes do not count against your org's Apex code limit.
TestUpdateRelatedContactsHandler: This is the name of your test class. It's a good practice to name the test class after the class it's testing with a 'Test' prefix or suffix.
*/

/*
Creating the Test Method
@isTest static void testPhoneNumberUpdate() {

@isTest: This annotation marks the method as a test method.
testPhoneNumberUpdate: This is the name of the test method. It's a descriptive name indicating that this method will test the phone number update functionality.
*/

/*
Setting Up Test Data
// Create a test account
        Account testAccount = new Account(Name='Test Account', Phone='1234567890');
        insert testAccount;

        // Create a test contact related to the test account
        Contact testContact = new Contact(LastName='Test Contact', AccountId=testAccount.Id);
        insert testContact;

Creating a Test Account: You create an Account object with a name and phone number. This is your test data.
Inserting the Account: The insert statement adds the account to the database. In test methods, this is a simulation and doesn't affect your actual Salesforce data.
Creating a Test Contact: Similar to the account, you create a Contact and associate it with the test account using the AccountId.
Inserting the Contact: Like the account, the contact is inserted into the database.
*/

/*
Performing the Test Operation
        // Change the phone number of the test account
        testAccount.Phone = '0987654321';
        update testAccount;

Updating Test Data: You change the phone number of the test account.
Triggering the Update: By updating the test account, your trigger should fire, which in turn calls your handler class to update the related contact's phone number.

*/

/*
Verifying the Results
        // Retrieve the updated contact
        testContact = [SELECT Phone FROM Contact WHERE Id=:testContact.Id];

        // Assert that the contact's phone number was updated
        System.assertEquals('0987654321', testContact.Phone, 'The contact phone number should be updated to match the account phone number.');
    }
}

Retrieving Updated Data: You retrieve the contact again from the database to get the updated phone number.
Assertion: System.assertEquals checks if the contact's phone number matches the updated phone number of the account. This is a critical step as it verifies if your trigger and handler class work as expected.

Summary
Create Test Data: Set up an account and contact in a controlled test environment.
Perform Test Operation: Execute the operation you want to test (in this case, updating the account's phone number).
Verify the Outcome: Use assertions to ensure that the expected changes (contact phone number update) occurred.

*/
