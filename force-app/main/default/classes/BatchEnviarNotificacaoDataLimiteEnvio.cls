global without sharing class BatchEnviarNotificacaoDataLimiteEnvio implements Database.Batchable<sObject>, Database.Stateful {
	
    private String query;
    
    global BatchEnviarNotificacaoDataLimiteEnvio() {}
    
    global Database.QueryLocator start(Database.BatchableContext BC) {
        Datetime dataHoraAtual = Datetime.now();
        Datetime dataSuperior = Datetime.now().addHours(1);
        this.query = 'SELECT Id, Name, Data_Limite_de_Envio__c, Notificacao_Enviada__c FROM Opportunity WHERE Data_Limite_de_Envio__c > :dataHoraAtual AND Data_Limite_de_Envio__c < :dataSuperior';
        return Database.getQueryLocator(this.query);
    }
    
    global void execute(Database.BatchableContext BC, List<Opportunity> scope) {
        
        //List<Opportunity> oportunidades = (List<Opportunity>) scope;
                
        //Id proprietario = [SELECT Id, OwnerId FROM Opportunity WHERE Id =: scope].OwnerId;
		//Set<String> destinatario = new Set<String>();
		//destinatario.add(proprietario);
		
        Set<Id> opportunityIds = new Set<Id>();
        for (Opportunity opp : scope) {
            opportunityIds.add(opp.Id);
        }
        
        Map<String, Opportunity> opportunityOwnerMap = new Map<String, Opportunity>([SELECT Id, OwnerId FROM Opportunity WHERE Id IN :opportunityIds]);
        
        Set<String> ownerIdSet = new Set<String>();
        for (Opportunity opp : scope) {
            ownerIdSet.add(opportunityOwnerMap.get(opp.Id).OwnerId);
            System.debug('Ids: ' + ownerIdSet.add(opportunityOwnerMap.get(opp.Id).OwnerId));
        }
            
        
        CustomNotificationType notificationType = [SELECT Id, DeveloperName 
                                                   FROM CustomNotificationType 
                                                   WHERE DeveloperName='NotificarDataLimiteEnvio'];
        
        for (Opportunity opp : scope) {
            if(opp.Notificacao_Enviada__c == false) {
                String assunto = 'O prazo limite de envio da oportunidade ' + opp.Name + ' é até ' + opp.Data_Limite_de_Envio__c.format() + ' horas.';
                
                 try{
                    Utils.sendCustomNotification('Aviso de prazo limite de uma oportunidade', assunto, notificationType.id, opp.Id, ownerIdSet);
                    opp.Notificacao_Enviada__c = true;
                    System.debug('Notificação enviada');
                    update scope;
                 } catch(Exception e) {
                    System.debug('Problema no envio da notificação: ' + e.getMessage());
                 }   
            }
    
        }
        
 
    }
    
    global void finish(Database.BatchableContext BC) {
        if(!Test.isRunningTest()) {
            System.debug('Rodar batch');
            //System.scheduleBatch(new BatchEnviarNotificacaoDataLimiteEnvio(), 'BatchEnviarNotificacaoDataLimiteEnvio' + Datetime.now(), 60, 200);
        }
    }
}