CLASS lcl_mm_zi_paletizacao DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PUBLIC SECTION.
    METHODS messages IMPORTING p_task TYPE clike.

  PRIVATE SECTION.
    DATA gt_messages       TYPE STANDARD TABLE OF bapiret2.
    DATA gv_wait_async     TYPE abap_bool.

    METHODS create FOR MODIFY
      IMPORTING entities FOR CREATE zi_mm_paletizacao.

    METHODS delete FOR MODIFY
      IMPORTING keys FOR DELETE zi_mm_paletizacao.

    METHODS update FOR MODIFY
      IMPORTING entities FOR UPDATE zi_mm_paletizacao.

    METHODS lock FOR LOCK
      IMPORTING keys FOR LOCK zi_mm_paletizacao.

    METHODS read FOR READ
      IMPORTING keys FOR READ zi_mm_paletizacao RESULT result.

    METHODS get_authorizations FOR AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR zi_mm_paletizacao RESULT result.

ENDCLASS.

CLASS lcl_mm_zi_paletizacao IMPLEMENTATION.

  METHOD get_authorizations.

    READ ENTITIES OF zi_mm_paletizacao IN LOCAL MODE
        ENTITY zi_mm_paletizacao
        ALL FIELDS WITH CORRESPONDING #( keys )
        RESULT DATA(lt_data)
        FAILED failed.

    CHECK lt_data IS NOT INITIAL.

    DATA: lv_update TYPE if_abap_behv=>t_xflag,
          lv_delete TYPE if_abap_behv=>t_xflag.

    LOOP AT lt_data ASSIGNING FIELD-SYMBOL(<fs_data>).

      IF requested_authorizations-%update EQ if_abap_behv=>mk-on.

        IF zclmm_auth_zmmwerks=>werks_update( <fs_data>-centro ).
          lv_update = if_abap_behv=>auth-allowed.
        ELSE.
          lv_update = if_abap_behv=>auth-unauthorized.
        ENDIF.

      ENDIF.

      IF requested_authorizations-%delete EQ if_abap_behv=>mk-on.

        IF zclmm_auth_zmmwerks=>werks_delete( <fs_data>-centro ).
          lv_delete = if_abap_behv=>auth-allowed.
        ELSE.
          lv_delete = if_abap_behv=>auth-unauthorized.
        ENDIF.

      ENDIF.

      APPEND VALUE #( %tky = <fs_data>-%tky
                      %update = lv_update
                      %delete = lv_delete )
             TO result.

    ENDLOOP.

  ENDMETHOD.

  METHOD create.

    DATA ls_palet TYPE ztmm_paletizacao.
    DATA lv_longo  TYPE timestampl.
    DATA(lo_palet) = NEW zclmm_atual_mat_paletizacao( ).

    GET TIME STAMP FIELD lv_longo.

    DATA(ls_entities) = entities[ 1 ].

    ls_palet-client                = sy-mandt.
    ls_palet-material              = ls_entities-product.
    ls_palet-centro                = ls_entities-centro.
    ls_palet-z_lastro              = ls_entities-lastro.
    ls_palet-z_altura              = ls_entities-altura.
    ls_palet-z_unit                = ls_entities-unit.
    ls_palet-created_by            = sy-uname.
    ls_palet-created_at            = lv_longo.
    ls_palet-last_changed_by       = sy-uname.
    ls_palet-last_changed_at       = lv_longo.
    ls_palet-local_last_changed_at = lv_longo.

    "//AuthorityCreate.
    IF zclmm_auth_zmmwerks=>werks_create( ls_palet-centro ) EQ abap_false.

      APPEND VALUE #( product     = ls_entities-product
                      centro      = ls_entities-centro
                      %msg        = NEW zcxca_authority_check(
                                        severity = if_abap_behv_message=>severity-error
                                        textid   = zcxca_authority_check=>gc_create )
                      %element-centro = if_abap_behv=>mk-on )
        TO reported-zi_mm_paletizacao.

      RETURN.

    ENDIF.

    SELECT SINGLE material
      FROM c_mm_materialvaluehelp
      WHERE material = @ls_palet-material
      INTO @DATA(lv_material).

    IF sy-subrc <> 0.
      APPEND VALUE #(
              %msg = new_message( id       = 'ZMM_PALETIZACAO'
                                  number   = '003'
                                  severity =  CONV #( 'E' ) ) ) TO reported-zi_mm_paletizacao.
      DATA(lv_error) = abap_true.
      EXIT.
    ENDIF.

    SELECT SINGLE plant
     FROM c_mm_plantvaluehelp
     WHERE plant = @ls_palet-centro
     INTO @DATA(lv_plant).

    IF sy-subrc <> 0.
      APPEND VALUE #(
              %msg = new_message( id       = 'ZMM_PALETIZACAO'
                                  number   = '004'
                                  severity =  CONV #( 'E' ) ) ) TO reported-zi_mm_paletizacao.
      lv_error = abap_true.
      EXIT.
    ENDIF.

    SELECT SINGLE matnr, werks, disgr
      FROM marc
      WHERE matnr = @ls_palet-material
        AND werks = @ls_palet-centro
      INTO @DATA(ls_marc).

    IF sy-subrc <> 0.
      APPEND VALUE #(
              %msg = new_message( id       = 'ZMM_PALETIZACAO'
                                  number   = '006'
                                  severity =  CONV #( 'E' ) ) ) TO reported-zi_mm_paletizacao.
      lv_error = abap_true.
      EXIT.
    ENDIF.

    SELECT SINGLE unitofmeasure
     FROM zi_mm_vh_unidade_medida
     WHERE language = @sy-langu
       AND unitofmeasure = @ls_palet-z_unit
     INTO @DATA(lv_unitofmeasure).

    IF sy-subrc <> 0.
      APPEND VALUE #(
              %msg = new_message( id       = 'ZMM_PALETIZACAO'
                                  number   = '005'
                                  severity =  CONV #( 'E' ) ) ) TO reported-zi_mm_paletizacao.
      lv_error = abap_true.
      EXIT.
    ENDIF.

    SELECT SINGLE ean11
     FROM marm
     WHERE matnr = @ls_entities-product
       AND meinh = @ls_entities-unit
     INTO @DATA(lv_ean).

    IF sy-subrc <> 0
    OR lv_ean IS INITIAL.
      APPEND VALUE #(
              %msg = new_message( id       = 'ZMM_PALETIZACAO'
                                  number   = '007'
                                  severity =  CONV #( 'E' ) ) ) TO reported-zi_mm_paletizacao.
      lv_error = abap_true.
      EXIT.
    ENDIF.

    CHECK lv_error = abap_false.

    MODIFY ztmm_paletizacao FROM ls_palet.

    IF sy-subrc IS INITIAL.

      CALL FUNCTION 'ZFMM_ATUAL_MAT_PALETIZACAO'
        STARTING NEW TASK 'PALETIZACAO'
        CALLING messages ON END OF TASK
        EXPORTING
          is_palet = ls_palet.

      WAIT UNTIL gv_wait_async = abap_true.


      DATA(ls_message) = VALUE #( gt_messages[ type = 'E' ] OPTIONAL ).

      IF ls_message IS NOT INITIAL.

        APPEND VALUE #(
                     %msg        = new_message( id       = ls_message-id
                                                number   = ls_message-number
                                                v1       = ls_message-message_v1
                                                v2       = ls_message-message_v2
                                                v3       = ls_message-message_v3
                                                v4       = ls_message-message_v4
                                                severity = CONV #( ls_message-type ) )
                      )
       TO reported-zi_mm_paletizacao.
      ELSE.

*        NEW zclmm_trigger_matmas( )->execute(
*          EXPORTING
*            iv_matnr = ls_palet-material
*            iv_mtart = ls_marc-disgr
**           iv_tcode =
*        ).

        APPEND VALUE #(
                %msg = new_message( id       = 'ZMM_PALETIZACAO'
                                    number   = '002'
                                    severity =  CONV #( 'S' ) ) ) TO reported-zi_mm_paletizacao.


      ENDIF.

    ENDIF.


  ENDMETHOD.

  METHOD delete.

    DATA(ls_keys) = keys[ 1 ].

    SELECT SINGLE material, centro
      FROM ztmm_paletizacao
     WHERE material = @ls_keys-product
       AND centro   = @ls_keys-centro
      INTO @DATA(ls_palet).

    IF sy-subrc IS INITIAL.

      DELETE ztmm_paletizacao FROM @( VALUE #( material = ls_palet-material
                                               centro   = ls_palet-centro ) ).

      IF sy-subrc IS INITIAL.

        SELECT SINGLE matnr, werks, disgr
          FROM marc
          WHERE matnr = @ls_palet-material
            AND werks = @ls_palet-centro
          INTO @DATA(ls_marc).

        NEW zclmm_trigger_matmas( )->execute(
          EXPORTING
            iv_matnr = ls_palet-material
            iv_mtart = ls_marc-disgr ).

        APPEND VALUE #(
                        %msg = new_message( id       = 'ZMM_PALETIZACAO'
                                            number   = '000'
                                            severity =  CONV #( 'S' ) ) ) TO reported-zi_mm_paletizacao.
      ENDIF.


    ENDIF.
  ENDMETHOD.

  METHOD update.

    DATA(ls_entities) = entities[ 1 ].
    DATA lv_change TYPE abap_bool.
    DATA lv_longo  TYPE timestampl.
    DATA(lo_palet) = NEW zclmm_atual_mat_paletizacao( ).

    CLEAR: lv_change.

    SELECT *
      FROM ztmm_paletizacao
     WHERE material = @ls_entities-product
       AND centro   = @ls_entities-centro
      INTO @DATA(ls_palet)
        UP TO 1 ROWS.
    ENDSELECT.

    IF sy-subrc IS INITIAL.

      IF ls_entities-lastro IS NOT INITIAL.
        ls_palet-z_lastro = ls_entities-lastro.
        lv_change = abap_true.
      ENDIF.

      IF ls_entities-altura IS NOT INITIAL.
        ls_palet-z_altura = ls_entities-altura.
        lv_change = abap_true.
      ENDIF.
      IF ls_entities-unit IS NOT INITIAL.
        ls_palet-z_unit = ls_entities-unit.
        lv_change = abap_true.
      ENDIF.

      IF lv_change IS NOT INITIAL.

        GET TIME STAMP FIELD lv_longo.

        ls_palet-last_changed_by = sy-uname.
        ls_palet-last_changed_at = lv_longo.
        ls_palet-local_last_changed_at = lv_longo.

      ENDIF.

      MODIFY ztmm_paletizacao FROM ls_palet.

      IF sy-subrc IS INITIAL.

        CALL FUNCTION 'ZFMM_ATUAL_MAT_PALETIZACAO'
          STARTING NEW TASK 'PALETIZACAO'
          CALLING messages ON END OF TASK
          EXPORTING
            is_palet = ls_palet.

        WAIT UNTIL gv_wait_async = abap_true.

        DATA(ls_message) = VALUE #( gt_messages[ type = 'E' ] OPTIONAL ).

        IF ls_message IS NOT INITIAL.


          APPEND VALUE #(
                       %msg        = new_message( id       = ls_message-id
                                                  number   = ls_message-number
                                                  v1       = ls_message-message_v1
                                                  v2       = ls_message-message_v2
                                                  v3       = ls_message-message_v3
                                                  v4       = ls_message-message_v4
                                                  severity = CONV #( ls_message-type ) )
                        )
         TO reported-zi_mm_paletizacao.
        ELSE.

          SELECT SINGLE matnr, werks, disgr
            FROM marc
            WHERE matnr = @ls_palet-material
              AND werks = @ls_palet-centro
            INTO @DATA(ls_marc).

*          NEW zclmm_trigger_matmas( )->execute(
*            EXPORTING
*              iv_matnr = ls_palet-material
*              iv_mtart = ls_marc-disgr ).

          APPEND VALUE #(
                  %msg = new_message( id       = 'ZMM_PALETIZACAO'
                                      number   = '001'
                                      severity =  CONV #( 'S' ) ) ) TO reported-zi_mm_paletizacao.


        ENDIF.
      ENDIF.
    ENDIF.
  ENDMETHOD.

  METHOD read.
    IF  sy-subrc IS INITIAL.
    ENDIF.
  ENDMETHOD.

  METHOD messages.

    RECEIVE RESULTS FROM FUNCTION 'ZMMFI_ATUAL_MAT_PALETIZACAO'
        IMPORTING
          et_return = gt_messages.

    gv_wait_async = abap_true.

  ENDMETHOD.

  METHOD lock.
    IF sy-subrc IS INITIAL.
    ENDIF.
  ENDMETHOD.

ENDCLASS.

CLASS lcl_mm_szi_paletizacao DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.

    METHODS check_before_save REDEFINITION.

    METHODS finalize          REDEFINITION.

    METHODS save              REDEFINITION.

ENDCLASS.

CLASS lcl_mm_szi_paletizacao IMPLEMENTATION.

  METHOD check_before_save.
    IF  sy-subrc IS INITIAL.
    ENDIF.
  ENDMETHOD.

  METHOD finalize.
    IF  sy-subrc IS INITIAL.
    ENDIF.
  ENDMETHOD.

  METHOD save.
    IF  sy-subrc IS INITIAL.
    ENDIF.
  ENDMETHOD.

ENDCLASS.
