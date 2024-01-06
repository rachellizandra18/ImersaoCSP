public class PagamentoTriggerAlteraPagamento {
	private List<Pagamento__c> newListPagamento;
    private Map<Id, Pagamento__c> oldMapPagamento;
    private Map<Id, Pagamento__c> filteredMapPagamento = new Map<Id, Pagamento__c>();
    private Boolean hasRecords;
    
    public PagamentoTriggerAlteraPagamento(List<Pagamento__c> newListPagamento, Map<Id, Pagamento__c> oldMapPagamento) {
        this.newListPagamento = newListPagamento;
        this.oldMapPagamento = oldMapPagamento;
        filter();
        this.hasRecords = (filteredMapPagamento.isEmpty()) ? false : true;
    }
    
    private void filter() {
        
        for(Pagamento__c pagamento : newListPagamento) {
            String valorAntigoPagamentoPago = oldMapPagamento.get(pagamento.Id).Status__c;
            
            if(pagamento.Status__c == 'Pago' && pagamento.Status__c != valorAntigoPagamentoPago) {
				filteredMapPagamento.put(pagamento.Id, pagamento);
            }
          }                
        }    
    
    
    public void run() {
        if(hasRecords) {            
            List<Viagem__c> viagemFiltrada = [SELECT Id FROM Viagem__c WHERE Pagamento__c IN :filteredMapPagamento.keySet()];
            List<Despesa__c> despesaFiltrada = [SELECT Id FROM Despesa__c WHERE Pagamento__c IN :filteredMapPagamento.keySet()];
            
            if(!viagemFiltrada.isEmpty()) {
                
            for(Viagem__c viagem : viagemFiltrada) {
                viagem.Pago_pela_empresa__c = true;
            	update viagemFiltrada;
            	}     
            }

            if(!despesaFiltrada.isEmpty()) {
                
            for(Despesa__c despesa : despesaFiltrada) {
               despesa.Pago__c = true;
               despesa.Status__c = 'Pago_pela_empresa';
               update despesaFiltrada;
           		 }           
            }
            
        }
    }
  
}