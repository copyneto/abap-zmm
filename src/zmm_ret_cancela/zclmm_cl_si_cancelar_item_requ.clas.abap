class ZCLMM_CL_SI_CANCELAR_ITEM_REQU definition
  public
  create public .

public section.

  interfaces ZCLMM_II_SI_CANCELAR_ITEM_REQU .
protected section.
private section.
ENDCLASS.



CLASS ZCLMM_CL_SI_CANCELAR_ITEM_REQU IMPLEMENTATION.


  METHOD zclmm_ii_si_cancelar_item_requ~si_cancelar_item_requisicao_in.

    TRY.

        NEW zclmm_ret_cancela( )->execute( input ).

      CATCH zcxmm_erro_interface_mes INTO DATA(lo_erro).

        DATA(ls_erro) = VALUE zclmm_exchange_fault_data1( fault_text = lo_erro->get_text( ) ).

        RAISE EXCEPTION TYPE zclmm_cx_fmt_cancelar_item_req
          EXPORTING
            standard = ls_erro.

    ENDTRY.

  ENDMETHOD.
ENDCLASS.
