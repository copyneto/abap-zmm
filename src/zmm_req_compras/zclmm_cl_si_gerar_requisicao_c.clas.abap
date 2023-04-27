class ZCLMM_CL_SI_GERAR_REQUISICAO_C definition
  public
  create public .

public section.

  interfaces ZCLMM_II_SI_GERAR_REQUISICAO_C .
protected section.
private section.
ENDCLASS.



CLASS ZCLMM_CL_SI_GERAR_REQUISICAO_C IMPLEMENTATION.


  METHOD zclmm_ii_si_gerar_requisicao_c~si_gerar_requisicao_compra_in.

    TRY.

        DATA(lo_req_compra) = NEW zclmm_rec_solicitacao( ).

        lo_req_compra->execute( input ).

      CATCH zcxmm_erro_interface_mes INTO DATA(lo_erro).

        DATA(ls_erro) = VALUE zsmm_exchange_fault_data1( fault_text = lo_erro->get_text( ) ).

        RAISE EXCEPTION TYPE zclmm_cx_fmt_requisicao_compra
          EXPORTING
            standard = ls_erro.

    ENDTRY.

  ENDMETHOD.
ENDCLASS.
