
    data: lo_dim_detail      type ref to cl_uja_dim,
    lo_purch           type ref to cl_uja_application,
    lo_purch_mgr       type ref to if_uja_application_manager,
    lo_sqe             type ref to if_ujo_query,
    ls_appl_info       type uja_s_api_appl_info,
    ls_dim_details     type uja_s_api_appl_detail,
    lo_appl_data       type ref to if_uja_application_data,
    lo_metadatafactory type ref to if_uja_metadata_factory,
    lt_dimname         type uja_t_dim_list,
    ls_dimname         type line of uja_t_dim_list,
    ls_cv              type ujk_s_cv,
    ls_dimmember       type line of uja_t_dim_member,
    ls_sel             type uj0_s_sel,
    it_range           type uj0_t_sel,
    lt_data            type ref to data. 

field-symbols:
<fs_result>  type any,
<fs_data>    type any,
<fs_lt_data> type standard table. 


lo_metadatafactory = cl_uja_metadata_factory=>get_factory( 'ZBPC_SOLEN' ).

lo_appl_data = lo_metadatafactory->get_appl_data( 'Sales' ).
call method lo_appl_data->get_dim_list
importing
et_dim_name = lt_dimname.


lo_purch_mgr = cl_uja_bpc_admin_factory=>get_application_manager(
           i_appset_id      =  i_appset_id
           i_application_id =  'Sales' ).


lo_purch_mgr->create_data_ref(
EXPORTING
i_data_type   = 'T'
it_dim_name   = lt_dimname
if_tech_name  = abap_false
if_signeddata = abap_true
IMPORTING
er_data       = lt_data
).


ASSIGN lt_data->* TO <fs_lt_data>.


g_end_of_data = abap_false.
g_first_call = abap_true.



lo_sqe = cl_ujo_query_factory=>get_query_adapter(
  i_appset_id = i_appset_id
  i_appl_id = 'Sales'
  ).

WHILE g_end_of_data ne abap_true.



call METHOD lo_sqe->run_rsdri_query(
 EXPORTING
  it_dim_name       = lt_dimname   " BPC: Dimension List
  it_range          = it_range
  i_packagesize     = 50000
  if_check_security = abap_false    " BPC: Generic indicator
 IMPORTING
  e_end_of_data     = g_end_of_data
  et_data           = <fs_lt_data>
 changing
  c_first_call      = g_first_call

  ).

  LOOP AT <fs_lt_data> ASSIGNING <fs_result>.
    MOVE-CORRESPONDING <fs_result> to ls_sales.
      APPEND ls_sales to lt_sales.

  ENDLOOP.
*        CLEAR <fs_lt_data>.

ENDWHILE. 
