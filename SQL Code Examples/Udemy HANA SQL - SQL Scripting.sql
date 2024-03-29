/* What is SQL Scripting */
-- It is the language to write stored Procedures and user-defined functions in SAP HANA
-- It is and extension of ANSI SQL
--
/* Goal of SQL Scripting */
-- Eliminate data transfer between database & application layers (PUSHDOWN)
-- Calculations are executed at database layer to get benefits of HANA Database - like column operations, parallel processing of queries etc.
/* Advantages of SQL Scripting */
-- Moduler programming
-- Local variables for intermediate results
-- Supports parameters
-- Flow control logic (IF-THEN-ELSE) Loops(WHILE,FOR)
-- Stored Procedure can return multiple results
------------------------------------------------------
--    Object     |  Performance |   Functionality  |
------------------------------------------------------
--  Scalar UDF   |    High      |    Low           |
------------------------------------------------------
--  Table UDF    |    High      |    Moderate      |
------------------------------------------------------
--  Stored Proc. |              |                  |
------------------------------------------------------
--  Views        |              |                  |
------------------------------------------------------
-------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------
-- Scalar User-Defined Functions (SUDF)
-- Only expressions are allowed not SELECT statements.
SELECT
  CURRENT_DATE
FROM
  DUMMY;

--SAP Provided Formula in use
SELECT
  UPPER(Title),
  MRP
FROM
  "T4H"."Books";

-- SAP Provided formula in use
SELECT
  UPPER(Title),
  MRP,
  (MRP - (MRP * (20 / 200))) as FINAL_PRICE
FROM
  "T4H"."Books";

-- SAP Provided and Custom Formula
-- HANA DataBase Explorer
CREATE FUNCTION FPRICE (IP DECIMAL(10, 2)) -- IP variable parameter
RETURNS RESULT DECIMAL(10, 2) LANGUAGE SQLSCRIPT SQL SECURITY INVOKER AS BEGIN RESULT := IP - (:IP * (20 / 200));

END;

-- SAP Business Application Studio
FUNCTION "FPRICE2"(IN IP DECIMAL(10, 2)) RETURNS RESULT DECIMAL(10, 2) LANGUAGE SQLSCRIPT SQL SECURITY INVOKER AS BEGIN RESULT = :IP - (:IP * (20 / 200));

END;

SELECT
  UPPER(Title),
  MRP,
  FPRICE(MRP) AS FINAL_PRICE
FROM
  "T4H"."Books";

-- Exception Handling
FUNCTION "FPRICE2"(IN IP1 DECIMAL(10, 2), IN IP2 DECIMAL(2, 2)) RETURNS RESULT DECIMAL(10, 2) LANGUAGE SQLSCRIPT SQL SECURITY INVOKER AS BEGIN DECLARE INVALID_DISCOUNT CONDITION FOR SQL_ERROR_CODE 10001;

-- 10001 to 99999 custom error codes, below 10000 cannot be used
IF :IP2 >= 0 THEN RESULT = :IP1 - (:IP1 * (IP2 / 200));

ELSE SIGNAL INVALID_DISCOUNT
SET
  MESSAGE_TEXT = 'Discount Value ' || :IP2 || ' must be greater than zero(0)';

END IF;

END;

-- Factorial Function
FUNCTION "FACTORIAL"(I INT) RETURNS F INT LANGUAGE SQLSCRIPT SQL SECURITY INVOKER AS BEGIN DECLARE X INT = 2;

F = 1;

WHILE X <= :I DO F = :F * :X;

X = :X + 1;

END WHILE;

END;

-- Summary of Scalar UDF's
-- 1. You can use more than one Input Parameter
-- 2. Returns Scalar Values
-- 3. Body can contain only expressions and imperative logic
-- 4. You can't use SQL statements in the body.
-- 5. You can use functions in SELECT, WHERE, GROUP BY.
-- 6. You can call in another UDF's or stored proc.
-- 7. Most simple DB  object in SQL Scripting
-------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------
-- Table User-Defined Functions (TUDF)
FUNCTION "TF_BOOKS"(CAT VARCHAR(10)) RETURNS TABLE (
  BOOK_ID VARCHAR(3),
  CATEGORY VARCHAR(20),
  MRP DECIMAL(10, 2)
) LANGUAGE SQLSCRIPT SQL SECURITY INVOKER AS BEGIN RETURN
SELECT
  BOOK_ID,
  CATEGORY,
  MRP
FROM
  "T4H"."Books"
WHERE
  CATEGORY = :CAT;

END;

