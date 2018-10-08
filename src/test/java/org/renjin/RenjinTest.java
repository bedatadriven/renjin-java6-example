package org.renjin;

import org.junit.Test;
import org.renjin.script.RenjinScriptEngine;
import org.renjin.script.RenjinScriptEngineFactory;

import javax.script.ScriptException;

public class RenjinTest {

  @Test
  public void test() throws ScriptException {
    RenjinScriptEngineFactory factory = new RenjinScriptEngineFactory();
    RenjinScriptEngine session = factory.getScriptEngine();
    session.eval("print(pnbinom(0:12, size  = 2, prob = 1/2))");
  }
}
