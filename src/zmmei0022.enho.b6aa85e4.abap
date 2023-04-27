"Name: \PR:SAPLV50S\FO:VBPOK_CHECK_OBLIGATORY_FIELDS\SE:BEGIN\EI
ENHANCEMENT 0 ZMMEI0022.
*Tratativa para remessa sem referência (Armazenagem) - Cockpit Subcontratação
 IF TVLK-AUFER EQ 'L' AND "Subcontratação
    NOT pickingupdate   IS INITIAL AND
        vbpok_tab-vbeln IS INITIAL.
   CLEAR cf_subrc.
   EXIT.
 ENDIF.
ENDENHANCEMENT.