-- Scalar Func. in Table Func.
FUNCTION "TF_BOOKS"(CAT VARCHAR(10)) RETURNS TABLE (
  BOOK_ID VARCHAR(3),
  CATEGORY VARCHAR(20),
  MRP DECIMAL(10, 2),
  FINAL_PRICE DECIMAL(10, 2)
) LANGUAGE SQLSCRIPT SQL SECURITY INVOKER AS BEGIN RETURN
SELECT
  BOOK_ID,
  CATEGORY,
  MRP,
  FPRICE2(MRP, 20) AS FINAL_PRICE
FROM
  "T4H"."Books"
WHERE
  CATEGORY = :CAT;

END;

--Dynamic Filtering
FUNCTION "TF_BOOKS"(FILTER_STRING VARCHAR(1000)) RETURNS TABLE (
  BOOK_ID VARCHAR(3),
  CATEGORY VARCHAR(20),
  MRP DECIMAL(10, 2),
  FINAL_PRICE DECIMAL(10, 2)
) LANGUAGE SQLSCRIPT SQL SECURITY INVOKER AS BEGIN TEMP_TAB_VAR = APPLY_FILTER("T4H"."Books", :FILTER_STRING);

RETURN
SELECT
  BOOK_ID,
  CATEGORY,
  MRP,
  FPRICE2(MRP, 20) AS FINAL_PRICE
FROM
  :TEMP_TAB_VAR;

END;

-- Stored Procedures
PROCEDURE "deneme"() -- Parameter Clause: IN | OUT | INOUT ==> Default IN
LANGUAGE SQLSCRIPT -- SQLScript | R ==> Default SQLScript
SQL SECURITY INVOKER -- Mode -> DEFINER | INVOKER ==> Default DEFINER
--DEFAULT SCHEMA <default_schema_name>
READS SQL DATA AS BEGIN SEQUENTIAL EXECUTION -- Paralel islemden cikarip sirali isleme gecis icin
/*************************************
 Write your procedure logic
 *************************************/
END PROCEDURE "deneme"() LANGUAGE SQLSCRIPT SQL SECURITY INVOKER --DEFAULT SCHEMA <default_schema_name>
READS SQL DATA AS BEGIN
SELECT
  *
FROM
  "Books";

END -- Example Procedure, IF statement used and Table and input variable used.  
PROCEDURE "FILTER_BOOKS"(IN CAT VARCHAR(1)) LANGUAGE SQLSCRIPT SQL SECURITY INVOKER --DEFAULT SCHEMA <default_schema_name>
READS SQL DATA AS BEGIN --Table variable decleration
DECLARE X VARCHAR(10);

IF :CAT = 'p' THEN X = 'pdf';

ELSEIF :CAT = 'e' THEN X = 'e-book';

ELSE X = 'Printed';

END IF;

SELECT
  BOOK_ID,
  CATEGORY,
  MRP
FROM
  "Books"
WHERE
  CATEGORY = :X;

END CALL "T4H_1"."FILTER_BOOKS"(CAT = > 'p');

--------------------------------------------------------------------------
-- Example Procedure, OUTPUT Variable added
PROCEDURE "FILTER_BOOKS"(
  -- Input Variable
  IN CAT VARCHAR(1),
  -- Output Variable as a Table
  OUT RESULT TABLE(
    BOOK_ID VARCHAR(3),
    CATEGORY VARCHAR(10),
    MRP DECIMAL(10, 2)
  )
) LANGUAGE SQLSCRIPT SQL SECURITY INVOKER --DEFAULT SCHEMA <default_schema_name>
READS SQL DATA AS BEGIN --Table variable decleration
DECLARE X VARCHAR(10);

IF :CAT = 'p' THEN X = 'pdf';

ELSEIF :CAT = 'e' THEN X = 'e-book';

ELSE X = 'Printed';

END IF;

RESULT =
SELECT
  BOOK_ID,
  CATEGORY,
  MRP
FROM
  "Books"
WHERE
  CATEGORY = :X;

END CALL "T4H_1"."FILTER_BOOKS"(CAT = > 'p', RESULT = > ?) --------------------------------------------------------------------------
-- Table Variables
-- Explicit & Derived type of declaration of variables
DECLARE X VARCHAR(10);

DECLARE X TABLE (I INT, AMOUNT DECIMAL(10, 2)) DECLARE X TABLE_TYPE DEFAULT
SELECT
  *
FROM
  < "XXX Table" > ---------------------------
  PROCEDURE "TV_EXPLICIT"(OUT RESULTS TABLE(NUM INT)) -- Temporary Variable Explicit method
  LANGUAGE SQLSCRIPT SQL SECURITY INVOKER --DEFAULT SCHEMA <default_schema_name>
  READS SQL DATA AS BEGIN DECLARE TTV TABLE(NUM INT);

