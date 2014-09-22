package runner;

import infrastructure.LexicalErrorListener;
import infrastructure.Saida;
import infrastructure.SaidaParser;
import infrastructure.SyntaticErrorListener;
import java.io.FileInputStream;
import java.io.FileWriter;
import java.io.PrintWriter;
import laparser.LaLexer;
import laparser.LaParser;
import org.antlr.v4.runtime.ANTLRInputStream;
import org.antlr.v4.runtime.CommonTokenStream;
import org.antlr.v4.runtime.misc.ParseCancellationException;

/**
 * Runs the LaParser on a inputFile and outputs the result in an outputFile.
 *
 * This is the main class of the LaParser project. Therefore, the method
 * Runner.main(String[] args) will be called by the evaluator.
 *
 * @author Lucas
 */
public class Runner {

    /**
     * Runs the LaParser on a file that contains a LA source-code.
     *
     * @param inputFile name of the LA source-code file
     * @param outputFile name of the analysis result file
     * @throws Exception
     */
    public void start(String inputFile, String outputFile) throws Exception {

        ANTLRInputStream in = new ANTLRInputStream(new FileInputStream(inputFile));
        SaidaParser  output = new SaidaParser();
        
        LaLexer  lexer  = new LaLexer(in);
        LaParser parser = new LaParser(new CommonTokenStream(lexer));
        
        parser.removeErrorListeners();
        lexer .removeErrorListeners();
        
        SyntaticErrorListener syntatic = new SyntaticErrorListener(output);
        LexicalErrorListener   lexical = new LexicalErrorListener(output);

        parser.addErrorListener(syntatic);
        lexer .addErrorListener(lexical);

        try {
            parser.programa();
        }
        catch (ParseCancellationException e) {
            if (e.getMessage() != null) {
                output.println(e.getMessage());
            }
        }

        if (output.isModificado()){
            output.println("Fim da compilacao");
            PrintWriter saida = new PrintWriter(new FileWriter(outputFile));
            saida.print(output);
            saida.flush();
            saida.close();
        }
        else {
            Saida.println("Fim da compilacao");
            PrintWriter saida = new PrintWriter(new FileWriter(outputFile));
            saida.print(Saida.getTexto());
            saida.flush();
            saida.close();
        }
    }

    /**
     * Executes Runner.start() method with the arguments given.
     *
     * @param args array that contains the names of the input and output files
     * @throws java.lang.Exception
     */
    public static void main(String[] args) throws Exception {
        new Runner().start(args[0], args[1]);
    }
}
