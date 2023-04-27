CLASS lcl_subcont DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS read FOR READ
      IMPORTING keys FOR READ subcont RESULT result.

    METHODS atribpicking FOR MODIFY
      IMPORTING keys FOR ACTION subcont~atribpicking RESULT result.

    METHODS expedicao FOR MODIFY
      IMPORTING keys FOR ACTION subcont~expedicao. "RESULT result.

    METHODS get_features FOR FEATURES
      IMPORTING keys REQUEST requested_features FOR subcont RESULT result.

ENDCLASS.

CLASS lcl_subcont IMPLEMENTATION.

  METHOD read.
    IF sy-subrc IS INITIAL.
    ENDIF.
  ENDMETHOD.

  METHOD atribpicking.

    DATA: lt_keys TYPE zctgmm_subct_key.

    IF lines( keys ) <> 1.
      APPEND VALUE #( %msg  = new_message( id       = 'ZMM_SUBCONTRTC'
                                           number   = '032'
                                           severity =  CONV #( 'E' ) ) ) TO reported-subcont.
      EXIT.
    ENDIF.



    DATA(lo_object) = NEW zclmm_exped_subct_param( ).

    LOOP AT keys ASSIGNING FIELD-SYMBOL(<fs_keys>).

      lt_keys = VALUE #( BASE lt_keys ( rsnum   = <fs_keys>-rsnum
*                                        rspos   = <fs_keys>-rspos
*                                        vbeln   = <fs_keys>-vbeln
                                        picking = <fs_keys>-%param-picking ) ).

    ENDLOOP.

    IF lt_keys[] IS NOT INITIAL.

      DATA(ls_keys) = VALUE #( lt_keys[ 1 ] OPTIONAL ).

      lo_object->atribuir_picking( EXPORTING it_keys   = lt_keys
                                   IMPORTING et_return = DATA(lt_return) ).

      LOOP AT lt_return ASSIGNING FIELD-SYMBOL(<fs_return>).

        APPEND VALUE #( rsnum = ls_keys-rsnum
*                        rspos = ls_keys-rspos
*                        vbeln = ls_keys-vbeln
                        %msg  = new_message( id       = <fs_return>-id
                                             number   = <fs_return>-number
                                             v1       = <fs_return>-message_v1
                                             v2       = <fs_return>-message_v2
                                             v3       = <fs_return>-message_v3
                                             v4       = <fs_return>-message_v4
                                             severity =  CONV #( <fs_return>-type ) ) ) TO reported-subcont.
      ENDLOOP.

    ENDIF.

  ENDMETHOD.

  METHOD expedicao.

    DATA: lt_keys TYPE zctgmm_subct_key.

    DATA(lo_object) = NEW zclmm_exped_subct_param( ).

    DATA(ls_keys) = keys[ 1 ].

    LOOP AT keys ASSIGNING FIELD-SYMBOL(<fs_keys>).

      lt_keys = VALUE #( BASE lt_keys ( rsnum      = <fs_keys>-rsnum
*                                        rspos      = <fs_keys>-rspos
*                                        vbeln      = <fs_keys>-vbeln
                                        transptdr  = <fs_keys>-%param-transptdr
                                        incoterms1 = <fs_keys>-%param-incoterms1
                                        incoterms2 = <fs_keys>-%param-incoterms2
                                        traid      = <fs_keys>-%param-traid ) ).
    ENDLOOP.

    IF lt_keys[] IS NOT INITIAL.
      lo_object->expedicao( EXPORTING it_keys   = lt_keys
                            IMPORTING et_return = DATA(lt_return) ).

      LOOP AT lt_return ASSIGNING FIELD-SYMBOL(<fs_return>).

        APPEND VALUE #( rsnum = ls_keys-rsnum
*                        rspos = ls_keys-rspos
                        %msg  = new_message( id       = <fs_return>-id
                                             number   = <fs_return>-number
                                             v1       = <fs_return>-message_v1
                                             v2       = <fs_return>-message_v2
                                             v3       = <fs_return>-message_v3
                                             v4       = <fs_return>-message_v4
                                             severity =  CONV #( <fs_return>-type ) ) ) TO reported-subcont.
      ENDLOOP.
    ENDIF.

  ENDMETHOD.

  METHOD get_features.

    IF keys[] IS NOT INITIAL.
      SELECT rsnum,
             rspos,
             vbeln,
             status
        FROM zi_mm_exped_subcontrat
         FOR ALL ENTRIES IN @keys
       WHERE rsnum = @keys-rsnum
*         AND rspos = @keys-rspos
*         AND vbeln = @keys-vbeln
        INTO TABLE @DATA(lt_relat).

      IF sy-subrc IS INITIAL.
        SORT lt_relat BY rsnum
                         rspos
                         vbeln.

        LOOP AT keys ASSIGNING FIELD-SYMBOL(<fs_keys>).

          READ TABLE lt_relat ASSIGNING FIELD-SYMBOL(<fs_relat>) WITH KEY rsnum = <fs_keys>-rsnum
*                                                                          rspos = <fs_keys>-rspos
*                                                                          vbeln = <fs_keys>-vbeln
                                                                          BINARY SEARCH.
          IF sy-subrc IS INITIAL.
            IF <fs_relat>-status = TEXT-001.
              result = VALUE #( BASE result ( rsnum = <fs_keys>-rsnum
*                                              rspos = <fs_keys>-rspos
*                                              vbeln = <fs_keys>-vbeln
                                              %action-atribpicking = if_abap_behv=>fc-o-enabled
                                              %action-expedicao    = if_abap_behv=>fc-o-enabled ) ).
            ELSEIF <fs_relat>-status = TEXT-002.
              result = VALUE #( BASE result ( rsnum = <fs_keys>-rsnum
*                                              rspos = <fs_keys>-rspos
*                                              vbeln = <fs_keys>-vbeln
                                              %action-atribpicking = if_abap_behv=>fc-o-enabled
                                              %action-expedicao    = if_abap_behv=>fc-o-disabled ) ).
            ELSE.
              result = VALUE #( BASE result ( rsnum = <fs_keys>-rsnum
*                                              rspos = <fs_keys>-rspos
*                                              vbeln = <fs_keys>-vbeln
                                              %action-atribpicking = if_abap_behv=>fc-o-disabled
                                              %action-expedicao    = if_abap_behv=>fc-o-disabled ) ).
            ENDIF.
          ENDIF.

        ENDLOOP.
      ENDIF.
    ENDIF.

  ENDMETHOD.

ENDCLASS.

CLASS lcl_zi_mm_exped_subcontrat DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.

    METHODS check_before_save REDEFINITION.

    METHODS finalize          REDEFINITION.

    METHODS save              REDEFINITION.

ENDCLASS.

CLASS lcl_zi_mm_exped_subcontrat IMPLEMENTATION.

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
