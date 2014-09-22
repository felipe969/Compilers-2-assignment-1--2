package infrastructure;

import java.util.BitSet;
import org.antlr.v4.runtime.ANTLRErrorListener;
import org.antlr.v4.runtime.CommonToken;
import org.antlr.v4.runtime.Parser;
import org.antlr.v4.runtime.RecognitionException;
import org.antlr.v4.runtime.Recognizer;
import org.antlr.v4.runtime.atn.ATNConfigSet;
import org.antlr.v4.runtime.dfa.DFA;
import org.antlr.v4.runtime.misc.ParseCancellationException;

public class LexicalErrorListener implements ANTLRErrorListener {

    SaidaParser sp;
    StringConversionMap tokens;

    public LexicalErrorListener(SaidaParser sp) {
        this.sp = sp;
        tokens = new StringConversionMap();
    }

    @Override
    public void syntaxError(Recognizer<?, ?> rcgnzr, Object o, int i, int i1, String string, RecognitionException re) {
        
        
        // extracting undentified token from message
        String token = string.substring(string.indexOf('\'')+1, string.lastIndexOf('\''));
        
        if(tokens.containsKey(token)) {
            token = tokens.value(token);
        } else {
            token = token.substring(0,1);
        }
        
        if(token.equals("{")) {
            throw new ParseCancellationException("Linha " + (i+1) + ": comentario nao fechado");
        }
        else {
        throw new ParseCancellationException("Linha " + i + ": " + token + " - simbolo nao identificado");
        }
    }
    
    @Override
    public void reportAmbiguity(Parser parser, DFA dfa, int i, int i1, boolean bln, BitSet bitset, ATNConfigSet atncs) {
        throw new UnsupportedOperationException("Not supported yet."); //To change body of generated methods, choose Tools | Templates.
    }

    @Override
    public void reportAttemptingFullContext(Parser parser, DFA dfa, int i, int i1, BitSet bitset, ATNConfigSet atncs) {
        throw new UnsupportedOperationException("Not supported yet."); //To change body of generated methods, choose Tools | Templates.
    }

    @Override
    public void reportContextSensitivity(Parser parser, DFA dfa, int i, int i1, int i2, ATNConfigSet atncs) {
        throw new UnsupportedOperationException("Not supported yet."); //To change body of generated methods, choose Tools | Templates.
    }
}
