global without sharing class BatchEnviaNotificacaoOppVencida implements Database.Batchable<sObject>, Database.Stateful {
	
    private String query;
    
    global BatchEnviaNotificacaoOppVencida(){}
    
    global Database.QueryLocator start(Database.BatchableContext BC){
        Date dataAtual = Date.today();
        this.query = 'SELECT Id, Name, CloseDate, isClosed, Oportunidade_Vencida__c FROM Opportunity WHERE CloseDate < :dataAtual AND isClosed = false';
        return Database.getQueryLocator(this.query);
    }
    
    global void execute(Database.BatchableContext BC, List<Opportunity> scope) {
        
        Set<Id> oppIds = new Set<Id>();
        for(Opportunity opp : scope){
            oppIds.add(opp.Id);
        }
        
        Map<String, Opportunity> opportunityOwnerMap = new Map<String, Opportunity>([SELECT Id, OwnerId FROM Opportunity WHERE Id IN :oppIds]);
		Set<String> ownerId = new Set<String>();
        
        for(Opportunity opp : scope){
            ownerId.add(opportunityOwnerMap.get(opp.Id).OwnerId);
        }
        
        CustomNotificationType notificationType = [SELECT Id, DeveloperName 
                                                   FROM CustomNotificationType 
                                                   WHERE DeveloperName='NotificarOppVencida'];
        
        for (Opportunity opp : scope) {
            if(opp.Oportunidade_Vencida__c == false) {
                String assunto = 'A oportunidade ' + opp.Name + ' está vencida e ainda em aberto.';
                
                try{
                    Utils.sendCustomNotification('Aviso de prazo de fechamento de uma oportunidade', assunto, notificationType.id, opp.Id, ownerId);
                    opp.Oportunidade_Vencida__c = true;
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
            //System.scheduleBatch(new BatchEnviaNotificacaoOppVencida(), 'BatchEnviaNotificacaoOppVencida' + Datetime.now(), 600, 200);
        }
    }
}