
BREAK-POINT.
*--------------------------------------------------------------*
*Data Types
*--------------------------------------------------------------*
TYPES: BEGIN OF t_kons,
  GL_ACCOUNT TYPE /BIC/AZCONDS0100-GL_ACCOUNT,
  COMP_CODE TYPE /BIC/AZCONDS0100-COMP_CODE,
  /BIC/ZCONS_ACC TYPE /BIC/AZCONDS0100-/BIC/ZCONS_ACC,
  /BIC/ZCASE TYPE /BIC/AZCONDS0100-/BIC/ZCASE,
  END OF t_kons.
*--------------------------------------------------------------*
*Table Declaration
*--------------------------------------------------------------*

DATA: it_kons TYPE STANDARD TABLE OF /BIC/AZCONDS0100,
      wa_kons TYPE /BIC/AZCONDS0100.

DATA: WA_DATA_PACKAGE TYPE _ty_s_SC_1,
      lt_package type _ty_t_SC_1.
*--------------------------------------------------------------*
*Data Assigning
*--------------------------------------------------------------*

SELECT GL_ACCOUNT
       COMP_CODE
       /BIC/ZCONS_ACC
       /BIC/ZCASE
  FROM /BIC/AZCONDS0100
  INTO CORRESPONDING FIELDS OF TABLE  it_kons.

SORT it_kons ASCENDING by GL_ACCOUNT COMP_CODE.
SORT SOURCE_PACKAGE ASCENDING by GL_ACCOUNT COMP_CODE.

LOOP AT SOURCE_PACKAGE INTO WA_DATA_PACKAGE.

READ TABLE it_kons INTO wa_kons
                   WITH KEY GL_ACCOUNT = WA_DATA_PACKAGE-GL_ACCOUNT
                            COMP_CODE  = WA_DATA_PACKAGE-COMP_CODE
                            BINARY SEARCH.
IF sy-subrc EQ 0.

 IF wa_kons-/BIC/ZCASE IS INITIAL. "Case alanı boş için.

 WA_DATA_PACKAGE-/BIC/ZCONS_ACC = wa_kons-/BIC/ZCONS_ACC.

 ELSEIF NOT WA_DATA_PACKAGE-PCOMPANY IS INITIAL."Muhatap bilgisi dolu için.

 READ TABLE it_kons INTO wa_kons
                    WITH KEY GL_ACCOUNT = WA_DATA_PACKAGE-GL_ACCOUNT
                             COMP_CODE  = WA_DATA_PACKAGE-COMP_CODE
                             /BIC/ZCASE = 'MUHATAP'.
   IF sy-subrc EQ 0.

      WA_DATA_PACKAGE-/BIC/ZCONS_ACC = wa_kons-/BIC/ZCONS_ACC.

   ENDIF.

  ELSEIF NOT WA_DATA_PACKAGE-VENDOR IS INITIAL. "Satıcı dolu ise.

   READ TABLE it_kons INTO wa_kons
                      WITH KEY GL_ACCOUNT = WA_DATA_PACKAGE-GL_ACCOUNT
                               COMP_CODE  = WA_DATA_PACKAGE-COMP_CODE
                               /BIC/ZCASE = WA_DATA_PACKAGE-VENDOR.
   IF sy-subrc EQ 0.

      WA_DATA_PACKAGE-/BIC/ZCONS_ACC = wa_kons-/BIC/ZCONS_ACC.

   ELSE.

    READ TABLE it_kons INTO wa_kons
                        WITH KEY GL_ACCOUNT = WA_DATA_PACKAGE-GL_ACCOUNT
                                 COMP_CODE  = WA_DATA_PACKAGE-COMP_CODE
                                 /BIC/ZCASE = WA_DATA_PACKAGE-DOC_CURRCY.

    IF sy-subrc EQ 0.

       WA_DATA_PACKAGE-/BIC/ZCONS_ACC = wa_kons-/BIC/ZCONS_ACC.

    ELSE.

     READ TABLE it_kons INTO wa_kons
                        WITH KEY GL_ACCOUNT = WA_DATA_PACKAGE-GL_ACCOUNT
                                 COMP_CODE  = WA_DATA_PACKAGE-COMP_CODE
                                 /BIC/ZCASE = 'NON'.
        IF sy-subrc EQ 0.

         WA_DATA_PACKAGE-/BIC/ZCONS_ACC = wa_kons-/BIC/ZCONS_ACC.

        ENDIF.

     ENDIF.

   ENDIF.

  ELSEIF WA_DATA_PACKAGE-VENDOR IS INITIAL.

   READ TABLE it_kons INTO wa_kons
                      WITH KEY GL_ACCOUNT = WA_DATA_PACKAGE-GL_ACCOUNT
                               COMP_CODE  = WA_DATA_PACKAGE-COMP_CODE
                               /BIC/ZCASE = WA_DATA_PACKAGE-DOC_CURRCY.

   IF sy-subrc EQ 0.

      WA_DATA_PACKAGE-/BIC/ZCONS_ACC = wa_kons-/BIC/ZCONS_ACC.

   ELSE.

    READ TABLE it_kons INTO wa_kons
                       WITH KEY GL_ACCOUNT = WA_DATA_PACKAGE-GL_ACCOUNT
                                COMP_CODE  = WA_DATA_PACKAGE-COMP_CODE
                                /BIC/ZCASE = 'NON'.
       IF sy-subrc EQ 0.

          WA_DATA_PACKAGE-/BIC/ZCONS_ACC = wa_kons-/BIC/ZCONS_ACC.

       ENDIF.

    ENDIF.

  ENDIF.

ENDIF.

  append wa_data_package to lt_PACKAGE.

ENDLOOP.



DATA_PACKAGE[] = lt_package[].
