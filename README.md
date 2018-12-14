
Renjin Example with Oracle 11.2g R2
===================================

This example demonstrates how R can be used in an Oracle
Stored Procedure with the help of Renjin.

## Oracle Database Setup

This example requires Oracle 11g, release 11.2.0.4 or later. Earlier
releases do not support Java 1.6. Note that Oracle XE does not support
Java-language stored procedures at all.

This repository includes a Vagrant file that will construct a Virtual
Box Virtual Machine with a development version of Oracle 11g R2.0.4
installed. Visit the [Vagrant website](https://www.vagrantup.com/) for
installation instructions.

You should be able to create the virtual machine and connect to the
database as follows:

```
$ vagrant --version
Vagrant 2.2.2

$ vagrant up
$ vagrant ssh
Last login: Fri Dec 14 16:55:49 2018 from 10.0.2.2

[oracledb@oraclebox ~]$ sqlplus /nolog
SQL*Plus: Release 11.2.0.4.0 Production on Fri Dec 14 16:56:56 2018

Copyright (c) 1982, 2013, Oracle.  All rights reserved.

SQL> CONNECT dbpass/sys as sysdba
Connected.

SQL> SELECT 1+1 FROM DUAL;

       1+1
----------
         2

```

## Renjin Build Configuration

This example also requires access to the Renjin certified release
repository, where we publish a version of Renjin compatible with
Java 1.6. To request access, contact support@renjin.org.

To build, you must include your credentials for the
Nexus Repository for the Java 1.6 build of the Certified Release 3.4
in your Maven settings.xml file:


```.xml
<settings xmlns="http://maven.apache.org/SETTINGS/1.0.0"
xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
xsi:schemaLocation="http://maven.apache.org/SETTINGS/1.0.0
                  https://maven.apache.org/xsd/settings-1.0.0.xsd">
<localRepository/>
<interactiveMode/>
<usePluginRegistry/>
<offline/>
<pluginGroups/>
<servers>
    <server>
        <id>renjin-certified</id>
        <username>YOUR_USERNAME</username>
        <password>YOUR_PASSWORD</password>
    </server>
</servers>
<mirrors/>
<proxies/>
<profiles/>
<activeProfiles/>
</settings>
```

Run `mvn test` to verify that configuration is correct.


## Writing a Java Wrapper

We need a [Java class](src/main/java/Renjin.java) that we can
reference in a stored procedure or function:

```.java
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
```

The class above starts a new Renjin session if one is not already
running and includes a static function which calls the `dnorm` function
from the stats package.

## Build the JAR

Next, we'll use the Maven assembly plugin to create a jar that includes
not only our Renjin class with the `dnorm` function but also all
required dependencies.

```
mvn package
```

This will produce the archive `renjin-oracle11g-example-1.0-SNAPSHOT-jar-with-dependencies.jar`
in the `target` directory.

## Load the JAR into Oracle

Before we can use Renjin and our wrapper class in the database, we need
to load the JAR into the database.

```.sh
[oracledb@oraclebox ~]$ loadjava -force \
         -resolve \
         -grant public \
         -genmissingjar /vagrant/missing.jar \
         -fileout /vagrant/loadjava.log \
         -verbose  \
         /vagrant/target/renjin-oracle11g-example-1.0-SNAPSHOT-jar-with-dependencies.jar

exiting  : Failures occurred during processing

```

The log will contain a number of warnings about missing classes.

The reason that the Oracle JVM considers these classes to be "missing"
stems from a difference in the way the Oracle JVM and most JVMs resolve
classes: the Oracle Database JVM appears to try to resolve all
references found in all classes when loadjava is invoked.

A "normal" JVM on the other hand, only resolves classes when they
are actually used. The BLAS/Lapack library that Renjin uses,
for example, contains references to a generator class that is never
used at runtime.

We know that these "missing" classes aren't actually required because
the Renjin release passes the full Renjin test suite without them.

# Define the function

Finally, we create an SQL function `renjin_dnorm` that references
the static method from our wrapper class.

```
$ vagrant ssh
Last login: Fri Dec 14 15:14:15 2018 from 10.0.2.2

[oracledb@oraclebox ~]$ sqlplus /nolog

SQL*Plus: Release 11.2.0.4.0 Production on Fri Dec 14 15:25:08 2018

Copyright (c) 1982, 2013, Oracle.  All rights reserved.

SQL> CONNECT dbpass/sys as sysdba
Connected.

SQL> CREATE OR REPLACE FUNCTION renjin_dnorm(x FLOAT)
  2        RETURN FLOAT
  3        AS LANGUAGE JAVA
  4        NAME 'Renjin.dnorm(double) return double';
  5  /

Function created.

SQL> SELECT renjin_dnorm(0) FROM dual;


RENJIN_DNORM(0)
---------------
      .39894228

```

See the [test.sql](shell/test.sql) script for further examples.
