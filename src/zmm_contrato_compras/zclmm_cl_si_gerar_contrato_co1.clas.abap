class ZCLMM_CL_SI_GERAR_CONTRATO_CO1 definition
  public
  create public .

public section.

  interfaces ZCLMM_II_SI_GERAR_CONTRATO_COM .
protected section.
private section.
ENDCLASS.



CLASS ZCLMM_CL_SI_GERAR_CONTRATO_CO1 IMPLEMENTATION.


  METHOD zclmm_ii_si_gerar_contrato_com~si_gerar_contrato_compra_in.

    TRY.

        NEW zclmm_contrato_comp( )->execute( input ).

      CATCH zcxmm_erro_interface_mes INTO DATA(lo_erro).

        DATA(ls_erro) = VALUE zclmm_exchange_fault_data2( fault_text = lo_erro->get_text( ) ).

        RAISE EXCEPTION TYPE zclmm_cx_fmt_contrato_compras
          EXPORTING
            standard = ls_erro.

    ENDTRY.

  ENDMETHOD.
ENDCLASS.
