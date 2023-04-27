"Name: \FU:MB_CREATE_GOODS_MOVEMENT\SE:END\EI
ENHANCEMENT 0 ZMMEI0026.
CONSTANTS: lc_101 TYPE bwart VALUE '101'.

  " Tratativa para Insumos - Baixa para Ordem de Produção
  READ TABLE xmseg INTO ls_mseg WITH KEY BWART = lc_101.

  IF sy-subrc EQ 0 AND ls_mseg-smbln IS INITIAL AND emkpf-mblnr IS NOT INITIAL.

    TRY.
      DATA lt_mseg_zinsumo TYPE ty_t_mseg.
      lt_mseg_zinsumo = CORRESPONDING #( xmseg[] ).

      CALL FUNCTION 'ZMM_BAIXA_INSUMO_OP_BACKGRD'
        EXPORTING
          it_mseg       = lt_mseg_zinsumo[].

        CATCH cx_root INTO DATA(lo_root_zinsumo).
    ENDTRY.

  ENDIF.
ENDENHANCEMENT.
