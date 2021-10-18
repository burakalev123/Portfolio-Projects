*----------------------------------------------------*
*Infopackage Routine - Filter
*----------------------------------------------------*

DATA: l_idx    LIKE sy-tabix,
      lv_datum LIKE sy-datum.

  READ TABLE l_t_range WITH KEY
       fieldname = 'KTARIH'.

  l_idx = sy-tabix.

  lv_datum = sy-datum - 2.
  l_idx = sy-tabix.

  l_t_range-low = lv_datum.
  l_t_range-high = sy-datum .
  l_t_range-option = 'BT'.

  MODIFY l_t_range INDEX l_idx.

  p_subrc = 0. 

*----------------------------------------------------*
*----------------------------------------------------*

  data: l_idx    like sy-tabix,
      lv_datum like sy-datum.

  read table l_t_range with key
       fieldname = 'TARIH'.
  lv_datum = sy-datum - 1.
  l_idx = sy-tabix.

  l_t_range-low = lv_datum.
  l_t_range-option = 'EQ'.


l_idx = sy-tabix.
*....
modify l_t_range index l_idx.

p_subrc = 0. 

*----------------------------------------------------*
* Infopackage Routine - Filter (last month)
*----------------------------------------------------*

data: l_idx like sy-tabix,
      lv_datum LIKE sy-datum,
      lv_datum2 LIKE sy-datum.

read table l_t_range with key
     fieldname = 'BUDAT'.
l_idx = sy-tabix.
*....
CONCATENATE sy-datum(6) '01' INTO lv_datum.
lv_datum = lv_datum - 1.
CONCATENATE lv_datum(6) '01' INTO lv_datum2.

  l_idx = sy-tabix.

  l_t_range-low = lv_datum2.
  l_t_range-high = lv_datum .
  l_t_range-option = 'BT'.
  l_t_range-SIGN = 'I'.
modify l_t_range index l_idx.

p_subrc = 0.
