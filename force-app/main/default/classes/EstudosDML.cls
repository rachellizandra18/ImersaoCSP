public class EstudosDML {
	// INSERT, UPDATE, DELETE
    public static Id createAccount(String name, String porteEmpresa, String status) {
        Account conta = new Account();
        conta.Name = name;
        conta.Porte_da_empresa__c = porteEmpresa;
        conta.Status__c = status;
        
        insert conta;
        
        return conta.Id;
    }
    
    public static void updateAccount(Id idConta, String name, String porteEmpresa, String status) {
        Account conta = new Account();
        conta.Id = idConta;
        conta.Name = name;
        conta.Porte_da_empresa__c = porteEmpresa;
        conta.Status__c = status;
        
        update conta;
    }
    
    //public static void upsertAccount(List<Account> contas){
        //try {
           // upsert contas CNPJ__c;
        //} catch (DmlException e){
         //   System.debug(e.getMessage());
        //}
   // }
    
}