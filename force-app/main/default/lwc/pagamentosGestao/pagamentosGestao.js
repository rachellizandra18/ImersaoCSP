import { LightningElement, wire } from 'lwc';
import { ShowToastEvent } from "lightning/platformShowToastEvent";

import getClientesAtivos from "@salesforce/apex/PagamentosGestaoController.getClientesAtivos";
import getViagens from "@salesforce/apex/PagamentosGestaoController.getViagens";
import getDespesas from "@salesforce/apex/PagamentosGestaoController.getDespesas";
import criarPagamento from "@salesforce/apex/PagamentosGestaoController.criarPagamento";

const COLUMNS_VIAGENS = [
    { label: 'Custo', fieldName: 'Custo__c', type: 'currency' },
    { label: 'Data/Hora Início', fieldName: 'Data_Hora_da_Ida__c', type: 'date', 
        typeAttributes:{
            year: "numeric",
            month: "long",
            day: "2-digit",
            hour: "2-digit",
            minute: "2-digit"
        } 
    },
    { label: 'Data/Hora Volta', fieldName: 'Data_Hora_da_Volta__c', type: 'date', 
        typeAttributes:{
            year: "numeric",
            month: "long",
            day: "2-digit",
            hour: "2-digit",
            minute: "2-digit"
        }  
    },
    { label: 'Origem', fieldName: 'Origem__c' },
    { label: 'Destino', fieldName: 'Destino__c' }
];

const COLUMNS_DESPESAS = [
    { label: 'Custo', fieldName: 'Custo__c', type: 'currency' },
    { label: 'Data', fieldName: 'Data_da_Despesa__c', type: 'date' },
    { label: 'Descrição', fieldName: 'Descricao__c'}
];

export default class PagamentosGestao extends LightningElement {

    columnsViagens = COLUMNS_VIAGENS;
    columnsDespesas = COLUMNS_DESPESAS;

    clienteSelecionado;
    dataInicio = '2023-10-01';
    dataFim = '2023-12-31';

    clientesAtivosOptions = [];
    error;

    viagens = []; //todas as viagens do período
    despesas = []; //todas as despesas do período

    viagensSelecionadas = [];
    despesasSelecionadas = []; 

    pesquisaRealizada = false;

    get temViagensOuDespesas() {
        return this.verificaViagensOuDespesas();
    }

    verificaViagensOuDespesas(){
        if(this.viagens.length !== 0 || this.despesas.length !== 0){
            return true;
        }else{
            return false;
        } 
    }

    get exibirMensagemNaoHaViagemOuDespesas(){
        return this.pesquisaRealizada && !this.verificaViagensOuDespesas();
    }

    get exibirBotaoCriarPagamento(){
        return this.viagensSelecionadas.length !== 0 || this.despesasSelecionadas.length !== 0;
    }

    get temViagens(){
        return this.viagens.length !== 0;
    }

    get temDespesas(){
        return this.despesas.length !== 0;
    }

    @wire(getClientesAtivos)
    wiredClienteAtivos({ error, data }) {

        //console.log('Início da função wiredClienteAtivos');
        //console.log('DATA', data);
        //console.log('ERROR', error); 

        if (data) {
            //Criando um outro padrão de objeto usando map
            this.clientesAtivosOptions = data.map(cliente => ({ label: cliente.Name, value: cliente.Id }));
            this.error = undefined;
        } else if (error) {
            this.error = error;
            console.log('ERRO AO BUSCAR CLIENTES ATIVOS', this.error);
            this.clientesAtivos = undefined;
        }
    }

    async pesquisarViagensDespesas(){
        console.log('Id do cliente selecionado', this.clienteSelecionado);
        console.log('Data Início', this.dataInicio);
        console.log('Data Fim', this.dataFim);

        await this.pesquisarViagens();
        await this.pesquisarDespesas();

        this.pesquisaRealizada = true;
    }

    async pesquisarViagens() {
        await getViagens({ contaId: this.clienteSelecionado, 
                     dataInicio:this.dataInicio, 
                     dataFim: this.dataFim })
        .then((result) => {
            this.viagens = result;
            console.log('Viagens retornadas', this.viagens);
            this.error = undefined;
        })
        .catch((error) => {
            this.error = error;
            this.viagens = [];
            console.log('ERRO AO RETORNAR VIAGENS', this.error);
        });
    }

    async pesquisarDespesas() {
        await getDespesas({ contaId: this.clienteSelecionado, 
                     dataInicio:this.dataInicio, 
                     dataFim: this.dataFim })
        .then((result) => {
            this.despesas = result;
            console.log('Despesas retornadas', this.despesas);
            this.error = undefined;
        })
        .catch((error) => {
            this.error = error;
            this.despesas = [];
            console.log('ERRO AO RETORNAR DESPESAS', this.error);
        });
    }

    handleChangeCliente(event){
        this.clienteSelecionado = event.detail.value;
        console.log('Id do cliente selecionado', this.clienteSelecionado);
    }

    handleChangeDataInicio(event){
        this.dataInicio = event.detail.value;
    }

    handleChangeDataFim(event){
        this.dataFim = event.detail.value;
    }

    selecionaViagens(event){
        this.viagensSelecionadas = event.detail.selectedRows;
        console.log('Viagens selecionadas',this.viagensSelecionadas);
    }

    selecionaDespesas(event){
        this.despesasSelecionadas = event.detail.selectedRows;
        console.log('Despesas selecionadas',this.despesasSelecionadas);
    }

    criarPagamento(){
        criarPagamento({ contaId: this.clienteSelecionado, 
                         viagens:this.viagensSelecionadas, 
                         despesas: this.despesasSelecionadas })
        .then((result) => {
            const pagamento = result;
            
            console.log('Pagamento criado', pagamento);
            this.showNotification('Sucesso', 'Pagamento criado com sucesso. Valor R$ ' + pagamento.Valor_Total__c, 'success');
            this.pesquisarViagensDespesas();
            this.error = undefined;
        })
        .catch((error) => {
            this.error = error;
            console.log('ERRO AO CRIAR PAGAMENTO', JSON.stringify(this.error));

            let errorMsg = 'Erro ao criar Pagamento, tente novamente ou consulte um admin.';

            if(error && error.body && error.body.pageErrors){
                errorMsg =  error.body.pageErrors[0].message;
            }    

            this.showNotification('Erro', errorMsg, 'error');
        });
    }

    showNotification(title, message, variant) {
        const evt = new ShowToastEvent({
            title: title,
            message: message,
            variant: variant
        });
        this.dispatchEvent(evt);
    }

}