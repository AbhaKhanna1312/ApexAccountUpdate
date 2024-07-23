@isTest
private class AccountEmailNotificationTest {

    @isTest
    static void testAccountEmailNotification() {
        Test.StartTest();
        
        // Create a list to hold multiple new Account records
        List<Account> newAccounts = new List<Account>();

        // Create and add 5 new Account records to the list
        for (Integer i = 0; i < 5; i++) {
            newAccounts.add(new Account(Name = 'Test Account ' + i));
        }

        // Insert the list of new Account records in a single DML operation
        insert newAccounts;

        // Call the sendNewAccountEmail method with the list of new Accounts
        AccountEmailNotification.sendNewAccountEmail(newAccounts);

        // Stop test execution context
        Test.stopTest();

        // Add your assertions here if needed
    }
}

/*
In this modified version of the test class:

We create a list newAccounts to hold multiple new Account records.

Inside a loop, we create and add 5 new Account records to the newAccounts list.

We insert the entire list of new Account records into the Salesforce database in a single DML operation using insert newAccounts.

We then call the sendNewAccountEmail method with the list of new Accounts.

This setup simulates the bulk creation of Account records and tests the email notification for all of them. You can adjust the loop to create as many records as needed for your bulk testing scenario.
/*
