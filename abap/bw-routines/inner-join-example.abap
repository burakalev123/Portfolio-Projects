" Example: reading a sales organization with an INNER JOIN
" Uses standard-style BW master data objects and generic filter values.

SELECT SINGLE a~salesorg
  FROM /bi0/pcust_sales AS a
  INNER JOIN /bi0/psalesorg AS b
    ON b~salesorg = a~salesorg
  INTO @DATA(lv_salesorg)
  WHERE a~division   = '10'
    AND a~distr_chan = '10'
    AND a~cust_sales = @source_fields-customer
    AND b~comp_code  = @source_fields-comp_code
    AND a~objvers    = 'A'
    AND b~objvers    = 'A'.

result = lv_salesorg.
