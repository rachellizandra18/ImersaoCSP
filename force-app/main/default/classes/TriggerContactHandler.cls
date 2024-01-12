public class TriggerContactHandler {
	
    public static void run(){
        List<Contact> newList = (List<Contact>) Trigger.new;
        Map<Id, Contact> oldMap = (Map<Id, Contact>) Trigger.oldMap;
        
        if(Trigger.isBefore && (Trigger.isInsert || Trigger.isUpdate)){
            valida2ContatosNaMesmaConta(newList);
            validaDuplicacaoDeEmailETelefone(newList, oldMap);
        }
    }
    
    public static void valida2ContatosNaMesmaConta(List<Contact> newList){
        Set<Id> contaIds = new Set<Id>();
        
        if(!newList.isEmpty()){
            for(Contact contato : newList){
                if(contato.AccountId != null){
                    contaIds.add(contato.AccountId);
                }
            }            
        }
        
        if(!contaIds.isEmpty()){
			List<AggregateResult> aggregate = [SELECT count(Id) conIds, AccountId FROM Contact WHERE AccountId IN :contaIds GROUP BY AccountId];
            Map<Id, Integer> contatoMap = new Map<Id, Integer>();
            
            if(!aggregate.isEmpty()){
                for(AggregateResult aggr : aggregate){
                    contatoMap.put((Id)aggr.get('AccountId'), (Integer)aggr.get('conIds'));
                }
            }
            
            if(!newList.isEmpty()){
                for(Contact contato : newList){
                    if(contato.AccountId != null && contatoMap.containsKey(contato.AccountId) && contatoMap.get(contato.AccountId) > 2){
                        contato.addError('Não é possível cadastrar ou alterar um contato, pois já existem 2 ou mais contatos relacionados a essa conta.');
                    }
                }
            }
        }
    }
    
    public static void validaDuplicacaoDeEmailETelefone(List<Contact> newList, Map<Id, Contact> oldMap){
        
        Map<String, Contact> mapEmails = new Map<String, Contact>();
        Map<String, Contact> mapTelefones = new Map<String, Contact>();
        
            for(Contact contato : newList){
                if(Trigger.isInsert){  
                    if(!newList.isEmpty()){
                        if(contato.Email != null){
                            mapEmails.put(contato.Email, contato);
                        }
                        
                        if(contato.Phone != null){
                            mapTelefones.put(contato.Phone, contato);
                        }
                    }
                    
                } else {
                    if(contato.Phone != oldMap.get(contato.Id).Phone){
                        mapTelefones.put(contato.Phone, contato);
                    }
                    
                    if(contato.Email != oldMap.get(contato.Id).Email){
                        mapEmails.put(contato.Email, contato);
                    }
                }
            }
        
        
            System.debug('Emails ' + mapEmails);
            System.debug('Telefones ' + mapTelefones);
            System.debug('new List ' + newList);
        
        if((!mapEmails.isEmpty() && !mapTelefones.isEmpty()) && !newList.isEmpty()){
            for(Contact contato : [SELECT Id, Email, Phone FROM Contact WHERE Email IN :mapEmails.keySet() AND Phone IN :mapTelefones.keySet()]){
                mapEmails.get(contato.Email).addError('O email ou telefone informados já constam no contato');
            }
        }
    }
}