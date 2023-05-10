SELECT DISTINCT t_region."User_ID",
  t_comp_code."Comp_Code"
FROM (
    (
      (
        "DOE_AUTHW_REGION" AS t_region
        INNER JOIN "DOE_AUTHW_AREA" AS t_area ON t_region."User_ID" = t_area."User_ID"
        AND t_region."Region" = t_area."Region"
      )
      INNER JOIN "DOE_AUTHW_COUNTRY" AS t_country ON t_region."User_ID" = t_country."User_ID"
      AND t_region."Region" = t_country."Region"
      AND t_area."Area" = t_country."Area"
    )
    INNER JOIN "DOE_AUTHW_COMP_CODE" AS t_comp_code ON t_region."User_ID" = t_comp_code."User_ID"
    AND t_region."Region" = t_comp_code."Region"
    AND t_country."Country" = t_comp_code."Country"
    AND t_area."Area" = t_comp_code."Area"
  );