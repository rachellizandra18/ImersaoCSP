public class OpportunityTriggerHandler extends TriggerHandler {
	private List<Opportunity> newList;
    private List<Opportunity> oldList;
    private Map<Id, Opportunity> newMap;
    private Map<Id, Opportunity> oldMap;
    
    public OpportunityTriggerHandler() {
        this.newList = (List<Opportunity>) Trigger.new;
        this.oldList = (List<Opportunity>) Trigger.old;
        this.newMap = (Map<Id, Opportunity>) Trigger.newMap;
        this.oldMap = (Map<Id, Opportunity>) Trigger.oldMap;
        
        if(this.oldList == null) this.oldList = new List<Opportunity>();
        if(this.oldMap == null) this.oldMap = new Map<Id, Opportunity>();
    }
    
    protected override void beforeInsert() {
        
    }
    
    protected override void afterInsert() {
    }
    
    protected override void beforeUpdate() {
        
    }
    
    protected override void afterUpdate() {
        
    }}