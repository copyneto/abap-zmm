CLASS zclmm_invt_nfe DEFINITION
  PUBLIC
  ABSTRACT
  CREATE PUBLIC .

  PUBLIC SECTION.

    TYPES: tt_nfe_emissao TYPE TABLE OF zi_mm_inventario_nfe_emissao.

    "! Creates Object
    "! @parameter iv_kind | 1 = Inventory; 2 = Nota Fiscal; 3 = Billing;
    CLASS-METHODS factory
      IMPORTING iv_kind       TYPE numc1
      RETURNING VALUE(rv_ref) TYPE REF TO zclmm_invt_nfe.

  PROTECTED SECTION.

    DATA gt_data TYPE tt_nfe_emissao.

    DATA gt_alivium TYPE TABLE OF ztmm_alivium.

    DATA gt_return TYPE bapiret2_tab.

    METHODS save
      RETURNING VALUE(rt_return) TYPE bapiret2_tab.

  PRIVATE SECTION.

ENDCLASS.



CLASS zclmm_invt_nfe IMPLEMENTATION.

  METHOD factory.

    CASE iv_kind.
      WHEN 1.
        rv_ref = NEW lcl_invt( ).
      WHEN 2.
        rv_ref = NEW lcl_nota( ).
      WHEN 3.
        rv_ref = NEW lcl_cntb( ).
      WHEN OTHERS.
    ENDCASE.

  ENDMETHOD.

  METHOD save.

    CHECK lines( me->gt_alivium ) GT 0.

    MODIFY ztmm_alivium FROM TABLE me->gt_alivium.
    IF sy-subrc EQ 0.

      CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
        EXPORTING
          wait = abap_true.

    ELSE.

      CALL FUNCTION 'BAPI_TRANSACTION_ROLLBACK'.
      rt_return = VALUE #( BASE rt_return ( id = 'M7' number = '790' type = if_abap_behv_message=>severity-error ) ).

    ENDIF.

  ENDMETHOD.

ENDCLASS.
