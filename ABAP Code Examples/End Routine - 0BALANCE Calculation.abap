
  BREAK-POINT.
  *--------------------------------------------------------------*
  *Table Declaration
  *--------------------------------------------------------------*
      DATA: counter       TYPE i,
            temp_balance  TYPE /bi0/oibalance,
            temp_balance2 TYPE /bic/oizbal_dc.
  
      DATA: e_s_result TYPE _ty_s_tg_1,
            e_t_result TYPE _ty_t_tg_1.
  *--------------------------------------------------------------*
  *Data Assigning
  *--------------------------------------------------------------*
  
  *DO .
  *  IF counter eq 1.
  *    exit.
  *  ENDIF.
  *ENDDO.
      LOOP AT result_package INTO e_s_result.
  
        e_s_result-balance = e_s_result-debit - e_s_result-credit.
        e_s_result-/bic/zbal_dc = e_s_result-debit_dc -
        e_s_result-credit_dc.
  
        temp_balance = e_s_result-balance.
        temp_balance2 = e_s_result-/bic/zbal_dc.
  
        e_s_result-deb_cre_lc = e_s_result-debit - e_s_result-credit.
        e_s_result-deb_cre_dc = e_s_result-debit_dc - e_s_result-credit_dc
        .
  
        COLLECT e_s_result INTO e_t_result.
  
        CLEAR e_s_result-credit.
        CLEAR e_s_result-debit.
        CLEAR e_s_result-credit_dc.
        CLEAR e_s_result-debit_dc.
  
        counter = 12 - e_s_result-fiscper+5(2).
  
        DO counter TIMES.
  
          e_s_result-fiscper  = e_s_result-fiscper + 1.
          e_s_result-deb_cre_lc = e_s_result-debit - e_s_result-credit.
          e_s_result-deb_cre_dc = e_s_result-debit_dc -
          e_s_result-credit_dc.
          e_s_result-balance = temp_balance.
          e_s_result-/bic/zbal_dc = temp_balance2.
  
          COLLECT e_s_result INTO e_t_result.
  
        ENDDO.
  
      ENDLOOP.
  
      REFRESH result_package.
  
      MOVE e_t_result[] TO result_package[].
  