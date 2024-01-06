public class ViagemTriggerValidaViagensExistentes {

    private List<Viagem__c> newList;
    private Map<Id, Viagem__c> oldMap;
	private Map<Id, Viagem__c> filteredMap = new Map<Id, Viagem__c>(); 
    
    private Boolean hasRecords; 
    
    private Boolean isUpdate;
    
    public ViagemTriggerValidaViagensExistentes(List<Viagem__c> newList, Map<Id, Viagem__c> oldMap){
        this.newList = newList;
        this.oldMap = oldMap;
        this.isUpdate = !oldMap.isEmpty() ? true : false;
        filter();
        this.hasRecords = !filteredMap.isEmpty();
    }
    
    private void filter(){
    	
        Map<Id, List<Viagem__c>> mapViagensPorColaborador = new Map<Id, List<Viagem__c>>();

        Datetime menorDataHora = System.now();
        Datetime maiorDataHora = System.now();
        
        for(Viagem__c viagem : newList){
        	if(viagem.Data_Hora_da_Ida__c < menorDataHora){
                menorDataHora = viagem.Data_Hora_da_Ida__c;
            }
            
            if(viagem.Data_Hora_da_Volta__c > maiorDataHora){
                maiorDataHora = viagem.Data_Hora_da_Volta__c;
            }
            
            if(!mapViagensPorColaborador.containsKey(viagem.Colaborador__c)){
                mapViagensPorColaborador.put(viagem.Colaborador__c, new List<Viagem__c>{viagem});
            }else{
                mapViagensPorColaborador.get(viagem.Colaborador__c).add(viagem); 
            }
        }
        
        Map<Id, List<Viagem__c>> mapaViagensExistentesPorColaborador = getMapaViagensExistentesPorColaborador(mapViagensPorColaborador.keySet(), menorDataHora, maiorDataHora);

        for(Viagem__c viagem : newList){
        	if(mapaViagensExistentesPorColaborador.containsKey(viagem.Colaborador__c) //verifica se o colaborador tem algum evento no periodo
               		&& existeViagemMarcadaNoPeriodo(viagem, mapaViagensExistentesPorColaborador.get(viagem.Colaborador__c), this.isUpdate)){
           			this.filteredMap.put(viagem.Id, viagem);
            }
        }
        
    }
    
    private static Boolean existeViagemMarcadaNoPeriodo(Viagem__c novaViagem, List<Viagem__c> viagensExistentesDoColaborador, Boolean isUpdate){
        
        for(Viagem__c viagemExistente : viagensExistentesDoColaborador){
            
            // Ignorando a mesma viagem
            if(isUpdate && viagemExistente.Id == novaViagem.Id) {
                continue;
            }
            
            Date dataIda = viagemExistente.Data_Hora_da_Ida__c.date();
            
            Boolean dataInicioNovaViagemNoPeriodoViagemExistente = novaViagem.Data_Hora_da_Ida__c >= viagemExistente.Data_Hora_da_Ida__c && novaViagem.Data_Hora_da_Ida__c <= viagemExistente.Data_Hora_da_Volta__c;
            Boolean dataFimNovaViagemNoPeriodoViagemExistente = novaViagem.Data_Hora_da_Volta__c >= viagemExistente.Data_Hora_da_Ida__c && novaViagem.Data_Hora_da_Volta__c <= viagemExistente.Data_Hora_da_Volta__c;
 
            Boolean dataInicioViagemExistenteDentroDoPeriodoDaNovaViagem = viagemExistente.Data_Hora_da_Ida__c >= novaViagem.Data_Hora_da_Ida__c && viagemExistente.Data_Hora_da_Ida__c <= novaViagem.Data_Hora_da_Volta__c;
            Boolean dataFimViagemExistenteDentroDoPeriodoDaNovaViagem = viagemExistente.Data_Hora_da_Volta__c >= novaViagem.Data_Hora_da_Ida__c && viagemExistente.Data_Hora_da_Volta__c <= novaViagem.Data_Hora_da_Volta__c;
            
            if(dataInicioNovaViagemNoPeriodoViagemExistente || dataFimNovaViagemNoPeriodoViagemExistente || dataInicioViagemExistenteDentroDoPeriodoDaNovaViagem || dataFimViagemExistenteDentroDoPeriodoDaNovaViagem){
                return true;
            }
        }
        
        return false;
    }
    
    
    private static Map<Id, List<Viagem__c>> getMapaViagensExistentesPorColaborador(Set<Id> colaboradoresId, Datetime menorDataHora, Datetime maiorDataHora){
        List<Viagem__c> viagensExistentes = [SELECT Id, Colaborador__c, Data_Hora_da_Ida__c, Data_Hora_da_Volta__c 
                                         FROM Viagem__c 
                                         WHERE Colaborador__c in : colaboradoresId
                                         AND 
                                         (
                                             Data_Hora_da_Ida__c >= :menorDataHora 
                                             OR Data_Hora_da_Volta__c <= :maiorDataHora
                                         )
                                         ORDER BY Data_Hora_da_Ida__c
                                        ];

        Map<Id, List<Viagem__c>> mapaViagensExistentes = new Map<Id, List<Viagem__c>>();
        
        for(Viagem__c viagem : viagensExistentes){
            if(!mapaViagensExistentes.containsKey(viagem.Colaborador__c)){
                mapaViagensExistentes.put(viagem.Colaborador__c, new List<Viagem__c>{viagem});
            }else{
                mapaViagensExistentes.get(viagem.Colaborador__c).add(viagem);
            }
        }
        
        return mapaViagensExistentes;
        
    }
    
    public void run(){
        if(hasRecords){
        	for(Viagem__c viagem : filteredMap.values()){
            	viagem.addError('Já existe uma viagem no período, favor revisar as datas ou procure seu gestor!');
            }
        }
    }
}