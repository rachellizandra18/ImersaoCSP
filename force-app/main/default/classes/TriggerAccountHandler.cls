public class TriggerAccountHandler {

    /*
    Business Use Case: Let’s say a sales rep is working on an account and marks the “Close_all_Opps__c” field as true. Without this trigger, they would have to manually go through each open opportunity for that account and close them as won, which can be time-consuming and prone to errors. With this trigger in place, the opportunities will be automatically closed as won if they meet the criteria specified in the code.

    Pre Work: Create a custom checkbox field on Account named Fechar_Oportunidades__c.
    */
    
    public static void run() {
        List<Account> oldList = (List<Account>) Trigger.old;
        List<Account> newList = (List<Account>) Trigger.new;
        Map<Id, Account> oldMap = (Map<Id, Account>) Trigger.oldMap;
        
        if(Trigger.isAfter && Trigger.isUpdate) {
            alterarOportunidadesParaFechadasGanhas(newList, oldMap);
            atualizarTelefoneDeContatosRelacionadosAConta(newList, oldMap);
        } else if(Trigger.isBefore && (Trigger.isInsert || Trigger.isUpdate)){
            validarDuplicidadeDeCPFOuCNPJ(newList, oldMap);
        }
    }
    
    public static void alterarOportunidadesParaFechadasGanhas(List<Account> newList, Map<Id, Account> oldMap) {
        Set<Id> contaIds = new Set<Id>();
        
        if(!newList.isEmpty()) {
            for(Account conta : newList) {
                System.debug(conta.Fechar_Oportunidades__c);
                System.debug(oldMap.containsKey(conta.Id));
                System.debug(oldMap.containsKey(conta.Id));
                System.debug(oldMap.get(conta.Id).Fechar_Oportunidades__c);
                if(conta.Fechar_Oportunidades__c == true && oldMap.containsKey(conta.Id) && oldMap.get(conta.Id).Fechar_Oportunidades__c == false) {
                    contaIds.add(conta.Id);
                    System.debug(contaIds);
                }
            }
        }
        
        if(!contaIds.isEmpty()) {
            List<Opportunity> oppList = [SELECT Id, AccountId, StageName FROM Opportunity WHERE AccountId IN :contaIds AND StageName != 'Fechado/Ganho'];
            List<Opportunity> listToUpdate = new List<Opportunity>();
            
            if(oppList != null) {
                for (Opportunity opp : oppList) {
                    opp.StageName = 'Fechado/Ganho';
                    opp.CloseDate = Date.today();
                    listToUpdate.add(opp);
                }
            }
            
            if(!listToUpdate.isEmpty()) {
                update listToUpdate;
                System.debug(listToUpdate);
            }
            
        }
        
    }

    public static void atualizarTelefoneDeContatosRelacionadosAConta(List<Account> contas, Map<Id, Account> oldMap){
        /*
        Your team uses Salesforce to manage customer accounts and contacts, and you want to ensure that all contacts associated with a particular account have the same phone number as the account.
        */
        Map<Id, Account> accountMap = new Map<Id, Account>();

        if(!contas.isEmpty()){
            for(Account conta : contas){
                if(conta.Phone != oldMap.get(conta.Id).Phone){
                    accountMap.put(conta.Id, conta);
                }
            }
        }

        List<Contact> contatosList = [SELECT Id, Phone, AccountId FROM Contact WHERE AccountId IN :accountMap.keySet()];
        List<Contact> contatosUpdate = new List<Contact>();

        if(!contatosList.isEmpty()){
            for(Contact contato : contatosList){
                contato.Phone = accountMap.get(contato.AccountId).Phone;
                contatosUpdate.add(contato);
            }
        }

        if(!contatosUpdate.isEmpty()){
            try {
                update contatosUpdate;
            } catch(Exception e) {
                System.debug('Um problema ocorreu ao atualizar os contatos: ' + e.getMessage());
            }
        }
    }

    public static void validarDuplicidadeDeCPFOuCNPJ(List<Account> contas, Map<Id, Account> oldMap){
        List<Account> accountList = contas;

        Map<String, Account> accMap = new Map<String, Account>();

        for(Account conta : accountList){
            if(Trigger.isInsert){
                if(conta.CPF_CNPJ__c != null){
                    accMap.put(conta.CPF_CNPJ__c, conta);
                }
            } else {
                if(conta.CPF_CNPJ__c != null && conta.CPF_CNPJ__c != oldMap.get(conta.Id).CPF_CNPJ__c){
                    accMap.put(conta.CPF_CNPJ__c, conta);
                }
            }
        }

        if(!accMap.isEmpty()){
            for(Account conta : [SELECT Id, CPF_CNPJ__c FROM Account WHERE CPF_CNPJ__c IN : accMap.keySet()]){
                accMap.get(conta.CPF_CNPJ__c).addError('O CPF/CNPJ informado já existe!');
            }
        }
    }
}