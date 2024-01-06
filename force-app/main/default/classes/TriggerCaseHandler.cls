public class TriggerCaseHandler {

    /*
    Business Use Case: Automate the assignment of an “Account Rating” to Accounts based on the number of closed Cases associated with each Account.
    */
    public static void run() {
        List<Case> oldList = (List<Case>) Trigger.old;
        List<Case> newList = (List<Case>) Trigger.new;
        Map<Id, Case> oldMap = (Map<Id, Case>) Trigger.oldMap;

        if(Trigger.isAfter && Trigger.isInsert) {

        } else if (Trigger.isAfter && Trigger.isUpdate){

        }
    }

    public static void alterarCampoRatingNaContaParaCasosFechados(List<Case> newList, Map<Id, Case> oldMap){
        Set<Id> accountIds = new Set<Id>();
        Map<Id, Integer> mapCasosCount = new Map<Id, Integer>();
        List<Account> listToUpdate = new List<Account>();

        if(!newList.isEmpty()){
            for(Case caso : newList){

                if(!oldMap.isEmpty()){
                    Case oldCase = oldMap.get(caso.Id);

                    if(oldCase != null){
                        accountIds.add(caso.AccountId);
                        accountIds.add(oldCase.AccountId);
                    } else if(oldCase.IsClosed != caso.IsClosed){
                        accountIds.add(caso.AccountId);
                    } else if(caso.IsClosed == true){
                        accountIds.add(caso.AccountId);
                    }
                }
                
            }
        }

        if(!accountIds.isEmpty()){
            List<AggregateResult> results = [SELECT AccountId, count(Id) casosId FROM Case WHERE AccountId IN :accountIds AND IsClosed = true GROUP BY AccountId];

            for(AggregateResult aggr : results){
                Id accountId = (Id) aggr.get('AccountId');
                Integer countCasos = (Integer) aggr.get('casosId');
                mapCasosCount.put(accountId, countCasos);
            }

            List<Account> listContas = [SELECT Id, Rating FROM Account WHERE Id IN :accountIds];

            if(!listContas.isEmpty()){
                for(Account conta : listContas){
                    Integer countCasos = mapCasosCount.containsKey(conta.Id) ? mapCasosCount.get(conta.Id) : 0;
                    if(countCasos > 5){
                        conta.Rating = 'Hot';
                    } else if(countCasos > 2){
                        conta.Rating = 'Warm';
                    } else {
                        conta.Rating = 'Cold';
                    }

                    listToUpdate.add(conta);
                }
            }

        }

        if(!listToUpdate.isEmpty()){
            update listToUpdate;
        }

    }
}