class ZCLMM_ARGO_REPROVAR_SOLIC definition
  public
  final
  create public .

public section.

  methods EXECUTE
    importing
      !IV_NROSOLIC type EBAN-BEDNR
      !IV_MOTIVO type BAPI_MSG
    returning
      value(RV_RETURN) type STRING .
protected section.
private section.

  constants GC_REPROVAR type CHAR1 value 'R' ##NO_TEXT.

    "! Executa Chama proxy para reprovar solicitação
    "! @parameter IV_NROSOLIC |Número da Solicitação
    "! @parameter IV_MOTIVO   |Motivo
  methods CALL_PROXY
    importing
      !IV_NROSOLIC type EBAN-BEDNR
      !IV_MOTIVO type BAPI_MSG
    returning
      value(RV_RETURN) type STRING .
ENDCLASS.



CLASS ZCLMM_ARGO_REPROVAR_SOLIC IMPLEMENTATION.


  METHOD call_proxy.

    TRY.

        NEW zclmm_co_si_enviar_status_out( )->si_enviar_status_out(
          EXPORTING
            output = VALUE #( mt_status_processamento = VALUE #(  status                  = gc_reprovar
                                                                  nro_solic               = iv_nrosolic
                                                                  motivo                  = iv_motivo )
                                                            ) ).
          rv_return = text-001.
      CATCH cx_ai_system_fault INTO DATA(lo_message).
        rv_return = lo_message->if_message~get_text( ).
    ENDTRY.

  ENDMETHOD.


  METHOD execute.

    RV_RETURN = call_proxy( EXPORTING iv_nrosolic = iv_nrosolic
                                      iv_motivo   = iv_motivo ).

  ENDMETHOD.
ENDCLASS.
