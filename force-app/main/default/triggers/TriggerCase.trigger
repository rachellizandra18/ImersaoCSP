trigger TriggerCase on Case (after insert, after update) {
  TriggerCaseHandler.run();
}