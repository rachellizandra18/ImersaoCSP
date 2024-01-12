trigger TriggerContact on Contact (before insert, before update) {
	TriggerContactHandler.run();
}