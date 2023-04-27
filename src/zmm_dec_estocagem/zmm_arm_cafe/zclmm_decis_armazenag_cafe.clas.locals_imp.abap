CLASS lcl_header DEFINITION INHERITING FROM cl_abap_behavior_handler.

  PRIVATE SECTION.

    METHODS processar FOR MODIFY
      IMPORTING keys FOR ACTION _header~processar.
    METHODS get_features FOR FEATURES
      IMPORTING keys REQUEST requested_features FOR _header RESULT result.

ENDCLASS.

CLASS lcl_header IMPLEMENTATION.

  METHOD processar.

    READ ENTITIES OF zi_mm_decis_armazenag_cafe IN LOCAL MODE
    ENTITY _header
    ALL FIELDS WITH CORRESPONDING #( keys )
    RESULT DATA(lt_header).

    CHECK lt_header[] IS NOT INITIAL.

    READ TABLE lt_header ASSIGNING FIELD-SYMBOL(<fs_header>) INDEX 1.

    IF sy-subrc IS INITIAL.

      DATA(lo_object) = NEW zclmm_arm_cafe( ).

      reported-_header = VALUE #( FOR ls_mensagem IN lo_object->execute_proc_armaz( EXPORTING iv_romaneio = <fs_header>-romaneio )
                             (  %msg    = new_message(
                                   id       = ls_mensagem-id
                                   number   = ls_mensagem-number
                                   severity = CONV #( ls_mensagem-type )
                                   v1       = ls_mensagem-message_v1
                                   v2       = ls_mensagem-message_v2
                                   v3       = ls_mensagem-message_v3
                                   v4       = ls_mensagem-message_v4 )
                       ) ) .

    ENDIF.
  ENDMETHOD.

  METHOD get_features.

    IF keys[] IS NOT INITIAL.

      SELECT doc_uuid_h,
             status_armazenado
        FROM ztmm_romaneio_in
         FOR ALL ENTRIES IN @keys
       WHERE doc_uuid_h = @keys-docuuidh
        INTO TABLE @DATA(lt_relat).

      IF sy-subrc IS INITIAL.
        SORT lt_relat BY doc_uuid_h.

        LOOP AT keys ASSIGNING FIELD-SYMBOL(<fs_keys>).

          READ TABLE lt_relat ASSIGNING FIELD-SYMBOL(<fs_relat>) WITH KEY doc_uuid_h = <fs_keys>-docuuidh
                                                                          BINARY SEARCH.
          IF sy-subrc IS INITIAL.
            IF <fs_relat>-status_armazenado = 'S'.
              result = VALUE #( BASE result ( docuuidh          = <fs_keys>-docuuidh
                                              %action-processar = if_abap_behv=>fc-o-disabled
                                              %update           = if_abap_behv=>fc-o-disabled
                                              %assoc-_lote      = if_abap_behv=>fc-o-disabled ) ).
            ELSE.
              result = VALUE #( BASE result ( docuuidh = <fs_keys>-docuuidh
                                              %action-processar = if_abap_behv=>fc-o-enabled ) ).
            ENDIF.
          ENDIF.

        ENDLOOP.
      ENDIF.
    ENDIF.

  ENDMETHOD.

ENDCLASS.

CLASS lcl_lote DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS determlote FOR DETERMINE ON SAVE
      IMPORTING keys FOR _lote~determlote.
    METHODS get_features FOR FEATURES
      IMPORTING keys REQUEST requested_features FOR _lote RESULT result.

ENDCLASS.

