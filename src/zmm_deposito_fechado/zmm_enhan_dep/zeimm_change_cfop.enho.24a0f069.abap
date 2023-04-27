"Name: \FU:J_1B_NF_CFOP_1_DETERMINATION\SE:BEGIN\EI
ENHANCEMENT 0 ZEIMM_CHANGE_CFOP.

  "Import de memória para atribuiçao de CFOP STANDARD
  "Export ZFMMM_LANC_FAT_RECEB
DATA lv_cfop_lanc TYPE c.
CLEAR lv_cfop_lanc.
IMPORT  lv_cfop to lv_cfop_lanc from MEMORY id 'LANC_FAT_CFOP'.
*FREE MEMORY ID 'LANC_FAT_CFOP'.

  FIELD-SYMBOLS: <fs_entrd_merc> TYPE char1.

 " Cockpit Locação/Comodato deve seguir com determinação STANDARD - GAP 158
 ASSIGN ('(SAPLZFGSD_ENTRADA_MERCADORIA)GV_COCKPIT') to <fs_entrd_merc>.

IF lv_cfop_lanc IS INITIAL .
IF <fs_entrd_merc> IS NOT ASSIGNED.
TRY.
    NEW zclmm_change_cfop( )->change_cfop( CHANGING cv_cfop = cfop  ).
    IF cfop IS NOT INITIAL.
      RETURN.
    ELSE.

      "!    Ajuste de determinação de CFOP de região de zona franca - GAP 524

      NEW zclmm_change_cfop( )->change_cfop_4(
      EXPORTING
            is_parameters = cfop_parameters
            iv_land1      = i_land1
            iv_region     = i_region
            iv_date       = i_date
          CHANGING
            cv_cfop = cfop   ).

      "Lógica para buscar o CFOP correto por Item

      DATA(lo_cfop) = zclmm_atualiza_cfop=>get_instance( ).
      DATA(lv_cfop) = lo_cfop->update_cfop( ).

     IF lv_cfop IS NOT INITIAL.
        cfop = lv_cfop.
     ENDIF.

      IF cfop IS NOT INITIAL.
        RETURN.
      ENDIF.

    ENDIF.
  CATCH cx_root.
ENDTRY.
ENDIF.
endif.
ENDENHANCEMENT.
