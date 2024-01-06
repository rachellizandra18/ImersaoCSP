public class CriaNotificacaoDeAjusteViagem {
	@InvocableMethod(label='Cria Notificacao para Ajuste de Viagem' description='Cria uma notificação de ajuste de viagem se já existir algum evento no período da viagem' category='Viagem__c')
    public static void notificarUsuarioAjusteViagem(List<Viagem__c> viagens) {
        CustomNotificationType notificationType = [SELECT Id, DeveloperName 
                                                   FROM CustomNotificationType 
                                                   WHERE DeveloperName='NotificarAjusteViagem'];
        
        //List<Event> eventos = new List<Event>();
        
        for(Viagem__c viagem : viagens) {
            //for (Event evento : eventos) {
               // if(viagem.Data_Hora_da_Ida__c == evento.ActivityDateTime && viagem.Data_Hora_da_Volta__c == evento.EndDateTime && viagem.Colaborador__c == evento.WhoId) {
        
                        Messaging.CustomNotification notification = new Messaging.CustomNotification();
        
                        notification.setTitle('Uma viagem precisa ser ajustada');
                        notification.setBody('Existe um evento já criado para o período escolhido.' + ' Clique para ver.');
                        
                        notification.setNotificationTypeId(notificationType.Id);
                        notification.setTargetId(viagem.Colaborador__c);
            
                    try{
                        notification.send(new Set<String> { Userinfo.getUserId() });
                    } catch(Exception e) {
                        System.debug('Problema no envio da notificação: ' + e.getMessage());
                    }
                    
                //}

      		//}
        }

 
    }
}