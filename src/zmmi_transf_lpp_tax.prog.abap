*&---------------------------------------------------------------------*
*& Include ZMMI_TRANSF_LPP_TAX
*&---------------------------------------------------------------------*
" Necessário dar um CONTINUE para verificar outro ICMS
    IF lv_lppflag IS INITIAL
   AND lv_ipiflag IS INITIAL.
      CONTINUE.
    ENDIF.
