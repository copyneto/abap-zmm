CLASS zclmm_ord_arm DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    DATA: gs_cafe         TYPE zi_mm_01_cafe,
          gt_bapiret2     TYPE bapiret2_t,
          gv_wait_async_1 TYPE abap_bool.

    METHODS:

      constructor
        IMPORTING
          is_order_arm TYPE zi_mm_01_cafe,

      execute
        RETURNING VALUE(rt_bapiret2) TYPE bapiret2_t,

      setup_messages
        IMPORTING
            p_task TYPE clike.

  PROTECTED SECTION.
  PRIVATE SECTION.

ENDCLASS.



CLASS zclmm_ord_arm IMPLEMENTATION.


  METHOD execute.

    CALL FUNCTION 'ZFMMM_ARM_CAFE'
      STARTING NEW TASK 'MM_ARM_CAFE'
      CALLING setup_messages ON END OF TASK
      EXPORTING
        is_mm_01_cafe = gs_cafe.

    WAIT UNTIL gv_wait_async_1 = abap_true.

    rt_bapiret2 = gt_bapiret2.

    FREE gv_wait_async_1.

  ENDMETHOD.

  METHOD constructor.

    gs_cafe = is_order_arm.

  ENDMETHOD.

  METHOD setup_messages.

    RECEIVE RESULTS FROM FUNCTION 'MM_ARM_CAFE'
     IMPORTING
       et_return = gt_bapiret2.

    gv_wait_async_1 = abap_true.

  ENDMETHOD.

ENDCLASS.
