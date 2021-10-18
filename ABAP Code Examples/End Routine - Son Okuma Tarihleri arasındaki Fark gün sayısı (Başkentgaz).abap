********son okuma tarihine göre fark okuma kayma raporu *****
data: begin of p_okuma,
      UC_DEVICE type /BI0/OIUC_DEVICE,
      /BIC/ZSTRHAY type /BIC/OIZSTRHAY,
      /BIC/ZSONTRH type /BIC/OIZSONTRH,
  END OF p_okuma.
data: t_okuma like table of p_okuma,
      l_okuma like line of t_okuma,
      t_okuma2 like TABLE OF p_okuma,
      l_okuma2 like line of t_okuma2.
********son okuma tarihine göre fark okuma kayma raporu ***** 

********son okuma tarihine göre fark okuma kayma raporu *****
select UC_DEVICE /BIC/ZSTRHAY /BIC/ZSONTRH from /BIC/AZBIN_D0200 into
table
t_okuma.
********son okuma tarihine göre fark okuma kayma raporu ***** 

 sort t_okuma by UC_DEVICE /BIC/ZSTRHAY /BIC/ZSONTRH DESCENDING.
    move t_okuma to t_okuma2.
    delete ADJACENT DUPLICATES FROM t_okuma2 COMPARING  UC_DEVICE
    /BIC/ZSTRHAY. 

********son okuma tarihine göre fark okuma kayma raporu *****
loop at t_okuma into l_okuma where UC_DEVICE = ls_result-UC_DEVICE and
/BIC/ZSONTRH < ls_result-/BIC/ZSONTRH.

read table t_okuma2 into l_okuma2 with key UC_DEVICE =
ls_result-UC_DEVICE
/BIC/ZSTRHAY = ls_result-/BIC/ZSTRHAY
/BIC/ZSONTRH = ls_result-/BIC/ZSONTRH.
if sy-subrc EQ 0.
  ls_result-/BIC/ZFARKGUN2 = ls_result-/BIC/ZSONTRH -
  l_okuma-/BIC/ZSONTRH.

  CLEAR l_okuma.

IF ls_result-/BIC/ZFARKGUN2 LT  '18'.
   ls_result-/BIC/ZFARKGRP = '17'.

ELSEIF ls_result-/BIC/ZFARKGUN2 GE  '18' AND ls_result-/BIC/ZFARKGUN2 LE
'42'.
 ls_result-/BIC/ZFARKGRP = ls_result-/BIC/ZFARKGUN2.
ELSEIF ls_result-/BIC/ZFARKGUN2 GT  '42'.
  ls_result-/BIC/ZFARKGRP = '43'.
   ENDIF.
   endif.
  exit.
  endloop.
********son okuma tarihine göre fark okuma kayma raporu ***** 

