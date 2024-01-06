({
	doInit : function(component, event, helper) {
		var meses = [
            {'label': 'Janeiro', 'value': 'Janeiro'},
            {'label': 'Fevereiro', 'value': 'Fevereiro'},
            {'label': 'Março', 'value': 'Março'},
            {'label': 'Abril', 'value': 'Abril'},
            {'label': 'Maio', 'value': 'Maio'},
            {'label': 'Junho', 'value': 'Junho'},
            {'label': 'Julho', 'value': 'Julho'},
            {'label': 'Agosto', 'value': 'Agosto'},
            {'label': 'Setembro', 'value': 'Setembro'},
            {'label': 'Outubro', 'value': 'Outubro'},
            {'label': 'Novembro', 'value': 'Novembro'},
            {'label': 'Dezembro', 'value': 'Dezembro'}
            ];
        
        var estados = [
            {'label': 'Acre', 'value': 'AC'},
            {'label': 'Alagoas', 'value': 'AL'},
            {'label': 'Amapá', 'value': 'AP'},
            {'label': 'Amazonas', 'value': 'AM'},
            {'label': 'Bahia', 'value': 'BA'},
            {'label': 'Ceará', 'value': 'CE'},
            {'label': 'Distrito Federal', 'value': 'DF'},
            {'label': 'Espírito Santo', 'value': 'ES'},
            {'label': 'Goiás', 'value': 'GO'},
            {'label': 'Maranhão', 'value': 'MA'},
            {'label': 'Mato Grosso', 'value': 'MT'},
            {'label': 'Mato Grosso do Sul', 'value': 'MS'},
            {'label': 'Minas Gerais', 'value': 'MG'},
            {'label': 'Pará', 'value': 'PA'},
            {'label': 'Paraíba', 'value': 'PB'},
            {'label': 'Paraná', 'value': 'PR'},
            {'label': 'Pernambuco', 'value': 'PE'},
            {'label': 'Piauí', 'value': 'PI'},
            {'label': 'Rio de Janeiro', 'value': 'RJ'},
            {'label': 'Rio Grande do Norte', 'value': 'RN'},
            {'label': 'Rio Grande do Sul', 'value': 'RS'},
            {'label': 'Rondônia', 'value': 'RO'},
            {'label': 'Roraima', 'value': 'RR'},
            {'label': 'Santa Catarina', 'value': 'SC'},
            {'label': 'São Paulo', 'value': 'SP'},
            {'label': 'Sergipe', 'value': 'SE'},
            {'label': 'Tocantins', 'value': 'TO'}
        ];

        component.set('v.mes', meses);
        component.set('v.estado', estados);
	},
    
    exibirViagens : function(component, event, helper) {

        var ano = component.find('ano').get('v.value');  
        var mes = component.find('mes').get('v.value'); 
        var estado = component.find('estado').get('v.value');

        component.set('v.columns', [
            {label: 'Número da Viagem', fieldName: 'Name', type: 'url', typeAttributes: {label: { fieldName: 'Name' }, target: '_blank'}},
            {label: 'Data/Hora da Ida', fieldName: 'Data_Hora_da_Ida__c', type: 'datetime'},
            {label: 'Data/Hora da Volta', fieldName: 'EndDate', type: 'datetime'},
            {label: 'Companhia', fieldName: 'Companhia__r.Name', type: 'text'}
        ]);

        if(ano != '' && mes != '' && estado != ''){
            helper.helperExibirViagens(component, event, helper);
        } else{
            alert('Preencha mês, ano e estado para continuar');
        }
        
    }
})