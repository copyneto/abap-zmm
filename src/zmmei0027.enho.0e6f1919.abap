"Name: \FU:MB_CREATE_GOODS_MOVEMENT\SE:END\EI
ENHANCEMENT 0 ZMMEI0027.

  " Perdas de Subcontratação - Tratativa estoque livre para bloqueado
  READ TABLE xmseg INTO ls_mseg WITH KEY BWART = lc_542.

  IF sy-subrc EQ 0 AND ls_mseg-smbln IS INITIAL AND emkpf-mblnr IS NOT INITIAL.

    TRY.
      DATA lt_mseg_zbloq TYPE ty_t_mseg.
      lt_mseg_zbloq = CORRESPONDING #( xmseg[] ).

      CALL FUNCTION 'ZMM_LIVRE_BLOQ_BACKGRD'
        EXPORTING
          it_mseg       = lt_mseg_zbloq[].

        CATCH cx_root INTO DATA(lo_root_zbloq).
    ENDTRY.

  ENDIF.
ENDENHANCEMENT.
