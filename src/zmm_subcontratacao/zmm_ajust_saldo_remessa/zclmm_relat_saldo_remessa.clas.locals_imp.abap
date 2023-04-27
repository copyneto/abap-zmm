CLASS lcl_mm_relat_saldo_remessa DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS lock FOR LOCK
      IMPORTING keys FOR LOCK remessa.

    METHODS read FOR READ
      IMPORTING keys FOR READ remessa RESULT result.

    METHODS atrbpedido FOR MODIFY
      IMPORTING keys FOR ACTION remessa~atrbpedido.

    METHODS ajustarremess FOR MODIFY
      IMPORTING keys FOR ACTION remessa~ajustarremess.

ENDCLASS.

CLASS lcl_mm_relat_saldo_remessa IMPLEMENTATION.

  METHOD lock.
    IF sy-subrc IS INITIAL.
    ENDIF.
  ENDMETHOD.

  METHOD read.
    IF sy-subrc IS INITIAL.
    ENDIF.
  ENDMETHOD.

  METHOD atrbpedido.

    DATA(lo_sld_remessa) = NEW zclmm_ajst_sald_remessa( ).

    DATA(ls_keys) = keys[ 1 ].

    DATA(ls_docdata) = VALUE zsmm_subc_saveatrib( rsnum     = ls_keys-rsnum
                                                  rspos     = ls_keys-rspos
                                                  ebeln_new = ls_keys-%param-pednv ).

    lo_sld_remessa->atribuir_pedido( EXPORTING is_key    = ls_docdata
                                     IMPORTING es_return = DATA(ls_return) ).

    APPEND VALUE #( rsnum = ls_keys-rsnum
                    rspos = ls_keys-rspos
                    %msg  = new_message( id       = ls_return-id
                                         number   = ls_return-number
                                         v1       = ls_return-message_v1
                                         v2       = ls_return-message_v2
                                         v3       = ls_return-message_v3
                                         v4       = ls_return-message_v4
                                         severity =  CONV #( ls_return-type ) ) ) TO reported-remessa.

  ENDMETHOD.

  METHOD ajustarremess.

    DATA(ls_keys) = keys[ 1 ].

    DATA(lo_ajust_rems) = NEW zclmm_ajst_sald_remessa( ).

    DATA(ls_docdata) = VALUE zsmm_subc_saveatrib( rsnum = ls_keys-rsnum
                                                  rspos = ls_keys-rspos ).

    lo_ajust_rems->ajustar_remessa( EXPORTING is_key    = ls_docdata
                                    IMPORTING et_return = DATA(lt_return) ).

    LOOP AT lt_return ASSIGNING FIELD-SYMBOL(<fs_return>) .

      APPEND VALUE #( rsnum = ls_keys-rsnum
                      rspos = ls_keys-rspos
                      %msg  = new_message( id       = <fs_return>-id
                                           number   = <fs_return>-number
                                           v1       = <fs_return>-message_v1
                                           v2       = <fs_return>-message_v2
                                           v3       = <fs_return>-message_v3
                                           v4       = <fs_return>-message_v4
                                           severity =  CONV #( <fs_return>-type ) ) ) TO reported-remessa.

    ENDLOOP.

  ENDMETHOD.

ENDCLASS.

CLASS lcl_mm_relat_saldo_remessa_fin DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.

    METHODS check_before_save REDEFINITION.

    METHODS finalize          REDEFINITION.

    METHODS save              REDEFINITION.

ENDCLASS.

CLASS lcl_mm_relat_saldo_remessa_fin IMPLEMENTATION.

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
