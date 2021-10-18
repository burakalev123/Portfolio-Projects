
DATA: e_s_result TYPE _ty_s_tg_1 .
DATA: e_t_result TYPE _ty_t_tg_1.
****************************************************************
lv_datum = sy-datum.

  LOOP AT result_package INTO e_s_result.

      IF lv_datum+0(4) EQ e_s_result-fiscyear.
        lv_year = e_s_result-fiscyear.
      ELSE.
        lv_year = e_s_result-fiscyear.
        lv_year = lv_year - 1.
      ENDIF.
      EXIT.
    ENDLOOP.

****************************************************************
    BREAK-POINT.

    "Katsayı DSO itabını Result Package'a göre dolduruyoruz.
    SELECT * INTO CORRESPONDING FIELDS OF TABLE lt_data
      FROM /bic/ausd_o8300.

    SELECT * INTO CORRESPONDING FIELDS OF TABLE lt_data3
      FROM /bic/ausd_o83m00.

    SELECT * INTO CORRESPONDING FIELDS OF TABLE lt_y_urun
      FROM zyeni_urun.

    SELECT * INTO CORRESPONDING FIELDS OF TABLE lt_mat_kat
      FROM /bic/pzh_mater
      FOR ALL ENTRIES IN result_package
      WHERE /bic/zh_mater  = result_package-/bic/zh_mater.

    SELECT * INTO CORRESPONDING FIELDS OF TABLE lt_malyt_donem
        FROM zmlyt_donem.

SORT result_package BY /bic/zh_mater fiscper /bic/zh_compco ASCENDING.
****************************************************************
   LOOP AT result_package INTO e_s_result.
      CLEAR : ls_data.

" MÜŞTERİ GRUBU BOŞ OLDUĞUNDA
IF e_s_result-/bic/uww004 IS INITIAL.

"Son 3 aylık malzemeye müşterisiz bakıyor.
  READ TABLE lt_data3 INTO ls_data3
    WITH KEY /bic/zh_compco = e_s_result-/bic/zh_compco
             salesorg       = e_s_result-salesorg
             /bic/zh_mater  = e_s_result-/bic/zh_mater
             BINARY SEARCH.

        IF sy-subrc = 0.
          IF ls_data-net_wgt_dl IS NOT INITIAL.
            "Oran(BrmMly) = Maliyet/Satış miktarı
            lv_oran1 = ls_data-/bic/umal01 / ls_data-net_wgt_dl.
            lv_oran2 = ls_data-/bic/umal02 / ls_data-net_wgt_dl.
            lv_oran3 = ls_data-/bic/umal03 / ls_data-net_wgt_dl.

          ENDIF.

          e_s_result-/bic/umal01  = lv_oran1 *
          e_s_result-net_wgt_dl.
          e_s_result-/bic/umal02  = lv_oran2 *
          e_s_result-net_wgt_dl.
          e_s_result-/bic/umal03  = lv_oran3 *
          e_s_result-net_wgt_dl.
          APPEND e_s_result TO e_t_result.
       ELSE.
"Bütçelenen Malzeme son 3 ayda yoksa kategorisine bakılıyor.
"Son 3 ay da ilgili kategornin en büyük değeri alınıyor.
          READ TABLE lt_mat_kat INTO ls_mat_kat
            WITH KEY /bic/zh_mater = e_s_result-/bic/zh_mater.

          lv_kat = ls_mat_kat-/bic/uwwhy02.

          SELECT * INTO CORRESPONDING FIELDS OF TABLE lt_data2
            FROM /bic/ausd_o83m00
            WHERE /bic/zh_compco = e_s_result-/bic/zh_compco AND
                  salesorg       = e_s_result-salesorg       AND
                  /bic/uwwhy02   = lv_kat.

          SORT lt_data2 BY /bic/umal01 /bic/umal02 /bic/umal03
           DESCENDING.

          READ TABLE lt_data2 INTO ls_data2 INDEX 1.

          IF ls_data2-net_wgt_dl IS NOT INITIAL.
            "Oran(BrmMly) = Maliyet/Satış miktarı
            lv_oran1 = ls_data2-/bic/umal01 / ls_data2-net_wgt_dl.
            lv_oran2 = ls_data2-/bic/umal02 / ls_data2-net_wgt_dl.
            lv_oran3 = ls_data2-/bic/umal03 / ls_data2-net_wgt_dl.

          ENDIF.

          e_s_result-/bic/umal01  = lv_oran1 *
          e_s_result-net_wgt_dl.
          e_s_result-/bic/umal02  = lv_oran2 *
          e_s_result-net_wgt_dl.
          e_s_result-/bic/umal03  = lv_oran3 *
          e_s_result-net_wgt_dl.
          APPEND e_s_result TO e_t_result.
       ENDIF.

" MÜŞTERİ GRUBU DOLU OLDUĞUNDA
ELSE.

