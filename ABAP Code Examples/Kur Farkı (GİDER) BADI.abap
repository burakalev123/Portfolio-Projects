METHOD if_uj_custom_logic~execute.
    " Created on 12.10.2018 BTC DMENGU
    " Kur Farkı Hesaplama

    DATA : lt_ex_bom   TYPE TABLE OF zpp_s_bpc_bom,
           lt_ex_deg   TYPE TABLE OF zpp_s_bpc_deg,
           lt_mat_list TYPE TABLE OF zpp_s_bpc_mat,
           ls_mat_list LIKE LINE OF  lt_mat_list,
           ref_wb      TYPE REF TO   if_ujo_write_back,
           wb_status   TYPE          ujo_s_wb_status.

    DATA : lt_gider_klm TYPE TABLE OF zpp_s_bpc_gider,
           ls_gider_klm LIKE LINE OF  lt_gider_klm.

    DATA : lt_odemeler     TYPE TABLE OF zpp_s_bpc_gider,
           lt_odemeler_tmp TYPE TABLE OF zpp_s_bpc_gider,
           lt_kur_fark_top TYPE TABLE OF zpp_s_bpc_gider,
           ls_odemeler     LIKE LINE OF  lt_odemeler,
           ls_odemeler_tmp LIKE LINE OF  lt_odemeler,
           ls_kur_fark_top LIKE LINE OF lt_kur_fark_top,
           lv_kalan        TYPE          zpp_s_bpc_gider-kalan,
           lv_kalan2       TYPE          zpp_s_bpc_gider-kalan,
           lv_odeme_tarih  TYPE          zpp_s_bpc_gider-odeme_donemi,
           lv_taksit       TYPE          i.

    DATA : lv_period      TYPE char7,
           lv_period_temp TYPE char7,
           lv_period_yil  TYPE char4,
           lv_add         TYPE i,
           lv_odeme_no    TYPE c,
           lv_date        TYPE datum,
           lv_date_out    TYPE datum,
           lv_odeme       TYPE zpp_s_bpc_gider-signeddata,
           lv_version     TYPE char32,
           lv_kur1        TYPE zpp_s_bpc_gider-signeddata,
           lv_kur2        TYPE zpp_s_bpc_gider-signeddata,
           lv_kurfarki    TYPE zpp_s_bpc_gider-signeddata.


    FIELD-SYMBOLS : <fs_data>   TYPE any,
                    <fs_value>  TYPE any,
                    <fs_value2> TYPE any.

    TYPES : BEGIN OF ty_header  ,
              time        TYPE char32,
              hesapplani  TYPE char32,
              gider_klm   TYPE char32,
              sirketkodu  TYPE char32,
              signeddata  TYPE char32,
              rptcurrency TYPE char32,
            END OF ty_header.

    DATA : lt_header TYPE TABLE OF ty_header,
           ls_header LIKE LINE OF lt_header.

    DATA  : et_table TYPE TABLE OF zbpc_s_et,
            ls_table LIKE LINE OF et_table.

    CHECK ct_data[] IS NOT INITIAL .
    " Aşağıdaki 3 birim alınmayacak ...
    LOOP AT ct_data ASSIGNING <fs_data> .

      UNASSIGN  <fs_value> .
      ASSIGN COMPONENT 'RPTCURRENCY' OF STRUCTURE <fs_data> TO <fs_value> .
      IF  <fs_value> IS ASSIGNED .
        IF  <fs_value> EQ 'R_EUR' OR
            <fs_value> EQ 'R_USD' OR
            <fs_value> EQ 'R_TRY' .
          DELETE ct_data .
          CONTINUE .
        ENDIF.
      ENDIF.

      UNASSIGN  <fs_value> .
      ASSIGN COMPONENT 'GIDER_KLM' OF STRUCTURE <fs_data> TO <fs_value> .
      IF  <fs_value> EQ 'gider'.
        UNASSIGN  <fs_value> .
        ASSIGN COMPONENT 'RPTCURRENCY' OF STRUCTURE <fs_data> TO <fs_value> .
        IF <fs_value> EQ 'Non_Curr' .
          DELETE ct_data .
          CONTINUE .
        ENDIF.
      ENDIF.

      MOVE-CORRESPONDING  <fs_data> TO ls_gider_klm .
      APPEND ls_gider_klm TO lt_gider_klm .

      IF lv_version IS INITIAL AND ls_gider_klm-version IS NOT INITIAL .
        lv_version = ls_gider_klm-version.
      ENDIF.

    ENDLOOP .

    CHECK  lt_gider_klm[] IS NOT INITIAL .
    SORT  lt_gider_klm BY sirketkodu hesapplani gider_klm time signeddata.

    LOOP AT lt_gider_klm INTO ls_gider_klm
                     WHERE gider_klm EQ 'gider' .
      MOVE-CORRESPONDING ls_gider_klm TO ls_header .
      APPEND ls_header TO lt_header.
    ENDLOOP.

    SORT lt_odemeler BY gider_klm.
    SORT lt_header BY sirketkodu hesapplani gider_klm time signeddata.
    DELETE ADJACENT DUPLICATES FROM lt_header COMPARING ALL FIELDS.

    " Kur oranları çekilir versiyona göre
    CALL FUNCTION 'ZBPC_KUR_CEKIMI'
      EXPORTING
        im_version = lv_version
      TABLES
        et_table   = et_table.
    SORT et_table BY time inputcurrency.
