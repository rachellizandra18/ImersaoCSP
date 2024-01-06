public class TriggerFuncionarioHandler {

    /*
    Business Use Case: Your Company ABC Corp. wants to keep track of the highest and lowest salaries paid by each of its tech firms to gain insights into how salaries are distributed across different parts of the organization and take appropriate actions to ensure that employee salaries are fair and equitable.

    Pre Work:  You need to create 2 Custom Objects . Object – 1 : Tech_Firm__c Fields : Salario_Maximo__c (Currency) , Salario_Minimo__c (Currency)

    Object – 2 : Funcionario__c Fields : Salario__c (Currency) , Tech_Firm__c (Lookup)
    
    */
	
    public static void run() {
        List<Funcionario__c> oldList = (List<Funcionario__c>) Trigger.old;
        List<Funcionario__c> newList = (List<Funcionario__c>) Trigger.new;
        Map<Id, Funcionario__c> oldMap = (Map<Id, Funcionario__c>) Trigger.oldMap;
        
        if(Trigger.isAfter && Trigger.isUpdate) {
			preencherCamposMaxEMinSalario(newList, oldMap);            
        } else if (Trigger.isAfter && Trigger.isDelete) {
            preencherCamposMaxEMinSalario(oldList, null);
        } else {
            preencherCamposMaxEMinSalario(newList, null);
        }
        
    }
    
    public static void preencherCamposMaxEMinSalario(List<Funcionario__c> newList, Map<Id, Funcionario__c> oldMap) {
        Set<Id> funcionarioIds = new Set<Id>();
        
        if(!newList.isEmpty()) {
            for(Funcionario__c newFunc : newList) {
                
                if(oldMap != null) {
                    Funcionario__c oldFuncionario = oldMap.get(newFunc.Id);   
                    
                    if(oldFuncionario.Tech_Firm__c != newFunc.Tech_Firm__c) {
                        funcionarioIds.add(oldFuncionario.Tech_Firm__c);
                        funcionarioIds.add(newFunc.Tech_Firm__c);
                    } else {
                        funcionarioIds.add(newFunc.Tech_Firm__c);
                    }
                } else {
                    funcionarioIds.add(newFunc.Tech_Firm__c);
                }
                
            }
        }
        
        List<AggregateResult> aggrList = [SELECT Tech_Firm__c tfId, MAX(Salario__c) salarioMaximo, MIN(Salario__c) salarioMinimo
                                         FROM Funcionario__c WHERE Tech_Firm__c IN :funcionarioIds GROUP BY Tech_Firm__c];
        
        Map<Id, Tech_Firm__c> mapToUpdate = new Map<Id, Tech_Firm__c>();
        
        for(Id ids : funcionarioIds) {
            Tech_Firm__c tf = new Tech_Firm__c();
            tf.Id = ids;
            tf.Salario_Maximo__c = 0;
            tf.Salario_Minimo__c = 0;
            mapToUpdate.put(ids, tf);
        }
        
        if(!aggrList.isEmpty()) {
            for(AggregateResult aggr : aggrList) {
                Tech_Firm__c tf = new Tech_Firm__c();
                tf.Id = (Id) aggr.get('tfId');
                tf.Salario_Maximo__c = (Decimal) aggr.get('salarioMaximo');
                tf.Salario_Minimo__c = (Decimal) aggr.get('salarioMinimo');
                mapToUpdate.put(tf.Id, tf);
            }
        }
        
        if(!mapToUpdate.isEmpty()) {
            update mapToUpdate.values();
        }
    }
}