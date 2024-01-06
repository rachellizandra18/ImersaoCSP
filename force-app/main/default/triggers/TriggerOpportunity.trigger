trigger TriggerOpportunity on Opportunity (after insert, after update, after delete, after undelete) {
	TriggerOpportunityHandler.run();
}