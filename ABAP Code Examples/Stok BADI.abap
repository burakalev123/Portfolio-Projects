
  METHOD if_uj_custom_logic~execute.
    TYPES: BEGIN OF ty_collect,
             idnrk   TYPE c LENGTH 18,
             version TYPE c LENGTH 32,
             time    TYPE c LENGTH 32,
             meins   TYPE meins,
             mnglg   TYPE menge_d,
             yi_yd   TYPE char2,
           END OF ty_collect,
           BEGIN OF ty_matnr,
             matnr TYPE matnr,
           END OF ty_matnr.
    DATA : lt_ex_bom      TYPE TABLE OF zpp_s_bpc_bom,
           lt_ex_deg      TYPE TABLE OF zpp_s_bpc_deg,
           lt_mat_list    TYPE TABLE OF zpp_s_bpc_mat,
           ls_mat_list    LIKE LINE OF lt_mat_list,
           lv_destination TYPE c LENGTH 10,
           ref_wb         TYPE REF TO if_ujo_write_back,
           lt_uretim      TYPE TABLE OF zpp_s_uretim,
           ls_uretim      LIKE LINE OF lt_uretim,
           lt_data        TYPE TABLE OF zpp_s_maliyet,
           ls_data        TYPE zpp_s_maliyet,
           wb_status      TYPE ujo_s_wb_status.
    DATA : lt_collect      TYPE TABLE OF ty_collect,
           ls_collect      LIKE LINE OF lt_collect,
           lt_kapasite     TYPE TABLE OF /bic/azpp_o0100,
           ls_kapasite     LIKE LINE OF lt_kapasite,
           lt_matnr        TYPE TABLE OF zpp_s_matnr,
           ls_matnr        LIKE LINE OF lt_matnr,
           lt_export       TYPE TABLE OF zpp_s_export,
           lt_matnr_tmp    TYPE TABLE OF zpp_s_matnr,
           lv_matnr        TYPE matnr,
           lv_count        TYPE int4,
           lv_kayit_sayisi TYPE int4,
           lv_mal_grubu    TYPE char32.

**"-> + 13.06.2018 14:22:42
    DATA : lt_stok_data TYPE TABLE OF zpp_s_bpc_stok_data,
           ls_stok_data TYPE zpp_s_bpc_stok_data,
           lt_mat_stok  TYPE TABLE OF zpp_s_bpc_mat_stok,
           ls_mat_stok  TYPE zpp_s_bpc_mat_stok.
**"-<  13.06.2018 14:22:42
    FIELD-SYMBOLS : <fs_data>   TYPE any,
                    <fs_ex>     TYPE zpp_s_bpc_bom,
                    <fs_export> LIKE LINE OF lt_export,
                    <fs_matnr>  LIKE LINE OF lt_matnr.

    IF sy-sysid EQ 'SBD'.
      lv_destination = 'SSQCLNT100'.
    ELSEIF sy-sysid EQ 'SBP'.
      lv_destination = 'SSP500CLNT'.
    ENDIF.

    LOOP AT ct_data ASSIGNING <fs_data>.
      MOVE-CORRESPONDING <fs_data> TO ls_mat_stok.
      IF ls_mat_stok-signeddata IS NOT INITIAL  .
        ls_mat_stok-artis_oran = '1.YIL'.
        ls_mat_stok-musteri = 'Dummy'.
        ls_mat_stok-yi_yd = 'NO'.
        APPEND ls_mat_stok TO lt_mat_stok.
      ENDIF.
    ENDLOOP.

**"Stok Bilgileri ve Maliyet ERP den alınır ZBW_FM_GET_STOK ile .
**********************************************************************
    FIELD-SYMBOLS : <fs_value> TYPE any.

    " Stok ve Maliyet Alınır
    CALL FUNCTION 'ZBW_FM_GET_STOK'
      DESTINATION lv_destination
      EXPORTING
        it_mat  = lt_mat_stok[]
      IMPORTING
        et_data = lt_stok_data.

    LOOP AT ct_data ASSIGNING <fs_data>.

      CLEAR : lv_mal_grubu . UNASSIGN  <fs_value> .
*      ASSIGN COMPONENT 'HARICIMALGRUP' OF STRUCTURE <fs_data> TO <fs_value> .
*      if  <fs_value> is ASSIGNED  .
*        lv_mal_grubu = <fs_value> .
*      endif.

      LOOP AT lt_stok_data INTO ls_stok_data.
        ls_stok_data-artis_oran = '1.YIL'.
        ls_stok_data-musteri    = 'Dummy'.
        ls_stok_data-yi_yd      = 'NO'.

        IF ls_stok_data-satis_klm EQ 'DB_TUTAR'.
          ls_stok_data-rptcurrency = 'R_TRY'.
        ENDIF.
        READ TABLE lt_mat_stok INTO ls_mat_stok
          WITH KEY malzeme = ls_stok_data-malzeme.

        ls_stok_data-haricimalgrup =  ls_mat_stok-haricimalgrup  .

        MOVE-CORRESPONDING ls_stok_data TO <fs_data>.
        APPEND <fs_data> TO ct_data.
        CLEAR : <fs_data>.
      ENDLOOP.
      EXIT.
    ENDLOOP.

    UNASSIGN <fs_data>.

**" CT_DATA içerisinde ERP den alınan stok verileri ve maliyet değeri yer alır.
**" SATIS_KLM = 'STOK'      -> stok bilgisi signedData içeriside yer alır .
**" SATIS_KLM = 'DB_TUTAR'  -> maliyet bilgisi signedData içeriside yer alır .
    LOOP AT ct_data ASSIGNING <fs_data>.
      ASSIGN COMPONENT 'SATIS_KLM' OF STRUCTURE <fs_data> TO <fs_value>.
      IF <fs_value> EQ 'ADT' OR <fs_value> IS INITIAL.
        DELETE ct_data.
      ENDIF.
    ENDLOOP.
**********************************************************************



  ENDMETHOD.
