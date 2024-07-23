/*
Create a trigger on Account object . After that once an Account record is inserted, an email should go to the Salesforce system admin user with subject 'New Account Alert' & body 'Please login to Salesforce and see all the new Account records'. Then do testing & write a test class as well. 
*/






//Trigger code
trigger NewAccountTrigger on Account (after insert) {
    if (Trigger.isAfter && Trigger.isInsert) {
        AccountEmailNotification.sendNewAccountEmail(Trigger.new);
    }
}

//Apex Class
public class AccountEmailNotification {
    public static void sendNewAccountEmail(List<Account> newAccounts) {
        List<Messaging.SingleEmailMessage> emailList = new List<Messaging.SingleEmailMessage>();
        
        for (Account acc : newAccounts) {
            Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
            email.setToAddresses(new String[]{'abha.khanna131290@gmail.com'}); // Replace with your admin's email
            email.setSubject('New Account Alert');
            email.setPlainTextBody('Please login to Salesforce and see all the new Account records.');
            emailList.add(email);
        }
        
        if (!emailList.isEmpty()) {
            Messaging.sendEmail(emailList);
        }
    }
}

/*

public class AccountEmailNotification {

This line defines the start of a public Apex class named AccountEmailNotification.

public static void sendNewAccountEmail(List<Account> newAccounts) {
This line defines a public, static method named sendNewAccountEmail that takes a List of Account records (newAccounts) as its parameter. The method is void, meaning it doesn't return any value.

List<Messaging.SingleEmailMessage> emailList = new List<Messaging.SingleEmailMessage>();
This line declares a List of Messaging.SingleEmailMessage objects named emailList. This list will store the email messages that will be sent.

for (Account acc : newAccounts) {
This line starts a for loop that iterates over each Account record in the newAccounts list. The loop variable acc represents each Account record in each iteration.

Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
Inside the loop, a new Messaging.SingleEmailMessage object named email is created. This object represents an individual email message that will be sent.

email.setToAddresses(new String[]{'admin@example.com'});
This line sets the recipient(s) of the email. In this case, it sets the recipient's email address to 'admin@example.com'. You should replace this with the actual email address of your Salesforce system admin user.

email.setSubject('New Account Alert');
This line sets the subject of the email to 'New Account Alert'.

email.setPlainTextBody('Please login to Salesforce and see all the new Account records.');
This line sets the plain text body of the email to 'Please login to Salesforce and see all the new Account records.'

emailList.add(email);
After setting up the email message with recipient, subject, and body, the email object is added to the emailList to be sent later.

if (!emailList.isEmpty()) {
This line checks if the emailList is not empty (i.e., it contains email messages to be sent).

Messaging.sendEmail(emailList);
If the emailList is not empty, this line sends the email messages contained in the list using Salesforce's Messaging.sendEmail method.



The line List<Messaging.SingleEmailMessage> emailList = new List<Messaging.SingleEmailMessage>(); is declaring and initializing a variable named emailList of type List<Messaging.SingleEmailMessage>.

Let's break down what this line does:

List<Messaging.SingleEmailMessage>: This part of the line specifies the data type of the variable emailList. It declares that emailList will be a list (a collection of elements) of objects of type Messaging.SingleEmailMessage. In Salesforce, the Messaging.SingleEmailMessage class represents an email message that can be sent through Apex.

emailList: This is the name of the variable. It's a user-defined name, and you can choose any valid identifier name you like for your variable.

= new List<Messaging.SingleEmailMessage>();: This part of the line initializes the emailList variable as a new empty list of Messaging.SingleEmailMessage objects. It uses the new keyword to create a new instance of the list and assigns it to the emailList variable. This means that emailList is initially empty and ready to store email messages.

So, the overall purpose of this line is to create an empty list (emailList) that will be used to store Messaging.SingleEmailMessage objects. These email messages will be generated and added to this list before they are sent using the Messaging.sendEmail method later in the code.
*/




