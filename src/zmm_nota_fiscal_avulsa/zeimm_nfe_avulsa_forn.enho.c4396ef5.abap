"Name: \FU:J_1B_NFE_FILL_MONITOR_TABLE\SE:END\EI
ENHANCEMENT 0 ZEIMM_NFE_AVULSA_FORN.
*
  CONSTANTS: lc_i   TYPE char1 VALUE 'I',
             lc_BT  TYPE char2 VALUE 'BT',
             lC_890 TYPE j_1bnfe_active-serie VALUE '890',
             lC_899 TYPE j_1bnfe_active-serie VALUE '899'.

  DATA: lr_serie TYPE RANGE OF j_1bnfe_active-serie.

  lr_serie = VALUE #( ( sign = lC_i
                      option = lc_BT
                      low = lc_890
                      high = lc_899 ) ).

  IF e_active-serie IN lr_serie.

    SELECT SINGLE lifnr, stcd1
        FROM ztmm_nf_avulsa
        INTO @DATA(ls_cnpj)
        WHERE lifnr = @i_doc-parid.
    IF sy-subrc = 0.
      MOVE ls_cnpj-stcd1(14) TO e_active-stcd1.
      MOVE ls_cnpj-stcd1(14) TO e_acckey-stcd1.
      MOVE ls_cnpj-stcd1(14) TO ls_acckey-stcd1.

      "O cálculo do dígito tivemos que refazer aqui, pois estava considerando CPF na função
      if not e_active-docnum9+1(8) is initial.                  "1150733
        CALL FUNCTION 'J_1B_NFE_CREATE_CHECK_DIGIT'
          CHANGING
            c_acckey = ls_acckey.

            e_active-cdv = ls_acckey-cdv.
            e_acckey     = ls_acckey.
      endif.                                                    "1150733

    ENDIF.
  ENDIF.

ENDENHANCEMENT.
