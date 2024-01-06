public class SMSUtils {
	
    @future(callout=true)
    public static void sendSMSAsync(String remetente, String destinatario, String mensagem) {
        String results = sendSMS(remetente, destinatario, mensagem);
        System.debug(results);
    }
    
    public static String sendSMS(String remetente, String destinatario, String mensagem) {
        //String results = SmsMessage.send(remetente, destinatario, mensagem);
        //insert new SMS_Log__c(to__c=destinatario, from__c=remetente, msg__c=results);
        //return results;
        return '';
    }
}