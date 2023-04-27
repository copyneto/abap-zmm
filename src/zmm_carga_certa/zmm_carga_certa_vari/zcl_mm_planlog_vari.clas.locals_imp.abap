*"* use this source file for the definition and implementation of
*"* local helper classes, interface definitions and type
*"* declarations

CLASS lcl_handler DEFINITION INHERITING FROM cl_abap_behavior_handler.

  PUBLIC SECTION.

    CONSTANTS: c_e TYPE c VALUE 'E',
               c_s TYPE c VALUE 'S'.

    CLASS-DATA mt_root_to_create TYPE STANDARD TABLE OF ztplanlog_vari.

  PRIVATE SECTION.
    METHODS create FOR MODIFY
      IMPORTING roots_to_create FOR CREATE vari.

    METHODS read FOR READ
      IMPORTING keys FOR READ vari RESULT et_resultado.

    METHODS update FOR MODIFY
      IMPORTING entities FOR UPDATE vari.
    METHODS delete FOR MODIFY
      IMPORTING entities FOR DELETE vari.


ENDCLASS.

CLASS lcl_handler IMPLEMENTATION.

  METHOD create.

    DATA: lv_max_id TYPE i.

    LOOP AT roots_to_create INTO DATA(ls_create).

      SELECT SINGLE MAX( cont )
      FROM ztplanlog_vari
      INTO lv_max_id
      WHERE report = ls_create-report
      AND vari = ls_create-vari.
      IF sy-subrc <> 0.
        lv_max_id = 1.
      ELSE.
        lv_max_id = lv_max_id + 1.
      ENDIF.

      ls_create-cont = lv_max_id.
      INSERT CORRESPONDING #( ls_create-%data ) INTO TABLE mt_root_to_create.
    ENDLOOP.

  ENDMETHOD.

  METHOD read.

    SELECT *
    FROM ztplanlog_vari
    INTO CORRESPONDING FIELDS OF TABLE @et_resultado
    FOR ALL ENTRIES IN @keys
    WHERE report = @keys-report
    AND vari = @keys-vari.

  ENDMETHOD.

  METHOD update.

  ENDMETHOD.

  METHOD delete.

  ENDMETHOD.

ENDCLASS.

CLASS lcl_saver DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.
    METHODS finalize REDEFINITION.
    METHODS check_before_save REDEFINITION.
    METHODS save REDEFINITION.
ENDCLASS.

CLASS lcl_saver IMPLEMENTATION.

  METHOD save.
    INSERT ztplanlog_vari FROM TABLE @lcl_handler=>mt_root_to_create.
  ENDMETHOD.

  METHOD finalize.
  ENDMETHOD.

  METHOD check_before_save.
  ENDMETHOD.

ENDCLASS.
