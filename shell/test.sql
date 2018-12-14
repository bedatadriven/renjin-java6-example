
CONNECT dbpass/sys as sysdba

WHENEVER SQLERROR exit sql.sqlcode;

CREATE OR REPLACE FUNCTION renjin_dnorm(x FLOAT)
      RETURN FLOAT
      AS LANGUAGE JAVA
      NAME 'Renjin.dnorm(double) return double';
/

-- Should return .39894...
SELECT renjin_dnorm(0) FROM dual;

-- create a full table
CREATE TABLE numbers (x FLOAT);
INSERT INTO numbers (x) VALUES (0);
INSERT INTO numbers (x) VALUES (1.5);
INSERT INTO numbers (x) VALUES (2);
INSERT INTO numbers (x) VALUES (-1.5);
INSERT INTO numbers (x) VALUES (.5);
INSERT INTO numbers (x) VALUES (.2);

SELECT x, renjin_dnorm(x) FROM numbers;

EXIT;