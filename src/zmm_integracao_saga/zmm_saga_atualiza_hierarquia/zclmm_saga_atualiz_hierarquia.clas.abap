class ZCLMM_SAGA_ATUALIZ_HIERARQUIA definition
  public
  final
  create public .

public section.

  methods PROCESS
    importing
      !IV_MATNR type MATNR .
protected section.
private section.
ENDCLASS.



CLASS ZCLMM_SAGA_ATUALIZ_HIERARQUIA IMPLEMENTATION.


  METHOD process.

    DATA: lr_mtart TYPE RANGE OF mtart.

    DATA: lv_prdha      TYPE mara-prdha,
          lv_desc_compl TYPE string,
          lv_nivel_prod TYPE t179-stufe,
          lv_char40     TYPE char40.

    DATA: ls_output TYPE zclmm_mt_envia_grupo_mercadori.

    CHECK iv_matnr IS NOT INITIAL.

    SELECT SINGLE matnr,
                  mtart,
                  prdha
      FROM mara
     WHERE matnr = @iv_matnr
      INTO @DATA(ls_mara).

    IF sy-subrc IS INITIAL.

      DATA(lo_params) = zclca_tabela_parametros=>get_instance( ).    " CHANGE - JWSILVA - 21.07.2023

      TRY.
          lo_params->m_get_range( EXPORTING iv_modulo = 'MM'
                                            iv_chave1 = 'SAGA'
                                            iv_chave2 = 'MESTRE_MAT'
                                            iv_chave3 = 'MTART'
                                  IMPORTING et_range  = lr_mtart ).
        CATCH zcxca_tabela_parametros.
          " Erro no parâmetro
      ENDTRY.

      " Filtro dos tipos de materiais do SAGA
