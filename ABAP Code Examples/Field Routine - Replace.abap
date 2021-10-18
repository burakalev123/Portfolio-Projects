*Karakter düzeltme ve Replace rutini

data: lv_result(60) type c.
call function 'SCP_REPLACE_STRANGE_CHARS'
exporting
intext = SOURCE_FIELDS-GELENMESAJ1
*Infoobject name*
intext_lg = 0
inter_cp = '0000'
inter_base_cp = '0000'
in_cp = '0000'
replacement = 46
importing outtext = RESULT.
*OUTUSED =
*OUTOVERFLOW =
* EXCEPTIONS
*INVALID_CODEPAGE = 1
* CODEPAGE_MISMATCH = 2
* INTERNAL_ERROR = 3
* CANNOT_CONVERT = 4
* FIELDS_NOT_TYPE_C = 5
* OTHERS = 6.

REPLACE ALL OCCURRENCES OF  '.' IN RESULT WITH ''.

 CONDENSE RESULT. 


* # i "." yaptı ondan "." yı boşlukla yer değiştirdik


****************************************************************************************

      REPLACE ALL OCCURRENCES OF '/' IN s_zoxbed0189-zzkonu WITH space .
      REPLACE ALL OCCURRENCES OF '\' IN s_zoxbed0189-zzkonu WITH space .
      REPLACE ALL OCCURRENCES OF '(' IN s_zoxbed0189-zzkonu WITH space .
      REPLACE ALL OCCURRENCES OF ')' IN s_zoxbed0189-zzkonu WITH space .
      REPLACE ALL OCCURRENCES OF '-' IN s_zoxbed0189-zzkonu WITH space .
      REPLACE ALL OCCURRENCES OF '.' IN s_zoxbed0189-zzkonu WITH space .
      REPLACE ALL OCCURRENCES OF '*' IN s_zoxbed0189-zzkonu WITH space .
      REPLACE ALL OCCURRENCES OF ',' IN s_zoxbed0189-zzkonu WITH space .
      REPLACE ALL OCCURRENCES OF '!' IN s_zoxbed0189-zzkonu WITH space .
      REPLACE ALL OCCURRENCES OF '?' IN s_zoxbed0189-zzkonu WITH space .
      REPLACE ALL OCCURRENCES OF '%' IN s_zoxbed0189-zzkonu WITH space .
      REPLACE ALL OCCURRENCES OF '&' IN s_zoxbed0189-zzkonu WITH space .
     REPLACE ALL OCCURRENCES OF 'M³' IN s_zoxbed0189-zzkonu WITH space .
      REPLACE ALL OCCURRENCES OF 'Ø' IN s_zoxbed0189-zzkonu WITH space .
      REPLACE ALL OCCURRENCES OF '{' IN s_zoxbed0189-zzkonu WITH space .
      REPLACE ALL OCCURRENCES OF '}' IN s_zoxbed0189-zzkonu WITH space .
      REPLACE ALL OCCURRENCES OF ':' IN s_zoxbed0189-zzkonu WITH space .
      REPLACE ALL OCCURRENCES OF ';' IN s_zoxbed0189-zzkonu WITH space .
      REPLACE ALL OCCURRENCES OF '~' IN s_zoxbed0189-zzkonu WITH space .
REPLACE ALL OCCURRENCES OF REGEX '\h\n#' IN s_zoxbed0189-zzkonu WITH space .
REPLACE ALL OCCURRENCES OF REGEX  '[\n\r\t]+' IN s_zoxbed0189-zzkonu WITH space .
REPLACE ALL OCCURRENCES OF REGEX  '<br/>' IN s_zoxbed0189-zzkonu WITH space .
REPLACE ALL OCCURRENCES OF REGEX  '<br>' IN s_zoxbed0189-zzkonu WITH space .
REPLACE ALL OCCURRENCES OF REGEX  '\n' IN s_zoxbed0189-zzkonu WITH space .
REPLACE ALL OCCURRENCES OF REGEX  '\r' IN s_zoxbed0189-zzkonu WITH space .
REPLACE ALL OCCURRENCES OF REGEX  '/p' IN s_zoxbed0189-zzkonu WITH space .
      REPLACE ALL OCCURRENCES OF '#' IN s_zoxbed0189-zzkonu WITH space .
      REPLACE ALL OCCURRENCES OF '"' IN s_zoxbed0189-zzkonu WITH space .
        REPLACE ALL OCCURRENCES OF 'Ş' IN s_zoxbed0189-zzkonu WITH 'S' .
        REPLACE ALL OCCURRENCES OF 'ş' IN s_zoxbed0189-zzkonu WITH 's' .
        REPLACE ALL OCCURRENCES OF 'İ' IN s_zoxbed0189-zzkonu WITH 'I' .
      REPLACE ALL OCCURRENCES OF '#' IN s_zoxbed0189-zzkonu WITH space .
        REPLACE ALL OCCURRENCES OF 'ı' IN s_zoxbed0189-zzkonu WITH 'i' .
        REPLACE ALL OCCURRENCES OF 'Ü' IN s_zoxbed0189-zzkonu WITH 'U' .
        REPLACE ALL OCCURRENCES OF 'ü' IN s_zoxbed0189-zzkonu WITH 'u' .
        REPLACE ALL OCCURRENCES OF 'Ğ' IN s_zoxbed0189-zzkonu WITH 'G' .
        REPLACE ALL OCCURRENCES OF 'ğ' IN s_zoxbed0189-zzkonu WITH 'g' .
        REPLACE ALL OCCURRENCES OF 'Ö' IN s_zoxbed0189-zzkonu WITH 'O' .
        REPLACE ALL OCCURRENCES OF 'ö' IN s_zoxbed0189-zzkonu WITH 'o' .
        REPLACE ALL OCCURRENCES OF 'Ç' IN s_zoxbed0189-zzkonu WITH 'C' .
        REPLACE ALL OCCURRENCES OF 'ç' IN s_zoxbed0189-zzkonu WITH 'c' .

****************************************************************************************

 DATA: l_allow_char TYPE rsallowedchar-allowchar,
          l_length     TYPE i,
          l_act        TYPE i,
          l_postxt     TYPE /bi0/oipostxt,
          l_postxt_2   TYPE /bi0/oipostxt.

    CLEAR  l_allow_char.


    CALL FUNCTION 'RSKC_ALLOWED_CHAR_GET'
      IMPORTING
        e_allowed_char = l_allow_char.


    l_postxt = source_fields-zuonr.
    l_postxt_2 = l_postxt.

    TRANSLATE l_postxt_2 TO UPPER CASE.

    IF l_postxt_2 CO l_allow_char.

      CONDENSE l_postxt.

      result = l_postxt.
    ELSE.

      l_length = strlen( l_postxt ).

      l_act = 0.

      DO l_length TIMES.

        IF l_postxt_2+l_act(1) NA l_allow_char.

          l_postxt+l_act(1) = space.

        ENDIF.

        l_act = l_act + 1.

      ENDDO.

      CONDENSE l_postxt.

      result = l_postxt.
    ENDIF. 

****************************************************************************************
