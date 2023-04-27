"Name: \FU:J_1BNFE_INB_DELIV_PREPARE_SC\SE:END\EI
ENHANCEMENT 0 ZEIMM_SUBCONTRAT_LOTE.
      DATA(lt_lecomp) = et_lecomp[].

      DATA(lo_lote) = zclmm_atualiza_cfop=>get_instance( ).
      lo_lote->update_charg( EXPORTING iv_vgbel     = ls_component_info-ebeln
                             CHANGING  ct_component = lt_lecomp  ).

      IF lt_lecomp[] is NOT INITIAL.

        FREE et_lecomp.
        et_lecomp[] = lt_lecomp[].

      ENDIF.
ENDENHANCEMENT.
