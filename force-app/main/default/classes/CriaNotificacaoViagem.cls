public class CriaNotificacaoViagem {
    
    @InvocableMethod(label='Cria Notificacao para Viagem' description='Cria uma notificação de viagem toda vez que uma for cadastrada' category='Viagem__c')
    public static void notificarUsuario(List<Viagem__c> recipientsId) {
        CustomNotificationType notificationType = [SELECT Id, DeveloperName 
                                                   FROM CustomNotificationType 
                                                   WHERE DeveloperName='NotificarEventoNovaViagem'];
        
        Set<Id> colaboradorId = new Set<Id>();
        for (Viagem__c viagem : recipientsId) {
            colaboradorId.add(viagem.Colaborador__c);
        }
        
        Map<Id,Contact> mapContatos = new Map<Id, Contact>([Select Id, FirstName, LastName FROM Contact Where Id IN:colaboradorId]); 
        
        for (Viagem__c viagem : recipientsId) {

            Messaging.CustomNotification notification = new Messaging.CustomNotification();
            
            notification.setTitle('Uma nova viagem foi agendada');
            notification.setBody('A viagem ' + viagem.Name + ' foi criada para o contato ' + mapContatos.get(viagem.Colaborador__c).FirstName + '. Clique para ver.');
            
            notification.setNotificationTypeId(notificationType.Id);
            notification.setTargetId(viagem.Colaborador__c);
            
         try{
            notification.send(new Set<String> { Userinfo.getUserId() });
         } catch(Exception e) {
            System.debug('Problema no envio da notificação: ' + e.getMessage());
        	}
        }     
    }
}