*
*********************************
    LOOP AT lt_header INTO ls_header .
      " başlık bazında
      CLEAR : ls_odemeler.
      lv_period = ls_header-time .
      lv_kalan  = ls_header-signeddata .
*      MOVE-CORRESPONDING ls_header TO ls_odemeler .
      LOOP AT lt_gider_klm INTO ls_gider_klm
             WHERE gider_klm NE 'gider' AND
        hesapplani = ls_header-hesapplani.
        MOVE-CORRESPONDING ls_gider_klm TO ls_odemeler .

        CASE ls_gider_klm-gider_klm.
          WHEN '30'.
            lv_add = 1.
          WHEN '60'.
            lv_add = 2.
          WHEN '90'.
            lv_add = 3.
          WHEN '120'.
            lv_add = 4.
          WHEN '150'.
            lv_add = 5.
          WHEN '180'.
            lv_add = 6.
        ENDCASE.

        CONCATENATE ls_header-time(4) ls_header-time+5(2) '01' INTO lv_date.

        CALL FUNCTION 'UJD_ADD_MONTH_TO_DATE' "
          EXPORTING
            i_months   = lv_add
            i_old_date = lv_date
          IMPORTING
            e_new_date = lv_date_out.

        CONCATENATE lv_date_out(4) '.' lv_date_out+4(2) INTO ls_odemeler-time.

        ls_odemeler-signeddata = ls_header-signeddata * ls_odemeler-signeddata.
        lv_odeme_no = lv_add.
        CONCATENATE lv_odeme_no '.' 'ODEME' INTO  ls_odemeler-gider_klm.

        APPEND ls_odemeler TO lt_odemeler.
      ENDLOOP.
      SORT lt_odemeler BY gider_klm.

      LOOP AT  lt_odemeler INTO ls_odemeler
                      WHERE
                            hesapplani EQ ls_header-hesapplani AND
                            gider_klm  NE 'gider'              AND " ödeme
                            sirketkodu EQ ls_header-sirketkodu
      .
        ls_odemeler-kalan = lv_kalan.

        IF lv_period IS INITIAL.
          ls_odemeler-odeme_donemi = lv_odeme_tarih.
        ELSE.
          ls_odemeler-odeme_donemi = lv_period.
          CLEAR: lv_kalan , lv_period .
        ENDIF.
        lv_odeme_tarih = ls_odemeler-time.

        " gider - ödeme
        lv_kalan2 = ls_odemeler-kalan.
        ls_odemeler-kalan  = ls_odemeler-kalan - ls_odemeler-signeddata .
        lv_kalan = ls_odemeler-kalan.

        READ TABLE et_table INTO ls_table WITH KEY time = ls_odemeler-odeme_donemi
                         inputcurrency = ls_header-rptcurrency
                                           BINARY SEARCH .

        IF sy-subrc EQ 0 .
          lv_kur1 = ls_table-signeddata .
        ENDIF.

        READ TABLE et_table INTO ls_table WITH KEY time = ls_odemeler-time
                          inputcurrency = ls_header-rptcurrency
                                            BINARY SEARCH .

        IF sy-subrc EQ 0 .
          lv_kur2 = ls_table-signeddata .
        ENDIF.

        lv_kurfarki = lv_kur2 - lv_kur1 .

        " her ödeme sonrası kur farkı tutarı hesaplanır .
