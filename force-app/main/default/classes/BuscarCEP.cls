public with sharing class BuscarCEP {
   
 /*   @AuraEnabled 
    public static boolean salvarRegistro(String enderecoJSON, String recordId){
        try {
            Id myId = (Id) recordId;
            String sObjName = myId.getSObjectType().getDescribe().getName();
            Map<String, Schema.SObjectType> globalDescribe = Schema.getGlobalDescribe();
            Map<String, Schema.SObjectField> fieldMap = globalDescribe.get(sObjName).getDescribe().fields.getMap();
            System.debug('fieldMap ' + fieldMap);
            Set<String> setFieldNames = fieldMap.keySet();
            list<String> lstFieldNames = new List<String>();
            if( sObjName == 'Account' ) {
                for( String setFieldName : setFieldNames ) {
                    if( !setFieldName.contains('__pc') ) {
                        lstFieldNames.add( setFieldName );
                    }
                }
            }
            System.debug('lstFieldNames ' + lstFieldNames);
            String query = 'SELECT ' + String.join(lstFieldNames, ',') + ' FROM ' + sObjName + ' WHERE Id =: myId ';
            SObject obj = Database.query(String.escapeSingleQuotes(query));
            InfoCEP infocep = (InfoCEP) JSON.deserialize(enderecoJSON, InfoCEP.class);

            if(fieldMap.get('Bairro__c') != null){
                obj.put('Bairro__c', infocep.bairro);
            }
            
            if(fieldMap.get('CEP__c') != null){
                obj.put('CEP__c', infocep.cep);
            }
            
            if(fieldMap.get('Cidade__c') != null){
                obj.put('Cidade__c', infocep.localidade);
            }
            
            if(fieldMap.get('Complemento__c') != null){
                obj.put('Complemento__c', infocep.complemento);
            }
            
            if(fieldMap.get('Logradouro__c') != null){
                obj.put('Logradouro__c', infocep.logradouro);
            }
            if(fieldMap.get('Endereco__c') != null){
                obj.put('Endereco__c', infocep.logradouro);
            }
            
            if(fieldMap.get('Numero__c') != null){
                obj.put('Numero__c', infocep.numero);
            }
            
            if(fieldMap.get('UF__c') != null){
                obj.put('UF__c', infocep.uf);
            }
            
            if(fieldMap.get('BillingPostalCode') != null){
                obj.put('BillingPostalCode', infocep.cep);
            }
            
            if(fieldMap.get('BillingCity') != null){
                obj.put('BillingCity', infocep.localidade);
            }
            
            if(fieldMap.get('BillingState') != null){
                obj.put('BillingState', infocep.uf);
            }
            
            if(fieldMap.get('BillingStreet') != null){
                obj.put('BillingStreet', infocep.logradouro);
            }
            
            if(fieldMap.get('PostalCode') != null){
                obj.put('PostalCode', infocep.cep);
            }
            
            if(fieldMap.get('City') != null){
                obj.put('City', infocep.localidade);
            }
            
            if(fieldMap.get('State') != null){
                obj.put('State', infocep.uf);
            }
            
            if(fieldMap.get('Street') != null){
                obj.put('Street', infocep.logradouro);
            }
            
            System.debug('Obj: ' + obj);
            if(obj != null){
                update obj;
            }

            return true;
            
        } catch (Exception e) {
            System.debug(e.getStackTraceString() );
            AuraHandledException ex = new AuraHandledException(e.getMessage());
            ex.setMessage( e.getMessage() );
            throw ex;
        }
    }

    @AuraEnabled
    public static Correios.ViaCEPResponse getZIPCode( String zipCode ) {
        Correios.AtendeClientePort instance = new Correios.AtendeClientePort();
        try {
            Correios.enderecoERP zipCodeResponse = instance.consultaCEP(zipCode);
            Correios.ViaCEPResponse result = new Correios.ViaCEPResponse();
            result.bairro = zipCodeResponse.bairro;
            result.cep = zipCode;
            result.localidade = zipCodeResponse.cidade;
            result.logradouro = zipCodeResponse.end_x;
            result.uf = zipCodeResponse.uf;
            result.complemento = zipCodeResponse.complemento2;
            System.debug(result);
            return result;
        } catch( Exception e ) {
            return null;
        }
    }

    public class InfoCEP {
        @AuraEnabled public String cep { get; set; }
        @AuraEnabled public String logradouro { get; set; }
        @AuraEnabled public Integer numero { get; set; }
        @AuraEnabled public String complemento { get; set; }
        @AuraEnabled public String bairro { get; set; }
        @AuraEnabled public String localidade { get; set; }
        @AuraEnabled public String uf { get; set; }
    } 
    */
}