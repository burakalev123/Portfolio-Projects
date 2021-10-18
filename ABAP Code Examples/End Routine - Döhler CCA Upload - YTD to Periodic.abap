*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
DATA: lt_temp TYPE _ty_t_tg_1,
ls_temp TYPE _ty_s_tg_1.

DATA: lt_temp2 TYPE _ty_t_tg_1,
ls_temp2 TYPE _ty_s_tg_1.

DATA: lt_bukrs TYPE RANGE OF /bi0/oicomp_code,
ls_bukrs LIKE LINE OF lt_bukrs,
lt_perio TYPE RANGE OF /bi0/oifiscper,
ls_perio LIKE LINE OF lt_perio.
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
BREAK-POINT.
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
*   Cancellation documents are generated here.
*   The entire annual balance is hereby to be set to zero.
*   However, the reversal documents are posted in the current period.
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*

LOOP AT RESULT_PACKAGE ASSIGNING <result_fields>.

"Collects the Comp Codes in Result Package.
ls_bukrs-sign = 'I'.
ls_bukrs-option = 'EQ'.
ls_bukrs-low = <result_fields>-comp_code.
COLLECT ls_bukrs INTO lt_bukrs.

"Collect the Periods in Result Package.
ls_perio-sign = 'I'.
ls_perio-option = 'EQ'.
ls_perio-low(4) = <result_fields>-fiscper(4).
ls_perio-low+4(3) = '001'.
ls_perio-high = <result_fields>-fiscper.
COLLECT ls_perio INTO lt_perio.

ENDLOOP.
*----------------------------------------------------------------------*
LOOP AT lt_bukrs INTO ls_bukrs.
*----------------------------------------------------------------------*
"Selection of the data from active and new table...
*----------------------------------------------------------------------*
"Active Data Table for DataStore DCCAEAD03
SELECT fiscvarnt comp_code costcenter /bic/dbc_chart /bic/dbc_item
   pcomp_code CURRENCY co_area costelmnt
   SUM( amount ) AS amount
INTO CORRESPONDING FIELDS OF TABLE lt_temp
FROM /bic/adccaead032
WHERE fiscvarnt =  'K4'          AND
    fiscper   >= ls_perio-low  AND
    fiscper   <= ls_perio-high AND
    comp_code = ls_bukrs-low
GROUP BY fiscvarnt comp_code costcenter /bic/dbc_chart
       /bic/dbc_item pcomp_code CURRENCY co_area costelmnt.
*----------------------------------------------------------------------*
"Inbound Table for DataStore DCCAEAD03
SELECT fiscvarnt comp_code costcenter /bic/dbc_chart /bic/dbc_item
   pcomp_code CURRENCY co_area costelmnt
   SUM( amount ) AS amount
INTO CORRESPONDING FIELDS OF TABLE lt_temp2
FROM /bic/adccaead031
WHERE fiscvarnt =  'K4'          AND
    fiscper   >= ls_perio-low  AND
    fiscper   <= ls_perio-high AND
    comp_code = ls_bukrs-low
GROUP BY fiscvarnt comp_code costcenter /bic/dbc_chart
       /bic/dbc_item pcomp_code CURRENCY co_area costelmnt.
*----------------------------------------------------------------------*
"Table sorting...
*----------------------------------------------------------------------*
SORT lt_temp
BY fiscper comp_code costcenter /bic/dbc_item pcomp_code.

SORT lt_temp2
BY fiscper comp_code costcenter /bic/dbc_item pcomp_code.

SORT RESULT_PACKAGE
BY fiscper comp_code costcenter /bic/dbc_item pcomp_code.
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
"New Data table empty...
IF lt_temp2 IS INITIAL.
*----------------------------------------------------------------------*
LOOP AT lt_temp INTO ls_temp.

ls_temp-fiscper = ls_perio-high.
ls_temp-amount  = ls_temp-amount * -1.
*----------------------------------------------------------------------*
READ TABLE RESULT_PACKAGE ASSIGNING <result_fields>
  WITH KEY fiscper        = ls_temp-fiscper
           comp_code      = ls_temp-comp_code
           costcenter     = ls_temp-costcenter
           /bic/dbc_item  = ls_temp-/bic/dbc_item
           pcomp_code     = ls_temp-pcomp_code
           BINARY SEARCH.

IF sy-subrc = 0.
  <result_fields>-amount = <result_fields>-amount
                         + ls_temp-amount.
ELSE.
  CALL METHOD me->new_record__end_routine
    EXPORTING
      source_segid  = 1
      source_record = ls_temp-record
    IMPORTING
      record_new    = ls_temp-record.

  APPEND ls_temp TO RESULT_PACKAGE.

ENDIF.
ENDLOOP.
*----------------------------------------------------------------------*
ELSE.

LOOP AT lt_temp2 INTO ls_temp2.

ls_temp2-fiscper = ls_perio-high.
ls_temp2-amount  = ls_temp2-amount * -1.
*----------------------------------------------------------------------*
READ TABLE RESULT_PACKAGE ASSIGNING <result_fields>
     WITH KEY fiscper        = ls_temp2-fiscper
              comp_code      = ls_temp2-comp_code
              costcenter     = ls_temp2-costcenter
              /bic/dbc_item  = ls_temp2-/bic/dbc_item
              pcomp_code     = ls_temp2-pcomp_code
              BINARY SEARCH.

IF sy-subrc = 0.
  <result_fields>-amount = <result_fields>-amount
                         + ls_temp2-amount.
ELSE.
  CALL METHOD me->new_record__end_routine
    EXPORTING
      source_segid  = 1
      source_record = ls_temp2-record
    IMPORTING
      record_new    = ls_temp2-record.

  APPEND ls_temp2 TO RESULT_PACKAGE.

ENDIF.
ENDLOOP.
*----------------------------------------------------------------------*
ENDIF.
ENDLOOP. 
