trigger TriggerFuncionario on Funcionario__c (after insert, after update, after delete, after undelete) {
	TriggerFuncionarioHandler.run();
}