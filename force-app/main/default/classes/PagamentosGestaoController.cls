public class PagamentosGestaoController {
    
    @AuraEnabled(cacheable=true) //faz a comunicação com o LWC (ou Aura component) com o APEX
    public static List<Account> getClientesAtivos() {
       return [SELECT Name FROM Account WHERE Status__c = 'Ativo' AND RecordType.Name = 'Cliente'];
    }
	
    @AuraEnabled //faz a comunicação com o LWC (ou Aura component) com o APEX
    public static List<Viagem__c> getViagens(Id contaId, Date dataInicio, Date dataFim) {
        return [SELECT Origem__c, Destino__c, Custo__c, Data_Hora_da_Ida__c, Data_Hora_da_Volta__c, Colaborador__r.Name, Colaborador__r.FirstName FROM Viagem__c 
                WHERE Data_Hora_da_Ida__c >= :dataInicio AND Data_Hora_da_Ida__c <= :dataFim 
                AND Cliente__c = :contaId
                AND Pagamento__c = null
                ORDER BY Data_Hora_da_Ida__c
               ];
    }
    
    
    @AuraEnabled //faz a comunicação com o LWC (ou Aura component) com o APEX
    public static List<Despesa__c> getDespesas(Id contaId, Date dataInicio, Date dataFim) {
        return [SELECT Custo__c, Descricao__c, Data_da_Despesa__c, Colaborador__r.Name, Colaborador__r.FirstName FROM Despesa__c 
                WHERE Data_da_Despesa__c >= :dataInicio AND Data_da_Despesa__c <= :dataFim 
                AND Cliente__c = :contaId
                AND Pagamento__c = null
                ORDER BY Data_da_Despesa__c
               ];
    }
    
    @AuraEnabled
    public static Pagamento__c criarPagamento(Id contaId, List<Viagem__c> viagens, List<Despesa__c> despesas) {
        
        Pagamento__c pagamento = new Pagamento__c();
        pagamento.Cliente__c = contaId;
        pagamento.Status__c = 'Aguardando Pagamento';
        insert pagamento;
        
        Decimal valorTotalCustoViagem = 0;
        if(!viagens.isEmpty()) {
            for(Viagem__c viagem : viagens) {
                viagem.Pagamento__c = pagamento.Id;
                valorTotalCustoViagem += viagem.Custo__c;
            }
            update viagens;
        }
        
        Decimal valorTotalCustoDespesa = 0;
        if(!despesas.isEmpty()) {
            for(Despesa__c despesa : despesas) {
                despesa.Pagamento__c = pagamento.Id;
                valorTotalCustoDespesa += despesa.Custo__c;
            }
            update despesas;
        }
        
        pagamento.Valor_Total_Despesas__c = valorTotalCustoDespesa;
        pagamento.Valor_Total_Viagens__c = valorTotalCustoViagem;
        update pagamento;
        
       //update new Pagamento__c(Id=pagamento.Id, ValorTotalViagens__c=valorTotalCustoViagem, ValorTotalDespesas__c=valorTotalCustoDespesa);
        
        Formula.recalculateFormulas(new List<Pagamento__c>{pagamento});
        
        return pagamento;
    }
    
    
    //Não está sendo usado, mas fiz para que vocês possam estudar como retornar uma classe customizada para um LWC ou AURA especifico
    public class Pagamento{
        @AuraEnabled
        public Id pagamentoId;
        @AuraEnabled
        public Decimal valorTotal;
        
        public Pagamento(Id pagamentoId, Decimal valorTotal){
            this.pagamentoId = pagamentoId;
            this.valorTotal = valorTotal;
        }
    }


}