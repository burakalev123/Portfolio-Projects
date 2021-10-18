METHOD if_uj_custom_logic~execute.
    ****************************************************************
        TYPES: BEGIN OF zbp01_ty_comment,
                 datewritten    TYPE timestamp,
                 category       TYPE c LENGTH 32,
                 masrafyeri     TYPE c LENGTH 32,
                 hesap          TYPE c LENGTH 32,
                 proje          TYPE c LENGTH 32,
                 sirketkodu     TYPE c LENGTH 32,
                 rptcurrency    TYPE c LENGTH 32,
                 time           TYPE c LENGTH 32,
                 version        TYPE c LENGTH 32,
                 yardimci       TYPE c LENGTH 32,
                 yatirim_kalemi TYPE c LENGTH 32,
                 scomment       TYPE c LENGTH 32,
               END OF zbp01_ty_comment.
    
        TYPES: BEGIN OF ty_yatirim_model,
                 category       TYPE /b28/oifwd5s7e,
                 hesap          TYPE /b28/oifwdkkud,
                 masrafyeri     TYPE /b28/oifwdcxtr,
                 proje          TYPE /b28/oifwdh6i6,
                 rptcurrency    TYPE /b28/oifwd4t38,
                 sirketkodu     TYPE /b28/oifwddbyj,
                 tesvik         TYPE /b28/oifwd4sp3,
                 time           TYPE /b28/oifwd8rnf,
                 version        TYPE /b28/oifwd3te9,
                 yardimci       TYPE /b28/oifwdi1ru,
                 yatirim_kalemi TYPE /b28/oifwd9h8g,
                 measures       TYPE c LENGTH 32,
                 signeddata     TYPE /b28/oisdata,
                 scomment       TYPE c LENGTH 32,
               END OF ty_yatirim_model.
    
        TYPES: BEGIN OF ty_yatirim_model2,
                 category       TYPE /b28/oifwd5s7e,
                 hesap          TYPE /b28/oifwdkkud,
                 masrafyeri     TYPE /b28/oifwdcxtr,
                 measures       TYPE c LENGTH 32,
                 proje          TYPE /b28/oifwdh6i6,
                 rptcurrency    TYPE /b28/oifwd4t38,
                 sirketkodu     TYPE /b28/oifwddbyj,
                 tesvik         TYPE /b28/oifwd4sp3,
                 time           TYPE /b28/oifwd8rnf,
                 version        TYPE /b28/oifwd3te9,
                 yardimci       TYPE /b28/oifwdi1ru,
                 yatirim_kalemi TYPE /b28/oifwd9h8g,
                 signeddata     TYPE /b28/oisdata,
               END OF ty_yatirim_model2.
    
        DATA: lt_comment TYPE TABLE OF zbp01_ty_comment,
              ls_comment TYPE zbp01_ty_comment.
    
        DATA: lt_yatirim_data   TYPE TABLE OF ty_yatirim_model,
              ls_yatirim_data   TYPE ty_yatirim_model,
              ls_yatirim_data2  TYPE ty_yatirim_model,
              lt_yatirim_data_2 TYPE TABLE OF ty_yatirim_model2,
              ls_yatirim_data_2 TYPE ty_yatirim_model2.
    
        DATA: lo_appset      TYPE REF TO cl_uja_appset,
              lo_application TYPE REF TO if_uja_application_manager,
              ls_appset_info TYPE uja_s_appset_info,
              lo_gentab      TYPE REF TO cl_uj_gen_table,
              l_tabtype      TYPE tabname,
              lt_tabname     TYPE tabname,
              lt_tabtype     LIKE STANDARD TABLE OF l_tabtype,
              prefix         TYPE uja_s_prefix.
    
    
        DATA: lv_environment_id TYPE uj_appset_id VALUE 'SARSILMAZ',
              lv_application_id TYPE uj_appl_id VALUE 'YATIRIM',
              lt_dim_list       TYPE uja_t_dim_list,
              lo_appl_mgr       TYPE REF TO if_uja_application_manager,
              lo_query          TYPE REF TO if_ujo_query,
              lr_data           TYPE REF TO data,
              lt_message        TYPE uj0_t_message,
              ls_application    TYPE uja_s_application,
              ls_dimensions     TYPE uja_s_dimension.
    
        DATA: lv_date        TYPE sy-datum,
    
              lv_amort_oran  TYPE p DECIMALS 5,
              lv_amort_tutar TYPE /bi0/oiamount,
              lv_omur        TYPE i,
              lv_tutar       TYPE /bi0/oiamount,
              lv_count       TYPE i,
              lv_kalan       TYPE /bi0/oiamount,
              lv_year_old    TYPE c LENGTH 4,
              last_year      TYPE c LENGTH 4,
              lv_toplam      TYPE /bi0/oiamount,
              lv_check       TYPE c LENGTH 1,
              lv_ay          TYPE i,
              zdyn_tab       TYPE c LENGTH 21.
    
        FIELD-SYMBOLS: <fs_data>    TYPE any,
                       <fs_yatirim> TYPE ty_yatirim_model.
    
    *    BREAK-POINT.
    *>>> get comment table
        CREATE OBJECT lo_appset
          EXPORTING
            i_appset_id = i_appset_id.
    
        CALL METHOD lo_appset->if_uja_appset_data~get_appset_info
          IMPORTING
            es_appset_info = ls_appset_info.
    
    
        lo_application = cl_uja_bpc_admin_factory=>get_application_manager(
              i_appset_id = i_appset_id
              i_application_id  = i_appl_id ).
    
        lo_application->get(
        IMPORTING
          es_application = ls_application ).
    
    
    
        prefix-appl_prefix = ls_application-appl_prefix.
        prefix-appset_prefix = ls_appset_info-appset_prefix.
    
        CALL METHOD cl_uj_gen_table=>get_instance
          IMPORTING
            eo_instance = lo_gentab.
    
    
        APPEND 'COMMENT' TO lt_tabtype.
    
        LOOP AT  lt_tabtype INTO l_tabtype.
          TRY.
    
              CALL METHOD lo_gentab->get_ddic_table_name
                EXPORTING
                  i_table   = l_tabtype
                  is_prefix = prefix
                IMPORTING
                  e_tabname = lt_tabname.
    *        e_gotstate = l_gotstate.
    
          ENDTRY.
    
        ENDLOOP.
    
        zdyn_tab = lt_tabname.
    
        SELECT * FROM  (zdyn_tab) INTO CORRESPONDING FIELDS OF TABLE lt_comment .
        DELETE lt_comment WHERE yardimci NE '004' OR scomment(2) EQ '..'.
        DELETE ADJACENT DUPLICATES FROM lt_comment COMPARING ALL FIELDS.
    
        SORT lt_comment DESCENDING BY category masrafyeri rptcurrency time version yatirim_kalemi datewritten.
    *<<< get comment table
    
        LOOP AT ct_data ASSIGNING <fs_data>.
          MOVE-CORRESPONDING <fs_data> TO ls_yatirim_data.
          APPEND ls_yatirim_data TO lt_yatirim_data.
          CLEAR ls_yatirim_data.
        ENDLOOP.
    
        DELETE lt_yatirim_data WHERE yardimci EQ '002'.
        DELETE lt_yatirim_data WHERE yardimci EQ '003'.
        DELETE lt_yatirim_data WHERE yardimci EQ 'NON'.
    
    
        LOOP AT lt_yatirim_data ASSIGNING <fs_yatirim>.
    
          IF ls_yatirim_data-scomment IS INITIAL.
    
    
            READ TABLE lt_comment INTO ls_comment
                                       WITH KEY yardimci       = '004'
                                                hesap          = <fs_yatirim>-hesap
                                                time           = <fs_yatirim>-time
                                                yatirim_kalemi = <fs_yatirim>-yatirim_kalemi
                                                masrafyeri     = <fs_yatirim>-masrafyeri
                                                proje          = <fs_yatirim>-proje
                                                rptcurrency    = <fs_yatirim>-rptcurrency
                                                sirketkodu     = <fs_yatirim>-sirketkodu
                                                version        = <fs_yatirim>-version.
    
            <fs_yatirim>-scomment = ls_comment-scomment.
          ENDIF.
        ENDLOOP.
    
        DELETE lt_yatirim_data WHERE scomment IS INITIAL.
    
    *Amortisman Hesaplamaları
    
        LOOP AT lt_yatirim_data INTO ls_yatirim_data.
          CASE ls_yatirim_data-scomment.
    
    *****NORMAL AMORTİSMAN*****
            WHEN 'NA'.
              IF ls_yatirim_data-yardimci EQ '001'.
                READ TABLE lt_yatirim_data INTO ls_yatirim_data2
                                           WITH KEY yardimci       = '004'
                                                    hesap          = ls_yatirim_data-hesap
                                                    time           = ls_yatirim_data-time
                                                    yatirim_kalemi = ls_yatirim_data-yatirim_kalemi
                                                    masrafyeri     = ls_yatirim_data-masrafyeri
                                                    proje          = ls_yatirim_data-proje
                                                    rptcurrency    = ls_yatirim_data-rptcurrency
                                                    sirketkodu     = ls_yatirim_data-sirketkodu
                                                    version        = ls_yatirim_data-version.
    
                IF sy-subrc EQ 0.
                  lv_omur = ls_yatirim_data2-signeddata.
    
                  READ TABLE lt_yatirim_data INTO ls_yatirim_data2
                                             WITH KEY yardimci       = '001'
                                                      hesap          = ls_yatirim_data-hesap
                                                      time           = ls_yatirim_data-time
                                                      yatirim_kalemi = ls_yatirim_data-yatirim_kalemi
                                                      masrafyeri     = ls_yatirim_data-masrafyeri
                                                      proje          = ls_yatirim_data-proje
                                                      rptcurrency    = ls_yatirim_data-rptcurrency
                                                      sirketkodu     = ls_yatirim_data-sirketkodu
                                                      version        = ls_yatirim_data-version.
    
                  IF sy-subrc EQ 0.
                    lv_tutar = ls_yatirim_data2-signeddata.
                  ENDIF.
                  IF lv_omur NE '0'.
                    lv_amort_oran = 1 /  ( lv_omur  * 12 ).
                    lv_amort_tutar = lv_tutar * lv_amort_oran.
                    CONCATENATE  ls_yatirim_data-time(4) ls_yatirim_data-time+5(2) '01' INTO lv_date.
                    last_year = ls_yatirim_data-time(4) + lv_omur - 1.
                    DO lv_omur * 12 TIMES.
                      ls_yatirim_data-signeddata =  lv_amort_tutar.
                      lv_count = lv_count + 1.
    
                      IF lv_count GT 1.
                        CALL FUNCTION 'UJD_ADD_MONTH_TO_DATE'
                          EXPORTING
                            i_months   = 1
                            i_old_date = lv_date
                          IMPORTING
                            e_new_date = lv_date.
                      ELSE.
                        lv_ay = ls_yatirim_data-time+5(2).
                        ls_yatirim_data-signeddata =  lv_amort_tutar * lv_ay.
                      ENDIF.
                      IF lv_date(4) LE last_year.
                        CONCATENATE lv_date(4) '.' lv_date+4(2) INTO ls_yatirim_data-time.
                        ls_yatirim_data-yatirim_kalemi = 'NON'.
                        COLLECT ls_yatirim_data INTO lt_yatirim_data.
                      ENDIF.
                    ENDDO.
                  ENDIF.
                ENDIF.
              ENDIF.
              CLEAR: lv_date, lv_count, lv_amort_tutar, lv_amort_oran, lv_omur, lv_tutar.
    
    *****AZALAN AMORTİSMAN*****
            WHEN 'AA'.
              IF ls_yatirim_data-yardimci EQ '001'.
                READ TABLE lt_yatirim_data INTO ls_yatirim_data2
                                           WITH KEY yardimci       = '004'
                                                    hesap          = ls_yatirim_data-hesap
                                                    time           = ls_yatirim_data-time
                                                    yatirim_kalemi = ls_yatirim_data-yatirim_kalemi
                                                    masrafyeri     = ls_yatirim_data-masrafyeri
                                                    proje          = ls_yatirim_data-proje
                                                    rptcurrency    = ls_yatirim_data-rptcurrency
                                                    sirketkodu     = ls_yatirim_data-sirketkodu
                                                    version        = ls_yatirim_data-version.
    
                IF sy-subrc EQ 0.
                  lv_omur = ls_yatirim_data2-signeddata.
    
                  READ TABLE lt_yatirim_data INTO ls_yatirim_data2
                                             WITH KEY yardimci       = '001'
                                                      hesap          = ls_yatirim_data-hesap
                                                      time           = ls_yatirim_data-time
                                                      yatirim_kalemi = ls_yatirim_data-yatirim_kalemi
                                                      masrafyeri     = ls_yatirim_data-masrafyeri
                                                      proje          = ls_yatirim_data-proje
                                                      rptcurrency    = ls_yatirim_data-rptcurrency
                                                      sirketkodu     = ls_yatirim_data-sirketkodu
                                                      version        = ls_yatirim_data-version.
    
                  IF sy-subrc EQ 0.
                    lv_tutar = ls_yatirim_data2-signeddata.
                  ENDIF.
                  IF lv_omur NE '0'.
                    lv_amort_oran = 2 /  ( lv_omur ).
                    lv_amort_tutar = lv_tutar * lv_amort_oran.
                    lv_kalan = lv_tutar - lv_amort_tutar.
                    CONCATENATE  ls_yatirim_data-time(4) ls_yatirim_data-time+5(2) '01' INTO lv_date.
                    lv_year_old = lv_date(4).
                    last_year = ls_yatirim_data-time(4) + lv_omur - 1.
                    lv_count = lv_count + 1.
    
                    DO lv_omur * 12 TIMES.
                      IF lv_count GT 1.
                        CALL FUNCTION 'UJD_ADD_MONTH_TO_DATE'
                          EXPORTING
                            i_months   = 1
                            i_old_date = lv_date
                          IMPORTING
                            e_new_date = lv_date.
                      ENDIF.
    
                      IF lv_date(4) = last_year.
                        lv_amort_tutar = lv_kalan.
    
                      ELSEIF lv_date(4) GT lv_year_old.
                        lv_year_old = lv_date(4).
                        lv_amort_tutar = lv_kalan * lv_amort_oran.
                        lv_kalan = lv_kalan - lv_amort_tutar.
                      ENDIF.
    
                      IF lv_count EQ 1.
                        lv_ay = ls_yatirim_data-time+5(2).
                        ls_yatirim_data-signeddata =  lv_amort_tutar / 12 * lv_ay.
                      ELSE.
                        ls_yatirim_data-signeddata =  lv_amort_tutar / 12.
                      ENDIF.
    
                      lv_count = lv_count + 1.
    
                      IF lv_date(4) LE last_year.
                        CONCATENATE lv_date(4) '.' lv_date+4(2) INTO ls_yatirim_data-time.
                        ls_yatirim_data-yatirim_kalemi = 'NON'.
    
                        COLLECT ls_yatirim_data INTO lt_yatirim_data.
                      ENDIF.
                    ENDDO.
                  ENDIF.
                ENDIF.
              ENDIF.
              CLEAR: lv_date, lv_count, lv_amort_tutar, lv_amort_oran, last_year, lv_year_old.
    
    *****NORMAL KIST AMORTİSMAN*****
            WHEN 'NKA'.
    
              IF ls_yatirim_data-yardimci EQ '001'.
                READ TABLE lt_yatirim_data INTO ls_yatirim_data2
                                           WITH KEY yardimci       = '004'
                                                    hesap          = ls_yatirim_data-hesap
                                                    time           = ls_yatirim_data-time
                                                    yatirim_kalemi = ls_yatirim_data-yatirim_kalemi
                                                    masrafyeri     = ls_yatirim_data-masrafyeri
                                                    proje          = ls_yatirim_data-proje
                                                    rptcurrency    = ls_yatirim_data-rptcurrency
                                                    sirketkodu     = ls_yatirim_data-sirketkodu
                                                    version        = ls_yatirim_data-version.
    
                IF sy-subrc EQ 0.
                  lv_omur = ls_yatirim_data2-signeddata.
    
    
                  READ TABLE lt_yatirim_data INTO ls_yatirim_data2
                                             WITH KEY yardimci       = '001'
                                                      hesap          = ls_yatirim_data-hesap
                                                      time           = ls_yatirim_data-time
                                                      yatirim_kalemi = ls_yatirim_data-yatirim_kalemi
                                                      masrafyeri     = ls_yatirim_data-masrafyeri
                                                      proje          = ls_yatirim_data-proje
                                                      rptcurrency    = ls_yatirim_data-rptcurrency
                                                      sirketkodu     = ls_yatirim_data-sirketkodu
                                                      version        = ls_yatirim_data-version.
    
    
                  IF sy-subrc EQ 0.
                    lv_tutar = ls_yatirim_data2-signeddata.
                  ENDIF.
                  IF lv_omur NE '0'.
                    lv_amort_oran = 1 /  ( lv_omur  * 12 ).
                    lv_amort_tutar = lv_tutar * lv_amort_oran.
                    CONCATENATE  ls_yatirim_data-time(4) ls_yatirim_data-time+5(2) '01' INTO lv_date.
                    last_year = ls_yatirim_data-time(4) + lv_omur - 1.
                    lv_ay = ls_yatirim_data-time+5(2) - 1.
                    DO lv_omur * 12 - lv_ay TIMES.
    
                      lv_count = lv_count + 1.
                      IF lv_count GT 1.
                        CALL FUNCTION 'UJD_ADD_MONTH_TO_DATE'
                          EXPORTING
                            i_months   = 1
                            i_old_date = lv_date
                          IMPORTING
                            e_new_date = lv_date.
                      ENDIF.
    
                      IF lv_date(4) = last_year AND lv_check NE 'X'.
                        lv_amort_tutar = ( lv_tutar - lv_toplam ) / 12.
                        lv_check = 'X'.
                      ENDIF.
                      ls_yatirim_data-signeddata =  lv_amort_tutar.
                      lv_toplam = lv_toplam + lv_amort_tutar.
                      CONCATENATE lv_date(4) '.' lv_date+4(2) INTO ls_yatirim_data-time.
                      ls_yatirim_data-yatirim_kalemi = 'NON'.
    
                      COLLECT ls_yatirim_data INTO lt_yatirim_data.
                    ENDDO.
                  ENDIF.
                ENDIF.
              ENDIF.
              CLEAR: lv_date, lv_count, lv_amort_tutar, lv_amort_oran, last_year, lv_year_old, lv_check, lv_toplam.
    
    *****AZALAN KIST AMORTİSMAN*****
            WHEN 'AKA'.
              IF ls_yatirim_data-yardimci EQ '001'.
                READ TABLE lt_yatirim_data INTO ls_yatirim_data2
                                           WITH KEY yardimci       = '004'
                                                    hesap          = ls_yatirim_data-hesap
                                                    time           = ls_yatirim_data-time
                                                    yatirim_kalemi = ls_yatirim_data-yatirim_kalemi
                                                    masrafyeri     = ls_yatirim_data-masrafyeri
                                                    proje          = ls_yatirim_data-proje
                                                    rptcurrency    = ls_yatirim_data-rptcurrency
                                                    sirketkodu     = ls_yatirim_data-sirketkodu
                                                    version        = ls_yatirim_data-version.
    
                IF sy-subrc EQ 0.
                  lv_omur = ls_yatirim_data2-signeddata.
    
    
                  READ TABLE lt_yatirim_data INTO ls_yatirim_data2
                                             WITH KEY yardimci       = '001'
                                                      hesap          = ls_yatirim_data-hesap
                                                      time           = ls_yatirim_data-time
                                                      yatirim_kalemi = ls_yatirim_data-yatirim_kalemi
                                                      masrafyeri     = ls_yatirim_data-masrafyeri
                                                      proje          = ls_yatirim_data-proje
                                                      rptcurrency    = ls_yatirim_data-rptcurrency
                                                      sirketkodu     = ls_yatirim_data-sirketkodu
                                                      version        = ls_yatirim_data-version.
    
                  IF sy-subrc EQ 0.
                    lv_tutar = ls_yatirim_data2-signeddata.
                  ENDIF.
                  IF lv_omur NE '0'.
                    lv_amort_oran = 2 / ( lv_omur * 12 ).
                    lv_amort_tutar = lv_tutar * lv_amort_oran.
                    CONCATENATE  ls_yatirim_data-time(4) ls_yatirim_data-time+5(2) '01' INTO lv_date.
                    last_year = ls_yatirim_data-time(4) + lv_omur - 1.
    
    *              İlk yıl fark ay sayısı
                    lv_ay = ls_yatirim_data-time+5(2) - 1.
    *              Başlangıç Ayı
                    lv_year_old = lv_date(4).
    
                    lv_kalan = lv_tutar - ( lv_amort_tutar * ( 12 - lv_ay ) ).
    
                    DO lv_omur * 12 - lv_ay TIMES.
                      lv_count = lv_count + 1.
                      IF lv_count GT 1.
                        CALL FUNCTION 'UJD_ADD_MONTH_TO_DATE'
                          EXPORTING
                            i_months   = 1
                            i_old_date = lv_date
                          IMPORTING
                            e_new_date = lv_date.
                      ENDIF.
    
                      IF lv_date(4) = last_year.
                        lv_amort_tutar = lv_kalan / 12.
    
                      ELSEIF lv_date(4) GT lv_year_old.
                        lv_year_old = lv_date(4).
                        lv_amort_tutar = lv_kalan * lv_amort_oran.
                        lv_kalan = lv_kalan - lv_amort_tutar * 12.
                      ENDIF.
    
                      ls_yatirim_data-signeddata =  lv_amort_tutar.
    *                lv_toplam = lv_toplam + lv_amort_tutar.
                      CONCATENATE lv_date(4) '.' lv_date+4(2) INTO ls_yatirim_data-time.
                      ls_yatirim_data-yatirim_kalemi = 'NON'.
    
                      COLLECT ls_yatirim_data INTO lt_yatirim_data.
                    ENDDO.
                  ENDIF.
                ENDIF.
              ENDIF.
              CLEAR: lv_date, lv_count, lv_amort_tutar, lv_amort_oran, last_year, lv_year_old, lv_check, lv_toplam.
          ENDCASE.
    *
        ENDLOOP.
    
        LOOP AT lt_yatirim_data ASSIGNING <fs_data>.
          MOVE-CORRESPONDING <fs_data> TO ls_yatirim_data_2.
          COLLECT ls_yatirim_data_2 INTO lt_yatirim_data_2.
          CLEAR ls_yatirim_data_2.
        ENDLOOP.
    
        ct_data[] = lt_yatırım_data_2[].
      ENDMETHOD.
    