public class AlteraNomePropostaTrigger {

    private Map<Id, Account> contaNomes = new Map<Id, Account>();
    private List<Quote> newListProposta = [SELECT Id, Name FROM Quote WHERE Id IN :contaNomes.keySet()];
    
    public AlteraNomePropostaTrigger(List<Quote> newListProposta, Map<Id, Account> contaNomes) {
        this.newListProposta = newListProposta;
        this.contaNomes = contaNomes;
    }       
    
    public void run() {  
    
        Set<Id> contaIds = new Set<Id>();  
            
        // Consulta SOQL para obter o nome das contas associadas
        for (Quote proposta : newListProposta) {
            contaIds.add(proposta.AccountId);
        }
        
        if (!contaIds.isEmpty()) {
            for (Account conta : [SELECT Id, Name FROM Account WHERE Id IN :contaIds]) {
                contaNomes.put(conta.Id, conta);
            }
        }
    
        // Consulta SOQL para contar o número de propostas existentes para cada conta
        Map<Id, Integer> contaContagemPropostas = new Map<Id, Integer>();
        for (AggregateResult result : [
            SELECT AccountId, COUNT(Id) numPropostas
            FROM Quote
            WHERE AccountId IN :contaIds
            GROUP BY AccountId
        ]) {
            contaContagemPropostas.put((Id)result.get('AccountId'), (Integer)result.get('numPropostas'));
        }
    
        // Atualizar o nome da proposta com o formato desejado
        for (Quote proposta : newListProposta) {
          if (proposta.AccountId != null) {
            Id contaId = proposta.AccountId;
        	Account conta = contaNomes.get(contaId);
            String contaNome = conta.Name;
            //String numSeq = proposta.Numero_Sequencial__c;
            Integer numPropostas = contaContagemPropostas.get(contaId) + 1;
            String nomeProposta = 'PP-' + contaNome + '-' + numPropostas;
            proposta.Name = nomeProposta;
    
            // Atualizar a contagem de propostas para a conta
            contaContagemPropostas.put(contaId, numPropostas);
            }
            
            //insert proposta;
          }
	}
}