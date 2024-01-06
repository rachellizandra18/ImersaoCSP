public virtual class Animal {
    public String nome;
	public String especie;
    public String cor;
    public Integer idade;
    public Date dataNascimento;
    public Boolean voa;
    public List<Acao> acoes;
    
    public void emitirSomPadrao(String representacaoSom){
        if (voa == true) {
            System.debug('É uma ave');
        } else {
            system.debug('É outro animal');
        }
    }
    
        public String emitirSom(String representacaoSom){
        if (voa == true) {
            return 'É uma ave';
        } else {
            return 'É outro animal';
        }
    }
    
    public virtual void definirAcoes() {
        acoes = new List<Acao>();
        System.debug('Ação padrão');
    }
    
    public Integer retornarIdade(){
        //Date anoAtual = Date.year();
        //Date anoNascimento = dataNascimento.year();
        return null;
    }
}