DROP TABLE EMPLOYEE;
CREATE COLUMN TABLE EMPLOYEE
(
	FNAME	NVARCHAR(10),
	"Lname"	NVARCHAR(10),
	ID		INT,
	AGE		INT,
	DOJ		DATE,
	CITY	NVARCHAR(10),
	SALARY	DECIMAL(10,2)
);

INSERT INTO EMPLOYEE VALUES ('David',	'Gray',		99220,	60,	'20170120',	'SFO',	5000);
INSERT INTO EMPLOYEE VALUES ('Mary',	'Smith',	99233,	50,	'20160814',	'HYD',	9655);
INSERT INTO EMPLOYEE VALUES ('Edward',	NULL,		98820,	40,	'20170126',	'NY',	3400);
INSERT INTO EMPLOYEE VALUES ('Bill',	'Clinton',	98720,	30,	'20151010',	'LON',	9800);
INSERT INTO EMPLOYEE VALUES ('Steve',	'Beck',		79299,	23,	'20101212',	'PAR',	8080);
INSERT INTO EMPLOYEE VALUES ('Mary Fond','Lin',		90009,	44,	'19991101',	'DELHI',4500);
INSERT INTO EMPLOYEE VALUES ('David',	'Brown',	50905,	52,	'20000531',	'TOK',	5000);

SELECT * FROM EMPLOYEE;

--List the first name, last name and age for everyone that's in the table.

--List the first name and city for everyone that's not from SFO.

--List the first and last names for everyone whose first name ends in "d".

--List all columns for everyone whose first name equals "Mary".

--List all columns for everyone whose first name contains "Mary".

--List unique first names

--List all columns where city text length is not equal to 3.

--List first name, id, department (first two digits of ID represents dept)

--List all columns where last name not found.

--List all columns and sort by their work experience.

--List all columns and where they have more than 2 years of work experience.

--List id, fname, doj and work aniversary of all employees.

--Who is highest salary paid employee

--List total salary to be paid every month after deducting 15% tax

--List first name, salary, tax (if salary > 5000 then 20% else 15%)

-- List all departments and it's max and min salaries

