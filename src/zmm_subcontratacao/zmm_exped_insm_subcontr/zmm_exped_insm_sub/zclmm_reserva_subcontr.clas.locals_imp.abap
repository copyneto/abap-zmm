CLASS lcl_zi_mm_rkpf_reserva DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS read FOR READ
      IMPORTING keys FOR READ zi_mm_rkpf_reserva RESULT result.

    METHODS update FOR MODIFY
      IMPORTING entities FOR UPDATE zi_mm_rkpf_reserva.

    METHODS cba_item FOR MODIFY
      IMPORTING entities_cba FOR CREATE zi_mm_rkpf_reserva\_item.

    METHODS rba_item FOR READ
      IMPORTING keys_rba FOR READ zi_mm_rkpf_reserva\_item FULL result_requested RESULT result LINK association_links.

ENDCLASS.


CLASS lcl_zi_mm_rkpf_reserva IMPLEMENTATION.

  METHOD read.
    RETURN.
  ENDMETHOD.

  METHOD cba_item.
    RETURN.
  ENDMETHOD.

  METHOD rba_item.
    RETURN.
  ENDMETHOD.

  METHOD update.
    RETURN.
  ENDMETHOD.

ENDCLASS.

CLASS lcl_zi_mm_resb_reserva_item DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS delete FOR MODIFY
      IMPORTING keys FOR DELETE zi_mm_resb_reserva_item.

    METHODS update FOR MODIFY
      IMPORTING entities FOR UPDATE zi_mm_resb_reserva_item.

    METHODS read FOR READ
      IMPORTING keys FOR READ zi_mm_resb_reserva_item RESULT result.
    METHODS expedicao FOR MODIFY
      IMPORTING keys FOR ACTION zi_mm_resb_reserva_item~expedicao.
    METHODS duplicar FOR MODIFY
      IMPORTING keys FOR ACTION zi_mm_resb_reserva_item~duplicar. " RESULT result.
    METHODS get_features FOR FEATURES
      IMPORTING keys REQUEST requested_features FOR zi_mm_resb_reserva_item RESULT result.

ENDCLASS.

CLASS lcl_zi_mm_resb_reserva_item IMPLEMENTATION.

  METHOD get_features.
    RETURN.
*    IF keys[] IS NOT INITIAL.
*
*      SELECT rsnum,
*             rspos,
*             item,
*             qtdepicking
*        FROM zi_mm_resb_reserva_item
*         FOR ALL ENTRIES IN @keys
*       WHERE rsnum = @keys-rsnum
*         AND rspos = @keys-rspos
*         AND item  = @keys-item
*        INTO TABLE @DATA(lt_relat).
*      IF sy-subrc IS INITIAL.
*        SORT lt_relat BY rsnum rspos item.
*
*        LOOP AT keys ASSIGNING FIELD-SYMBOL(<fs_keys>).
*          READ TABLE lt_relat ASSIGNING FIELD-SYMBOL(<fs_relat>) WITH KEY
*          rsnum = <fs_keys>-rsnum
*          rspos = <fs_keys>-rspos
*          item  = <fs_keys>-item
*          BINARY SEARCH.
*          IF sy-subrc IS INITIAL.
*            IF <fs_relat>-qtdepicking > 0.
*              result = VALUE #( BASE result ( rsnum = <fs_keys>-rsnum
*                                              rspos = <fs_keys>-rspos
*                                              item  = <fs_keys>-item
*                                              %action-expedicao = if_abap_behv=>fc-o-enabled ) ).
*            ELSE.
*              result = VALUE #( BASE result ( rsnum = <fs_keys>-rsnum
*                                              rspos = <fs_keys>-rspos
*                                              item  = <fs_keys>-item
*                                              %action-expedicao = if_abap_behv=>fc-o-disabled ) ).
*            ENDIF.
*          ENDIF.
*        ENDLOOP.
*      ENDIF.
*    ENDIF.
  ENDMETHOD.



  METHOD delete.
    LOOP AT keys ASSIGNING FIELD-SYMBOL(<fs_keys>).
      DELETE FROM ztmm_sb_picking
      WHERE rsnum = @<fs_keys>-rsnum
        AND rspos = @<fs_keys>-rspos
        AND item  = @<fs_keys>-item.
    ENDLOOP.
  ENDMETHOD.

  METHOD update.
    LOOP AT entities ASSIGNING FIELD-SYMBOL(<fs_entity>).

      SELECT SINGLE * FROM zi_mm_resb_reserva_item
      WHERE rsnum = @<fs_entity>-rsnum
        AND rspos = @<fs_entity>-rspos
        AND ( item IS NULL OR item = @<fs_entity>-item )
       INTO @DATA(ls_reserva_item).
      CHECK sy-subrc = 0.

      DATA(ls_ztmm_sb_picking) = VALUE ztmm_sb_picking(
        rsnum     = <fs_entity>-rsnum
        rspos     = <fs_entity>-rspos
*        item      = COND #( WHEN <fs_entity>-item IS INITIAL THEN cl_system_uuid=>create_uuid_x16_static( ) ELSE <fs_entity>-item  )
        item      = <fs_entity>-item
        charg     = COND #( WHEN <fs_entity>-%control-charg = '01'
                            THEN <fs_entity>-charg
                            ELSE ls_reserva_item-charg )
