DATA: WA_DATA_PACKAGE LIKE DATA_PACKAGE,
     ZINDEX LIKE SY-TABIX,
     lt_package type STANDARD TABLE OF data_package_structure.
BREAK-POINT.
loop at DATA_PACKAGE .
  CLEAR ZINDEX.
  ZINDEX = SY-TABIX.

MOVE-CORRESPONDING DATA_PACKAGE to wa_data_package.

  IF wa_data_package-wbs_elemt(2) eq 'DI' or
  wa_data_package-wbs_elemt(2) eq 'DA'.
REPLACE ALL OCCURRENCES OF '.' in wa_data_package-wbs_elemt with ' '
    .
    CONDENSE wa_data_package-wbs_elemt NO-GAPS.
    CONCATENATE wa_data_package-wbs_elemt '0000000000000000000' INTO
    wa_data_package-wbs_elemt.
    wa_data_package-wbs_elemt = wa_data_package-wbs_elemt(17).

  ENDIF.
  append wa_data_package to lt_PACKAGE.
  endloop.

	
  LOOP AT  DATA_PACKAGE.
    clear wa_data_package.
  CLEAR ZINDEX.
  ZINDEX = SY-TABIX.

  MOVE-CORRESPONDING DATA_PACKAGE to wa_data_package.
  append wa_data_package to lt_PACKAGE.
  ENDLOOP.

  DATA_PACKAGE[] = lt_package[].
