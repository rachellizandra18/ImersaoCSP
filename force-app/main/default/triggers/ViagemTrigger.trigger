trigger ViagemTrigger on Viagem__c (before insert, after insert, before update, after update) {

	new ViagemTriggerHandler().run(); 	
    
    /*if(Trigger.isInsert) {
     if(Trigger.isAfter) {
        System.debug('AFTER INSERT');
     } else {
        System.debug('BEFORE INSERT');
      } 
    } else { //update
        
     List<Viagem__c> viagensNew = Trigger.new;
        
      if(Trigger.isAfter) {
        System.debug('REGRA DE VALIDAÇÃO - AFTER UPDATE');
          
         List<Task> tasks = new List<Task>();    
         Map<Id, Viagem__c> mapViagemOld = Trigger.oldMap; 
          
         CustomNotificationType notificationType = [SELECT Id, DeveloperName 
                                                   FROM CustomNotificationType 
                                                   WHERE DeveloperName='ViagemPaga'];           
          for(Viagem__c viagem : viagensNew){
              
               Boolean valorAntigoDoCampoPagoEmpresa = mapViagemOld.get(viagem.Id).Pago_pela_empresa__c;

               if(viagem.Pago_pela_empresa__c && viagem.Pago_pela_empresa__c != valorAntigoDoCampoPagoEmpresa) {
                          
                   //Criar notificação
                    Messaging.CustomNotification ct = new Messaging.CustomNotification(); 
                    ct.setTitle('Viagem paga'); 
                    ct.setBody('Viagem ' + viagem.Name +  ' foi paga pela empresa com sucesso!');
                    ct.setNotificationTypeId(notificationType.Id); 
                    ct.setTargetId(viagem.Colaborador__c);
                    ct.send(new Set<String> { Userinfo.getUserId() });*/
                   
                   //Criar nova tarefa
                   /*Task novaTarefa = new Task();
                   novaTarefa.Subject = 'Liberar limite';
                   novaTarefa.Priority = 'Normal';
                   novaTarefa.Status = 'Não Iniciada';
                   novaTarefa.Description = 'Descrição da tarefa';
                   novaTarefa.ActivityDate = Date.today();
               	   novaTarefa.WhatId = viagem.Id; //definir id do registro ao qual a tarefa está relacionada
                   novaTarefa.WhoId = viagem.Colaborador__c; //definir id do colaborador ao qual a tarefa está relacionada
                   novaTarefa.OwnerId = '005Hs00000DQxmWIAT';
                   
                   tasks.add(novaTarefa);
               }/*
          }
          
            if(!tasks.isEmpty()){
               insert tasks;
            }
     } else {
        System.debug('REGRA DE VALIDAÇÃO - BEFORE UPDATE');
         
         //Datetime hoje = System.today();
         //Datetime tresDiasDepois = hoje.addDays(3);
                  
         for(Viagem__c viagemNew : viagensNew){
             if(viagemNew.Data_Hora_da_Volta__c <= viagemNew.Data_Hora_da_Ida__c) {
                 viagemNew.addError('Data_Hora_da_Volta__c', 'A data de volta não pode ser inferior a data de ida.');
             }
             
             if(viagemNew.Data_Hora_da_Ida__c < tresDiasDepois) {
                 viagemNew.addError('Data_Hora_da_Ida__c', 'Só é permitido criar uma viagem com pelo menos 3 dias de antecedência da data de hoje.');
             }
             
         }
      } 
    } */

}