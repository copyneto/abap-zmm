class ZCLMM_WF_CONTRATO_EVAL definition
  public
  final
  create public .

public section.

  interfaces IF_BADI_INTERFACE .
  interfaces IF_SWF_FLEX_IFS_CONDITION_EVAL .
protected section.
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



CLASS ZCLMM_WF_CONTRATO_EVAL IMPLEMENTATION.


  method IF_SWF_FLEX_IFS_CONDITION_EVAL~EVALUATE_CONDITION.

    cv_is_true = abap_false.

    CHECK is_sap_object_node_type-sont_key_part_1 IS NOT INITIAL.

    SELECT SINGLE CompanyCode, PurchaseContractType, PurchasingGroup
    FROM I_PurchaseContractAPI01
    WHERE PurchaseContract = @is_sap_object_node_type-sont_key_part_1
    INTO @DATA(ls_cds_con).

    CHECK sy-subrc EQ 0 AND ls_cds_con-CompanyCode IS NOT INITIAL AND ls_cds_con-PurchasingGroup IS NOT INITIAL.

    CASE is_condition-condition_id.
      WHEN 'ZBukrs'.

        READ TABLE it_parameter_value ASSIGNING FIELD-SYMBOL(<fs_parm>) INDEX 1.
        CHECK <fs_parm> IS ASSIGNED AND <fs_parm>-value IS NOT INITIAL.

        me->get_value(
          EXPORTING
            iv_value = <fs_parm>-value
          IMPORTING
            et_value = DATA(lt_dados)
        ).

        IF ls_cds_con-companycode IN lt_dados.
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

        IF ls_cds_con-purchasecontracttype IN lt_dados.
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

        IF ls_cds_con-purchasinggroup IN lt_dados.
          cv_is_true = abap_true.
        ENDIF.

    ENDCASE.

  endmethod.


  method GET_VALUE.
    SPLIT iv_value AT ';' INTO TABLE DATA(lt_dados).

    et_value = VALUE #( FOR ls_data IN lt_dados
      sign = 'I'
      option = 'EQ'
      ( low = ls_data )
    ) .
  endmethod.
ENDCLASS.
