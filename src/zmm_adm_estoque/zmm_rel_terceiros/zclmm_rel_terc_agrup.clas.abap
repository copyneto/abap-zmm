CLASS zclmm_rel_terc_agrup DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_sadl_exit .
    INTERFACES if_sadl_exit_calc_element_read .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCLMM_REL_TERC_AGRUP IMPLEMENTATION.


  METHOD if_sadl_exit_calc_element_read~calculate.

    DATA: lt_original_data TYPE STANDARD TABLE OF zi_mm_rel_terc_agrup WITH DEFAULT KEY.

    lt_original_data = CORRESPONDING #( it_original_data ).

    DATA(lt_original_data_aux) = lt_original_data[].
    SORT lt_original_data_aux BY docnumremessa nfitemrm.
    DELETE ADJACENT DUPLICATES FROM lt_original_data_aux COMPARING docnumremessa nfitemrm.

    DATA(lt_original_data_aux2) = lt_original_data[].
    SORT lt_original_data_aux2 BY docnumretorno nfitem.
    DELETE ADJACENT DUPLICATES FROM lt_original_data_aux2 COMPARING docnumretorno nfitem.
    DELETE lt_original_data_aux2 WHERE docnumretorno IS INITIAL.

    IF  lt_original_data_aux[] IS NOT INITIAL.

      SELECT br_notafiscal, br_notafiscalitem, br_nfitembaseamount, br_nfitemotherbaseamount ,br_nfitemexcludedbaseamount
      FROM i_br_nftax
      INTO TABLE @DATA(lt_taxrm)
      FOR ALL ENTRIES IN @lt_original_data_aux
      WHERE br_notafiscal = @lt_original_data_aux-docnumremessa
          AND   br_notafiscalitem = @lt_original_data_aux-nfitemrm
          AND taxgroup = 'ICMS'.
      IF sy-subrc IS INITIAL.

        SORT lt_taxrm BY br_notafiscal br_notafiscalitem.

      ENDIF.

    ENDIF.
    IF  lt_original_data_aux2[] IS NOT INITIAL.

      SELECT br_notafiscal, br_notafiscalitem, br_nfitembaseamount, br_nfitemotherbaseamount ,br_nfitemexcludedbaseamount
      FROM i_br_nftax
      INTO TABLE @DATA(lt_taxrt)
      FOR ALL ENTRIES IN @lt_original_data_aux2
      WHERE br_notafiscal = @lt_original_data_aux2-docnumretorno
          AND   br_notafiscalitem = @lt_original_data_aux2-nfitem
          AND taxgroup = 'ICMS'.
      IF sy-subrc IS INITIAL.

        SORT lt_taxrt BY br_notafiscal br_notafiscalitem.

      ENDIF.

    ENDIF.
    LOOP AT lt_original_data ASSIGNING FIELD-SYMBOL(<fs_data>).

      READ TABLE lt_taxrm INTO DATA(ls_taxrm) WITH KEY br_notafiscal = <fs_data>-docnumremessa
      br_notafiscalitem = <fs_data>-nfitemrm
      BINARY SEARCH.

      IF sy-subrc IS INITIAL.

        <fs_data>-montbasicretornorm = ls_taxrm-br_nfitembaseamount.

*        IF ls_taxrm-br_nfitembaseamount IS NOT INITIAL.
*          <fs_data>-montbasicretornorm = ls_taxrm-br_nfitembaseamount.
*        ELSEIF ls_taxrm-br_nfitemotherbaseamount IS NOT INITIAL.
*          <fs_data>-montbasicretornorm = ls_taxrm-br_nfitemotherbaseamount.
*        ELSEIF ls_taxrm-br_nfitemexcludedbaseamount IS NOT INITIAL.
*          <fs_data>-montbasicretornorm = ls_taxrm-br_nfitemexcludedbaseamount.
*        ENDIF.

      ENDIF.

      READ TABLE lt_taxrt INTO DATA(ls_taxrt) WITH KEY br_notafiscal = <fs_data>-docnumretorno
      br_notafiscalitem = <fs_data>-nfitem
      BINARY SEARCH.

      IF sy-subrc IS INITIAL.

        <fs_data>-montbasicretornort = ls_taxrt-br_nfitembaseamount.

*        IF ls_taxrt-br_nfitembaseamount IS NOT INITIAL.
*          <fs_data>-montbasicretornort = ls_taxrt-br_nfitembaseamount.
*        ELSEIF ls_taxrt-br_nfitemotherbaseamount IS NOT INITIAL.
*          <fs_data>-montbasicretornort = ls_taxrt-br_nfitemotherbaseamount.
*        ELSEIF ls_taxrt-br_nfitemexcludedbaseamount IS NOT INITIAL.
*          <fs_data>-montbasicretornort = ls_taxrt-br_nfitemexcludedbaseamount.
*        ENDIF.

      ENDIF.

    ENDLOOP.

    ct_calculated_data = CORRESPONDING #(  lt_original_data ).

  ENDMETHOD.


  METHOD if_sadl_exit_calc_element_read~get_calculation_info.
    IF sy-subrc IS INITIAL.
    ENDIF.
  ENDMETHOD.
ENDCLASS.
