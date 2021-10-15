/* What is SQL Scripting */
-- It is the language to write stored Procedures and user-defined functions in SAP HANA
-- It is and extension of ANSI SQL

/* Goal of SQL Scripting */
-- Eliminate data transfer between database & application layers (PUSHDOWN)
-- Calculations are executed at database layer to get benefits of HANA Database - like column operations, parallel processing of queries etc.

/* Advantages of SQL Scripting */
-- Moduler programming
-- Local variables for intermediate results
-- Supports parameters
-- Flow control logic (IF-THEN-ELSE) Loops(WHILE,FOR)
-- Stored Procedure can return multiple results