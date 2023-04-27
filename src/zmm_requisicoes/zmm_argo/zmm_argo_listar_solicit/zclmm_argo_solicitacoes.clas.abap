class ZCLMM_ARGO_SOLICITACOES definition
  public
  final
  create public .

public section.

  methods LISTAR_SOLICITACAO
    importing
      !IV_CRIAR type BOOLEAN
    exceptions
      PARAM_NOT_FOUND
      ERROR_CONNECTION .
protected section.

  constants GC_PARM_MOD type ZTCA_PARAM_VAL-MODULO value 'MM' ##NO_TEXT.
  constants GC_CHAVE1 type ZTCA_PARAM_VAL-CHAVE1 value 'ARGO' ##NO_TEXT.
  constants GC_CHAVE2 type ZTCA_PARAM_VAL-CHAVE2 value 'STATUSDESPESA' ##NO_TEXT.
  constants GC_CHAVE3 type ZTCA_PARAM_VAL-CHAVE3 value 'STATUS' ##NO_TEXT.
  constants GC_SIGN type ZTCA_PARAM_VAL-SIGN value 'I' ##NO_TEXT.
  constants GC_OPTION type ZTCA_PARAM_VAL-OPT value 'EQ' ##NO_TEXT.
  constants GC_CHAVE_VIAG type ZTCA_PARAM_VAL-CHAVE2 value 'STATUSVIAGEM' ##NO_TEXT.
  constants GC_TIP_DAT type STRING value 'dtAlteracao' ##NO_TEXT.
  constants GC_HORA_INI type STRING value ' 00:00:00' ##NO_TEXT.
  constants GC_HORA_FIM type STRING value ' 23:59:59' ##NO_TEXT.
private section.

  methods GET_STATUS_DESPESA
    exporting
      !EV_STATUS type ZE_STATUSDESPESA
    exceptions
      NOT_FOUND .
  methods GET_STATUS_VIAGEM
    exporting
      !EV_STATUS type ZE_STATUSVIAGEM
    exceptions
      NOT_FOUND .
ENDCLASS.



CLASS ZCLMM_ARGO_SOLICITACOES IMPLEMENTATION.


  METHOD get_status_despesa.

    SELECT SINGLE low
      FROM ztca_param_val
     WHERE modulo = @gc_parm_mod
       AND chave1 = @gc_chave1
       AND chave2 = @gc_chave2
       AND chave3 = @gc_chave3
       AND sign   = @gc_sign
       AND opt    = @gc_option
      INTO @DATA(lv_low).

    IF sy-subrc IS INITIAL.
      IF lv_low IS NOT INITIAL.
        ev_status = lv_low.
      ELSE.
        RAISE not_found.
      ENDIF.
    ELSE.
      RAISE not_found.
    ENDIF.

  ENDMETHOD.


  METHOD get_status_viagem.

    SELECT SINGLE low
      FROM ztca_param_val
     WHERE modulo = @gc_parm_mod
       AND chave1 = @gc_chave1
       AND chave2 = @gc_chave_viag
       AND chave3 = @gc_chave3
       AND sign   = @gc_sign
       AND opt    = @gc_option
      INTO @DATA(lv_low).

    IF sy-subrc IS INITIAL.
      IF lv_low IS NOT INITIAL.
        ev_status = lv_low.
      ELSE.
        RAISE not_found.
      ENDIF.
    ELSE.
      RAISE not_found.
    ENDIF.

  ENDMETHOD.


  METHOD listar_solicitacao.

    DATA: lt_solicitacoes TYPE zctgmm_list_solic_argo.

    DATA: ls_status_viag TYPE zmt_status_viagem.

    DATA: lv_status_viag TYPE ze_statusdespesa,
          lv_dia_ant     TYPE sy-datum.

    get_status_viagem( IMPORTING  ev_status = lv_status_viag
                       EXCEPTIONS not_found = 1
                                  OTHERS    = 2 ).

    IF lv_status_viag IS NOT INITIAL.

      TRY.

          DATA(lo_proxy) = NEW zclmm_co_si_buscar_id_solicita( ).

*          lv_dia_ant = sy-datum - 1.

          ls_status_viag-mt_status_viagem-tipo_data = gc_tip_dat.
*          ls_status_viag-mt_status_viagem-data_ini  = lv_dia_ant(4) && abap_undefined && lv_dia_ant+4(2) && abap_undefined && lv_dia_ant+6(2) && gc_hora_ini.
          ls_status_viag-mt_status_viagem-data_ini  = sy-datum(4) && abap_undefined && sy-datum+4(2) && abap_undefined && sy-datum+6(2) && gc_hora_ini.
          ls_status_viag-mt_status_viagem-data_fin  = sy-datum(4) && abap_undefined && sy-datum+4(2) && abap_undefined && sy-datum+6(2) && gc_hora_fim.

          IF iv_criar IS NOT INITIAL.
            ls_status_viag-mt_status_viagem-status_viagem = lv_status_viag.
          ENDIF.

          lo_proxy->si_buscar_id_solicitacao_out( output = ls_status_viag ).

          COMMIT WORK.

        CATCH cx_ai_system_fault.
          RAISE error_connection.
      ENDTRY.

    ELSE.
      RAISE param_not_found.
    ENDIF.

  ENDMETHOD.
ENDCLASS.
