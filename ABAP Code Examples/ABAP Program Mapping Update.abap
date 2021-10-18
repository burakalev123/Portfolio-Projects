
*T.Code. ZMAP_UPDATE

*&---------------------------------------------------------------------*
*& Report ZKONSMAP_EXCEL_TO_BW
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zkonsmap_excel_to_bw.
TABLES :sscrfields.
TYPE-POOLS : vrm.

DATA: param      TYPE vrm_id,
      values     TYPE vrm_values,
      value      LIKE LINE OF values,
      targetpath TYPE sapb-sappfad.

DATA: p_eventid   TYPE btceventid,
      p_eventparm TYPE btcevtparm,
      p_server    TYPE btcserver.

DATA: p_file_path1 LIKE sapb-sappfad,
      p_file_path2 LIKE sapb-sappfad,
      p_file_path3 LIKE sapb-sappfad,
      p_file_path4 LIKE sapb-sappfad,
      p_file_path5 LIKE sapb-sappfad.

DATA p_file TYPE localfile.


PARAMETERS: p_file1 TYPE localfile,
            p_file2 TYPE localfile,
            p_file3 TYPE localfile,
            p_file4 TYPE localfile,
            p_file5 TYPE localfile.


SELECTION-SCREEN BEGIN OF LINE.
SELECTION-SCREEN PUSHBUTTON (20) w_button  USER-COMMAND  but1.
SELECTION-SCREEN END OF LINE.

INITIALIZATION.

  w_button = 'Mapping Update'.

************************************************************
AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_file1.

  DATA: t_file TYPE filetable.
  DATA: xfile LIKE LINE OF t_file.
  DATA: rc TYPE i.

  CALL METHOD cl_gui_frontend_services=>file_open_dialog
    EXPORTING
      initial_directory = 'C:\'
    CHANGING
      file_table        = t_file
      rc                = rc.

  READ TABLE t_file INTO xfile INDEX 1.
  CHECK sy-subrc = 0.
  p_file1 = xfile-filename.
************************************************************
AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_file2.

  DATA: t_file TYPE filetable.
  DATA: xfile LIKE LINE OF t_file.
  DATA: rc TYPE i.

  CALL METHOD cl_gui_frontend_services=>file_open_dialog
    EXPORTING
      initial_directory = 'C:\'
    CHANGING
      file_table        = t_file
      rc                = rc.

  READ TABLE t_file INTO xfile INDEX 1.
  CHECK sy-subrc = 0.
  p_file2 = xfile-filename.

************************************************************
AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_file3.

  DATA: t_file TYPE filetable.
  DATA: xfile LIKE LINE OF t_file.
  DATA: rc TYPE i.

  CALL METHOD cl_gui_frontend_services=>file_open_dialog
    EXPORTING
      initial_directory = 'C:\'
    CHANGING
      file_table        = t_file
      rc                = rc.

  READ TABLE t_file INTO xfile INDEX 1.
  CHECK sy-subrc = 0.
  p_file3 = xfile-filename.

************************************************************

AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_file4.

  DATA: t_file TYPE filetable.
  DATA: xfile LIKE LINE OF t_file.
  DATA: rc TYPE i.

  CALL METHOD cl_gui_frontend_services=>file_open_dialog
    EXPORTING
      initial_directory = 'C:\'
    CHANGING
      file_table        = t_file
      rc                = rc.

  READ TABLE t_file INTO xfile INDEX 1.
  CHECK sy-subrc = 0.
  p_file4 = xfile-filename.

************************************************************

AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_file5.

  DATA: t_file TYPE filetable.
  DATA: xfile LIKE LINE OF t_file.
  DATA: rc TYPE i.

  CALL METHOD cl_gui_frontend_services=>file_open_dialog
    EXPORTING
      initial_directory = 'C:\'
    CHANGING
      file_table        = t_file
      rc                = rc.

  READ TABLE t_file INTO xfile INDEX 1.
  CHECK sy-subrc = 0.
  p_file5 = xfile-filename.


*
*INITIALIZATION.
*START-OF-SELECTION.

AT SELECTION-SCREEN.
  IF sscrfields-ucomm EQ 'BUT1'.

    IF p_file1 IS NOT INITIAL.

      p_file_path1 = p_file1.
      CALL FUNCTION 'ARCHIVFILE_CLIENT_TO_SERVER'
        EXPORTING
          path       = p_file_path1
          targetpath = 'PERAKENDE_Ort. Hsp. Map.csv'.

    ENDIF.

    IF p_file2 IS NOT INITIAL.

      p_file_path2 = p_file2.
      CALL FUNCTION 'ARCHIVFILE_CLIENT_TO_SERVER'
        EXPORTING
          path       = p_file_path2
          targetpath = 'GDZENERJI_Ort. Hsp. Map.csv'.

    ENDIF.

    IF p_file3 IS NOT INITIAL.

      p_file_path3 = p_file3.
      CALL FUNCTION 'ARCHIVFILE_CLIENT_TO_SERVER'
        EXPORTING
          path       = p_file_path3
          targetpath = 'DAGITIM_Ort. Hsp. Map.csv'.

    ENDIF.

    IF p_file4 IS NOT INITIAL.

      p_file_path4 = p_file4.
      CALL FUNCTION 'ARCHIVFILE_CLIENT_TO_SERVER'
        EXPORTING
          path       = p_file_path4
          targetpath = 'BEG_Ort. Hsp. Map.csv'.

    ENDIF.

    IF p_file5 IS NOT INITIAL.

      p_file_path5 = p_file5.
      CALL FUNCTION 'ARCHIVFILE_CLIENT_TO_SERVER'
        EXPORTING
          path       = p_file_path5
          targetpath = 'URETIM_Ort. Hsp. Map.csv'.

    ENDIF.
    PERFORM get_data.
  ENDIF.


END-OF-SELECTION.
*&---------------------------------------------------------------------*
*&      Form  GET_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_PARAM  text
*----------------------------------------------------------------------*
FORM get_data.

*  CALL FUNCTION 'ARCHIVFILE_CLIENT_TO_SERVER'
*    EXPORTING
*      path       = p_file_path1
*      targetpath = targetpath.

  """"""""""event raise
  p_eventid   = 'ZALL_MAP'.
  p_eventparm = 'Event parameter'.
  p_server    = ''.

  CALL METHOD cl_batch_event=>raise
    EXPORTING
      i_eventparm           = p_eventparm
      i_server              = p_server
      i_eventid             = p_eventid
    EXCEPTIONS
      excpt_raise_failed    = 1
      excpt_raise_forbidden = 3
      excpt_unknown_event   = 4
      excpt_no_authority    = 5
      OTHERS                = 6.



ENDFORM. 

