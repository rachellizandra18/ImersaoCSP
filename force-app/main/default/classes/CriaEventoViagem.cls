public class CriaEventoViagem {
    
    @InvocableMethod(label='Cria Evento para Viagem' description='Cria um evento para uma viagem a partir de sua data' category='Viagem__c')
    public static void criarEventoDataViagem(List<Viagem__c> novasViagens) {

        List<Event> eventos = new List<Event>();
        
        for(Viagem__c viagem : novasViagens) {
            Event evento = new Event();
            evento.Subject = viagem.Origem__c + ' - ' + viagem.Destino__c;
            evento.ActivityDateTime = viagem.Data_Hora_da_Ida__c;
            evento.EndDateTime = viagem.Data_Hora_da_Volta__c;
            evento.WhatId = viagem.Id;
            evento.WhoId = viagem.Colaborador__c;
            
            eventos.add(evento);
        }
        
        insert eventos;
        
    }
}