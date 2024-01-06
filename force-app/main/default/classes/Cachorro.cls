public class Cachorro extends Animal {
    public Cachorro(String nome, String especie, String cor, Integer idade, Boolean voa){
        this.nome = nome;
        this.especie = especie;
        this.cor = cor;
        this.idade = idade;
        this.voa = voa;
    }
    
    public override void definirAcoes() {
        System.debug('Comer, Correr, Latir...');
    }
}