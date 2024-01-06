public class ViagemTriggerHandler extends TriggerHandler{
	private List<Viagem__c> newList;
    private List<Viagem__c> oldList;
    private Map<Id, Viagem__c> newMap;
    private Map<Id, Viagem__c> oldMap;
    
    public ViagemTriggerHandler() {
        this.newList = (List<Viagem__c>) Trigger.new;
        this.oldList = (List<Viagem__c>) Trigger.old;
        this.newMap = (Map<Id, Viagem__c>) Trigger.newMap;
        this.oldMap = (Map<Id, Viagem__c>) Trigger.oldMap;
        
        if(this.oldList == null) this.oldList = new List<Viagem__c>();
        if(this.oldMap == null) this.oldMap = new Map<Id, Viagem__c>();
    }
    
    protected override void beforeInsert() {
        new ViagemTriggerValidaDataHora(this.newList, this.oldMap).run();
        new ViagemTriggerValidaViagensExistentes(this.newList, this.oldMap).run();
    }
    
    protected override void afterInsert() {}
    
    protected override void beforeUpdate() {
        new ViagemTriggerValidaDataHora(this.newList, this.oldMap).run();
    }
    
    protected override void afterUpdate() {
        new ViagemTriggerNotificaQuandoPago(this.newList, this.oldMap).run();
    }
}