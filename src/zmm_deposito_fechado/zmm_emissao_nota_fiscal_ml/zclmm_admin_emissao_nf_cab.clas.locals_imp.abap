CLASS lcl_Header DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS update FOR MODIFY
      IMPORTING entities FOR UPDATE Header.

    METHODS lock FOR LOCK
      IMPORTING keys FOR LOCK Header.

    METHODS read FOR READ
      IMPORTING keys FOR READ Header RESULT result.

    METHODS cba_Item FOR MODIFY
      IMPORTING entities_cba FOR CREATE Header\_Item.

    METHODS rba_Item FOR READ
      IMPORTING keys_rba FOR READ Header\_Item FULL result_requested RESULT result LINK association_links.

    METHODS get_authorizations FOR AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR Header RESULT result.

ENDCLASS.

CLASS lcl_Header IMPLEMENTATION.

  METHOD update.
    RETURN.
  ENDMETHOD.

  METHOD lock.
    RETURN.
  ENDMETHOD.

  METHOD read.
    RETURN.
  ENDMETHOD.

  METHOD cba_Item.
    RETURN.
  ENDMETHOD.

  METHOD rba_Item.
    RETURN.
  ENDMETHOD.

  METHOD get_authorizations.
    RETURN.
  ENDMETHOD.

ENDCLASS.

CLASS lcl_ZI_MM_ADMIN_EMISSAO_NF_CAB DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.

    METHODS check_before_save REDEFINITION.

    METHODS finalize          REDEFINITION.

    METHODS save              REDEFINITION.

ENDCLASS.

CLASS lcl_ZI_MM_ADMIN_EMISSAO_NF_CAB IMPLEMENTATION.

  METHOD check_before_save.
    RETURN.
  ENDMETHOD.

  METHOD finalize.
    RETURN.
  ENDMETHOD.

  METHOD save.
    RETURN.
  ENDMETHOD.

ENDCLASS.
