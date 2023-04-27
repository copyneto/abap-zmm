"Name: \FU:MB_CREATE_GOODS_MOVEMENT\SE:END\EI
ENHANCEMENT 0 ZMMEI0024.
CONSTANTS: lc_542 TYPE bwart VALUE '542',
           lc_942 TYPE bwart VALUE '942',
           lc_z42 TYPE bwart VALUE 'Z42',
           lc_y42 TYPE bwart VALUE 'Y42'.

* ZCLMM_DEP_FECHADO_GRC=>debug( ).
*Eliminar Remessa - Cockpit Subcontratação
 READ TABLE xmseg INTO DATA(ls_mseg) INDEX 1.
    IF sy-subrc EQ 0 AND emkpf-mblnr IS NOT INITIAL AND
       ls_mseg-smbln IS NOT INITIAL. "Estorno
      IF ( ls_mseg-vbeln_im IS NOT INITIAL AND
         ls_mseg-ebeln IS NOT INITIAL AND
*       ( ls_mseg-bwart EQ '542' OR
*         ls_mseg-bwart EQ '942' OR
*         ls_mseg-bwart EQ 'Z42' ) ) OR
       ( ls_mseg-bwart EQ lc_542 OR
        ls_mseg-bwart EQ lc_942 OR
        ls_mseg-bwart EQ lc_z42 ) ) OR
      ( ls_mseg-vbeln_im IS NOT INITIAL AND
*        ls_mseg-bwart EQ 'Y42' ).
        ls_mseg-bwart EQ lc_y42 ).

      CALL FUNCTION 'ZMM_DEL_REMESSA_BACKGRD' IN BACKGROUND TASK
      EXPORTING iv_vbeln  = ls_mseg-vbeln_im.

      ENDIF.
    ENDIF.
ENDENHANCEMENT.
