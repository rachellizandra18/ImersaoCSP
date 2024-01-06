public class EstudosSOQL {
    public static Account getAccount(String name){
        List<Account> contas = [SELECT Id, Name, Status__c, Porte_da_Empresa__c FROM Account WHERE Name = :name];
        
        if(!contas.isEmpty()) {
            return contas[0];
        } else {
            return null;
        }
    }
    
    public static List<Despesa__c> getDesepesasByClienteCompanhia(String cliente, String colaborador) {
        List<Despesa__c> despesas = [SELECT Id, Name, Cliente__r.Name, Colaborador__r.Name FROM Despesa__c WHERE Cliente__r.Name = :cliente AND Colaborador__r.Name = :colaborador];
        
        if(!despesas.isEmpty()) {
            return despesas;
        } else {
            return null;
        }
    }
    
    public static List<Viagem__c> getViagensByClienteCompanhia(String cliente, String companhia) {
        List<Viagem__c> viagens = [SELECT Id, Name, Cliente__r.Name, Companhia__r.Name FROM Viagem__c WHERE Cliente__r.Name = :cliente AND Companhia__r.Name = :companhia];
        
        if(!viagens.isEmpty()) {
            return viagens;
        } else {
            return null;
        }
    }
    
    public static List<Account> getClientesDespesasEViagens() {
        String recordType = 'Cliente';
        List<Account> contas1 = [SELECT Name, Status__c,
                                (SELECT Custo__c FROM Despesas__r), 
                                (SELECT Custo__c FROM Viagens__r)
                                FROM Account WHERE RecordType.DeveloperName = :recordType];
        
        if(!contas1.isEmpty()) {
            return contas1;
        } else {
            return null;
        }
            
    }
    
    public static Decimal getTotalCustoDespesas(String empresa) {
        AggregateResult[] groupedResults = [SELECT Cliente__r.Name, SUM(Custo__c) custo
                                           FROM Despesa__c 
                                           WHERE Cliente__r.Name = :empresa GROUP BY Cliente__r.Name];
    	
    	Decimal totalCusto = (Decimal) groupedResults[0].get('custo');
        
        return totalCusto;
    }
}