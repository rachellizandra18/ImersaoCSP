public class Utils {
    public static void sendCustomNotification(String titulo, String assunto, String notificationId, String targetId, Set<String> destinatario){
        Messaging.CustomNotification notification = new Messaging.CustomNotification(); 
        notification.setTitle(titulo); 
        notification.setBody(assunto);
        notification.setNotificationTypeId(notificationId); 
        notification.setTargetId(targetId);
        notification.send(destinatario);
    }
}