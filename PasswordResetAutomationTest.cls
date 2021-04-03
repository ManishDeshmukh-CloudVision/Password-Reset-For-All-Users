@isTest(SeeAllData=true) 
public class PasswordResetAutomationTest {
    static testMethod void insertUser(){
        Profile prof = [SELECT Id FROM Profile WHERE Name = 'Recruiter'];
        User user = new User();
        user.firstName = 'test1';
        user.lastName = 'test2';
        user.profileId = prof.id;
        user.username = 'test@test4343433.com';
        user.email = 'test@test.com';
        user.EmailEncodingKey = 'ISO-8859-1';
        user.TimeZoneSidKey = 'America/Los_Angeles';
        user.LocaleSidKey = 'en_US';
        user.LanguageLocaleKey = 'en_US';
        user.Alias='MDesh';
        insert user;
        
        Test.startTest();
        
        PasswordResetAutomation resetPassword = new PasswordResetAutomation ();
        Id BatchId = Database.executeBatch(resetPassword);
        System.assert(BatchId != null);
        Test.stopTest();
    }
}