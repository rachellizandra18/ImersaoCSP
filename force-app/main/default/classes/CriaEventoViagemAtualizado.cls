public class CriaEventoViagemAtualizado {
/*    
    //private static final String ID_REPRESENTANTE_DO_GRUPO = '';

    @InvocableMethod(label='Cria Evento para Viagem' description='Cria um evento para uma viagem a partir de sua data e envia notificação quando colaborador já tem viagem marcada em um período' category='Viagem__c')
    public static void criarEventoDataViagem(List<Viagem__c> novasViagens) {
                
        Map<Id, List<Event>> mapEventosPorColaborador = new Map<Id, List<Event>>(); // um colaborador pode ter vários eventos, por isso é passado uma lista de eventos no map
        
        Datetime menorDataHora = System.now();
        Datetime maiorDataHora = System.now();
        
        for(Viagem__c viagem : novasViagens) {
            
            if(viagem.Data_Hora_da_Ida__c < menorDataHora) {
                menorDataHora = viagem.Data_Hora_da_Ida__c;
            }
            
            if(viagem.Data_Hora_da_Volta__c > maiorDataHora) {
                maiorDataHora = viagem.Data_Hora_da_Volta__c;
            }
            
            Event evento = new Event();
            evento.Subject = viagem.Origem__c + ' - ' + viagem.Destino__c;
            evento.ActivityDateTime = viagem.Data_Hora_da_Ida__c;
            evento.EndDateTime = viagem.Data_Hora_da_Volta__c;
            evento.WhatId = viagem.Id;
            evento.WhoId = viagem.Colaborador__c;
            
            if(!mapEventosPorColaborador.containsKey(viagem.Colaborador__c)) { // se esse mapa não tiver a chave em questão:
                mapEventosPorColaborador.put(viagem.Colaborador__c, new List<Event>{evento}); // cria-se uma nova chave, adiciona um evento a uma nova lista
            } else { // se já tiver a chave:
                mapEventosPorColaborador.get(viagem.Colaborador__c).add(evento);// adiciona mais um evento a uma lista que já existe
            }
                     
        }
                
        List<Event> novosEventos = new List<Event>();
        // para cada lista de cada colaborador, adiciona todos os registros em uma lista maior
        for(List<Event> eventosList : mapEventosPorColaborador.values()) {
            novosEventos.addAll(eventosList); // insere todos os eventos de um colaborador na lista maior
        }     
        
        insert novosEventos;
        
        //Tendo outro compromisso no horário desejado, enviar outra notificação            
        //Criando uma custom notification na mesma classe:

		Id proprietario = [SELECT Id, OwnerId FROM Event WHERE Id =: novosEventos].OwnerId;
		Set<String> destinatario = new Set<String>();
		destinatario.add(proprietario);

		List<CustomNotificationType> notifications = [SELECT Id FROM CustomNotificationType WHERE DeveloperName in ('NotificarEventoNovaViagem', 'NotificarAjusteViagem') ORDER BY DeveloperName];
		CustomNotificationType notificationJaExisteViagem = notifications[0];
		CustomNotificationType notificationViagem = notifications[1];
        
        Map<Id, List<Event>> mapaEventosExistentesPorColaborador = getMapaEventosExistentesPorColaborador(mapEventosPorColaborador.keySet(), menorDataHora, maiorDataHora);

        for (Event evento : novosEventos){
            if(mapaEventosExistentesPorColaborador.containsKey(evento.WhoId) //verifica se o colaborador tem algum evento no periodo
               		&& existeEventoMarcadoNoPeriodo(evento, mapaEventosExistentesPorColaborador.get(evento.WhoId))){
                Utils.sendCustomNotification('Já existe uma viagem no período, favor reagendar!', evento.Subject, notificationJaExisteViagem.id, evento.Id, destinatario);
            }else{
                Utils.sendCustomNotification('Você tem uma nova viagem marcada!', evento.Subject, notificationViagem.id, evento.Id, destinatario);
            }                         
        }
    }
    
       private static Map<Id, List<Event>> getMapaEventosExistentesPorColaborador(Set<Id> colaboradorId, Datetime menorDataHora, Datetime maiorDataHora) {
        	List<Event> eventosExistentes = [SELECT Id, WhoId, ActivityDateTime, EndDateTime
                                         	FROM Event 
                                         	WHERE WhoId in : colaboradorId
                                         	AND (
                                             ActivityDateTime >= :menorDataHora
                                             OR EndDateTime <= :maiorDataHora
                                             )
                                             ORDER BY ActivityDateTime
                                        ];
           
           Map<Id, List<Event>> mapaEventosExistentes = new Map<Id, List<Event>>();
           
           for(Event evento : eventosExistentes) {
               if(!mapaEventosExistentes.containsKey(evento.WhoId)) {
                   mapaEventosExistentes.put(evento.WhoId, new List<Event>{evento});
               } else {
                   mapaEventosExistentes.get(evento.WhoId).add(evento);
               }
               
           }
           return mapaEventosExistentes;
       }
    
    private static Boolean existeEventoMarcadoNoPeriodo(Event novoEvento, List<Event> eventosExistentesDoColaborador){
        for(Event eventoExistente : eventosExistentesDoColaborador){
            Boolean dataInicioNovoEvento = novoEvento.ActivityDateTime >= eventoExistente.ActivityDateTime && novoEvento.ActivityDateTime <= eventoExistente.EndDateTime;
            Boolean dataFimNovoEvento = novoEvento.EndDateTime >= eventoExistente.ActivityDateTime && novoEvento.EndDateTime <= eventoExistente.EndDateTime;
            
            Boolean dataInicioEventoNoPeriodo = eventoExistente.ActivityDateTime >= novoEvento.ActivityDateTime && eventoExistente.ActivityDateTime <= novoEvento.EndDateTime;
			Boolean dataFimEventoNoPeriodo = eventoExistente.EndDateTime >= novoEvento.ActivityDateTime && eventoExistente.EndDateTime <= novoEvento.EndDateTime;
            
            if(dataInicioNovoEvento || dataFimNovoEvento || dataInicioEventoNoPeriodo || dataFimEventoNoPeriodo){
                return true;
            }
        }
        return false;
    }
    */
}