*        vbeln     = ls_reserva_item-vbeln
        lgort     = COND #( WHEN <fs_entity>-%control-lgort = '01'
                            THEN <fs_entity>-lgort
                            ELSE ls_reserva_item-lgort )
        picking     = COND #( WHEN <fs_entity>-%control-qtdepicking = '01'
                            THEN <fs_entity>-qtdepicking
                            ELSE ls_reserva_item-qtdepicking )
        fornecida     = COND #( WHEN <fs_entity>-%control-quantidade = '01'
                            THEN <fs_entity>-quantidade
                            ELSE ls_reserva_item-quantidade )
        meins     = COND #( WHEN <fs_entity>-%control-meins = '01'
                            THEN <fs_entity>-meins
                            ELSE ls_reserva_item-meins )
        dats      = sy-datum
        user_proc = sy-uname
      ).

*      DATA(lv_qtdpicking) = conv BDMNG( <fs_entity>-qtdepicking ).
*      DATA(lv_quantidade) = conv BDMNG( <fs_entity>-quantidade ).
      IF ls_ztmm_sb_picking-picking > ls_ztmm_sb_picking-fornecida.
        APPEND VALUE #( "%tky        =
         rsnum =   ls_ztmm_sb_picking-rsnum
         rspos =   ls_ztmm_sb_picking-rspos
         item  =   <fs_entity>-item "ls_ztmm_sb_picking-item
         %msg        = new_message( id       = 'ZMM_SUBCONTRTC' "ls_return-id
           number   = '050' "ls_return-number
*           v1       = ls_return-message_v1
*           v2       = ls_return-message_v2
*           v3       = ls_return-message_v3
*           v4       = ls_return-message_v4
           severity = CONV #( 'E' ) ) "ls_return-type ) )
         ) TO reported-zi_mm_resb_reserva_item.
        EXIT.
*        APPEND VALUE #( "%tky        =
*         rsnum =   ls_ztmm_sb_picking-rsnum
*         rspos =   ls_ztmm_sb_picking-rspos
*         item  =   ls_ztmm_sb_picking-item
*         ) TO mapped-zi_mm_resb_reserva_item.

      ELSE.
*        APPEND VALUE #( "%tky        =
*         rsnum =   ls_ztmm_sb_picking-rsnum
*         rspos =   ls_ztmm_sb_picking-rspos
*         item  =   ls_ztmm_sb_picking-item
*                        %msg        = new_message( id       = 'ZMM_SUBCONTRTC' "ls_return-id
*                                                   number   = '050' "ls_return-number
**                                                 v1       = ls_return-message_v1
**                                                 v2       = ls_return-message_v2
**                                                 v3       = ls_return-message_v3
**                                                 v4       = ls_return-message_v4
*                                                   severity = CONV #( 'S' ) ) "ls_return-type ) )
*          %element = VALUE #( item = '01' )
*          ) TO reported-zi_mm_resb_reserva_item.
*
*        APPEND VALUE #( "%tky        =
*         rsnum =   ls_ztmm_sb_picking-rsnum
*         rspos =   ls_ztmm_sb_picking-rspos
*         item  =   ls_ztmm_sb_picking-item
*
*         )  TO mapped-zi_mm_resb_reserva_item.

