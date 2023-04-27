*"* use this source file for the definition and implementation of
*"* local helper classes, interface definitions and type
*"* declarations

CLASS lcl_handler DEFINITION INHERITING FROM cl_abap_behavior_handler.

  PUBLIC SECTION.

    CONSTANTS: c_e TYPE c VALUE 'E',
               c_s TYPE c VALUE 'S'.

    CLASS-DATA mt_root_to_create TYPE STANDARD TABLE OF ztmmsd_planlog.

  PRIVATE SECTION.
    METHODS create FOR MODIFY
      IMPORTING entities FOR CREATE variante.

    METHODS read FOR READ
      IMPORTING keys FOR READ variante RESULT result.

    METHODS update FOR MODIFY
      IMPORTING entities FOR UPDATE variante.


ENDCLASS.

CLASS lcl_handler IMPLEMENTATION.

  METHOD create.

    DATA: ls_result TYPE ztmmsd_planlog,
          lt_return TYPE bapiret2_t,
          ls_return LIKE LINE OF lt_return,
          gs_ref    TYPE REF TO data.

    FIELD-SYMBOLS <gt_deriva>    TYPE STANDARD TABLE.

    ls_return-id = 'ZMMCARGACERTA'.

    LOOP AT entities INTO DATA(ls_create).


      ls_result-report = ls_create-%data-ztran.
      ls_result-variant = ls_create-%data-zvari.


      SUBMIT zmmsd_planlog AND RETURN
      WITH p_tran = ls_result-report
      WITH p_vari = ls_result-variant.

*-- RECUPERANDO DA MEMÓRIA O RESULTADO DO ALV.
      TRY.
          cl_salv_bs_runtime_info=>get_data_ref(
            IMPORTING r_data = gs_ref ).

          ASSIGN gs_ref->* TO <gt_deriva>.
        CATCH cx_salv_bs_sc_runtime_info.
          ls_return-message_v1 = ls_result-report.
          ls_return-message_v2 = ls_result-variant.
          ls_return-number = '001'.
          ls_return-type = 'E'.
          APPEND ls_return TO lt_return.
          APPEND VALUE #( %tky                = ls_result-variant ) TO failed-variante.
      ENDTRY.

      DATA: lv_sucesso TYPE c.

      IMPORT lv_sucesso = lv_sucesso FROM MEMORY ID 'CARGA_CERTA'.

      IF lv_sucesso IS NOT INITIAL.
        ls_return-number = '000'.
        ls_return-type = 'S'.
        APPEND ls_return TO lt_return.
      ELSE.
        ls_return-message_v1 = ls_result-report.
        ls_return-message_v2 = ls_result-variant.
        ls_return-number = '001'.
        ls_return-type = 'E'.
        APPEND ls_return TO lt_return.
        APPEND VALUE #( %tky                = ls_result-variant ) TO failed-variante.
      ENDIF.


      reported-variante = VALUE #( FOR ls_mensagem IN lt_return (
                      %msg = new_message( id       = ls_mensagem-id
                                          number   = ls_mensagem-number
                                          severity = COND #( WHEN ls_mensagem-type = 'E'
                                                             THEN if_abap_behv_message=>severity-information
                                                             ELSE CONV #( ls_mensagem-type ) )
                                          v1       = ls_mensagem-message_v1
                                          v2       = ls_mensagem-message_v2
                                          v3       = ls_mensagem-message_v3
                                          v4       = ls_mensagem-message_v4 ) ) ) .


    ENDLOOP.



  ENDMETHOD.



  METHOD read.

    DATA: ls_result TYPE ztmmsd_planlog,
          lt_return TYPE bapiret2_t,
          ls_return LIKE LINE OF lt_return.

    ls_return-id = 'ZMMCARGACERTA'.

    SUBMIT zmmsd_planlog AND RETURN
    WITH p_tran = ls_result-report
    WITH p_vari = ls_result-variant.

    IF sy-subrc EQ 0.
      ls_return-number = '000'.
      ls_return-type = 'S'.
      APPEND ls_return TO lt_return.

    ELSE.
      ls_return-message_v1 = ls_result-report.
      ls_return-message_v2 = ls_result-variant.
      ls_return-number = '001'.
      ls_return-type = 'E'.
      APPEND ls_return TO lt_return.

    ENDIF.

    reported-variante = VALUE #( FOR ls_mensagem IN lt_return (
                    %msg = new_message( id       = ls_mensagem-id
                                        number   = ls_mensagem-number
                                        severity = COND #( WHEN ls_mensagem-type = 'W'
                                                           THEN if_abap_behv_message=>severity-information
                                                           ELSE CONV #( ls_mensagem-type ) )
                                        v1       = ls_mensagem-message_v1
                                        v2       = ls_mensagem-message_v2
                                        v3       = ls_mensagem-message_v3
                                        v4       = ls_mensagem-message_v4 ) ) ) .



  ENDMETHOD.


  METHOD update.
    DATA: ls_result TYPE ztmmsd_planlog,
          lt_return TYPE bapiret2_t,
          ls_return LIKE LINE OF lt_return.

    ls_return-id = 'ZMMCARGACERTA'.

    LOOP AT entities INTO DATA(ls_create).


      "ls_result-report = ls_create-%data-ztran.
      "ls_result-variant = ls_create-%data-zvari.

      ls_result-report = 'ZZ'.
      ls_result-variant = 'ZVARIANTE'.

      SUBMIT zmmsd_planlog AND RETURN
      WITH p_tran = ls_result-report
      WITH p_vari = ls_result-variant.
      IF sy-subrc EQ 0.
        ls_return-number = '000'.
        ls_return-type = 'S'.
        APPEND ls_return TO lt_return.

      ELSE.
        ls_return-message_v1 = ls_result-report.
        ls_return-message_v2 = ls_result-variant.
        ls_return-number = '001'.
        ls_return-type = 'E'.
        APPEND ls_return TO lt_return.

      ENDIF.

      reported-variante = VALUE #( FOR ls_mensagem IN lt_return (
                      %msg = new_message( id       = ls_mensagem-id
                                          number   = ls_mensagem-number
                                          severity = COND #( WHEN ls_mensagem-type = 'W'
                                                             THEN if_abap_behv_message=>severity-information
                                                             ELSE CONV #( ls_mensagem-type ) )
                                          v1       = ls_mensagem-message_v1
                                          v2       = ls_mensagem-message_v2
                                          v3       = ls_mensagem-message_v3
                                          v4       = ls_mensagem-message_v4 ) ) ) .
    ENDLOOP.


  ENDMETHOD.



ENDCLASS.

CLASS lsc_yi_poc_crud DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.

    METHODS check_before_save REDEFINITION.

    METHODS finalize          REDEFINITION.

    METHODS save              REDEFINITION.

ENDCLASS.

CLASS lsc_yi_poc_crud IMPLEMENTATION.

  METHOD check_before_save.
  ENDMETHOD.

  METHOD finalize.
  ENDMETHOD.

  METHOD save.

  ENDMETHOD.

ENDCLASS.
