class ZCLMM_WF_CONDITION_PEDIDO_EVAL definition
  public
  final
  create public .

public section.

  interfaces IF_BADI_INTERFACE .
  interfaces IF_SWF_FLEX_IFS_CONDITION_EVAL .
PRIVATE SECTION.

  TYPES:
    BEGIN OF ty_range,
      sign   TYPE ddsign,
      option TYPE ddoption,
      low    TYPE c LENGTH 10,
      high   TYPE c LENGTH 10,
    END OF ty_range .
  TYPES:
    tt_range TYPE TABLE OF ty_range .

  METHODS get_value
    IMPORTING
      !iv_value TYPE string
    EXPORTING
      !et_value TYPE tt_range .
ENDCLASS.



CLASS ZCLMM_WF_CONDITION_PEDIDO_EVAL IMPLEMENTATION.


  method GET_VALUE.
    SPLIT iv_value AT ';' INTO TABLE DATA(lt_dados).

    et_value = VALUE #( FOR ls_data IN lt_dados
      sign = 'I'
      option = 'EQ'
      ( low = ls_data )
    ) .
  endmethod.


  METHOD if_swf_flex_ifs_condition_eval~evaluate_condition.

*    DATA: lv_break TYPE c VALUE 'X'.
*    DO.
*      IF lv_break = ''.
*        EXIT.
*      ENDIF.
*    ENDDO.

    cv_is_true = abap_false.

    CHECK is_sap_object_node_type-sont_key_part_1 IS NOT INITIAL.

    SELECT SINGLE PurchaseOrderType, PurchasingGroup
    FROM i_purchaseorderapi01
    WHERE purchaseorder = @is_sap_object_node_type-sont_key_part_1
    INTO @DATA(ls_cds_ped).

    CHECK sy-subrc EQ 0 AND ls_cds_ped-purchaseordertype IS NOT INITIAL AND ls_cds_ped-purchasinggroup IS NOT INITIAL.

    SELECT SINGLE plant
    FROM i_purchaseorderitemapi01
    WHERE purchaseorder = @is_sap_object_node_type-sont_key_part_1
    AND plant IS NOT INITIAL
    "AND purchaseorderitem = @is_sap_object_node_type-sont_key_part_2
    INTO @DATA(lv_plant).

    CASE is_condition-condition_id.
      WHEN 'ZBsart'.

        READ TABLE it_parameter_value ASSIGNING FIELD-SYMBOL(<fs_parm>) INDEX 1.
        CHECK <fs_parm> IS ASSIGNED AND <fs_parm>-value IS NOT INITIAL.

        me->get_value(
          EXPORTING
            iv_value = <fs_parm>-value
          IMPORTING
            et_value = DATA(lt_dados)
        ).

        IF ls_cds_ped-purchaseordertype IN lt_dados.
          cv_is_true = abap_true.
        ENDIF.

      WHEN 'ZEkgrp'.

        CLEAR lt_dados.
        READ TABLE it_parameter_value ASSIGNING <fs_parm> INDEX 1.
        CHECK <fs_parm> IS ASSIGNED AND <fs_parm>-value IS NOT INITIAL.

        me->get_value(
          EXPORTING
            iv_value = <fs_parm>-value
          IMPORTING
            et_value = lt_dados
        ).

        IF ls_cds_ped-purchasinggroup IN lt_dados.
          cv_is_true = abap_true.
        ENDIF.

      WHEN 'ZWerks'.

        CLEAR lt_dados.
        READ TABLE it_parameter_value ASSIGNING <fs_parm> INDEX 1.
        CHECK <fs_parm> IS ASSIGNED AND <fs_parm>-value IS NOT INITIAL.

        me->get_value(
          EXPORTING
            iv_value = <fs_parm>-value
          IMPORTING
            et_value = lt_dados
        ).

        IF lv_plant IN lt_dados.
          cv_is_true = abap_true.
        ENDIF.

    ENDCASE.


*    CHECK is_sap_object_node_type-sont_key_part_1 IS NOT INITIAL.
*
*    SELECT Plant, PurchaseOrderItem UP TO 1 ROWS
*             FROM i_purchaseorderitemapi01
*             INTO @DATA(ls_cds_po)
*            WHERE PurchaseOrder     EQ @is_sap_object_node_type-sont_key_part_1
*      ORDER BY PurchaseOrderItem.
*    ENDSELECT.
*
*    CASE is_condition-condition_id.
*      WHEN 'ZPlant'.
*
*        READ TABLE it_parameter_value TRANSPORTING NO FIELDS WITH KEY value = ls_cds_po-Plant
*                                      BINARY SEARCH.
*        IF sy-subrc EQ 0.
*          cv_is_true = abap_true.
*        ENDIF.
*
*    ENDCASE.

  ENDMETHOD.
ENDCLASS.
