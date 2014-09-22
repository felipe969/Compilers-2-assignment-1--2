/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package infrastructure;

/**
 *
 * @author daniel
 */
public class Mensagens {
    public static void erroVariavelNaoExiste(int numLinha, String variavel) {
        Saida.println("Linha "+numLinha+": identificador "+variavel+" nao declarado");
    }
    
    public static void erroVariavelJaExiste(int numLinha, String variavel) {
        Saida.println("Linha "+numLinha+": identificador "+variavel+" ja declarado anteriormente");
    }
    
    public static void escopoProibido(int numLinha) {
        Saida.println("Linha "+numLinha+": comando retorne nao permitido nesse escopo");
    }
}
