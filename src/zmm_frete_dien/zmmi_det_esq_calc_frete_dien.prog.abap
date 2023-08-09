*&---------------------------------------------------------------------*
*& Include ZMMI_DET_ESQ_CALC_FRETE_DIEN
*&---------------------------------------------------------------------*

"Variáveis
DATA: lv_bsart      TYPE ekko-bsart,
      lv_kalsk_from TYPE lfm1-kalsk,
      lv_kalsk_to   TYPE lfm1-kalsk.

"Constante
DATA: lv_modulo            TYPE ze_param_modulo       VALUE 'MM',
      lv_chave1            TYPE ztca_param_par-chave1 VALUE 'ESQUEMA_FRETE_DIEN',
      lv_chave2_bsart      TYPE ztca_param_par-chave2 VALUE 'BSART',
      lv_chave2_kalsk_from TYPE ztca_param_par-chave2 VALUE 'KALSK_FROM',
      lv_chave2_kalsk_to   TYPE ztca_param_par-chave2 VALUE 'KALSK_TO'.

DATA(lo_param) = zclca_tabela_parametros=>get_instance( ). " CHANGE - LSCHEPP - 24.07.2023

TRY.
    lo_param->m_get_single( EXPORTING iv_modulo = lv_modulo
                                      iv_chave1 = lv_chave1
                                      iv_chave2 = lv_chave2_bsart
                            IMPORTING ev_param  = lv_bsart ).
  CATCH zcxca_tabela_parametros.
    DATA(lv_erro) = abap_true.
ENDTRY.

TRY.
    lo_param->m_get_single( EXPORTING iv_modulo = lv_modulo
                                      iv_chave1 = lv_chave1
                                      iv_chave2 = lv_chave2_kalsk_from
                            IMPORTING ev_param  = lv_kalsk_from ).
  CATCH zcxca_tabela_parametros.
    lv_erro = abap_true.
ENDTRY.

TRY.
    lo_param->m_get_single( EXPORTING iv_modulo = lv_modulo
                                      iv_chave1 = lv_chave1
                                      iv_chave2 = lv_chave2_kalsk_to
                            IMPORTING ev_param  = lv_kalsk_to ).
  CATCH zcxca_tabela_parametros.
    lv_erro = abap_true.
ENDTRY.


"Determinando esquema de cálculo para Frete DIEN
IF lv_erro IS INITIAL AND pi_bsart = lv_bsart AND
   *lfm1-kalsk = lv_kalsk_from AND
   lv_kalsk_to IS NOT INITIAL.
  CALL FUNCTION 'ME_GET_PRICING_SCHEME'
    EXPORTING
      groupe = t024e-kalse
      groupk = lv_kalsk_to
    IMPORTING
      scheme = po_kalsm.
ENDIF.
