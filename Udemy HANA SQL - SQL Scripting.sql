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

SELECT CURRENT_DATE FROM DUMMY;  --SAP Provided Formula in use

SELECT UPPER(Title), MRP FROM "T4H"."Books"; -- SAP Provided formula in use

SELECT UPPER(Title), MRP, (MRP - (MRP * (20/200))) as FINAL_PRICE FROM "T4H"."Books"; -- SAP Provided and Custom Formula

-- HANA DataBase Explorer
CREATE FUNCTION FPRICE (IP DECIMAL(10,2)) -- IP variable parameter
RETURNS RESULT DECIMAL(10,2)
LANGUAGE SQLSCRIPT
SQL SECURITY INVOKER AS 
BEGIN
RESULT:= IP - (:IP * (20/200));
END;

-- SAP Business Application Studio
FUNCTION "FPRICE2"(IN IP DECIMAL(10, 2))
   	RETURNS RESULT DECIMAL(10, 2)
    LANGUAGE SQLSCRIPT
    SQL SECURITY INVOKER AS
BEGIN
    	RESULT = :IP - ( :IP * ( 20 / 200 ) );
END;

SELECT 
	UPPER(Title),
	MRP,
	FPRICE(MRP) AS FINAL_PRICE
FROM "T4H"."Books";

-- Exception Handling
FUNCTION "FPRICE2"(IN IP1 DECIMAL(10, 2), IN IP2 DECIMAL(2, 2)) 
  RETURNS RESULT DECIMAL(10, 2) 
  LANGUAGE SQLSCRIPT 
  SQL SECURITY INVOKER AS 
BEGIN
  DECLARE INVALID_DISCOUNT CONDITION FOR SQL_ERROR_CODE 10001; -- 10001 to 99999 custom error codes, below 10000 cannot be used
  IF :IP2 >= 0 THEN RESULT = :IP1 - (:IP1 * (IP2 / 200));
  ELSE SIGNAL INVALID_DISCOUNT
  SET MESSAGE_TEXT = 'Discount Value ' || :IP2 || ' must be greater than zero(0)';
END IF;
END;

-- Factorial Function
FUNCTION "FACTORIAL"(I INT) 
  RETURNS F INT 
  LANGUAGE SQLSCRIPT 
  SQL SECURITY INVOKER AS 
BEGIN
  DECLARE X INT = 2;
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

FUNCTION "TF_BOOKS"(CAT VARCHAR(10)) 
  RETURNS TABLE (
    BOOK_ID VARCHAR(3),
    CATEGORY VARCHAR(20),
    MRP DECIMAL(10, 2)
  ) 
  LANGUAGE SQLSCRIPT 
  SQL SECURITY INVOKER AS 
BEGIN 
  RETURN
  SELECT BOOK_ID,
    CATEGORY,
    MRP
  FROM "T4H"."Books"
  WHERE CATEGORY = :CAT;
END;

-- Scalar Func. in Table Func.
FUNCTION "TF_BOOKS"(CAT VARCHAR(10)) 
  RETURNS TABLE (
    BOOK_ID VARCHAR(3),
    CATEGORY VARCHAR(20),
    MRP DECIMAL(10, 2),
    FINAL_PRICE DECIMAL(10, 2)
  ) 
  LANGUAGE SQLSCRIPT 
  SQL SECURITY INVOKER AS 
BEGIN 
  RETURN
  SELECT BOOK_ID,
    CATEGORY,
    MRP,
    FPRICE2(MRP, 20) AS FINAL_PRICE
  FROM "T4H"."Books"
  WHERE CATEGORY = :CAT;
END;

--Dynamic Filtering

FUNCTION "TF_BOOKS"(FILTER_STRING VARCHAR(1000)) 
  RETURNS TABLE (
    BOOK_ID VARCHAR(3),
    CATEGORY VARCHAR(20),
    MRP DECIMAL(10, 2),
    FINAL_PRICE DECIMAL(10, 2)
  ) 
  LANGUAGE SQLSCRIPT 
  SQL SECURITY INVOKER AS 
BEGIN TEMP_TAB_VAR = APPLY_FILTER("T4H"."Books", :FILTER_STRING);
  RETURN
  SELECT BOOK_ID,
    CATEGORY,
    MRP,
    FPRICE2(MRP, 20) AS FINAL_PRICE
  FROM :TEMP_TAB_VAR;
END;