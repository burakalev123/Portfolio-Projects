/* The Address Table has 78  rows 
   The Business Partner Tbale has 45 rows*/

Select * from "PROJECT1_HDI_DB_1"."MD.BusinessPartner" AS A
	inner join "PROJECT1_HDI_DB_1"."MD.Addresses" AS B
	On A."ADDRESSES.ADDRESSID" = B."ADDRESSID"
	
Select * from "PROJECT1_HDI_DB_1"."MD.BusinessPartner" AS A
	Left outer join "PROJECT1_HDI_DB_1"."MD.Addresses" AS B
	On A."ADDRESSES.ADDRESSID" = B."ADDRESSID"
	
Select * from "PROJECT1_HDI_DB_1"."MD.Addresses" AS A
	Left outer join "PROJECT1_HDI_DB_1"."MD.BusinessPartner" AS B
	On  A."ADDRESSID" = B."ADDRESSES.ADDRESSID"
	
Select * from "PROJECT1_HDI_DB_1"."MD.BusinessPartner" AS A
	Right outer join "PROJECT1_HDI_DB_1"."MD.Addresses" AS B
	On A."ADDRESSES.ADDRESSID" = B."ADDRESSID"	

Select * from "PROJECT1_HDI_DB_1"."MD.BusinessPartner" AS A
	Full join "PROJECT1_HDI_DB_1"."MD.Addresses" AS B
	On A."ADDRESSES.ADDRESSID" = B."ADDRESSID"

------------------

Select * from "PROJECT1_HDI_DB_1"."MD.BusinessPartner" AS A
	Left outer join "PROJECT1_HDI_DB_1"."MD.Addresses" AS B
	On A."ADDRESSES.ADDRESSID" = B."ADDRESSID"
	
Select * from "PROJECT1_HDI_DB_1"."MD.Addresses" AS A
	Left outer join "PROJECT1_HDI_DB_1"."MD.BusinessPartner" AS B
	On  A."ADDRESSID" = B."ADDRESSES.ADDRESSID"
	
Select * from "PROJECT1_HDI_DB_1"."MD.BusinessPartner" AS A
	Right outer join "PROJECT1_HDI_DB_1"."MD.Addresses" AS B
	On A."ADDRESSES.ADDRESSID" = B."ADDRESSID"	

Select * from "PROJECT1_HDI_DB_1"."MD.BusinessPartner" AS A
	Full join "PROJECT1_HDI_DB_1"."MD.Addresses" AS B
	On A."ADDRESSES.ADDRESSID" = B."ADDRESSID"

Select * from "PROJECT1_HDI_DB_1"."MD.Addresses" AS A
	Full join "PROJECT1_HDI_DB_1"."MD.BusinessPartner" AS B
	On B."ADDRESSES.ADDRESSID" = A."ADDRESSID"

Select * from "PROJECT1_HDI_DB_1"."MD.Products" AS P
	Inner Join "PROJECT1_HDI_DB_1"."MD.BusinessPartner" AS B
	ON P."SUPPLIER.PARTNERID" = B."PARTNERID"
	

Select * from "PROJECT1_HDI_DB_1"."MD.Products" AS P
	Inner Join "PROJECT1_HDI_DB_1"."MD.BusinessPartner" AS B
	ON P."SUPPLIER.PARTNERID" = B."PARTNERID"
	
Select P.PRODUCTID, B.PARTNERID from "PROJECT1_HDI_DB_1"."MD.Products" AS P
	Inner Join "PROJECT1_HDI_DB_1"."MD.BusinessPartner" AS B
	ON P."SUPPLIER.PARTNERID" = B."PARTNERID"