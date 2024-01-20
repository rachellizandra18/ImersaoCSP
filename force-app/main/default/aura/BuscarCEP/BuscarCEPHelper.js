({
    procurarCEP : function(component) {
        console.log('Salvando registro');
        var cep = component.find('cep').get('v.value');
        var action = component.get('c.getZIPCode');
        action.setParams({ 
            'zipCode' : cep
        });

        action.setCallback(this, function(response){
            var state = response.getState();
            if(state == "SUCCESS"){
                let dados = response.getReturnValue();
                component.set('v.logradouro', dados.logradouro);
				component.set('v.cidade', dados.localidade);
				component.set('v.bairro', dados.bairro);
				component.set('v.estado', dados.uf);
            } else {
                var errors = action.getError();

                if (errors) {
                    if (errors[0] && errors[0].message) {
                        var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                            "title"		: 'Houve um erro ao realizar o cálculo.',
                            "message"	: errors[0].message,
                            "type"		: "error"});
                        toastEvent.fire(); 
                        $A.get('e.force:refreshView').fire();			
                        $A.get("e.force:closeQuickAction").fire();
                    }
                }
            }
            component.set('v.showSpinner', false);
        });
        $A.enqueueAction(action);
    },
    salvarEndereco: function(component) {
        let obj = {
            cep : component.find('cep').get('v.value'),
			logradouro : component.get('v.logradouro'),
			numero : component.find('numero').get('v.value'),
			complemento : component.find('complemento').get('v.value'),
			localidade : component.get('v.cidade'),
			bairro :component.get('v.bairro'),
			uf : component.get('v.estado')
        } 

        var recordId = component.get('v.recordId');
        var action = component.get('c.salvarRegistro');
        action.setParams({
            'enderecoJSON' : JSON.stringify(obj),
			'recordId' : recordId
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            console.log('state >> ' + state);
            if( state === "SUCCESS" ) {
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title"		: 'Registro atualizado!',
                    "message"	: 'Os dados de endereço foram atualizados com sucesso.',
                    "type"		: "Success"});
                toastEvent.fire(); 
                $A.get('e.force:refreshView').fire();			
                $A.get("e.force:closeQuickAction").fire();
            } else {
                var errors = action.getError();
                
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                            "title"		: 'Ocorreu um erro!',
                            "message"	: errors[0].message,
                            "type"		: "error"});
                        toastEvent.fire(); 
                        $A.get('e.force:refreshView').fire();			
                        $A.get("e.force:closeQuickAction").fire();
                    }
                }	                
            }
            component.set('v.showSpinner', false);
        });
        $A.enqueueAction( action );
    }
})
