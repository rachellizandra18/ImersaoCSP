public class TriggerOppLineItemHandler {

    /*
    Business Use Case: Your organization sells products to its customers through opportunities. Each opportunity can have multiple products (Opportunity Line Items) associated with it. The organization wants to keep track of the total number of products sold to each account and display it on the Account record for reporting purposes.

    Pre Work: Create a custom field on the Account object named Numero_de_Produtos__c (Number) to count the total number of products related to all Opportunities associated with the Account.
    
    */
	
    public static void run() {
        
        List<OpportunityLineItem> oldList = (List<OpportunityLineItem>) Trigger.old;
        List<OpportunityLineItem> newList = (List<OpportunityLineItem>) Trigger.new;
        Map<Id, OpportunityLineItem> oldMap = (Map<Id, OpportunityLineItem>) Trigger.oldMap;
        
        if(Trigger.isAfter && Trigger.isInsert) {
            preencherCampoNumeroDeProdutosNaConta(newList);
        } else if(Trigger.isAfter && Trigger.isDelete){
            preencherCampoNumeroDeProdutosNaConta(oldList);
        }
    }
    
    public static void preencherCampoNumeroDeProdutosNaConta(List<OpportunityLineItem> newList){
        
        Set<Id> oppIds = new Set<Id>();
        List<Account> listToUpdate = new List<Account>();
        Map<Id, Decimal> oliMap = new Map<Id,Decimal>();
        
        if(!newList.isEmpty()){
            for(OpportunityLineItem oppLine : newList){
                oppIds.add(oppLine.OpportunityId);
            }
        }
        
        if(!oppIds.isEmpty()) {
            List<Opportunity> oppList = [SELECT Id, AccountId FROM Opportunity WHERE Id IN : oppIds];
            
            if(!oppList.isEmpty()) {
                for(Opportunity opp : oppList) {
                    oliMap.put(opp.AccountId, 0);
                }
            }
            
            for(AggregateResult aggr : [SELECT count(Id) oli, Opportunity.AccountId FROM OpportunityLineItem 
                                        WHERE Opportunity.AccountId IN :oliMap.keySet() GROUP BY Opportunity.AccountId]) {
                                            
                                            oliMap.put((Id) aggr.get('AccountId'), (Decimal) aggr.get('oli'));      
                                            
                                        }
            
            for(Id accIds : oliMap.keySet()){
                Account acc = new Account();
                acc.Id = accIds;
                acc.Numero_de_Produtos__c = oliMap.get(accIds);
                listToUpdate.add(acc);
            }
            
            if(!listToUpdate.isEmpty()) {
                try {
                    update listToUpdate;
                } catch(Exception e) {
                    System.debug('Ocorreu um erro ao atualizar o registro da conta' + e.getMessage());
                }
            }
        }
    }
}