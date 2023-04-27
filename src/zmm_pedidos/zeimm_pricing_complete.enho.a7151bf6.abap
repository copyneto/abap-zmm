"Name: \FU:PRICING_COMPLETE\SE:BEGIN\EI
ENHANCEMENT 0 ZEIMM_PRICING_COMPLETE.
*IF CALCULATION_TYPE EQ 'E'.
*  EXPORT ABAP_TRUE TO MEMORY ID 'ZMM_KONDERR'.
*  RETURN.
*ELSE.
*  FREE MEMORY ID 'ZMM_KONDERR'.
*ENDIF.

DATA gv_sub_prod TYPE abap_bool.

FIELD-SYMBOLS <fs_ex_vbapkom> TYPE vbapkom_t.

"Importa a variável da função ZFMSD_SUBSTITUIR_DESCONTO - método CALL_BAPI_SUBSTITUIR - classe ZCLSD_VERIF_UTIL_SUB
IMPORT gv_sub_prod TO gv_sub_prod FROM MEMORY ID 'ZSD_SUB_PROD'.

IF NOT gv_sub_prod IS INITIAL. "App Substituir Produto

  ASSIGN ('(SAPLVBAK)EX_VBAPKOM[]') TO <fs_ex_vbapkom>.
  IF <fs_ex_vbapkom> IS ASSIGNED.
    DATA(lt_vbapkom) = <fs_ex_vbapkom>.
    DELETE lt_vbapkom WHERE matnr IS INITIAL.
    LOOP AT tkomp ASSIGNING FIELD-SYMBOL(<fs_tkomp>).
      DATA(lv_tabix) = sy-tabix.
      READ TABLE lt_vbapkom TRANSPORTING NO FIELDS WITH KEY posnr = <fs_tkomp>-kposn.
      IF sy-subrc NE 0.
        DELETE tkomp[] INDEX lv_tabix.
      ENDIF.
    ENDLOOP.
  ENDIF.

ENDIF.

ENDENHANCEMENT.
