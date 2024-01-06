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
        
        Datetime dataViagem = Datetime.newInstance(Integer.valueOf(ano), mapMesString.get(mes), 1);
        System.debug('Data viagem 1 ' + dataViagem);
        
        List<Viagem__c> viagensRealizadasAnual = [SELECT Id, Name, Data_Hora_da_Ida__c, Data_Hora_da_Volta__c, Estado_de_Destino__c, Pago_pela_empresa__c, Companhia__r.Name
                                                  FROM Viagem__c 
                                                  WHERE Data_Hora_da_Ida__c <= :dataViagem
                                                  AND Data_Hora_da_Volta__c >= :dataViagem
                                                  AND Pago_pela_empresa__c = true
                                                  AND Estado_de_Destino__c = :estado
                                                 ];
        // if(!viagensRealizadasAnual.isEmpty()){

        // }

        System.debug('Data viagem ' + dataViagem);
        System.debug('Estado ' + estado);
        System.debug('Viagens realizadas ' + viagensRealizadasAnual);
        
        
        return viagensRealizadasAnual;
    }
}