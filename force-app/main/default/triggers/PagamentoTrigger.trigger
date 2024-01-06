trigger PagamentoTrigger on Pagamento__c (before insert, after insert, before update, after update) {
	new PagamentoTriggerHandler().run();
}