*      IF lr_mtart IS NOT INITIAL
*     AND ls_mara-mtart IN lr_mtart.
*
*        SELECT SINGLE vtext
*          FROM t179t
*         WHERE spras = @sy-langu
*           AND prodh = @ls_mara-prdha
*          INTO @DATA(lv_vtext_1).
*
*        SELECT SINGLE stufe
*          FROM t179
*         WHERE prodh = @ls_mara-prdha
*          INTO @DATA(lv_nivel).
*
*        IF sy-subrc IS INITIAL.
*
*          DATA(lv_nivel_ult) = lv_nivel.
*
*          lv_prdha = ls_mara-prdha.
*          lv_nivel = lv_nivel - 1.
*
*          IF lv_nivel EQ 2.
*            lv_prdha = lv_prdha(10).
*
*            SELECT SINGLE vtext
*              FROM t179t
*             WHERE spras = @sy-langu
*               AND prodh = @lv_prdha
*              INTO @DATA(lv_vtext_2).
*
*            IF sy-subrc IS INITIAL.
*              DATA(lv_prdha_ant) = lv_prdha.
*            ENDIF.
*
*            lv_nivel = lv_nivel - 1.
*
*          ENDIF.
*
*          IF lv_nivel EQ 1.
*            lv_prdha = lv_prdha(5).
*
*            SELECT SINGLE vtext
*              FROM t179t
*             WHERE spras = @sy-langu
*               AND prodh = @lv_prdha
*              INTO @DATA(lv_vtext_3).
*
*            IF sy-subrc IS INITIAL.
*              IF lv_prdha_ant IS INITIAL.
*                lv_prdha_ant = lv_prdha.
*              ENDIF.
*            ENDIF.
*          ENDIF.
*
*          IF lv_nivel EQ 0.
*            lv_prdha_ant = ls_mara-prdha.
*          ENDIF.
*
*          CASE lv_nivel_ult.
*            WHEN '3'.
*              TRY.
*
*                  DATA(lo_object) = NEW zclmm_co_si_grupo_mercadoria_o( ).
*
*                  " Envio do nível 1
*                  ls_output-mt_envia_grupo_mercadoria-z_prdha = ls_mara-prdha(5).
*                  ls_output-mt_envia_grupo_mercadoria-vtext_1 = lv_vtext_3.
*                  ls_output-mt_envia_grupo_mercadoria-vtext_2 = lv_vtext_3(40).
*
*                  lo_object->si_grupo_mercadoria_out( output = ls_output ).
*
*                  COMMIT WORK AND WAIT.
*                  WAIT UP TO 3 SECONDS.
*
*                  " Envio do nível 1 e 2
*                  ls_output-mt_envia_grupo_mercadoria-z_prdha = ls_mara-prdha(10).
*                  ls_output-mt_envia_grupo_mercadoria-vtext_1 = |{ lv_vtext_3 } { lv_vtext_2 }|.
*
*                  lv_char40 = |{ lv_vtext_3 } { lv_vtext_2 }|.
*                  ls_output-mt_envia_grupo_mercadoria-vtext_2 = lv_char40.
*                  ls_output-mt_envia_grupo_mercadoria-prodh   = ls_mara-prdha(5).
*
*                  lo_object->si_grupo_mercadoria_out( output = ls_output ).
*
*                  COMMIT WORK AND WAIT.
*                  WAIT UP TO 3 SECONDS.
*
*                  " Envio do nível 2 e 3
*                  ls_output-mt_envia_grupo_mercadoria-z_prdha = ls_mara-prdha.
*                  ls_output-mt_envia_grupo_mercadoria-vtext_1 = |{ lv_vtext_3 } { lv_vtext_2 } { lv_vtext_1 }|.
*
*                  lv_char40 = |{ lv_vtext_3 } { lv_vtext_2 } { lv_vtext_1 }|.
*                  ls_output-mt_envia_grupo_mercadoria-vtext_2 = lv_char40.
*                  ls_output-mt_envia_grupo_mercadoria-prodh   = ls_mara-prdha(10).
*
*                  lo_object->si_grupo_mercadoria_out( output = ls_output ).
*
*                  COMMIT WORK AND WAIT.
*                  WAIT UP TO 3 SECONDS.
*
*                CATCH cx_ai_system_fault. " Application Integration: Technical Error.
*              ENDTRY.
*
*            WHEN '2'.
*              TRY.
*
*                  " Envio do nível 1
*                  lo_object = NEW zclmm_co_si_grupo_mercadoria_o( ).
*
*                  ls_output-mt_envia_grupo_mercadoria-z_prdha = ls_mara-prdha(5).
*                  ls_output-mt_envia_grupo_mercadoria-vtext_1 = lv_vtext_3.
*                  ls_output-mt_envia_grupo_mercadoria-vtext_2 = lv_vtext_3(40).
*
*                  lo_object->si_grupo_mercadoria_out( output = ls_output ).
*
*                  COMMIT WORK AND WAIT.
*                  WAIT UP TO 3 SECONDS.
*
*                  " Envio do nível 1 e 2
*                  lo_object = NEW zclmm_co_si_grupo_mercadoria_o( ).
*
*                  ls_output-mt_envia_grupo_mercadoria-z_prdha = ls_mara-prdha(10).
*                  ls_output-mt_envia_grupo_mercadoria-vtext_1 = |{ lv_vtext_3 } { lv_vtext_1 }|.
*                  lv_char40 = |{ lv_vtext_3 } { lv_vtext_1 }|.
*                  ls_output-mt_envia_grupo_mercadoria-vtext_2 = lv_char40.
*                  ls_output-mt_envia_grupo_mercadoria-prodh   = ls_mara-prdha(5).
*
*                  lo_object->si_grupo_mercadoria_out( output = ls_output ).
*
*                  COMMIT WORK AND WAIT.
*                  WAIT UP TO 3 SECONDS.
*
*                CATCH cx_ai_system_fault. " Application Integration: Technical Error.
*              ENDTRY.
*
*            WHEN '1'.
*              TRY.
*
*                  " Envio do nível 1
*                  lo_object = NEW zclmm_co_si_grupo_mercadoria_o( ).
*
*                  ls_output-mt_envia_grupo_mercadoria-z_prdha = ls_mara-prdha.
*                  ls_output-mt_envia_grupo_mercadoria-vtext_1 = lv_vtext_1.
*                  ls_output-mt_envia_grupo_mercadoria-vtext_2 = lv_vtext_1(40).
*
*                  lo_object->si_grupo_mercadoria_out( output = ls_output ).
*
*                  COMMIT WORK AND WAIT.
*                  WAIT UP TO 3 SECONDS.
*
*                CATCH cx_ai_system_fault. " Application Integration: Technical Error.
*              ENDTRY.
*
*            WHEN OTHERS.
*          ENDCASE.
*
*        ENDIF.
*      ENDIF.
    ENDIF.

  ENDMETHOD.
ENDCLASS.
