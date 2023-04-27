CLASS lcl_expedicao DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS read FOR READ
      IMPORTING keys FOR READ expedicao RESULT result.

    METHODS expedicao FOR MODIFY
      IMPORTING keys FOR ACTION expedicao~expedicao.

    METHODS get_features FOR FEATURES
      IMPORTING keys REQUEST requested_features FOR expedicao RESULT result.

ENDCLASS.

CLASS lcl_expedicao IMPLEMENTATION.

  METHOD read.
    IF sy-subrc IS INITIAL.
    ENDIF.
  ENDMETHOD.

  METHOD expedicao.

    DATA: lt_mark TYPE STANDARD TABLE OF zsmm_subc_marc_line.

    DATA(lo_object) = NEW zclmm_exped_espc_subctrt( ).

    LOOP AT keys ASSIGNING FIELD-SYMBOL(<fs_keys>).

      lt_mark = VALUE #( BASE lt_mark ( rsnum = <fs_keys>-rsnum
                                        rspos = <fs_keys>-rspos
                                        vbeln = <fs_keys>-vbeln ) ).

    ENDLOOP.

    DATA(ls_key) = keys[ 1 ].

    IF ls_key-%param IS NOT INITIAL.
      DATA(ls_xml_transp) = VALUE zsmm_subc_xml_transp( xml_transp = ls_key-%param-xml_transp
*                                                        transptdr  = ls_key-%param-transptdr
                                                        incoterms1 = 'SFR' "ls_key-%param-incoterms1
                                                        incoterms2 = 'SFR' "ls_key-%param-incoterms2
*                                                        traid      = ls_key-%param-traid
                                                        txsdc = ls_key-%param-txsdc
                                                        ).
    ENDIF.

    lo_object->expedicao( EXPORTING is_xml_trasnp = ls_xml_transp
                                    it_keys       = lt_mark
                          IMPORTING et_return     = DATA(lt_return) ).

    LOOP AT lt_return ASSIGNING FIELD-SYMBOL(<fs_return>).

      APPEND VALUE #( rsnum = ls_key-rsnum
                      rspos = ls_key-rspos
                      %msg  = new_message( id       = <fs_return>-id
                                           number   = <fs_return>-number
                                           v1       = <fs_return>-message_v1
                                           v2       = <fs_return>-message_v2
                                           v3       = <fs_return>-message_v3
                                           v4       = <fs_return>-message_v4
                                           severity =  CONV #( <fs_return>-type ) ) ) TO reported-expedicao.
    ENDLOOP.

  ENDMETHOD.

  METHOD get_features.

    IF keys[] IS NOT INITIAL.

      SELECT rsnum,
             rspos,
             vbeln,
             status
        FROM zi_mm_expedinsum_espc_subcontr
         FOR ALL ENTRIES IN @keys
       WHERE rsnum = @keys-rsnum
         AND rspos = @keys-rspos
         AND vbeln = @keys-vbeln
        INTO TABLE @DATA(lt_relat).

      IF sy-subrc IS INITIAL.
        SORT lt_relat BY rsnum
                         rspos
                         vbeln.

        LOOP AT keys ASSIGNING FIELD-SYMBOL(<fs_keys>).

          READ TABLE lt_relat ASSIGNING FIELD-SYMBOL(<fs_relat>) WITH KEY rsnum = <fs_keys>-rsnum
                                                                          rspos = <fs_keys>-rspos
                                                                          vbeln = <fs_keys>-vbeln
                                                                          BINARY SEARCH.
          IF sy-subrc IS INITIAL.
            IF <fs_relat>-status = 'Pendente'.
              result = VALUE #( BASE result ( rsnum = <fs_keys>-rsnum
                                              rspos = <fs_keys>-rspos
                                              vbeln = <fs_keys>-vbeln
                                              %action-expedicao = if_abap_behv=>fc-o-enabled ) ).
            ELSE.
              result = VALUE #( BASE result ( rsnum = <fs_keys>-rsnum
                                              rspos = <fs_keys>-rspos
                                              vbeln = <fs_keys>-vbeln
                                              %action-expedicao = if_abap_behv=>fc-o-disabled ) ).
            ENDIF.
          ENDIF.

        ENDLOOP.
      ENDIF.
    ENDIF.
  ENDMETHOD.

ENDCLASS.

CLASS lcl_zi_mm_expedinsum_espc_subc DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.

    METHODS check_before_save REDEFINITION.

    METHODS finalize          REDEFINITION.

    METHODS save              REDEFINITION.

ENDCLASS.

CLASS lcl_zi_mm_expedinsum_espc_subc IMPLEMENTATION.

  METHOD check_before_save.
    IF sy-subrc IS INITIAL.
    ENDIF.
  ENDMETHOD.

  METHOD finalize.
    IF sy-subrc IS INITIAL.
    ENDIF.
  ENDMETHOD.

  METHOD save.
    IF sy-subrc IS INITIAL.
    ENDIF.
  ENDMETHOD.

ENDCLASS.
