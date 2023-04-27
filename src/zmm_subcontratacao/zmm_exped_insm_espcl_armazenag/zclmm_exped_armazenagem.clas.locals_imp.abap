CLASS lcl_armazenagem DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS read FOR READ
      IMPORTING keys FOR READ armazenagem RESULT result.

    METHODS expedicao FOR MODIFY
      IMPORTING keys FOR ACTION armazenagem~expedicao.

    METHODS get_features FOR FEATURES
      IMPORTING keys REQUEST requested_features FOR armazenagem RESULT result.

ENDCLASS.

CLASS lcl_armazenagem IMPLEMENTATION.

  METHOD read.
    IF sy-subrc IS INITIAL.
    ENDIF.
  ENDMETHOD.

  METHOD expedicao.

    CONSTANTS: lc_sem_frete TYPE inco1 VALUE 'SFR'.

    DATA: lt_keys TYPE STANDARD TABLE OF zsmm_armaz_key.

    DATA(lo_object) = NEW zclmm_exped_espc_armazgm( ).

    DATA(ls_keys) = keys[ 1 ].

    DATA(ls_xml_trasnp) = VALUE zsmm_subc_xml_transp(
*      transptdr  = ls_keys-%param-transptdr
*      incoterms1 = ls_keys-%param-incoterms1
*      incoterms2 = ls_keys-%param-incoterms2
*      traid      = ls_keys-%param-traid
      incoterms1 = lc_sem_frete
      incoterms2 = lc_sem_frete
      txsdc      = ls_keys-%param-txsdc ).

    LOOP AT keys ASSIGNING FIELD-SYMBOL(<fs_keys>).

      lt_keys = VALUE #( BASE lt_keys ( docnum = <fs_keys>-docnum
                                        itmnum = <fs_keys>-itmnum ) ).

    ENDLOOP.

    lo_object->expedicao( EXPORTING is_xml_trasnp = ls_xml_trasnp
                                    it_keys       = lt_keys
                          IMPORTING et_return     = DATA(lt_return) ).

    LOOP AT lt_return ASSIGNING FIELD-SYMBOL(<fs_return>).

      APPEND VALUE #( docnum = ls_keys-docnum
                      itmnum = ls_keys-itmnum
                      %msg  = new_message( id       = <fs_return>-id
                                           number   = <fs_return>-number
                                           v1       = <fs_return>-message_v1
                                           v2       = <fs_return>-message_v2
                                           v3       = <fs_return>-message_v3
                                           v4       = <fs_return>-message_v4
                                           severity =  CONV #( <fs_return>-type ) ) ) TO reported-armazenagem.
    ENDLOOP.

  ENDMETHOD.

  METHOD get_features.

    IF keys[] IS NOT INITIAL.

      SELECT docnum,
             itmnum,
             status
        FROM zi_mm_exped_armazenagem
         FOR ALL ENTRIES IN @keys
       WHERE docnum = @keys-docnum
         AND itmnum = @keys-itmnum
        INTO TABLE @DATA(lt_relat).

      IF sy-subrc IS INITIAL.
        SORT lt_relat BY docnum
                         itmnum.

        LOOP AT keys ASSIGNING FIELD-SYMBOL(<fs_keys>).

          READ TABLE lt_relat ASSIGNING FIELD-SYMBOL(<fs_relat>) WITH KEY docnum = <fs_keys>-docnum
                                                                          itmnum = <fs_keys>-itmnum
                                                                          BINARY SEARCH.
          IF sy-subrc IS INITIAL.
            IF <fs_relat>-status = 'Pendente'.
              result = VALUE #( BASE result ( docnum = <fs_keys>-docnum
                                              itmnum = <fs_keys>-itmnum
                                              %action-expedicao = if_abap_behv=>fc-o-enabled ) ).
            ELSE.
              result = VALUE #( BASE result ( docnum = <fs_keys>-docnum
                                              itmnum = <fs_keys>-itmnum
                                              %action-expedicao = if_abap_behv=>fc-o-disabled ) ).
            ENDIF.
          ENDIF.

        ENDLOOP.
      ENDIF.
    ENDIF.

  ENDMETHOD.

ENDCLASS.

CLASS lcl_zi_mm_exped_armazenagem DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.

    METHODS check_before_save REDEFINITION.

    METHODS finalize          REDEFINITION.

    METHODS save              REDEFINITION.

ENDCLASS.

CLASS lcl_zi_mm_exped_armazenagem IMPLEMENTATION.

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
