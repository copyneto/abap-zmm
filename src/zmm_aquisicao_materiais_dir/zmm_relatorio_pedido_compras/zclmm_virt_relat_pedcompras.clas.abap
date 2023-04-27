class ZCLMM_VIRT_RELAT_PEDCOMPRAS definition
  public
  final
  create public .

public section.

  interfaces IF_SADL_EXIT .
  interfaces IF_SADL_EXIT_CALC_ELEMENT_READ .
protected section.
private section.
ENDCLASS.



CLASS ZCLMM_VIRT_RELAT_PEDCOMPRAS IMPLEMENTATION.


  METHOD if_sadl_exit_calc_element_read~calculate.

    TYPES: BEGIN OF ty_tot_migo,
             purchaseorder     TYPE ekpo-ebeln,
             purchaseorderitem TYPE ekpo-ebelp,
             total_migo        TYPE menge_d,
           END OF ty_tot_migo,

           BEGIN OF ty_est_lib,
             purchaseorder TYPE ekpo-ebeln,
             qtd_lib       TYPE i,
           END OF ty_est_lib.

    DATA: lt_tot_migo   TYPE STANDARD TABLE OF ty_tot_migo,
          lt_qtd_pend   TYPE STANDARD TABLE OF ty_tot_migo,
          lt_est_lib    TYPE STANDARD TABLE OF ty_est_lib,
          lt_bapirlcopo TYPE STANDARD TABLE OF bapirlcopo.

    DATA: ls_tot_migo TYPE ty_tot_migo,
          ls_qtd_pend TYPE ty_tot_migo,
          ls_est_lib  TYPE ty_est_lib.

    CHECK NOT it_original_data IS INITIAL.

    DATA lt_calculated_data TYPE STANDARD TABLE OF zc_mm_pedido_compras WITH DEFAULT KEY.

    MOVE-CORRESPONDING it_original_data TO lt_calculated_data.

    IF lt_calculated_data[] IS NOT INITIAL.

      SELECT purchaseorder,
             purchaseorderitem,
             debitcreditcode,
             quantityinbaseunit
        FROM c_purchaseordergoodsreceipt
         FOR ALL ENTRIES IN @lt_calculated_data
       WHERE purchaseorder     = @lt_calculated_data-purchaseorder
         AND purchaseorderitem = @lt_calculated_data-purchaseorderitem
        INTO TABLE @DATA(lt_goodsreceipt).

      IF sy-subrc IS INITIAL.
        LOOP AT lt_goodsreceipt ASSIGNING FIELD-SYMBOL(<fs_goodsreceipt>).

          ls_tot_migo-purchaseorder     = <fs_goodsreceipt>-purchaseorder.
          ls_tot_migo-purchaseorderitem = <fs_goodsreceipt>-purchaseorderitem.

          IF <fs_goodsreceipt>-debitcreditcode EQ 'S'.
            ls_tot_migo-total_migo = <fs_goodsreceipt>-quantityinbaseunit.
          ELSE.
            ls_tot_migo-total_migo = <fs_goodsreceipt>-quantityinbaseunit * -1.
          ENDIF.

          COLLECT ls_tot_migo INTO lt_tot_migo.
          CLEAR ls_tot_migo.

        ENDLOOP.
      ENDIF.

      SELECT purchasingdocument,
             purchasingdocumentitem,
             debitcreditcode,
             qtyinpurchaseorderpriceunit
        FROM c_grirpurchaseorderhistory
         FOR ALL ENTRIES IN @lt_calculated_data
       WHERE purchasingdocument     = @lt_calculated_data-purchaseorder
         AND purchasingdocumentitem = @lt_calculated_data-purchaseorderitem
        INTO TABLE @DATA(lt_purchsorderhisto).

      IF sy-subrc IS INITIAL.
        LOOP AT lt_purchsorderhisto ASSIGNING FIELD-SYMBOL(<fs_purchsorderhisto>).

          ls_qtd_pend-purchaseorder     = <fs_purchsorderhisto>-purchasingdocument.
          ls_qtd_pend-purchaseorderitem = <fs_purchsorderhisto>-purchasingdocumentitem.

          IF <fs_purchsorderhisto>-debitcreditcode EQ 'S'.
            ls_qtd_pend-total_migo = <fs_purchsorderhisto>-qtyinpurchaseorderpriceunit.
          ELSE.
            ls_qtd_pend-total_migo = <fs_purchsorderhisto>-qtyinpurchaseorderpriceunit * -1.
          ENDIF.

          COLLECT ls_qtd_pend INTO lt_qtd_pend.
          CLEAR ls_qtd_pend.

        ENDLOOP.
      ENDIF.

      DATA(lt_calc_aux) = lt_calculated_data[].

      SORT lt_calc_aux BY purchaseorder.

      DELETE ADJACENT DUPLICATES FROM lt_calc_aux COMPARING purchaseorder.

      LOOP AT lt_calc_aux ASSIGNING FIELD-SYMBOL(<fs_calc>).

        CALL FUNCTION 'BAPI_PO_GETRELINFO'
          EXPORTING
            purchaseorder = <fs_calc>-purchaseorder
          TABLES
            release_final = lt_bapirlcopo.

        IF lt_bapirlcopo[] IS NOT INITIAL.
          DATA(ls_bapirlcopo) = lt_bapirlcopo[ 1 ].

          ls_est_lib-purchaseorder = <fs_calc>-purchaseorder.

          IF ls_bapirlcopo-rel_code1 IS NOT INITIAL.
            ls_est_lib-qtd_lib = ls_est_lib-qtd_lib + 1.
          ENDIF.
          IF ls_bapirlcopo-rel_code2 IS NOT INITIAL.
            ls_est_lib-qtd_lib = ls_est_lib-qtd_lib + 1.
          ENDIF.
          IF ls_bapirlcopo-rel_code3 IS NOT INITIAL.
            ls_est_lib-qtd_lib = ls_est_lib-qtd_lib + 1.
          ENDIF.
          IF ls_bapirlcopo-rel_code4 IS NOT INITIAL.
            ls_est_lib-qtd_lib = ls_est_lib-qtd_lib + 1.
          ENDIF.
          IF ls_bapirlcopo-rel_code5 IS NOT INITIAL.
            ls_est_lib-qtd_lib = ls_est_lib-qtd_lib + 1.
          ENDIF.
          IF ls_bapirlcopo-rel_code6 IS NOT INITIAL.
            ls_est_lib-qtd_lib = ls_est_lib-qtd_lib + 1.
          ENDIF.
          IF ls_bapirlcopo-rel_code7 IS NOT INITIAL.
            ls_est_lib-qtd_lib = ls_est_lib-qtd_lib + 1.
          ENDIF.
          IF ls_bapirlcopo-rel_code8 IS NOT INITIAL.
            ls_est_lib-qtd_lib = ls_est_lib-qtd_lib + 1.
          ENDIF.

          APPEND ls_est_lib TO lt_est_lib.
          CLEAR ls_est_lib.

          FREE: lt_bapirlcopo[].
        ENDIF.
      ENDLOOP.

      SORT lt_tot_migo BY purchaseorder
                          purchaseorderitem.

      SORT lt_qtd_pend BY purchaseorder
                          purchaseorderitem.

      SORT lt_est_lib BY purchaseorder.

      LOOP AT lt_calculated_data ASSIGNING FIELD-SYMBOL(<fs_calculated>).

        READ TABLE lt_tot_migo ASSIGNING FIELD-SYMBOL(<fs_tot_migo>)
                                             WITH KEY purchaseorder     = <fs_calculated>-purchaseorder
                                                      purchaseorderitem = <fs_calculated>-purchaseorderitem
                                                      BINARY SEARCH.
        IF sy-subrc IS INITIAL.
          <fs_calculated>-migo = <fs_tot_migo>-total_migo.
        ENDIF.

        READ TABLE lt_qtd_pend ASSIGNING FIELD-SYMBOL(<fs_qtd_pend>)
                                             WITH KEY purchaseorder     = <fs_calculated>-purchaseorder
                                                      purchaseorderitem = <fs_calculated>-purchaseorderitem
                                                      BINARY SEARCH.
        IF sy-subrc IS INITIAL.
          <fs_calculated>-qtdpendente = <fs_qtd_pend>-total_migo.
          <fs_calculated>-saldopend   = <fs_qtd_pend>-total_migo.
        ENDIF.

        READ TABLE lt_est_lib ASSIGNING FIELD-SYMBOL(<fs_est_lib>)
                                            WITH KEY purchaseorder = <fs_calculated>-purchaseorder
                                            BINARY SEARCH.
        IF sy-subrc IS INITIAL.
          <fs_calculated>-estliberac = <fs_est_lib>-qtd_lib.
        ENDIF.

      ENDLOOP.

      MOVE-CORRESPONDING lt_calculated_data TO ct_calculated_data.

    ENDIF.

  ENDMETHOD.


  METHOD IF_SADL_EXIT_CALC_ELEMENT_READ~GET_CALCULATION_INFO.
    IF et_requested_orig_elements IS INITIAL.
*    APPEND 'REQNUMBER' TO et_requested_orig_elements.
    ENDIF.
  ENDMETHOD.
ENDCLASS.
