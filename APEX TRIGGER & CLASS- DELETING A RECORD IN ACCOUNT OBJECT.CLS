/*
scenario : When Account record owner is trying to delete a record, then it should be allowed
But if any other user is trying to delete, then trigger should throw error
*/

//Trigger Code
trigger AccountDeleteRecordTrigger on Account (before delete) {
    AccountDeleteRecordClass.checkDeletePermission(trigger.old);
}

//Apex class code
public class AccountDeleteRecordClass {
// A static method that checks delete permission for a list of deleted Account records.
//Declare a method & create a list to store the account records that are being deleted

    public static void checkDeletePermission(List<Account> VarDeletedAccountsList) {

        // Create a set to store the IDs of the deleted Account records.
        /*
        We use a set <id> collection to store the record ids of the deleted account.
        Sets in Apex are collections that do not allow duplicate values. When we are working with records in Salesforce, it's possible that the same record ID might appear multiple times in the trigger.old list. To ensure that we only process each unique ID once, we use a Set to store them. 
        This helps prevent unnecessary duplication in our processing.
        */
        Set<Id> VarAccountIdsSet = new Set<Id>();

        // Loop through the deleted Accounts and add their IDs to the set.
          for (Account VarAccount : VarDeletedAccountsList) {
            VarAccountIdsSet.add (VarAccount.id);
          }
        // Query the Account records with their IDs and OwnerIds
        // We're using a map to efficiently associate the records with their IDs.   
         Map<Id, Account> accountMap = new Map<Id, Account>(
             [SELECT Id, OwnerId FROM Account WHERE Id IN :VarAccountIdsSet]
        );
        
        // Loop through the deleted Accounts again
        for (Account VarAccount : VarDeletedAccountsList) {
        // Check if the OwnerId of the Account matches the current user's Id.
        if (VarAccount.OwnerId != Userinfo.getuserid()) {
        // If the OwnerId does not match the current user's Id, it means the user is not the owner.
        // In this case, add an error message to the Account record.
            VarAccount.addError('You are not the owner of this Account and cannot delete it.');
        }
        }
    }
}

/*
for (Account VarAccount : VarDeletedAccountsList) {
    // Check if the OwnerId of the Account matches the current user's Id.
    if (VarAccount.OwnerId != Userinfo.getuserid()) {
        // If the OwnerId does not match the current user's Id, it means the user is not the owner.
        // In this case, add an error message to the Account record.
        VarAccount.addError('You are not the owner of this Account and cannot delete it.');
    }
}

Here's a step-by-step breakdown of what this code is doing:

For Loop: This code is using a for loop to iterate through a list of Account records named VarDeletedAccountsList. The loop syntax for (Account VarAccount : VarDeletedAccountsList) means that for each Account in the VarDeletedAccountsList, the loop body (the code inside the curly braces) will be executed.

Owner ID Check: Inside the loop, the code is checking whether the OwnerId of each VarAccount (which is an Account record from the list) matches the ID of the current user (Userinfo.getuserid()). The OwnerId of an Account represents the user who owns that Account record.

Conditional Statement: The if statement is used to evaluate a condition. In this case, it's checking whether the OwnerId of VarAccount is not equal (!=) to the ID of the current user. If the OwnerId does not match the current user's ID, it means the current user is not the owner of this Account.

Adding an Error: If the condition in the if statement is true (i.e., the current user is not the owner of the Account), then the code inside the if block is executed. In this block, the addError method is called on the VarAccount. This method adds a custom error message to the Account record. The error message is: 'You are not the owner of this Account and cannot delete it.'

So, in summary, this code is looping through a list of Account records that are about to be deleted. For each Account, it checks if the current user is the owner of that Account. If the user is not the owner, it adds an error message to the Account record to prevent the deletion and informs the user that they cannot delete an Account they do not own.
*/


