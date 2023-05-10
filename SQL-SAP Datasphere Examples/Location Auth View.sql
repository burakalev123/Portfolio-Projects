SELECT DISTINCT
  "DOE_AUTHW_REGION_0"."User_ID",
  "DOE_AUTHW_COMP_CODE_3"."Comp_Code"
FROM ((("DOE_AUTHW_REGION" AS "DOE_AUTHW_REGION_0" 
  INNER JOIN "DOE_AUTHW_AREA" AS "DOE_AUTHW_AREA_1" ON "DOE_AUTHW_REGION_0"."User_ID" = "DOE_AUTHW_AREA_1"."User_ID" 
    AND "DOE_AUTHW_REGION_0"."Region" = "DOE_AUTHW_AREA_1"."Region") 
      INNER MANY TO MANY JOIN "DOE_AUTHW_COUNTRY" AS "DOE_AUTHW_COUNTRY_2" ON "DOE_AUTHW_REGION_0"."User_ID" = "DOE_AUTHW_COUNTRY_2"."User_ID" 
        AND "DOE_AUTHW_REGION_0"."Region" = "DOE_AUTHW_COUNTRY_2"."Region" 
        AND "DOE_AUTHW_AREA_1"."Area" = "DOE_AUTHW_COUNTRY_2"."Area") 
          INNER JOIN "DOE_AUTHW_COMP_CODE" AS "DOE_AUTHW_COMP_CODE_3" ON "DOE_AUTHW_REGION_0"."User_ID" = "DOE_AUTHW_COMP_CODE_3"."User_ID" 
            AND "DOE_AUTHW_REGION_0"."Region" = "DOE_AUTHW_COMP_CODE_3"."Region" AND "DOE_AUTHW_COUNTRY_2"."Country" = "DOE_AUTHW_COMP_CODE_3"."Country" 
            AND "DOE_AUTHW_AREA_1"."Area" = "DOE_AUTHW_COMP_CODE_3"."Area");