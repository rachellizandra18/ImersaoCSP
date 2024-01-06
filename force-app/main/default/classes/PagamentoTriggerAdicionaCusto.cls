public class PagamentoTriggerAdicionaCusto {
    
    private List<Pagamento__c> newListPagamento;
    private Map<Id, Pagamento__c> oldMapPagamento;
    private Map<Id, Decimal> mapViagemCusto = new Map<Id, Decimal>();
    private Map<Id, Decimal> mapDespesaCusto = new Map<Id, Decimal>();
    private List<Pagamento__c> pagamentosToUpdate = new List<Pagamento__c>();
	
    public PagamentoTriggerAdicionaCusto(List<Pagamento__c> newListPagamento, Map<Id, Pagamento__c> oldMapPagamento) {
       this.newListPagamento = newListPagamento;
       this.oldMapPagamento = oldMapPagamento;
       filter();
    }
    
    private void filter() {
        
        for(Pagamento__c pagamento : newListPagamento){
            //String valorAntigoPagamentoPago = oldMapPagamento.get(pagamento.Id).Status__c != null ? oldMapPagamento.get(pagamento.Id).Status__c : 'Aguardando Pagamento'; 
            
            if(pagamento.Status__c == 'Pago' /*&& pagamento.Status__c != valorAntigoPagamentoPago*/) {

                for (AggregateResult result : [SELECT Pagamento__c, SUM(Custo__c) FROM Viagem__c WHERE Pagamento__c = :pagamento.Id GROUP BY Pagamento__c]) {
                    this.mapViagemCusto.put((Id) result.get('Pagamento__c'), (Decimal) result.get('expr0'));
                }

                for (AggregateResult result : [SELECT Pagamento__c, SUM(Custo__c) FROM Despesa__c WHERE Pagamento__c = :pagamento.Id GROUP BY Pagamento__c]) {
                    this.mapDespesaCusto.put((Id) result.get('Pagamento__c'), (Decimal) result.get('expr0'));
                }
                
                this.pagamentosToUpdate.add(pagamento);
            }
        }
        
    }
    
    public void run() {

        for (Pagamento__c pagamento : pagamentosToUpdate) {
        	Decimal valorTotalCustoViagem = mapViagemCusto.get(pagamento.Id) != null ? mapViagemCusto.get(pagamento.Id) : 0;
            System.debug('Valor Viagem' + valorTotalCustoViagem);
			Decimal valorTotalCustoDespesa = mapDespesaCusto.get(pagamento.Id) != null ? mapDespesaCusto.get(pagamento.Id) : 0;
            
            pagamento.Valor_Total_Viagens__c = valorTotalCustoViagem;
            pagamento.Valor_Total_Despesas__c = valorTotalCustoDespesa;
            
            update pagamento;
        }
        
     //update pagamentosToUpdate;
                       
    }   
}