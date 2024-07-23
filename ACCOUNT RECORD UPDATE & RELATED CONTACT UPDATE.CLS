/*
As soon as phone number is updated on Account record then the same number should be updated in all related contact record
*/

//Trigger Code
trigger UpdateRelatedContactTrigger on Account (after update) {
    UpdateRelatedContactsHandler.updaterelatedcontacts (Trigger.new, Trigger.oldMap);

}

//Apex Class
public class UpdateRelatedContactsHandler {
    public static void updaterelatedcontacts(List<Account> newAccounts, Map<Id, Account> oldAccountMap) {
        // Create a set to hold Account IDs where the phone number has changed
        Set<Id> accountIdsWithChangedPhoneNumber = new Set<Id>();

        // Create a map from the list of new Accounts for easy access
        Map<Id, Account> newAccountsMap = new Map<Id, Account>(newAccounts);

        // Identify Account IDs with changed phone numbers
        for (Account newAccount : newAccounts) {
            Account oldAccount = oldAccountMap.get(newAccount.Id);
            
            // Check if the Account's phone number field has changed
            if (newAccount.Phone != oldAccount.Phone) {
                accountIdsWithChangedPhoneNumber.add(newAccount.Id);
            }
        }

        // No accounts with changed phone numbers, no further action needed
        if (accountIdsWithChangedPhoneNumber.isEmpty()) {
            return;
        }

        // Query for all related contacts
        List<Contact> contactsToUpdate = [
            SELECT Id, Phone, AccountId 
            FROM Contact 
            WHERE AccountId IN :accountIdsWithChangedPhoneNumber
        ];

        // Update contacts with the new phone number
        for (Contact con : contactsToUpdate) {
            Account parentAccount = newAccountsMap.get(con.AccountId);
            con.Phone = parentAccount.Phone;
        }

        // Perform the update DML operation
        if (!contactsToUpdate.isEmpty()) {
            update contactsToUpdate;
        }
    }
}
/*
Defining the Handler Class and Method
public class UpdateRelatedContactsHandler {
public static void updaterelatedcontacts(List<Account> newAccounts, Map<Id, Account> oldAccountMap) {

UpdateRelatedContactsHandler: This is the name of your class. Classes are blueprints for creating objects or a set of instructions to handle some specific logic.

updaterelatedcontacts: This is a method inside your class. A method is a collection of statements that are grouped together to perform an operation. This specific method is designed to update related contacts when an account's phone number changes.

List<Account> newAccounts, Map<Id, Account> oldAccountMap: These are the parameters your method accepts. newAccounts is a list of updated account records, and oldAccountMap is a map of the original account records indexed by their IDs.
*/

/*
Preparing to Track Phone Number Changes
Set<Id> accountIdsWithChangedPhoneNumber = new Set<Id>();
Map<Id, Account> newAccountsMap = new Map<Id, Account>(newAccounts);
A Set named accountIdsWithChangedPhoneNumber is created to store the IDs of accounts where the phone number has changed.
A Map named newAccountsMap is created from newAccounts. This map will allow quick access to the updated account records by their ID.
*/

/*
Identifying Changed Phone Numbers
for (Account newAccount : newAccounts) {
Account oldAccount = oldAccountMap.get(newAccount.Id);
    if (newAccount.Phone != oldAccount.Phone) {
    accountIdsWithChangedPhoneNumber.add(newAccount.Id);
            }
        }
This loop goes through each account in newAccounts.
For each account, it retrieves the corresponding old account from oldAccountMap using the account ID.
It checks if the phone number has changed. If yes, it adds the account ID to accountIdsWithChangedPhoneNumber.     
*/

/*
Querying Related Contacts
        if (accountIdsWithChangedPhoneNumber.isEmpty()) {
            return;
        }
        List<Contact> contactsToUpdate = [SELECT Id, Phone, AccountId FROM Contact WHERE AccountId IN :accountIdsWithChangedPhoneNumber];
If there are no changed phone numbers, the method returns early. This is an efficiency step.
If there are changes, it queries all contacts related to these accounts and stores them in contactsToUpdate.

*/

/*
Updating Contact Phone Numbers
        for (Contact con : contactsToUpdate) {
            Account parentAccount = newAccountsMap.get(con.AccountId);
            con.Phone = parentAccount.Phone;
        }
For each contact in contactsToUpdate, the loop finds the corresponding parent account in newAccountsMap.
It then updates the contact's phone number to match the phone number of the parent account.
*/

/*
Performing the Update Operation
        if (!contactsToUpdate.isEmpty()) {
            update contactsToUpdate;
        }
    }
}
If there are contacts to update, it performs a DML update operation to save these changes to the database.

Summary:
Determine which accounts have changed phone numbers.
Find all contacts related to these accounts.
Update these contacts with the new phone number from their parent accounts.
Save the changes to the database.
*/


