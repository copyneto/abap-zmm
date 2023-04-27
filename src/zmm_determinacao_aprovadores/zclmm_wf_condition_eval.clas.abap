"!<p>Essa classe é utilizada para Avaliação de valor de condições adicionais para cenários
"!<p><strong>Autor:</strong> Bruno Costa - Meta</p>
"!<p><strong>Data:</strong> 11/02/2022</p>
CLASS zclmm_wf_condition_eval DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_badi_interface .
    INTERFACES if_swf_flex_ifs_condition_eval .

  PROTECTED SECTION.

private section.

  types:
    BEGIN OF ty_range,
      sign   TYPE ddsign,
      option TYPE ddoption,
      low    TYPE c LENGTH 10,
      high   TYPE c LENGTH 10,
    END OF ty_range .
  types:
    tt_range TYPE TABLE OF ty_range .

  methods GET_VALUE
    importing
      !IV_VALUE type STRING
    exporting
      !ET_VALUE type TT_RANGE .
ENDCLASS.



CLASS ZCLMM_WF_CONDITION_EVAL IMPLEMENTATION.


  METHOD if_swf_flex_ifs_condition_eval~evaluate_condition.

*    DATA: lv_break TYPE c VALUE 'X'.
*    DO.
*      IF lv_break = ''.
*        EXIT.
*      ENDIF.
*    ENDDO.

    CONSTANTS: lc_sim TYPE c LENGTH 3 VALUE 'Sim'.

    cv_is_true = abap_false.

    CHECK is_sap_object_node_type-sont_key_part_1 IS NOT INITIAL.

    SELECT SINGLE accountassignmentcategory, material,
                  storagelocation          , purreqnssprequestor, purchaserequisitiontype
             FROM i_purchaserequisition_api01
             INTO @DATA(ls_cds_pr)
            WHERE purchaserequisition     EQ @is_sap_object_node_type-sont_key_part_1
              AND purchaserequisitionitem EQ @is_sap_object_node_type-sont_key_part_2.

    CHECK sy-subrc EQ 0.

    CASE is_condition-condition_id.
      WHEN 'ZCostCenter'.

        READ TABLE it_parameter_value TRANSPORTING NO FIELDS WITH KEY value = lc_sim.
        IF sy-subrc EQ 0.
          cv_is_true = abap_true.
        ENDIF.

      WHEN 'ZPepType'.

        SELECT multipleacctassgmtdistrpercent, purreqnnetamount,
               purchasereqnacctassgmtnumber, costcenter,
               wbselement
          FROM i_purreqnacctassgmt_api01
          INTO TABLE @DATA(lt_cds_pr_acct)
         WHERE purchaserequisition     EQ @is_sap_object_node_type-sont_key_part_1
           AND purchaserequisitionitem EQ @is_sap_object_node_type-sont_key_part_2.

        CHECK sy-subrc EQ 0.

        SORT lt_cds_pr_acct BY multipleacctassgmtdistrpercent DESCENDING purreqnnetamount DESCENDING purchasereqnacctassgmtnumber ASCENDING.

        READ TABLE lt_cds_pr_acct ASSIGNING FIELD-SYMBOL(<fs_cds_pr_acct>) INDEX 1.

        READ TABLE it_parameter_value ASSIGNING FIELD-SYMBOL(<fs_parm>) INDEX 1.

        CHECK <fs_parm> IS ASSIGNED AND <fs_parm>-value IS NOT INITIAL.

        me->get_value(
          EXPORTING
            iv_value = <fs_parm>-value
          IMPORTING
            et_value = DATA(lt_dados)
        ).

        IF <fs_cds_pr_acct>-wbselement(3) IN lt_dados.
          cv_is_true = abap_true.
        ENDIF.

      WHEN 'ZStorage'.

        READ TABLE it_parameter_value TRANSPORTING NO FIELDS WITH KEY value = lc_sim.
        IF sy-subrc EQ 0.
          cv_is_true = abap_true.
        ENDIF.

      WHEN 'ZOrder'.

        READ TABLE it_parameter_value TRANSPORTING NO FIELDS WITH KEY value = lc_sim.
        IF sy-subrc EQ 0.
          cv_is_true = abap_true.
        ENDIF.

      WHEN 'ZBsart'.

        CLEAR lt_dados.

        READ TABLE it_parameter_value ASSIGNING <fs_parm> INDEX 1.

        CHECK <fs_parm> IS ASSIGNED AND <fs_parm>-value IS NOT INITIAL.

        me->get_value(
          EXPORTING
            iv_value = <fs_parm>-value
          IMPORTING
            et_value = lt_dados
        ).

        IF ls_cds_pr-purchaserequisitiontype IN lt_dados.
          cv_is_true = abap_true.
        ENDIF.

    ENDCASE.

  ENDMETHOD.


  METHOD get_value.
    SPLIT iv_value AT ';' INTO TABLE DATA(lt_dados).

    et_value = VALUE #( FOR ls_data IN lt_dados
      sign = 'I'
      option = 'EQ'
      ( low = ls_data )
    ) .

  ENDMETHOD.
ENDCLASS.
