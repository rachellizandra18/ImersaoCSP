public class ViagemTriggerValidaDataHora {
	private List<Viagem__c> newList;
    private Map<Id, Viagem__c> oldMap;
    private Map<Id, Viagem__c> filteredMapDataVoltaInferior = new Map<Id, Viagem__c>();
    private Boolean hasRecords;
    
    public ViagemTriggerValidaDataHora(List<Viagem__c> newList, Map<Id, Viagem__c> oldMap) {
        this.newList = newList;
        this.oldMap = oldMap;
        filter();
        this.hasRecords = (filteredMapDataVoltaInferior.isEmpty()) ? false : true;
    }
    
    private void filter() {
        for (Viagem__c viagem : newList) {
            if(
                (
                    oldMap.isEmpty() || /*verifica se já tem uma viagem*/
                	viagem.Data_Hora_da_Volta__c != oldMap.get(viagem.Id).Data_Hora_da_Volta__c ||
              		viagem.Data_Hora_da_Ida__c != oldMap.get(viagem.Id).Data_Hora_da_Ida__c
                )
                
                && viagem.Data_Hora_da_Volta__c <= viagem.Data_Hora_da_Ida__c) {
                	filteredMapDataVoltaInferior.put(viagem.Id, viagem);
            }
        }
    }
    
    public void run() {
        if(!filteredMapDataVoltaInferior.isEmpty()) {
            for(Viagem__c viagem : filteredMapDataVoltaInferior.values()) {
                 viagem.addError('A data de volta não pode ser inferior a data de ida.');
            }
        }
    }
}