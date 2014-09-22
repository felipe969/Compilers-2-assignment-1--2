
package infrastructure;

import java.util.HashMap;

/**
 *
 * @author Lucas
 */
public class StringConversionMap {
    
    HashMap<String, String> tokens;
    
    public StringConversionMap() {
        tokens = new HashMap<>();
        
        // place all possible tokens here
        tokens.put("<EOF>", "EOF");
    }
    
    public String value(String key) {
        return tokens.get(key);
    }
    
    public boolean containsKey(String key) {
        return tokens.containsKey(key);
    }
    
}