*>>>>>>Yeni ürün kontrolü
  IF e_s_result-/bic/zh_mater+0(6) EQ 'Y_URUN'.

    READ TABLE lt_y_urun INTO ls_y_urun
      WITH KEY urun1 = e_s_result-/bic/zh_mater.

"Yeni ürün ve istisna kategori ise
"İstisna kategori kontrolü
    READ TABLE lt_mat_kat INTO ls_mat_kat
      WITH KEY /bic/zh_mater =  ls_y_urun-urun2.

        lv_kat = ls_mat_kat-/bic/uwwhy02.

    READ TABLE lt_malyt_donem INTO ls_malyt_donem
      WITH KEY /bic/uwwhy02 =  lv_kat
               BINARY SEARCH.
*
      IF sy-subrc = 0.
          SELECT * INTO CORRESPONDING FIELDS OF TABLE lt_data2
            FROM /bic/ausd_o83f00
            WHERE
            fiscper        = ls_malyt_donem-zdonem2    AND
            /bic/zh_compco = e_s_result-/bic/zh_compco AND
            salesorg       = e_s_result-salesorg       AND
            /bic/zh_mater  = ls_y_urun-urun2           AND
            /bic/uww004    = e_s_result-/bic/uww004.

          SORT lt_data2 BY /bic/zh_compco
                           salesorg
                           /bic/zh_mater
                           /bic/uww004
                           fiscper
                           ASCENDING.

          READ TABLE lt_data2 INTO ls_data2
            WITH KEY /bic/zh_compco = e_s_result-/bic/zh_compco
                     salesorg       = e_s_result-salesorg
                     /bic/zh_mater  = ls_y_urun-urun2
                     /bic/uww004    = e_s_result-/bic/uww004
                     fiscper        = ls_malyt_donem-zdonem2
                     BINARY SEARCH.

          IF sy-subrc = 0.
            IF ls_data2-net_wgt_dl IS NOT INITIAL.
              "Oran(BrmMly) = Maliyet/Satış miktarı
              lv_oran1 = ls_data2-/bic/umal01 / ls_data2-net_wgt_dl.
              lv_oran2 = ls_data2-/bic/umal02 / ls_data2-net_wgt_dl.
              lv_oran3 = ls_data2-/bic/umal03 / ls_data2-net_wgt_dl.

            ENDIF.

            e_s_result-/bic/umal01  = lv_oran1 *
            e_s_result-net_wgt_dl.
            e_s_result-/bic/umal02  = lv_oran2 *
            e_s_result-net_wgt_dl.
            e_s_result-/bic/umal03  = lv_oran3 *
            e_s_result-net_wgt_dl.
            APPEND e_s_result TO e_t_result.
          ENDIF.

ELSE.
"Yeni Ürün Genel Kategori
        READ TABLE lt_data INTO ls_data
          WITH KEY /bic/zh_compco = e_s_result-/bic/zh_compco
                   salesorg       = e_s_result-salesorg
                   /bic/zh_mater  = ls_y_urun-urun2
                   /bic/uww004    = e_s_result-/bic/uww004
                   BINARY SEARCH.

        IF sy-subrc = 0.
          IF ls_data-net_wgt_dl IS NOT INITIAL.
            "Oran(BrmMly) = Maliyet/Satış miktarı
            lv_oran1 = ls_data-/bic/umal01 / ls_data-net_wgt_dl.
            lv_oran2 = ls_data-/bic/umal02 / ls_data-net_wgt_dl.
            lv_oran3 = ls_data-/bic/umal03 / ls_data-net_wgt_dl.

          ENDIF.

          e_s_result-/bic/umal01  = lv_oran1 *
          e_s_result-net_wgt_dl.
          e_s_result-/bic/umal02  = lv_oran2 *
          e_s_result-net_wgt_dl.
          e_s_result-/bic/umal03  = lv_oran3 *
          e_s_result-net_wgt_dl.
          APPEND e_s_result TO e_t_result.
        ENDIF.

  ENDIF.
"<<<<<<Yeni ürün kontrolü

