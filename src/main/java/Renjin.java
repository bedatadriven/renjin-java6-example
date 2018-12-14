import org.renjin.script.RenjinScriptEngine;
import org.renjin.script.RenjinScriptEngineFactory;
import org.renjin.sexp.AtomicVector;

import javax.script.ScriptException;

/**
 * This class can be referenced in a stored procedure or function
 */
public class Renjin {

  private static final ThreadLocal<RenjinScriptEngine> ENGINE = new ThreadLocal<RenjinScriptEngine>();

  public static double dnorm(double x) throws ScriptException, NoSuchMethodException {
    RenjinScriptEngine engine = ENGINE.get();
    if(engine == null) {
      RenjinScriptEngineFactory factory = new RenjinScriptEngineFactory();
      engine = factory.getScriptEngine();
      ENGINE.set(engine);
    }

    AtomicVector result = (AtomicVector) engine.invokeFunction("dnorm", x);
    return result.getElementAsDouble(0);
  }
}
