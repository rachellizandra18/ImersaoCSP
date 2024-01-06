({
	helperExibirViagens : function(component, event, helper) {
		var ano = component.find('ano').get('v.value');  
        var mes = component.find('mes').get('v.value');
        var estado = component.find('estado').get('v.value');
        var action = component.get('c.exibirViagensRealizadas');
        action.setParams({
            'ano' : ano,
            'mes' : mes,
            'estado' : estado
        });
        
        action.setCallback(this, function(response){
            var state = response.getState();
            if( state === "SUCCESS" ) {	
                var records = response.getReturnValue();
                records.forEach(function(record){
                    record.Name = '/' + record.Id;
                });
                component.set('v.viagensExistentes', true);
                component.set('v.data', response.getReturnValue());
                this.showToast('Sucesso!','As suas viagens serão exibidas. Aguarde...', 'success');
                console.log('retorno com sucesso!!!!');
            } else {
                var errors = action.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        this.showToast('Houve um erro ao realizar a requisição',errors[0].message, 'error');
                        $A.get('e.force:refreshView').fire();	
                        console.log('ocorreu um erro!!!!' + errors[0].message);
                    }
                }                		
            }
        });
        
        $A.enqueueAction( action );	
	}, 
    
    showToast : function(title, message, type){
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title"		: title,
            "message"	: message,
            'duration': 5000,
            "type"		: type});
        toastEvent.fire();
    }
})