-- Even if it is not declared, if it starts with SELECT, it will be created by itself. 
TTV =
SELECT
  1 AS NUM
FROM
  DUMMY;

RESULTS =
SELECT
  *
FROM
  :TTV;

END -- If you DECLARE a variable in a block EXPLICITLY it will only be in that block
-- If you dont DECLARE a variable it will be GENERAL variable, even if there multiple blocks.
--------------------------------------------------------------------------
--Table Type -- Simple Structure
CREATE TYPE tab_table AS TABLE (ID INT, NAME VARCHAR(10));

-- Usage of in a procedure
-- Created the Table structure outside of the procedure and use it at OUT variable
CREATE TYPE PART_BOOK AS TABLE (
  BOOK_ID VARCHAR(3),
  CATEGORY VARCHAR(10),
  MRP DECIMAL(10, 2)
);

PROCEDURE "PART_BOOKS"(
  -- Input Variable
  IN CAT VARCHAR(1),
  -- Output Variable as a Table
  OUT RESULT PART_BOOK
) LANGUAGE SQLSCRIPT SQL SECURITY INVOKER --DEFAULT SCHEMA <default_schema_name>
READS SQL DATA AS BEGIN --Table variable decleration
DECLARE X VARCHAR(10);

IF :CAT = 'p' THEN X = 'pdf';

ELSEIF :CAT = 'e' THEN X = 'e-book';

ELSE X = 'Printed';

END IF;

RESULT =
SELECT
  BOOK_ID,
  CATEGORY,
  MRP
FROM
  "Books"
WHERE
  CATEGORY = :X;

END -- Transaction Application
set schema
  T4H;

CREATE COLUMN TABLE TRANSACTIONS (
  TRX_ID INT,
  TRX_TS TIMESTAMP,
  ACCOUNT INT,
  AMOUNT DECIMAL(10, 2),
  ACTI ON VARCHAR(1)
);

INSERT INTO
  "TRANSACTIONS"
VALUES
  (1000, NOW(), 1, 100, 'D');

INSERT INTO
  "TRANSACTIONS"
VALUES
  (1001, NOW(), 2, 100, 'D');

SELECT
  *
FROM
  "TRANSACTIONS";

-------------------
PROCEDURE "TRANSACTIONS_APP"(
  IN ACCOUNT INT,
  IN AMOUNT DECIMAL(10, 2),
  IN ACTION VARCHAR(1),
  OUT MSG1 NVARCHAR(100),
  OUT MSG2 NVARCHAR(100)
) LANGUAGE SQLSCRIPT SQL SECURITY INVOKER --DEFAULT SCHEMA <default_schema_name>
-- READS SQL DATA 
AS BEGIN DECLARE TRX INT DEFAULT 1;

DECLARE BALANCE DECIMAL(10, 2) DEFAULT 1.0;

IF :ACTION = 'D' THEN
SELECT
  MAX(TRX_ID) + 1 INTO TRX
FROM
  "TRANSACTIONS";

INSERT INTO
  "TRANSACTIONS"
VALUES
  (:TRX, NOW(), :ACCOUNT, :AMOUNT, :ACTION);

MSG1 = 'Transaction successful and $' || :AMOUNT || ' Deposited into your account';

SELECT
  SUM(AMOUNT) INTO BALANCE
FROM
  "TRANSACTIONS"
WHERE
  ACCOUNT = :ACCOUNT;

MSG2 = 'Your available balance is: $' || :BALANCE;

ELSEIF :ACTION = 'W' THEN
SELECT
  SUM(AMOUNT) INTO BALANCE
FROM
  "TRANSACTIONS";

IF :BALANCE > :AMOUNT THEN
SELECT
  MAX(TRX_ID) + 1 INTO TRX
FROM
  "TRANSACTIONS";

AMOUNT = :AMOUNT * (-1);

INSERT INTO
  "TRANSACTIONS"
VALUES
  (:TRX, NOW(), :ACCOUNT, :AMOUNT, :ACTION);

MSG1 = 'Transaction successful and $' || :AMOUNT || ' is deducted from your account';

SELECT
  SUM(AMOUNT) INTO BALANCE
FROM
  "TRANSACTIONS"
WHERE
  ACCOUNT = :ACCOUNT;

MSG2 = 'Your available balance is: $' || :BALANCE;

ELSE MSG1 = 'Insufficient funds';

MSG2 = 'Try again with less amount';

END IF;

ELSE MSG1 = 'Invalid Transaction Type';

MSG2 = 'Please try again with D/W transaction types'
END IF;

END