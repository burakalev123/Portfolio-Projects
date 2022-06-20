CREATE PROCEDURE pr_Names @VarPrice money AS BEGIN -- The print statement returns text to the user --
PRINT 'Products less than' + CAST(@VarPrice AS varchar(10));

-- A Second statement starts here 
SELECT
	ProductName,
	Price
FROM
	vw_Names
WHERE
	Price < @VarPrice;

END
GO
	EXECUTE pr_Names 10.000
GO