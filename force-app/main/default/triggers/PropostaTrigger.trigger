trigger PropostaTrigger on Quote (before insert) {
	//new PropostaTriggerHandler().run();
	
    // Lista para armazenar as contas associadas às propostas
    /*Map<Id, String> contaNomes = new Map<Id, String>();
    Set<Id> contaIds = new Set<Id>();

    // Consulta SOQL para obter o nome das contas associadas
    for (Quote proposta : Trigger.new) {
        //contaNomes.add(proposta.Conta__r.Name);
        contaIds.add(proposta.AccountId);
    }
    
    if (!contaIds.isEmpty()) {
        for (Account conta : [SELECT Id, Name FROM Account WHERE Id IN :contaIds]) {
            contaNomes.put(conta.Id, conta.Name);
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
    for (Quote proposta : Trigger.new) {
      if (proposta.AccountId != null) {
        Id contaId = proposta.AccountId;
        String contaNome = contaNomes.get(contaId);
        //String numSeq = proposta.Numero_Sequencial__c;
        Integer numPropostas = contaContagemPropostas.get(contaId) + 1;
        String nomeProposta = 'PP-' + contaNome + '-' + numPropostas;
        proposta.Name = nomeProposta;
        //insert proposta;

        // Atualizar a contagem de propostas para a conta
        contaContagemPropostas.put(contaId, numPropostas);
    	}
    }*/
	
}