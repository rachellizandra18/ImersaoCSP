public class ViagemTriggerNotificaQuandoPago {
	private List<Viagem__c> newList;
    private Map<Id, Viagem__c> oldMap;
    private Map<Id, Viagem__c> filteredMap = new Map<Id, Viagem__c>(); //mapa com apenas os registros que possuem relevância para a automação na trigger
    private Boolean hasRecords;
    
    public ViagemTriggerNotificaQuandoPago(List<Viagem__c> newList, Map<Id, Viagem__c> oldMap) {
        this.newList = newList;
        this.oldMap = oldMap;
        filter();
        this.hasRecords = (filteredMap.isEmpty()) ? false : true;
    }
    
    // método que realiza lógica para mapear os registros que terão automação
    private void filter() {    
        
        for(Viagem__c viagem : newList) {
            Boolean valorAntigoDoCampoPagoEmpresa = oldMap.get(viagem.Id).Pago_pela_empresa__c;
            
            if(viagem.Pago_pela_empresa__c && viagem.Pago_pela_empresa__c != valorAntigoDoCampoPagoEmpresa) {
                 filteredMap.put(viagem.Id, viagem);
            }
        }
    }
    
    public void run() { //método que dispara (trigger) a automação
        if(hasRecords) {
            CustomNotificationType notification = [SELECT Id FROM CustomNotificationType WHERE DeveloperName = 'ViagemPaga'];
            Set<String> destinatarios = new Set<String>{ Userinfo.getUserId() };
                
            for(Viagem__c viagem : filteredMap.values()) {
                String assunto = 'A viagem ' + viagem.Name + ' foi paga pela empresa com sucesso!';
				Utils.sendCustomNotification('Viagem paga', assunto, notification.Id, viagem.Id, destinatarios);
            }
        }
    }
}