**********************************************************************
        ls_odemeler-gider_klm   = 'KUR_FARKI'.
        ls_odemeler-rptcurrency = 'R_TRY'    .
        ls_odemeler-version     = lv_version .
        ls_odemeler-artis_oran  = '1.YIL'    .
        ls_odemeler-category    = 'Budget'   .
        ls_odemeler-masrafyeri  = 'DUMMY'    .
        ls_odemeler-signeddata = lv_kalan2 * lv_kurfarki .


        APPEND ls_odemeler TO lt_odemeler .

        IF ls_odemeler-kalan = 0.
          EXIT.
        ENDIF.
      ENDLOOP.

      LOOP AT lt_odemeler INTO ls_odemeler.
        MOVE-CORRESPONDING ls_odemeler TO ls_odemeler_tmp .
        COLLECT ls_odemeler_tmp INTO lt_odemeler_tmp.
      ENDLOOP.

      SORT lt_odemeler_tmp BY sirketkodu hesapplani gider_klm time .
      DELETE ADJACENT DUPLICATES FROM lt_odemeler_tmp
       COMPARING  sirketkodu hesapplani gider_klm time .
      CLEAR: lt_odemeler[].
    ENDLOOP.

    DELETE lt_odemeler_tmp WHERE gider_klm NE 'KUR_FARKI'.

    LOOP AT lt_odemeler_tmp INTO ls_odemeler_tmp.
      MOVE-CORRESPONDING ls_odemeler_tmp TO ls_kur_fark_top .
      ls_kur_fark_top-hesapplani   = ''         .
      ls_kur_fark_top-gider_klm    = 'KUR_FARKI'.
      ls_kur_fark_top-rptcurrency  = 'R_TRY'    .
      ls_kur_fark_top-version      = lv_version .
      ls_kur_fark_top-artis_oran   = '1.YIL'    .
      ls_kur_fark_top-category     = 'Budget'   .
      ls_kur_fark_top-masrafyeri   = 'DUMMY'    .
      ls_kur_fark_top-kalan        = ''         .
      ls_kur_fark_top-odeme_donemi = ''         .
      COLLECT ls_kur_fark_top INTO lt_kur_fark_top.
    ENDLOOP.

    LOOP AT lt_kur_fark_top INTO ls_kur_fark_top.
      MOVE-CORRESPONDING ls_kur_fark_top TO ls_odemeler_tmp.
      IF ls_kur_fark_top-signeddata GT 0.
        ls_odemeler_tmp-hesapplani = '646'.
      ELSE.
        ls_odemeler_tmp-hesapplani = '656'.
      ENDIF.
      APPEND ls_odemeler_tmp TO lt_odemeler_tmp.
    ENDLOOP.

    " kur farkları CT_DATA tablosuna eklenir.
    LOOP AT ct_data ASSIGNING <fs_data>     .

      LOOP AT lt_odemeler_tmp INTO ls_odemeler_tmp WHERE signeddata IS NOT INITIAL .
        MOVE-CORRESPONDING ls_odemeler_tmp TO <fs_data>.
        APPEND <fs_data> TO ct_data.
        CLEAR : <fs_data>.
      ENDLOOP .
      EXIT .
    ENDLOOP.
*
    LOOP AT ct_data ASSIGNING <fs_data>.
      ASSIGN COMPONENT 'GIDER_KLM' OF STRUCTURE <fs_data> TO <fs_value>.
      IF <fs_value> NE 'KUR_FARKI' .
        DELETE ct_data.
      ENDIF.
    ENDLOOP.
*
  ENDMETHOD. 
