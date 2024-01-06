public class GestaoDeViagensCTRL {

    @AuraEnabled
    public static List<Viagem__c> exibirViagensRealizadas(String ano, String mes, String estado){
        
        Map<String, Integer> mapMesString = new Map<String, Integer>();
        
        mapMesString.put('Janeiro', 1);
        mapMesString.put('Fevereiro', 2);
        mapMesString.put('Março', 3);
        mapMesString.put('Abril', 4);
        mapMesString.put('Maio', 5);
        mapMesString.put('Junho', 6);
        mapMesString.put('Julho', 7);
        mapMesString.put('Agosto', 8);
        mapMesString.put('Setembro', 9);
        mapMesString.put('Outubro', 10);
        mapMesString.put('Novembro', 11);
        mapMesString.put('Dezembro', 12);
        
        List<Viagem__c> viagens = new List<Viagem__c>();

        List<Viagem__c> viagensRealizadasMensal = [SELECT Id, Name, Data_Hora_da_Ida__c, Data_Hora_da_Volta__c, Custo__c, Estado_de_Destino__c, Pago_pela_empresa__c, Companhia__c, Companhia__r.Name, Pagamento__c, Colaborador__r.FirstName
                                                  FROM Viagem__c 
                                                  WHERE Pago_pela_empresa__c = true
                                                  AND Pagamento__c != null
                                                  AND Estado_de_Destino__c = :estado
                                                 ];

        for(Viagem__c viagem : viagensRealizadasMensal){
            Datetime dataViagem = Datetime.newInstance(Integer.valueOf(ano), mapMesString.get(mes), viagem.Data_Hora_da_Ida__c.day());
            String dateStr = dataViagem.format('yyyy-MM-dd hh:ss');
            System.debug('Data viagem 1 ' + dataViagem);

            String dataIda = viagem.Data_Hora_da_Ida__c.format('yyyy-MM-dd hh:ss');
            System.debug('data ida formatada:'+dataIda);
            System.debug('Comparação das datas:'+dateStr);
            if(dataIda == dateStr){
                viagem.Data_Hora_da_Ida__c = dataViagem;
                viagens.add(viagem);
            }

            System.debug('Data viagem ' + dataViagem);
        }

        System.debug('Estado ' + estado);
        System.debug('Viagens realizadas ' + viagensRealizadasMensal);

        if(viagens.isEmpty()){
            throw new AuraHandledException('Você não possui viagens nesse período.');
        }       
        
        return viagens;
    }
}