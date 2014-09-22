/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package infrastructure;

/**
 *
 * @author daniel
 */
public class Saida {
    private static StringBuffer texto = new StringBuffer();
    
    public static void println(String txt) {
        texto.append(txt);
        texto.append(System.getProperty("line.separator"));
    }
    
    public static void clear() {
        texto = new StringBuffer();
    }
    
    public static String getTexto() {
        return texto.toString();
    }
}
