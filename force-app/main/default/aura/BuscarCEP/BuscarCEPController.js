({
    buscarCEP : function(component, event, helper) {
        helper.procurarCEP(component, event);
        component.set('v.showSearchCEP', false);
        component.set('v.showAddress', true);
    },
    handleDismiss : function(component, event, helper){
        $A.get("e.force:closeQuickAction").fire();
    },
    salvarEndereco : function(component, event, helper){
        helper.salvarEndereco(component, event);
    }
})
