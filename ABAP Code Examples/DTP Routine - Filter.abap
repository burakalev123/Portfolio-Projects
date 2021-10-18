*----------------------------------------------------*
* DTP Routine - Filter (last month)
*----------------------------------------------------*
data: l_idx like sy-tabix,
      lv_datum LIKE sy-datum,
      lv_datum2 LIKE sy-datum.

read table l_t_range with key
           fieldname = 'BUDAT'.
*BREAK-POINT.

l_idx = sy-tabix.
*....
CONCATENATE sy-datum(6) '01' INTO lv_datum.
lv_datum = lv_datum - 1.
CONCATENATE lv_datum(6) '01' INTO lv_datum2.

  l_idx = sy-tabix.
  l_t_range-fieldname = 'BUDAT'.
  l_t_range-iobjnm = '0FISCPER'.
  l_t_range-low = lv_datum2.
  l_t_range-high = lv_datum.
  l_t_range-option = 'BT'.
  l_t_range-SIGN = 'I'.

IF l_idx <> 0.
  MODIFY l_t_range INDEX l_idx.
ELSE.
  APPEND l_t_range.
ENDIF.
p_subrc = 0. 

*----------------------------------------------------*
* Takvim Ayı -1 den önceki son 3 ay
*----------------------------------------------------*

DATA: l_idx          LIKE sy-tabix,
lv_add         TYPE i,
lv_period_low  TYPE char7,
lv_period_high TYPE char7,
lv_datum       LIKE sy-datum,
lv_datum2      LIKE sy-datum.

READ TABLE l_t_range WITH KEY fieldname = 'FISCPER'.
*BREAK-POINT.

l_idx = sy-tabix.
*....
************************************************************************
CONCATENATE sy-datum(6) '01' INTO lv_datum.
lv_add = -1 .
CALL FUNCTION 'UJD_ADD_MONTH_TO_DATE' "
EXPORTING
i_months   = lv_add
i_old_date = lv_datum
IMPORTING
e_new_date = lv_datum2.

lv_datum = lv_datum2.

CLEAR lv_datum2.
CLEAR lv_add .
************************************************************************

lv_add = -3 .
CALL FUNCTION 'UJD_ADD_MONTH_TO_DATE' "
EXPORTING
i_months   = lv_add
i_old_date = lv_datum
IMPORTING
e_new_date = lv_datum2.

CONCATENATE lv_datum(4)  '0' lv_datum+4(2)  INTO lv_period_high.
CONCATENATE lv_datum2(4) '0' lv_datum2+4(2) INTO lv_period_low.

l_idx = sy-tabix.
l_t_range-fieldname = 'FISCPER'.
l_t_range-iobjnm    = '0FISCPER'.
l_t_range-low       = lv_period_low.
l_t_range-high      = lv_period_high.
l_t_range-option    = 'BT'.
l_t_range-sign      = 'I'.

IF l_idx <> 0.
MODIFY l_t_range INDEX l_idx.
ELSE.
APPEND l_t_range.
ENDIF.

p_subrc = 0. 
