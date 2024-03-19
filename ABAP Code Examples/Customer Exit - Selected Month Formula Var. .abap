METHOD FV_VEX_AKTPER_USER.
    
        DATA:
          loc_var_range TYPE rrrangeexit,
          l_s_range     TYPE rsr_s_rangesid,
          lv_value      TYPE c LENGTH 8,
          lv_month      TYPE /bi0/oicalmonth,
          lv_fiscper    TYPE /bi0/oifiscper.
    
    if i_vnam eq 'FV_VEX_AKTPER_USER' and i_step = 2.

      clear : lv_fiscper.

      loop at i_t_var_range into loc_var_range where vnam = 'VEX_AKTPER_USER'.

          lv_fiscper = loc_var_range-low.
          lv_value = lv_fiscper.
          CONCATENATE lv_value(4)   "Year
                      lv_value+5(2) "Month
          INTO lv_month.
    
        l_s_range-low    = lv_month.
        l_s_range-sign   = 'I'.
        l_s_range-opt    = 'EQ'.
        append l_s_range to e_t_range.
      endloop.
    endif.
    
    ENDMETHOD.