*        MODIFY zi_mm_resb_reserva_item FROM ls_reserva_item.

        MODIFY ztmm_sb_picking FROM ls_ztmm_sb_picking.
      ENDIF.
    ENDLOOP.



  ENDMETHOD.

  METHOD read.
    RETURN.
  ENDMETHOD.

  METHOD expedicao.
    DATA: lt_keys TYPE zctgmm_subct_key.

    DATA(lo_object) = NEW zclmm_exped_subct_param( ).

    DATA(ls_keys) = keys[ 1 ].

    LOOP AT keys ASSIGNING FIELD-SYMBOL(<fs_keys>).
      SELECT SINGLE item, charg FROM zi_mm_resb_reserva_item
       WHERE rsnum = @<fs_keys>-rsnum
         AND rspos = @<fs_keys>-rspos
         AND ( item IS NULL OR item = @<fs_keys>-item )
        INTO @DATA(ls_reserva_item).

      lt_keys = VALUE #( BASE lt_keys (
        rsnum      = <fs_keys>-rsnum
        rspos      = <fs_keys>-rspos
        item       = ls_reserva_item-item "<fs_keys>-item
        charg      = ls_reserva_item-charg
        transptdr  = <fs_keys>-%param-transptdr
        incoterms1 = <fs_keys>-%param-incoterms1
        incoterms2 = <fs_keys>-%param-incoterms2
        traid      = <fs_keys>-%param-traid
        txsdc      = <fs_keys>-%param-txsdc  )
      ).
    ENDLOOP.

    IF lt_keys[] IS NOT INITIAL.
      lo_object->expedicao( EXPORTING it_keys   = lt_keys
                            IMPORTING et_return = DATA(lt_return) ).

      LOOP AT lt_return ASSIGNING FIELD-SYMBOL(<fs_return>).
        APPEND VALUE #(
        rsnum = ls_keys-rsnum
        rspos = ls_keys-rspos
        item  = ls_keys-item
        %msg  = new_message(
          id       = <fs_return>-id
          number   = <fs_return>-number
          v1       = <fs_return>-message_v1
          v2       = <fs_return>-message_v2
          v3       = <fs_return>-message_v3
          v4       = <fs_return>-message_v4
          severity =  CONV #( <fs_return>-type ) )
        ) TO reported-zi_mm_resb_reserva_item.
      ENDLOOP.
    ENDIF.

  ENDMETHOD.

  METHOD duplicar.

    LOOP AT keys ASSIGNING FIELD-SYMBOL(<fs_keys>).

      SELECT SINGLE * FROM zi_mm_resb_reserva_item
       WHERE rsnum = @<fs_keys>-rsnum
         AND rspos = @<fs_keys>-rspos
         AND ( item IS NULL OR item = @<fs_keys>-item )
        INTO @DATA(ls_reserva_item).
      IF sy-subrc = 0.
        IF <fs_keys>-item IS INITIAL.
          SELECT COUNT(*) FROM ztmm_sb_picking
           WHERE rsnum = @<fs_keys>-rsnum
            AND rspos = @<fs_keys>-rspos
            AND ( item IS NULL OR item = @<fs_keys>-item ).
          IF sy-subrc <> 0.
            DATA(ls_ztmm_sb_picking) = VALUE ztmm_sb_picking(
              rsnum     = ls_reserva_item-rsnum
              rspos     = ls_reserva_item-rspos
*          item      = cl_system_uuid=>create_uuid_x16_static( )
              charg     = ls_reserva_item-charg
*          vbeln     = ls_reserva_item-vbeln
              lgort     = ls_reserva_item-lgort
              picking   = ls_reserva_item-qtdepicking
              fornecida = ls_reserva_item-quantidade
              meins     = ls_reserva_item-meins
              dats      = sy-datum
              user_proc = sy-uname
            ).
            INSERT INTO ztmm_sb_picking VALUES ls_ztmm_sb_picking.
          ENDIF.
        ENDIF.

        try.
            ls_ztmm_sb_picking = value ztmm_sb_picking(
              rsnum     = ls_reserva_item-rsnum
              rspos     = ls_reserva_item-rspos
              item      = cl_system_uuid=>create_uuid_x16_static( )
              charg     = ls_reserva_item-charg
*          vbeln     = ls_reserva_item-vbeln
              lgort     = ls_reserva_item-lgort
              picking   = ls_reserva_item-qtdepicking
              fornecida = ls_reserva_item-quantidade
              meins     = ls_reserva_item-meins
              dats      = sy-datum
              user_proc = sy-uname
            ).
          catch cx_uuid_error.
            "handle exception
        endtry.
        INSERT INTO ztmm_sb_picking VALUES ls_ztmm_sb_picking.
      ENDIF.



*      IF <fs_keys>-item IS INITIAL.
*        ls_ztmm_sb_picking = VALUE ztmm_sb_picking(
*          rsnum     = ls_reserva_item-rsnum
*          rspos     = ls_reserva_item-rspos
*          item      = cl_system_uuid=>create_uuid_x16_static( )
*          charg     = ls_reserva_item-charg
**          vbeln     = ls_reserva_item-vbeln
*          lgort     = ls_reserva_item-lgort
*          picking   = ls_reserva_item-qtdepicking
*          fornecida = ls_reserva_item-quantidade
*          meins     = ls_reserva_item-meins
*          dats      = sy-datum
*          user_proc = sy-uname
*        ).
*        INSERT INTO ztmm_sb_picking VALUES ls_ztmm_sb_picking.
*
*      ENDIF.


*      MODIFY ztmm_sb_picking FROM ls_ztmm_sb_picking.

*      lt_keys = VALUE #( BASE lt_keys ( rsnum   = <fs_keys>-rsnum
**                                        rspos   = <fs_keys>-rspos
**                                        vbeln   = <fs_keys>-vbeln
*                                        picking = <fs_keys>-%param-picking ) ).

    ENDLOOP.
  ENDMETHOD.

ENDCLASS.

CLASS lcl_zi_mm_rkpf_reserva_saver DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.

    METHODS check_before_save REDEFINITION.

    METHODS finalize          REDEFINITION.

    METHODS save              REDEFINITION.

ENDCLASS.

CLASS lcl_zi_mm_rkpf_reserva_saver IMPLEMENTATION.

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
