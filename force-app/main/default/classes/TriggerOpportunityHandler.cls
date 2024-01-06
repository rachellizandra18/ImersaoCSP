public class TriggerOpportunityHandler {

    public static void run() {
        List<Opportunity> oldList = (List<Opportunity>) Trigger.old;
        List<Opportunity> newList = (List<Opportunity>) Trigger.new;
        Map<Id, Opportunity> oldMap = (Map<Id, Opportunity>) Trigger.oldMap;
        
        if(Trigger.isAfter && Trigger.isUpdate) {
            preencherCampoMaxOppNaConta(newList, oldMap);
            criarOuAtualizaTaskQuandoStatusOppAtualizar(newList, oldMap);
        } else if (Trigger.isAfter && Trigger.isDelete) {
            preencherCampoMaxOppNaConta(oldList, null);
        } else {
            preencherCampoMaxOppNaConta(newList, null);
        }
    }
    
    public static void preencherCampoMaxOppNaConta(List<Opportunity> oppList, Map<Id, Opportunity> oldMap) {

        /*
        Business Use Case: A Sales Organization wants to track the largest Opportunity associated with each of its Accounts. This information could be used to prioritize sales efforts, allocate resources, or identify opportunities for cross-selling or upselling.

        Pre Work: Create a Custom field on Account Object named Oportunidade_Maxima__c (Text) to store Opportunity Name.
        */
        Set<Id> parentIds = new Set<Id>();
        
        if(!oppList.isEmpty()) {
            for(Opportunity newOpp : oppList) {
                
                if(oldMap != null) {
                    Opportunity oldOpp = oldMap.get(newOpp.Id);
                    
                    if(oldOpp.AccountId != newOpp.AccountId) {
                        parentIds.add(oldOpp.AccountId);
                        parentIds.add(newOpp.AccountId);
                    } else {
                        parentIds.add(newOpp.AccountId);
                    }
                } else {
                    parentIds.add(newOpp.AccountId);
                }                  
            }
        }
        
        if(!parentIds.isEmpty()){
            List<Account> accList = [SELECT Oportunidade_Maxima__c,(SELECT Name,Amount FROM Opportunities WHERE Amount != null
										ORDER BY Amount DESC LIMIT 1) FROM Account WHERE Id IN : parentIds];
            
            List<Account> accListUpdate = new List<Account>();
            
            if(!accList.isEmpty()) {
                for(Account conta : accList) {
                    if(!conta.Opportunities.isEmpty()) {
                        conta.Oportunidade_Maxima__c = conta.Opportunities[0].Name;
                        accListUpdate.add(conta);
                    } else {
                        conta.Oportunidade_Maxima__c = '';
                        accListUpdate.add(conta);
                    }
                }
                
                update accListUpdate;
            }
        }
    }
    
    
    public static void criarOuAtualizaTaskQuandoStatusOppAtualizar(List<Opportunity> newList, Map<Id, Opportunity> oldMap){

        /*
        Business Use Case : Your company XYZ corp. wants to automate the creation of follow-up tasks for sales representatives whenever an opportunity’s stage changes in the Salesforce org.
        */

        Set<Id> oppIds = new Set<Id>();
        List<Task> listTaskToInsert = new List<Task>();
        List<Task> listTaskToUpdate = new List<Task>();
        
        if(!newList.isEmpty()){
            for(Opportunity opp : newList) {
                if(opp.StageName != oldMap.get(opp.Id).StageName){
                    oppIds.add(opp.Id);
                }
            }
        }
        
        if(!oppIds.isEmpty()) {
            List<Task> taskList = [SELECT Id, WhatId, Description FROM Task WHERE WhatId IN :oppIds];
            Map<Id, Task> mapTask = new Map<Id, Task>();
            
            if(!taskList.isEmpty()) {
                for(Task tarefa : taskList){
                    mapTask.put(tarefa.Id, tarefa);
                }
            }
            
            for(Opportunity opp : newList){
                if(opp.StageName != 'Fechado/Ganho'){
                    if(mapTask.containsKey(opp.Id)) {
                        Task tarefa = mapTask.get(opp.Id);
                        tarefa.Description = 'Oportunidade ' + opp.Name + ' foi atualizada para o status ' + opp.StageName + '. Faça o follow-up.'; 
                        listTaskToUpdate.add(tarefa);
                    } else {
                        Task tarefa = new Task();
                        tarefa.Subject = 'Follow-up de oportunidade';
                        tarefa.Description = 'Oportunidade ' + opp.Name + ' foi atualizada para o status ' + opp.StageName + '. Faça o follow-up.';
                        tarefa.OwnerId = opp.OwnerId; // ou UserInfo.getUserId();
                        tarefa.WhatId = opp.Id;
                        tarefa.ActivityDate = Date.today();
                        tarefa.Status = 'Não Iniciada';
                        listTaskToInsert.add(tarefa);
                    }
                }
            }
        }
        
        try {
            if(!listTaskToInsert.isEmpty()){
                insert listTaskToInsert;
            } 
            
            if(!listTaskToUpdate.isEmpty()){
                update listTaskToUpdate;
            }
        } catch(Exception e){
            
        }
    }
}