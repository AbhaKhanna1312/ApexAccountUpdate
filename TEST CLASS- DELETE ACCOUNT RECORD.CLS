/*
scenario : When Account record owner is trying to delete a record, then it should be allowed
But if any other user is trying to delete, then trigger should throw error
*/

@isTest
public class AccountDeleteRecordClassTest {
    // Test method to simulate an Account deletion by a non-owner
    @isTest
    public static void testNonOwnerDeletePermission() {
        // Create a test user who is not the owner
        Profile profile = [SELECT Id FROM Profile WHERE Name='Users for Nike & Ebay Project' LIMIT 1];
        User testUser = new User(
            ProfileId = profile.Id,
            FirstName = 'Test',
            LastName = 'User',
            Email = 'testuser_nonowner@example.com', // Unique username
            Username = 'testuser_nonowner@example.com', // Unique username
            Alias = 'TUser',
            TimeZoneSidKey = 'America/Los_Angeles',
            LocaleSidKey = 'en_US',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US'
        );

        insert testUser;

        // Create a test Account owned by another user
        User ownerUser = [SELECT Id FROM User WHERE Profile.Name = 'System Administrator' LIMIT 1];
        Account testAccount = new Account(
            Name = 'Test Account',
            OwnerId = ownerUser.Id
        );

        insert testAccount;

        // Set the test context to run as the owner of the Account
        System.runAs(ownerUser) {
           // Attempt to delete the Account record
            Test.startTest();
            delete testAccount; // This line may throw an exception if the user is not the owner
            Test.stopTest();
        }
    }

    // Test method to simulate an Account deletion by the owner
    @isTest
    public static void testOwnerDeletePermission() {
        // Create a test user who is the owner
        Profile profile = [SELECT Id FROM Profile WHERE Name='Standard User' LIMIT 1];
        User testUser = new User(
            ProfileId = profile.Id,
            FirstName = 'Test',
            LastName = 'User',
            Email = 'testuser_owner@example.com', // Unique username
            Username = 'testuser_owner@example.com', // Unique username
            Alias = 'TUser',
            TimeZoneSidKey = 'America/Los_Angeles',
            LocaleSidKey = 'en_US',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US'
        );

        insert testUser;

        // Create a test Account owned by the test user
        Account testAccount = new Account(
            Name = 'Test Account',
            OwnerId = testUser.Id
        );

        insert testAccount;

        // Set the test context to run as the owner test user
        System.runAs(testUser) {
            // Attempt to delete the Account record
            Test.startTest();
            delete testAccount; // This line should not throw an exception as the owner is deleting the record
            Test.stopTest();
        }
    }
}