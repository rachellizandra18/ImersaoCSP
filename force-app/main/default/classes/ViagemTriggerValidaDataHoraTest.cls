@isTest
public class ViagemTriggerValidaDataHoraTest {
	//Objetos classes de teste
	//1 - Cobrir os cenários de negócios, ou seja, codificar um cenário similar ao real para validar o código criado
	//2 - Cobrir o código (cobrir as linhas de código) - Code coverage
	
    @TestSetup
    public static void setup() { //método que inicializa/prepara os registros que serão utilizados para cenário
		        
        //Conta, Contato da conta, Viagem
        Account conta = new Account();
        conta.Name = 'Thamires Tavares';
        conta.Limite_de_Credito__c = 10000;
        conta.Status__c = 'Ativo';
        insert conta;
        
        Contact contato = new Contact();
        contato.LastName = 'Teste';
        contato.AccountId = conta.Id;
        insert contato;
        
        Viagem__c viagem = new Viagem__c();
        viagem.Cliente__c = conta.Id;
        viagem.Colaborador__c = contato.Id;
        viagem.Custo__c = 100;
        viagem.Data_Hora_da_Ida__c = System.now().addDays(5);
        viagem.Data_Hora_da_Volta__c = viagem.Data_Hora_da_Ida__c.addDays(2);
		viagem.Origem__c = 'Origem Teste';
        viagem.Destino__c = 'Destino Teste';
        insert viagem;

    }
    
    @isTest
    public static void validarDataHoraInferiorDataIdaInsert() {
		Viagem__c viagem = [SELECT Data_Hora_da_Ida__c, Data_Hora_da_Volta__c FROM Viagem__c LIMIT 1];
        
        viagem.Data_Hora_da_Volta__c = viagem.Data_Hora_da_Ida__c.addDays(-3); //forçando o erro
        
        try {
            insert viagem;
        } catch(Exception e) {
            String error = e.getMessage();
            System.assert(error.contains('A data de volta não pode ser inferior a data de ida.'), 'Deve conter a mensagem "A data de volta não pode ser inferior a data de ida!"');
        }
    }
    
    @isTest
    public static void validarDataHoraInferiorDataIdaUpdate() {
        Viagem__c viagem = [SELECT Data_Hora_da_Ida__c, Data_Hora_da_Volta__c FROM Viagem__c LIMIT 1];
        
        viagem.Data_Hora_da_Volta__c = viagem.Data_Hora_da_Ida__c.addDays(-3); //forçando o erro
        
        try{
            update viagem;
        }catch(Exception e){
            String error = e.getMessage();
            System.assert(error.contains('A data de volta não pode ser inferior a data de ida.'), 'Deve conter a mensagem "A data de volta não pode ser inferior a data de ida!"');
        }
	}
}