trigger TriggerAccount on Account (before insert, before update, after update) {
	TriggerAccountHandler.run();
}