class ZCLMM_VIRT_SALDO_REMESSA definition
  public
  final
  create public .

public section.

  interfaces IF_SADL_EXIT .
  interfaces IF_SADL_EXIT_CALC_ELEMENT_READ .
protected section.
private section.
ENDCLASS.



CLASS ZCLMM_VIRT_SALDO_REMESSA IMPLEMENTATION.


  METHOD if_sadl_exit_calc_element_read~calculate.

    LOOP AT it_original_data ASSIGNING FIELD-SYMBOL(<fs_original_data>).
      append INITIAL LINE TO ct_calculated_data  ASSIGNING FIELD-SYMBOL(<fs_calculated_data>).
      MOVE-CORRESPONDING  <fs_original_data> to <fs_calculated_data>.
*     <fs_calculated_data>-saldo =  <fs_calculated_data>-lfimg - <fs_calculated_data>-erimg.
    ENDLOOP.
*
*    exit.
*    DATA: lt_key TYPE zctgmm_subc_saveatrib.
*
*    CHECK NOT it_original_data IS INITIAL.
*
*    DATA lt_calculated_data TYPE STANDARD TABLE OF zc_mm_relat_saldo_remessa WITH DEFAULT KEY.
*
*    MOVE-CORRESPONDING it_original_data TO lt_calculated_data.
*
*    LOOP AT lt_calculated_data ASSIGNING FIELD-SYMBOL(<fs_calculated>).
*
*      IF <fs_calculated>-vbeln IS NOT INITIAL
*     AND <fs_calculated>-matnr IS NOT INITIAL.
*        lt_key = VALUE #( BASE lt_key ( rsnum = <fs_calculated>-rsnum
*                                        rspos = <fs_calculated>-rspos ) ).
*      ENDIF.
*
*    ENDLOOP.
*
*    IF lt_key[] IS NOT INITIAL.
*      DATA(lo_process) = NEW zclmm_ajst_sald_remessa( ).
*
*      lo_process->get_saldo( EXPORTING it_key  = lt_key
*                             IMPORTING et_soma = DATA(lt_soma) ).
*
*      IF lt_soma[] IS NOT INITIAL.
*
*        SORT lt_soma BY matnr
*                        ebeln.
*
*        LOOP AT lt_calculated_data ASSIGNING <fs_calculated>.
*
*          READ TABLE lt_soma ASSIGNING FIELD-SYMBOL(<fs_soma>)
*                                           WITH KEY matnr = <fs_calculated>-matnr
*                                                    ebeln = <fs_calculated>-ebeln
*                                                    BINARY SEARCH.
*          IF sy-subrc IS INITIAL.
*            <fs_calculated>-saldo = <fs_soma>-menge.
*          ENDIF.
*
*        ENDLOOP.
*      ENDIF.
*    ENDIF.
*
*    MOVE-CORRESPONDING lt_calculated_data TO ct_calculated_data.

  ENDMETHOD.


  METHOD if_sadl_exit_calc_element_read~get_calculation_info.
    IF et_requested_orig_elements IS INITIAL.
*    APPEND 'REQNUMBER' TO et_requested_orig_elements.
    ENDIF.
  ENDMETHOD.
ENDCLASS.