CLASS lcl_lote IMPLEMENTATION.

  METHOD determlote.

    DATA: lv_aut_charg TYPE charg_d,
          lv_char5     TYPE char5,
          lv_numc2     TYPE numc2.

    READ ENTITIES OF zi_mm_decis_armazenag_cafe IN LOCAL MODE
    ENTITY _lote
    ALL FIELDS WITH CORRESPONDING #( keys )
    RESULT DATA(lt_lotes).

    CHECK lt_lotes[] IS NOT INITIAL.

    SELECT doc_uuid_h,
           doc_uuid_lot,
           charg
      FROM ztmm_romaneio_lo
       FOR ALL ENTRIES IN @lt_lotes
     WHERE doc_uuid_h = @lt_lotes-docuuidh
      INTO TABLE @DATA(lt_romaneio).

    IF sy-subrc IS INITIAL.
      SORT lt_romaneio BY charg.
    ENDIF.

    READ ENTITIES OF zi_mm_decis_armazenag_cafe IN LOCAL MODE
    ENTITY _header
    ALL FIELDS WITH CORRESPONDING #( keys )
    RESULT DATA(lt_header).

    IF lt_header[] IS NOT INITIAL.

      READ TABLE lt_header ASSIGNING FIELD-SYMBOL(<fs_header>) INDEX 1.
      IF sy-subrc IS INITIAL.

        CALL FUNCTION 'CONVERSION_EXIT_ALPHA_OUTPUT'
          EXPORTING
            input  = <fs_header>-romaneio
          IMPORTING
            output = lv_char5.

        CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
          EXPORTING
            input  = lv_char5
          IMPORTING
            output = lv_char5.


        lv_aut_charg = |{ 'TC' }{ lv_char5 }{ '-' }|.
      ENDIF.
    ENDIF.

    LOOP AT lt_lotes ASSIGNING FIELD-SYMBOL(<fs_lotes>).

      DO 100 TIMES.
        lv_numc2 = lv_numc2 + 1.
        lv_aut_charg+8(2) = lv_numc2.

        READ TABLE lt_romaneio TRANSPORTING NO FIELDS
                                             WITH KEY charg = lv_aut_charg
                                             BINARY SEARCH.
        IF sy-subrc IS NOT INITIAL.
          EXIT.
        ENDIF.
      ENDDO.

      MODIFY ENTITIES OF zi_mm_decis_armazenag_cafe IN LOCAL MODE
      ENTITY _lote
      UPDATE FIELDS ( charg )
      WITH VALUE #( ( %key-docuuidh    = <fs_lotes>-docuuidh
                      %key-docuuidlot  = <fs_lotes>-docuuidlot
                      charg            = lv_aut_charg ) )
      FAILED DATA(lt_failed)
      REPORTED DATA(lt_reported).

      reported = CORRESPONDING #( DEEP lt_reported ).
    ENDLOOP.

  ENDMETHOD.

  METHOD get_features.

    IF keys[] IS NOT INITIAL.

      SELECT doc_uuid_h,
             status_armazenado
        FROM ztmm_romaneio_in
         FOR ALL ENTRIES IN @keys
       WHERE doc_uuid_h = @keys-docuuidh
        INTO TABLE @DATA(lt_relat).

      IF sy-subrc IS INITIAL.
        SORT lt_relat BY doc_uuid_h.

        LOOP AT keys ASSIGNING FIELD-SYMBOL(<fs_keys>).

          READ TABLE lt_relat ASSIGNING FIELD-SYMBOL(<fs_relat>) WITH KEY doc_uuid_h = <fs_keys>-docuuidh
                                                                          BINARY SEARCH.
          IF sy-subrc IS INITIAL.
            IF <fs_relat>-status_armazenado = 'S'.
              result = VALUE #( BASE result ( docuuidh   = <fs_keys>-docuuidh
                                              docuuidlot = <fs_keys>-docuuidlot
                                              %update    = if_abap_behv=>fc-o-disabled
                                              %delete    = if_abap_behv=>fc-o-disabled ) ).
            ELSE.
              result = VALUE #( BASE result ( docuuidh   = <fs_keys>-docuuidh
                                              docuuidlot = <fs_keys>-docuuidlot
                                              %update    = if_abap_behv=>fc-o-enabled
                                              %delete    = if_abap_behv=>fc-o-enabled ) ).
            ENDIF.
          ENDIF.

        ENDLOOP.
      ENDIF.
    ENDIF.

  ENDMETHOD.

ENDCLASS.
