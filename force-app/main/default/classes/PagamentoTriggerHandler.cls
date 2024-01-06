public class PagamentoTriggerHandler extends TriggerHandler {
	private List<Pagamento__c> newList;
    private List<Pagamento__c> oldList;
    private Map<Id, Pagamento__c> newMap;
    private Map<Id, Pagamento__c> oldMap;
    
    public PagamentoTriggerHandler() {
        this.newList = (List<Pagamento__c>) Trigger.new;
        this.oldList = (List<Pagamento__c>) Trigger.old;
        this.newMap = (Map<Id, Pagamento__c>) Trigger.newMap;
        this.oldMap = (Map<Id, Pagamento__c>) Trigger.oldMap;
        
        if(this.oldList == null) this.oldList = new List<Pagamento__c>();
        if(this.oldMap == null) this.oldMap = new Map<Id, Pagamento__c>();
    }
    
    protected override void beforeInsert() {
        
    }
    
    protected override void afterInsert() {
      new PagamentoTriggerAdicionaCusto(this.newList, this.oldMap).run();
    }
    
    protected override void beforeUpdate() {
    }
    
    protected override void afterUpdate() {
        new PagamentoTriggerAlteraPagamento(this.newList, this.oldMap).run();
    }
}