package infrastructure;

/**
 *
 * @author Lucas
 */
public class UnrecognizedTokenException extends RuntimeException {

    /**
     * Creates a new instance of <code>UnrecognizedTokenException</code> without
     * detail message.
     */
    public UnrecognizedTokenException() {
    }

    /**
     * Constructs an instance of <code>UnrecognizedTokenException</code> with
     * the specified detail message.
     *
     * @param msg the detail message.
     */
    public UnrecognizedTokenException(String msg) {
        super(msg);
    }
}
