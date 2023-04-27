*&---------------------------------------------------------------------*
*& Include          ZXMBCU10
*&---------------------------------------------------------------------*

* ---------------------------------------------------------------------------
* Gestão de subcontratação - determina lote
* ---------------------------------------------------------------------------
TRY.

    DATA(lo_subcontratacao) = zclmm_gestao_subcontratacao=>get_instance( ).

    lo_subcontratacao->determine_batch( EXPORTING is_mseg     = i_mseg
                                                  is_vm07m    = i_vm07m
                                                  is_dm07m    = i_dm07m
                                                  is_mkpf     = i_mkpf
                                                  iv_transfer = i_transfer
                                        IMPORTING et_return   = DATA(lt_return)
                                        CHANGING  cv_charg    = e_charg ).
  CATCH cx_root INTO DATA(lo_root).
ENDTRY.
