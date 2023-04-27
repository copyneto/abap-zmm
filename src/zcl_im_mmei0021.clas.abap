class ZCL_IM_MMEI0021 definition
  public
  final
  create public .

public section.

  interfaces IF_EX_CFOP_DET_PREP .
protected section.
private section.
ENDCLASS.



CLASS ZCL_IM_MMEI0021 IMPLEMENTATION.


  METHOD if_ex_cfop_det_prep~change_parameters_sd.
* Determinação CFOP para Cockpit de Subcontratação
    IF is_likp-lfart EQ 'LB' AND "Remessa para Subcontratação
       is_likp-berot   = 'SUBCONTR.'. "Processo do Cockpit
      IF is_lips-bwart EQ '941' OR is_lips-bwart EQ '541' OR "Subcontratação
         is_lips-bwart EQ 'Y41' OR "Armazenagem
         is_lips-bwart EQ 'Y51'. "Grão Verde
        SELECT SINGLE j_1bitmtyp INTO cs_cfop_determination-itmtyp
        FROM t156 WHERE bwart = is_lips-bwart.

        CLEAR: cs_cfop_determination-spcsto,
               cs_cfop_determination-indus3.
      ENDIF.
    ENDIF.
  ENDMETHOD.


  method IF_EX_CFOP_DET_PREP~CHECK_PARAMETERS_SA.
  endmethod.


  method IF_EX_CFOP_DET_PREP~CHECK_PARAMETERS_SH.
  endmethod.
ENDCLASS.
