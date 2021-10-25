SET SCHEMA T4H;
DROP TABLE PRODUCT;
DROP TABLE REGION;
DROP TABLE SALES;

-- Create Product table
create column table PRODUCT
( 
	PRODUCT_ID INTEGER, 
    PRODUCT_NAME VARCHAR (100),
    primary key (PRODUCT_ID)
);
insert into PRODUCT values(1,'MicroSD card');
insert into PRODUCT values(2,'Bluetooth speaker');
insert into PRODUCT values(3,'Smart TV');
insert into PRODUCT values(4,'Laptop');
insert into PRODUCT values(5,'Mobile');
insert into PRODUCT values(6,'Projector');
insert into PRODUCT values(7,'Mini PC');
insert into PRODUCT values(8,'Fitness tracker');
insert into PRODUCT values(9,'Camera');

--Create Region table
create column table REGION
(
	REGION_ID INTEGER, 
	REGION_NAME VARCHAR (20),
	DIVISION VARCHAR (30),
	PRIMARY KEY (REGION_ID) 
);
insert into REGION values(1,'Americas','North-America');
insert into REGION values(2,'Americas','South-America');
insert into REGION values(3,'Asia','India');
insert into REGION values(4,'Asia','Japan');
insert into REGION values(5,'Asia','Chaina');
insert into REGION values(6,'Europe','Germany');
insert into REGION values(7,'Europe','UK');
insert into REGION values(8,'Africa','Egypt');
insert into REGION values(9,'Australia','Sidney');

--Create Sales table
create column table SALES
(
	SO_ID INT,
    TRX_DATE DATE,
    REGION_ID INTEGER ,
    PRODUCT_ID INTEGER ,
    SALES_AMOUNT DOUBLE,
    PRIMARY KEY (SO_ID) 
);

-- Requirement of procedure
--	Insert records into sales table based on value of input parameter
--	Hint: use RAND() function
--	SO_ID: is an incremental value
--	TRX_DATE: use DATE functions and RAND() function.
--	Rest of the fields, you can use RAND() function.

PROCEDURE "GENERATE_SALES_DATA"(IN RECS INT)
   LANGUAGE SQLSCRIPT
   SQL SECURITY INVOKER
   --DEFAULT SCHEMA <default_schema_name>
   --READS SQL DATA 
   AS
BEGIN
DECLARE CNTR INT DEFAULT 0; -- Counter
    -- Check for table empty or not...
    IF NOT IS_EMPTY(SALES) THEN
        DELETE FROM SALES;
    END IF;

    WHILE CNTR < :RECS DO
        INSERT INTO SALES 
            SELECT :CNTR+1000, -- Sales Order ID
                    ADD_DAYS (TO_DATE('2017-01-01', 'YYYY-MM-DD'), RAND()*730), -- Transaction Date
                    SUBSTR (ROUND((RAND()*9)+1,0),1,1), -- Region ID
                    SUBSTR (ROUND((RAND()*9)+1,0),1,1), -- Product ID
                    ROUND(RAND()*1000,0) -- Sales Amount 
            FROM "DUMMY";
        CNTR := CNTR+1;
    END WHILE;

END