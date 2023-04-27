CLASS zclmm_cl_si_get_message_pre_pe DEFINITION
  PUBLIC
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES zclmm_ii_si_get_message_pre_pe .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCLMM_CL_SI_GET_MESSAGE_PRE_PE IMPLEMENTATION.


  METHOD zclmm_ii_si_get_message_pre_pe~si_get_message_pre_pedido_in.

    TRY.

        NEW zclmm_pre_pedido( )->execute( input ).

      CATCH zcxmm_erro_interface_mes INTO DATA(lo_erro).

        DATA(ls_erro) = VALUE zclmm_exchange_fault_data1( fault_text = lo_erro->get_text( ) ).

        RAISE EXCEPTION TYPE zclmm_cx_fmt_pre_pedido
          EXPORTING
            standard = ls_erro.

    ENDTRY.

  ENDMETHOD.
ENDCLASS.
