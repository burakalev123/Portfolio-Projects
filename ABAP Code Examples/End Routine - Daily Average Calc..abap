
*----------------------------------------------------------------------*
*Table Declaration
*----------------------------------------------------------------------*
DATA: e_s_result TYPE _ty_s_tg_1,
      e_t_result TYPE _ty_t_tg_1.

DATA: counter TYPE i,
      var_month TYPE /bi0/oicalmonth2,
      var_day TYPE /bi0/oicalday,
      var_day1 TYPE /bi0/oicalday.
*----------------------------------------------------------------------*
*Data Assigning
*----------------------------------------------------------------------*
BREAK-POINT.

SORT RESULT_PACKAGE ASCENDING BY calday /bic/zclassapp.

LOOP AT RESULT_PACKAGE ASSIGNING <result_fields>.

      <result_fields>-/bic/zdaycount = <result_fields>-calday+6.
      <result_fields>-/bic/zsayac = <result_fields>-/bic/zsayac.
      <result_fields>-/bic/zdayavg = <result_fields>-/bic/zsayac /
      <result_fields>-/bic/zdaycount.

    APPEND <result_fields> TO e_t_result.

  var_month = <result_fields>-calday+4(2) + 1 .

  CONCATENATE <result_fields>-calday+0(4) var_month '01'
  INTO var_day1.

  var_day = var_day1 - 1.
  counter = var_day - <result_fields>-calday.

    DO counter TIMES.

       <result_fields>-calday = <result_fields>-calday + 1.
       <result_fields>-/bic/zdaycount = <result_fields>-calday+6.
       <result_fields>-/bic/zsayac = <result_fields>-/bic/zsayac.
       <result_fields>-/bic/zdayavg = <result_fields>-/bic/zsayac /
       <result_fields>-/bic/zdaycount.

    APPEND <result_fields> TO e_t_result.

    ENDDO.

ENDLOOP.

    REFRESH RESULT_PACKAGE.

    MOVE e_t_result[] TO RESULT_PACKAGE[]. 
