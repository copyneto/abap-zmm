class ZCLMM_CL_SI_REGISTRAR_ID_SOLIC definition
  public
  create public .

public section.

  interfaces ZCLMM_II_SI_REGISTRAR_ID_SOLIC .
protected section.
private section.
ENDCLASS.



CLASS ZCLMM_CL_SI_REGISTRAR_ID_SOLIC IMPLEMENTATION.


  METHOD zclmm_ii_si_registrar_id_solic~si_registrar_id_solicitacao_in.

    TRY.

        DATA(lo_id) = NEW zclmm_rec_solicitacao( ).

        lo_id->execute_lista_in( input-mt_id_solicitacao-lista ).

      CATCH zcxmm_erro_interface_mes INTO DATA(lo_erro).

        DATA(ls_erro) = VALUE zsmm_exchange_fault_data1( fault_text = lo_erro->get_text( ) ).

        RAISE EXCEPTION TYPE zclmm_cx_fmt_requisicao_compra
          EXPORTING
            standard = ls_erro.

    ENDTRY.

  ENDMETHOD.
ENDCLASS.
