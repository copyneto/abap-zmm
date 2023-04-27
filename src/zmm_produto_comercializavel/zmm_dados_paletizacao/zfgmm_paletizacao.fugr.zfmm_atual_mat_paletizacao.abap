FUNCTION ZFMM_ATUAL_MAT_PALETIZACAO .
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(IS_PALET) TYPE  ZTMM_PALETIZACAO OPTIONAL
*"  EXPORTING
*"     VALUE(ET_RETURN) TYPE  BAPIRET2_T
*"----------------------------------------------------------------------
  TRY .

      DATA(lo_palet) = NEW zclmm_atual_mat_paletizacao( ).

      lo_palet->atualiza_mat( EXPORTING is_palet  = is_palet
                             IMPORTING es_return = DATA(ls_return) ).

    CATCH cx_root INTO DATA(lo_catch). " Missing Input parameter in a method

      CALL FUNCTION 'RS_EXCEPTION_TO_BAPIRET2' "Convert Expection into Message
        EXPORTING
          i_r_exception = lo_catch             " cx_root       Abstract Superclass for All Global Exceptions
        CHANGING
          c_t_bapiret2  = et_return.           " bapirettab    BW: Table with Messages (Application Log)

  ENDTRY.

  APPEND ls_return TO et_return.


ENDFUNCTION.
