
data :  l_s_range     type rsr_s_rangesid,
loc_var_range type rrrangeexit,
lv_ay(3)      type n,
lv_year1(4)   type n,
lv_year2(4)   type n,
lv_year(3)    type n,
lv_year3(3)   type n,
lv_gun(3)    type n.
case i_vnam.

BREAK-POINT.
WHEN 'ZVB_GUNSAYISI'.
IF i_step = 2.
LOOP AT i_t_var_range into loc_var_range where vnam = 'ZVBM_RPRDON'.

lv_year1 = loc_var_range-high+0(4).             "Son değerin yılı.
lv_year2 = loc_var_range-low+0(4).              "İlk değerin yılı.
lv_year = ( lv_year1 - lv_year2 ) * 12.         "Yıl farkını alıp 12 ile çarparak ay sayısı birimine çevirdik.
lv_year3 = lv_year - loc_var_range-low+4(3).    "Bulduğumuz yıllık ay sayısından ilk değerin ay değerini çıkardık.
lv_ay = lv_year3 + loc_var_range-high+4(3) + 1. "Bir üstte bulduğumuz ay farkına son değerin ay değeri ile toplayıp FARK OLARAK KAÇ AY OLDUĞUNU BULDUK.
lv_gun = lv_ay * 30.                            "üstte bulduğumuz ay sayısını gün sayısına çevirdik.

l_s_range-sign     = 'I'.
l_s_range-opt      = 'EQ'. 
l_s_range-low = lv_gun.

ENDLOOP.
ENDIF.
endcase. 
