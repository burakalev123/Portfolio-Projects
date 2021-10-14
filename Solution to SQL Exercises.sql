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
SELECT FNAME, "Lname", AGE FROM EMPLOYEE;
--List the first name and city for everyone that's not from SFO.
SELECT FNAME, AGE FROM EMPLOYEE WHERE CITY <> 'SFO';
--List the first and last names for everyone whose first name ends in "d".
SELECT FNAME, "Lname" FROM EMPLOYEE WHERE FNAME LIKE '%d';
--List all columns for everyone whose first name equals "Mary".
SELECT * FROM EMPLOYEE WHERE FNAME = 'Mary';
--List all columns for everyone whose first name contains "Mary".
SELECT * FROM EMPLOYEE WHERE FNAME LIKE '%Mary%';
--List unique first names
SELECT DISTINCT FNAME FROM EMPLOYEE;
--List all columns where city text length is not equal to 3.
SELECT * FROM EMPLOYEE WHERE LENGTH(CITY) <> 3;
--List first name, id, department (first two digits of ID represents dept)
SELECT fname, id, left(id,2) as dept FROM EMPLOYEE 
--List all columns where last name not found.
SELECT * FROM EMPLOYEE WHERE "Lname" is null;
--List all columns and sort by their work experience.
SELECT * FROM EMPLOYEE order by doj;
--List all columns and where they have more than 2 years of work experience.
SELECT *  FROM EMPLOYEE WHERE DAYS_BETWEEN(DOJ, CURRENT_DATE) > 730;
--List id, fname, doj and work aniversary of all employees.
SELECT id, fname, doj, (add_years(doj,(YEARS_BETWEEN(DOJ, CURRENT_DATE)+1) ))  AS "Work Anniversary" FROM EMPLOYEE;
--Who is highest salary paid employee
SELECT top 1 * FROM EMPLOYEE order by salary desc;
--List total salary to be paid every month after deducting 15% tax
SELECT SUM(SALARY - (salary * 0.15)) FROM EMPLOYEE;
--List first name, salary, tax (if salary > 5000 then 20% else 15%)
SELECT fname, SALARY, (CASE WHEN SALARY > 5000 THEN SALARY * 0.2 ELSE SALARY * 0.15 END) AS TAX FROM EMPLOYEE;
-- List dept and it's max and min salaries
select left(id, 2) dept, max(salary), min(salary) from employee group by left(id,2)
