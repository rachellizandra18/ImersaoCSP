@isTest
public class BatchEnviarNotifDataLimiteEnvioTest {
	@TestSetup
    static void makeData() {
        Account conta = new Account();
        conta.Name = 'Rachel Lizandra';
        conta.Limite_de_Credito__c = 10000;
        conta.Status__c = 'Ativo';
        insert conta;
        
        Opportunity opp = new Opportunity();
        opp.AccountId = conta.Id;
        opp.Name = 'Teste enviar notificação';
        opp.StageName = 'Prospecting';
        opp.Data_Limite_de_Envio__c = System.now().addMinutes(30);
        opp.CloseDate = System.Today().addDays(10);
        insert opp;
    }
    
    @isTest
    public static void batchEnviarNotificacaoDataEnvioLimite() {
        
        Test.startTest();
        BatchEnviarNotificacaoDataLimiteEnvio batchJob = new BatchEnviarNotificacaoDataLimiteEnvio();
        //System.scheduleBatch(batchJob, 'BatchEnviarNotificacaoDataLimiteEnvio' + Datetime.now(), 30, 200);
        Database.executeBatch(batchJob);
        Test.stopTest();
        
        List<AsyncApexJob> aJList = [SELECT ApexClassId, Id, Status FROM AsyncApexJob WHERE ApexClassId IN (SELECT Id FROM ApexClass WHERE Name = 'BatchEnviarNotificacaoDataLimiteEnvio')];
        if (!aJList.isEmpty()) {
            System.assertEquals('Completed', aJList[0].Status);
        }
    }
}