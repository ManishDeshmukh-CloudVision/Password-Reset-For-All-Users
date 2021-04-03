global class PasswordResetAutomation implements Database.Batchable<sObject>, Database.Stateful{
    global Integer recordsProcessed = 0;
    global  List<string> UserlistPasswordreset =new List<string>();
    global Database.QueryLocator start(Database.BatchableContext bc) {       
        String Usr ='Select Id,LastPasswordChangeDate,username from User where (LastPasswordChangeDate = null or LastPasswordChangeDate< today) and IsActive= true and Id not in (\'0050K00000AcjIQQAZ\',\'0050K00000ATX9CQAX\',\'00528000005QSu0AAG\',\'0050K00000BDbh2QAD\',\'0050K00000AQwLKQA1\',\'0050K00000ARGPqQAP\',\'0050K00000ARNoTQAX\') '; 
   		return Database.getQueryLocator(Usr);
    }
    
    global void execute(Database.BatchableContext bc, List<user> scope){
        
        for (user usrlst: scope) {
            System.resetPassword(usrlst.Id,true);            
            
            recordsProcessed = recordsProcessed + 1;
        	UserlistPasswordreset.add(usrlst.username); 
            
        }
    }
    
    global void finish(Database.BatchableContext bc){
        String StrDeactiveUsrId;
        AsyncApexJob a = [Select Id, Status,ExtendedStatus,NumberOfErrors, JobItemsProcessed,TotalJobItems, CreatedBy.Email    from AsyncApexJob where Id =:BC.getJobId()];
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        String[] toAddresses = new String[] {'manish.cloudvision@gmail.com'};
            mail.setToAddresses(toAddresses);
        mail.setSubject('Password Reset automation' + a.Status);
        for(string s: UserlistPasswordreset)
        {
            StrDeactiveUsrId+=s+'\n';
        }
        
        mail.setPlainTextBody('records processed ' + a.TotalJobItems +   'with '+ a.NumberOfErrors + ' failures.' +'\n\n SFDC Username OF THE USER PROCESSED \n' + StrDeactiveUsrId );
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });    
    }
}