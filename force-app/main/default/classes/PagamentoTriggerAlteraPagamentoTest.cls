@isTest
public class PagamentoTriggerAlteraPagamentoTest {
	
    @TestSetup
    public static void setup() {
        
        Account contaCliente = new Account();
        contaCliente.RecordTypeId = '012Hs000000pezqIAA';
        contaCliente.Name = 'Rachel Lizandra';
        contaCliente.Status__c = 'Ativo';
        contaCliente.Porte_da_empresa__c = 'Pequeno';
        contaCliente.Limite_de_Credito__c = 4000.50;
        insert contaCliente;
        
        Account contaCompanhia = new Account();
        contaCompanhia.RecordTypeId = '012Hs000000pezvIAA';
        contaCompanhia.Name = 'GOL';
        contaCompanhia.Tipo_de_Companhia__c = 'Aérea';
        insert contaCompanhia;
        
        Contact contato = new Contact();
        contato.LastName = 'Teste';
        contato.AccountId = contaCliente.Id;
        insert contato;
        
        Pagamento__c pagamento = new Pagamento__c();
        pagamento.Cliente__c = contaCliente.Id; 
        pagamento.Status__c = 'Aguardando Pagamento';
        insert pagamento;
        
        Viagem__c viagem = new Viagem__c();
        viagem.Cliente__c = contaCliente.Id;
        viagem.Colaborador__c = contato.Id;
        viagem.Companhia__c = contaCompanhia.Id;
        viagem.Custo__c = 100;
        viagem.Data_Hora_da_Ida__c = System.now().addDays(1);
        viagem.Data_Hora_da_Volta__c = viagem.Data_Hora_da_Ida__c.addDays(4);
		viagem.Origem__c = 'Origem Teste Pagamento';
        viagem.Destino__c = 'Destino Teste Pagamento';
        viagem.Pagamento__c = pagamento.Id;
        insert viagem;
        
        Despesa__c despesa = new Despesa__c();
        despesa.Name = 'Hotel California';
        despesa.Cliente__c = contaCliente.Id;
        despesa.Colaborador__c = contato.Id;
        despesa.Custo__c = 300;
        despesa.Viagem__c = viagem.Id;
        despesa.Status__c = 'Novo';
        despesa.Data_da_Despesa__c = System.today().addDays(2);
        despesa.Descricao__c = 'testando despesa';
        despesa.Pagamento__c = pagamento.Id;
        insert despesa;
        
    }
    
    @isTest
    public static void validarAlteracaoDePagamentoViagemEDespesaUpdate() {
        
        List<Viagem__c> viagensPagasAntesDeRealizarPagamento = [SELECT Id, Pago_pela_empresa__c FROM Viagem__c WHERE Pago_pela_empresa__c = true];
        List<Despesa__c> despesasPagasAntesDeRealizarPagamento = [SELECT Id, Pago__c FROM Despesa__c WHERE Pago__c = true];
        
        System.assertEquals(0, viagensPagasAntesDeRealizarPagamento.size(), 'Até o momento nenhuma viagem foi paga');
        System.assertEquals(0, despesasPagasAntesDeRealizarPagamento.size(), 'Até o momento nenhuma despesa foi paga');
        
        Pagamento__c pagamento = [SELECT Id, Status__c FROM Pagamento__c];
        
        pagamento.Status__c = 'Pago';
        update pagamento;
        
        List<Viagem__c> viagensPagasAposRealizarPagamento = [SELECT Id, Pago_pela_empresa__c FROM Viagem__c WHERE Pago_pela_empresa__c = true];
        List<Despesa__c> despesasPagasAposRealizarPagamento = [SELECT Id, Pago__c FROM Despesa__c WHERE Pago__c = true];
        
        System.assertEquals(1, viagensPagasAposRealizarPagamento.size(), 'Até o momento uma viagem foi paga');
        System.assertEquals(1, despesasPagasAposRealizarPagamento.size(), 'Até o momento uma despesa foi paga');
        
    }
}