*>>>İstisna kategori
        READ TABLE lt_mat_kat INTO ls_mat_kat
          WITH KEY /bic/zh_mater =  e_s_result-/bic/zh_mater.

        lv_kat = ls_mat_kat-/bic/uwwhy02.

        READ TABLE lt_malyt_donem INTO ls_malyt_donem
          WITH KEY /bic/uwwhy02 =  lv_kat
                   BINARY SEARCH.

        IF sy-subrc = 0.

          SELECT * INTO CORRESPONDING FIELDS OF TABLE lt_data2
            FROM /bic/ausd_o83f00
            WHERE
            fiscper        = ls_malyt_donem-zdonem2         AND
            /bic/zh_compco = e_s_result-/bic/zh_compco AND
            salesorg       = e_s_result-salesorg       AND
            /bic/zh_mater  = e_s_result-/bic/zh_mater  AND
            /bic/uww004    = e_s_result-/bic/uww004.

          READ TABLE lt_data2 INTO ls_data2
            WITH KEY /bic/zh_compco = e_s_result-/bic/zh_compco
                     salesorg       = e_s_result-salesorg
                     /bic/zh_mater  = e_s_result-/bic/zh_mater
                     /bic/uww004    = e_s_result-/bic/uww004
                     fiscper        = ls_malyt_donem-zdonem2
                     BINARY SEARCH.

          IF sy-subrc = 0.
            IF ls_data2-net_wgt_dl IS NOT INITIAL.
              "Oran(BrmMly) = Maliyet/Satış miktarı
              lv_oran1 = ls_data2-/bic/umal01 / ls_data2-net_wgt_dl.
              lv_oran2 = ls_data2-/bic/umal02 / ls_data2-net_wgt_dl.
              lv_oran3 = ls_data2-/bic/umal03 / ls_data2-net_wgt_dl.

            ENDIF.

            e_s_result-/bic/umal01  = lv_oran1 *
            e_s_result-net_wgt_dl.
            e_s_result-/bic/umal02  = lv_oran2 *
            e_s_result-net_wgt_dl.
            e_s_result-/bic/umal03  = lv_oran3 *
            e_s_result-net_wgt_dl.
            APPEND e_s_result TO e_t_result.
          ENDIF.
          EXIT.
        ENDIF.
*<<<İstisna Kategori

*>>>Son 3 aylık data
        READ TABLE lt_data INTO ls_data
          WITH KEY /bic/zh_compco = e_s_result-/bic/zh_compco
                   salesorg       = e_s_result-salesorg
                   /bic/zh_mater  = e_s_result-/bic/zh_mater
                   /bic/uww004    = e_s_result-/bic/uww004
                   BINARY SEARCH.

        IF sy-subrc = 0.
          IF ls_data-net_wgt_dl IS NOT INITIAL.
            "Oran(BrmMly) = Maliyet/Satış miktarı
            lv_oran1 = ls_data-/bic/umal01 / ls_data-net_wgt_dl.
            lv_oran2 = ls_data-/bic/umal02 / ls_data-net_wgt_dl.
            lv_oran3 = ls_data-/bic/umal03 / ls_data-net_wgt_dl.

          ENDIF.

          e_s_result-/bic/umal01  = lv_oran1 *
          e_s_result-net_wgt_dl.
          e_s_result-/bic/umal02  = lv_oran2 *
          e_s_result-net_wgt_dl.
          e_s_result-/bic/umal03  = lv_oran3 *
          e_s_result-net_wgt_dl.
          APPEND e_s_result TO e_t_result.

        ELSE.

       "Bütçelenen Malzeme son 3 ayda yoksa kategorisine bakılıyor.
       "Son 3 ay da ilgili kategornin en büyük değeri alınıyor.
          READ TABLE lt_mat_kat INTO ls_mat_kat
            WITH KEY /bic/zh_mater = e_s_result-/bic/zh_mater.

          lv_kat = ls_mat_kat-/bic/uwwhy02.

          SELECT * INTO CORRESPONDING FIELDS OF TABLE lt_data2
            FROM /bic/ausd_o8300
            WHERE fiscyear       = lv_year                        AND
                  /bic/zh_compco = e_s_result-/bic/zh_compco AND
                  salesorg       = e_s_result-salesorg       AND
*                  /bic/zh_mater  = e_s_result-/bic/zh_mater  AND
                  /bic/uwwhy02   = lv_kat                         AND
                  /bic/uww004    = e_s_result-/bic/uww004.

          SORT lt_data2 BY /bic/umal01 /bic/umal02 /bic/umal03
           DESCENDING.

          READ TABLE lt_data2 INTO ls_data2 INDEX 1.

          IF ls_data2-net_wgt_dl IS NOT INITIAL.
            "Oran(BrmMly) = Maliyet/Satış miktarı
            lv_oran1 = ls_data2-/bic/umal01 / ls_data2-net_wgt_dl.
            lv_oran2 = ls_data2-/bic/umal02 / ls_data2-net_wgt_dl.
            lv_oran3 = ls_data2-/bic/umal03 / ls_data2-net_wgt_dl.

          ENDIF.

          e_s_result-/bic/umal01  = lv_oran1 *
          e_s_result-net_wgt_dl.
          e_s_result-/bic/umal02  = lv_oran2 *
          e_s_result-net_wgt_dl.
          e_s_result-/bic/umal03  = lv_oran3 *
          e_s_result-net_wgt_dl.
          APPEND e_s_result TO e_t_result.
        ENDIF.
      ENDIF.
ENDIF.
    ENDLOOP.

    REFRESH result_package.
    MOVE e_t_result[] TO result_package[]. 
