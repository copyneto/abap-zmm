class ZCL_IM_MMEI0022 definition
  public
  final
  create public .

public section.

  interfaces IF_EX_BOM_UPDATE .
protected section.
private section.
ENDCLASS.



CLASS ZCL_IM_MMEI0022 IMPLEMENTATION.


  METHOD if_ex_bom_update~change_at_save.

** Controle para alteração de lista técnica de subcontratação
*   data(lt_delta_stasb) = delta_stasb.
*   sort lt_delta_stasb by stlnr stvkn.
*
*   data(lt_delta_stkob) = delta_stkob.
*   SORT lt_delta_stkob by stlnr selkz.
*
*    LOOP AT delta_stpob INTO DATA(ls_stopb).
*      CHECK ls_stopb-postp = 'L' AND ls_stopb-vbkz IS NOT INITIAL.
*      READ TABLE lt_delta_stasb INTO DATA(ls_stasb) WITH KEY stlnr = ls_stopb-stlnr
*                                                          stvkn = ls_stopb-stvkn BINARY SEARCH.
*      IF sy-subrc EQ 0.
*        READ TABLE lt_delta_stkob INTO DATA(ls_stokb) WITH KEY stlnr = ls_stopb-stlnr
*                                                            selkz = 'X' BINARY SEARCH.
*        IF sy-subrc EQ 0.
*          IF ls_stopb-vbkz EQ 'D' or "Deleção
*             ls_stopb-vbkz EQ 'U'.   "Alteração
*
*            SELECT count(*)
*            FROM resb WHERE bdart = 'BB' AND
*                            werks = @ls_stokb-wrkan AND
*                            stlnr = @ls_stopb-stlnr AND
*                            stlal  = @ls_stasb-stlal AND
*                            xloek = @space AND
*                            kzear = @space AND
*                            postp = 'L' AND
*                            bdter >= @ls_stopb-andat AND
*                            bdter <= @ls_stopb-valid_to
*              INTO @DATA(ls_coun).
*
*            IF ls_coun > 0.
*              MESSAGE e003(zmm).
*            ENDIF.
*          ENDIF.
*        ENDIF.
*      ELSE.
*        IF ls_stopb-vbkz EQ 'I'." Iserção
*          READ TABLE delta_stkob INTO ls_stokb WITH KEY stlnr = ls_stopb-stlnr
*                                                        selkz = 'X' BINARY SEARCH.
*          IF sy-subrc EQ 0.
*            SELECT count(*)
*            INTO ls_coun
*            FROM resb WHERE bdart = 'BB' AND
*                            werks = ls_stokb-wrkan AND
*                            stlnr = ls_stokb-stlnr AND
*                            stlal  = ls_stokb-stlal AND
*                            xloek = space AND
*                            kzear = space AND
*                            postp = 'L' AND
*                            bdter >= ls_stokb-andat AND
*                            bdter <= ls_stokb-valid_to.
*
*            IF ls_coun > 0.
*              MESSAGE e003(zmm).
*            ENDIF.
*          ENDIF.
*        ENDIF.
*      ENDIF.
*    ENDLOOP.
  ENDMETHOD.


  method IF_EX_BOM_UPDATE~CHANGE_BEFORE_UPDATE.
  endmethod.


  method IF_EX_BOM_UPDATE~CHANGE_IN_UPDATE.
  endmethod.


  method IF_EX_BOM_UPDATE~CREATE_TREX_CPOINTER.
  endmethod.
ENDCLASS.
