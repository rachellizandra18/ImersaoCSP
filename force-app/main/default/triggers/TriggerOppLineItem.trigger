trigger TriggerOppLineItem on OpportunityLineItem (after insert, after update) {
	TriggerOppLineItemHandler.run();
}