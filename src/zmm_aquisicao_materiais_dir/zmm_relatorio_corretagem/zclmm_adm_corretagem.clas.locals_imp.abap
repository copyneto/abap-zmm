CLASS lcl_corretagem DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_features FOR FEATURES
      IMPORTING keys REQUEST requested_features FOR corretagem RESULT result.

    METHODS modifyadmcorretagem FOR DETERMINE ON SAVE
      IMPORTING keys FOR corretagem~modifyadmcorretagem.

ENDCLASS.

CLASS lcl_corretagem IMPLEMENTATION.

  METHOD get_features.
    READ ENTITIES OF zi_mm_adm_corretagem IN LOCAL MODE
      ENTITY corretagem
      FIELDS ( statuscompensacao  )
      WITH CORRESPONDING #( keys )
      RESULT DATA(lt_adm_corre)
      FAILED DATA(ls_erros).

    READ TABLE lt_adm_corre INTO DATA(ls_adm_corre) INDEX 1.

    result = VALUE #( FOR ls_keys IN keys
             LET lv_tem_recebimento = ls_keys-documentocompra
             IN
             ( %key                          = ls_keys-%key
               %features-%update             = COND #( WHEN ls_adm_corre-statuscompensacao = 'X'
                                                       THEN if_abap_behv=>fc-o-disabled
                                                       ELSE if_abap_behv=>fc-o-enabled   )
              ) ).
  ENDMETHOD.

  METHOD modifyadmcorretagem.

    DATA: lv_status_ap TYPE char1.

    READ ENTITIES OF zi_mm_adm_corretagem IN LOCAL MODE
          ENTITY corretagem
          ALL FIELDS
          WITH CORRESPONDING #( keys )
          RESULT DATA(lt_adm_corre)
          FAILED DATA(lt_erro).

    READ TABLE lt_adm_corre ASSIGNING FIELD-SYMBOL(<fs_adm_corre>) INDEX 1.
    IF sy-subrc NE 0.
      RETURN.
    ENDIF.

*    IF <fs_adm_corre>-valordesconto IS INITIAL.
*      lv_status_ap = 'P'.
*    ELSE.
*      lv_status_ap = 'F'.
*    ENDIF.

    SELECT SINGLE ebeln,
                  docnum,
                  vlr_desconto,
                  vlr_corretagem,
                  vlr_embarcador,
                  obs_apuracao,
                  status_apuracao,
                  status_compensacao,
                  created_by,
                  created_at,
                  last_changed_by,
                  last_changed_at,
                  local_last_changed_at
       FROM ztmm_corretagem
       INTO @DATA(ls_tab_corre)
      WHERE ebeln  = @<fs_adm_corre>-documentocompra
        AND docnum = @<fs_adm_corre>-docnum.
    IF sy-subrc = 0.

      UPDATE ztmm_corretagem SET vlr_desconto    = @<fs_adm_corre>-valordesconto,
                                 obs_apuracao    = @<fs_adm_corre>-observacao,
                                 status_apuracao = @<fs_adm_corre>-statusapuracao
*                                 status_apuracao = @lv_status_ap
      WHERE ebeln  = @<fs_adm_corre>-documentocompra
        AND docnum = @<fs_adm_corre>-docnum.

    ELSE.
      DATA(ls_ins_corre) = VALUE ztmm_corretagem( mandt              = sy-mandt
                                                  ebeln              = <fs_adm_corre>-documentocompra
                                                  docnum             = <fs_adm_corre>-docnum
                                                  vlr_desconto       = <fs_adm_corre>-valordesconto
                                                  vlr_corretagem     = <fs_adm_corre>-valordevcorretagem
                                                  vlr_embarcador     = <fs_adm_corre>-valorembarcador
                                                  obs_apuracao       = <fs_adm_corre>-observacao
*                                                  status_apuracao    = lv_status_ap
                                                  status_apuracao    = <fs_adm_corre>-statusapuracao
                                                  status_compensacao = <fs_adm_corre>-statuscompensacao  ).

      INSERT ztmm_corretagem FROM ls_ins_corre.

    ENDIF.

*    MODIFY ENTITIES OF zi_mm_adm_corretagem IN LOCAL MODE
*        ENTITY corretagem
*        UPDATE FIELDS ( statusapuracao )
*          WITH VALUE #( FOR ls_dados IN lt_adm_corre WHERE ( statusapuracao NE lv_status_ap ) (
*                            %key = <fs_adm_corre>-%key
*                            statusapuracao = lv_status_ap
*                           ) ).
*
*   MODIFY ENTITIES OF zi_mm_adm_corretagem IN LOCAL MODE
*      ENTITY corretagem
*      UPDATE FIELDS ( valordesconto valordevcorretagem observacao statusapuracao statuscompensacao )
*      WITH VALUE #( FOR ls_adm_corre IN lt_adm_corre (
*        %key               = ls_adm_corre-%key
*        valordesconto      = ls_adm_corre-valordesconto
*        valordevcorretagem = ls_adm_corre-valordevcorretagem
*        observacao         = ls_adm_corre-observacao
*        statusapuracao     = ls_adm_corre-statusapuracao
*        statuscompensacao  = ls_adm_corre-statuscompensacao ) )
*    REPORTED DATA(lt_reported).

  ENDMETHOD.

ENDCLASS.
