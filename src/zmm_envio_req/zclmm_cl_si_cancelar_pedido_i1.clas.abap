CLASS zclmm_cl_si_cancelar_pedido_i1 DEFINITION
  PUBLIC
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES zclmm_ii_si_cancelar_pedido_in .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCLMM_CL_SI_CANCELAR_PEDIDO_I1 IMPLEMENTATION.


  METHOD zclmm_ii_si_cancelar_pedido_in~si_cancelar_pedido_in.

    TRY.

        NEW zclmm_pre_pedido( )->execute_delete( input ).

      CATCH zcxmm_erro_interface_mes INTO DATA(lo_erro).

        DATA(ls_erro) = VALUE zclmm_exchange_fault_data1( fault_text = lo_erro->get_text( ) ).

        RAISE EXCEPTION TYPE zclmm_cx_fmt_cancelar_pedido
          EXPORTING
            standard = ls_erro.

    ENDTRY.

  ENDMETHOD.
ENDCLASS.
