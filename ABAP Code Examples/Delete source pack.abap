
delete SOURCE_PACKAGE
WHERE not ( /BIC/ZH_compco eq '1230' and
                              ( ( /BIC/ZH_glacc BETWEEN '6000000000' and
                              '6199999999' ) or
                                ( /BIC/ZH_glacc BETWEEN '6299999999' and
                                '7603899999' ) or
                                ( /BIC/ZH_glacc BETWEEN '7604000000' and
                                '9999999999' ) ) ) . 



    DELETE source_package
      WHERE NOT fiscper+5(2) EQ '00' OR
                fiscper+5(2) EQ '13' OR
                fiscper+5(2) EQ '14' OR
                fiscper+5(2) EQ '15' OR
                fiscper+5(2) EQ '16' . 


                DELETE source_package
                WHERE NOT sold_to EQ '0000000031' OR
                          sold_to EQ '0000000008' OR
                          sold_to EQ '0000000004' OR
                          sold_to EQ '0000000006' . 
          