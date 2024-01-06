public class CriaTarefaContaNaoVinculadaOppTrigger {
	List<Task> taskList = new List<Task>();
    Map<Id, Opportunity> oppMap = new Map<Id, Opportunity>();
    
    public CriaTarefaContaNaoVinculadaOppTrigger(List<Task> taskList, Map<Id, Opportunity> oppMap) {
        this.taskList = taskList;
        this.oppMap = oppMap;
        filter();
    }
    
    private void filter() {
        for(Opportunity opp : oppMap.values()) {
            if(opp.AccountId == null){
				Task tarefa = new Task();
                tarefa.Subject = 'Oportunidade criada sem uma conta vinculada';
                tarefa.Description = '';
            }
        }
    }
    
    public void run(){
        
    }

}