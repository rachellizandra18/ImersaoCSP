public class PropostaTriggerHandler extends TriggerHandler {
	private List<Quote> newList;
    //private List<Quote> oldList;
    //private Map<Id, Quote> newMap;
    //private Map<Id, Quote> oldMap;
    private Map<Id, Account> mapAccount;
    
    public PropostaTriggerHandler() {
        this.newList = (List<Quote>) Trigger.new;
        this.mapAccount = (Map<Id, Account>) Trigger.newMap;
        //this.oldList = (List<Quote>) Trigger.old;
        //this.newMap = (Map<Id, Quote>) Trigger.newMap;
        //this.oldMap = (Map<Id, Quote>) Trigger.oldMap;
        
        //if(this.oldList == null) this.oldList = new List<Quote>();
        //if(this.oldMap == null) this.oldMap = new Map<Id, Quote>();
       
    }
    
    protected override void beforeInsert() {
    }
    
    protected override void afterInsert() {
        new AlteraNomePropostaTrigger(this.newList, this.mapAccount).run();
    }
    
    protected override void beforeUpdate() {
        
    }
    
    protected override void afterUpdate() {

    }
}