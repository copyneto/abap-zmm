CLASS zclmm_po_cust DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_badi_interface .
    INTERFACES if_ex_me_process_po_cust .
  PROTECTED SECTION.
  PRIVATE SECTION.

    TYPES:
      ty_tp_ped TYPE RANGE OF bsart .
    TYPES:
      ty_tp_stat TYPE RANGE OF char2 .
    TYPES:
      ty_tp_net_emb TYPE RANGE OF ztca_param_val-low.

    CONSTANTS gc_modulo TYPE ze_param_modulo VALUE 'MM' ##NO_TEXT.
    CONSTANTS gc_chave1 TYPE ztca_param_par-chave1 VALUE 'GRAOVERDE' ##NO_TEXT.
    CONSTANTS gc_chave2 TYPE ztca_param_par-chave2 VALUE 'CLASSIFICACAO' ##NO_TEXT.
    CONSTANTS gc_bsart TYPE ztca_param_par-chave3 VALUE 'BSART' ##NO_TEXT.
    CONSTANTS gc_procstat TYPE ztca_param_par-chave3 VALUE 'PROCSTAT' ##NO_TEXT.
    CONSTANTS gc_status_classif TYPE ze_status_classific VALUE 'N' ##NO_TEXT.
    CONSTANTS gc_status_classif_s TYPE ze_status_classific VALUE 'S' ##NO_TEXT.
    DATA gr_tp_ped TYPE ty_tp_ped .
    DATA gr_tp_stat TYPE ty_tp_stat .
    CONSTANTS gc_net_emb TYPE ztca_param_par-chave3 VALUE 'NET_EMB' ##NO_TEXT.
    CONSTANTS gc_perc_cor TYPE ztca_param_par-chave3 VALUE 'PERC_COR' ##NO_TEXT.
    DATA gr_net_emb TYPE ty_tp_net_emb .
    DATA gr_perc_corr TYPE ty_tp_net_emb.
ENDCLASS.



CLASS ZCLMM_PO_CUST IMPLEMENTATION.


  METHOD if_ex_me_process_po_cust~check.

    INCLUDE mm_messages_mac.

    CONSTANTS: BEGIN OF lc_param,
                 modulo	TYPE ze_param_modulo VALUE 'MM',
                 chave1	TYPE ze_param_chave VALUE 'GAP_292',
                 chave2	TYPE ze_param_chave VALUE 'BSART',
                 chave3	TYPE ze_param_chave_3 VALUE 'TP_PEDID',
               END OF lc_param.

    TYPES: BEGIN OF ty_mdpm_key,
             stlty TYPE stlty,
             stlnr TYPE stnum,
             stknr TYPE stlkn,
             stkza TYPE cim_count,
           END OF ty_mdpm_key.
    TYPES:
      ty_tt_mdpmx TYPE TABLE OF mdpm_x .
    TYPES: BEGIN OF ty_eban,
             banfn TYPE banfn,
             bnfpo TYPE bnfpo,
             ebelp TYPE ebelp,
           END OF ty_eban.

    DATA: lt_mdpm_key TYPE TABLE OF ty_mdpm_key,
          lt_stb      TYPE TABLE OF stpox,
          lt_bom_tmp  TYPE mmpur_t_mdpm,
          lv_matnr    TYPE matnr,
          lt_eban     TYPE TABLE OF ty_eban.

    DATA: lv_zz1_verid TYPE ze_verid_list,
          lv_zz1_matnr TYPE ze_matnr_prd_ind.

    FIELD-SYMBOLS: <fs_xmdpm>     TYPE mdpm_x,
                   <fs_tab_xmdpm> TYPE me_mdpm_x_tty,
                   <fs_mdpa>      TYPE mdpa.

    DATA: ls_poheader  TYPE mepoheader,
          lt_poitem    TYPE purchase_order_items, " Table IF_PURCHASE_ORDER_ITEM_MM
          ls_items     TYPE purchase_order_item, " Line IF_PURCHASE_ORDER_ITEM_MM
          lt_esll      TYPE mmsrv_esll,
          ls_item_data TYPE mepoitem,
          lt_item_data TYPE tab_mepoitem,
          lo_item      TYPE REF TO cl_po_item_handle_mm.

    ls_poheader = im_header->get_data( ).
    lt_poitem = im_header->get_items( ).


    SELECT sign, opt, low, high
      FROM ztca_param_val
      WHERE modulo = @lc_param-modulo
        AND chave1 = @lc_param-chave1
        AND chave2 = @lc_param-chave2
        AND chave3 = @lc_param-chave3
      INTO TABLE @DATA(lt_bsart).

    IF lt_bsart[] IS NOT INITIAL.
      IF ls_poheader-bsart IN lt_bsart.
        LOOP AT lt_poitem INTO ls_items.
          ls_item_data = ls_items-item->get_data( ).
          IF ls_item_data-banfn IS INITIAL.
            mmpur_message_forced 'E' 'ZMM_SUBCONTRTC' '046' ls_item_data-ebelp '' '' ''.
            ch_failed = abap_true.
            EXIT.
          ENDIF.
          IF ls_item_data-bnfpo IS INITIAL.
            mmpur_message_forced 'E' 'ZMM_SUBCONTRTC' '047' ls_item_data-ebelp '' '' ''.
            ch_failed = abap_true.
            EXIT.
          ENDIF.

          SELECT SINGLE banfn
            FROM eban
            WHERE banfn = @ls_item_data-banfn
              AND bsart = @ls_poheader-bsart
            INTO @DATA(lv_banfn).

          IF  sy-subrc <> 0.
            mmpur_message_forced 'E' 'ZMM_SUBCONTRTC' '048' ls_item_data-ebelp ls_poheader-bsart '' ''.
            ch_failed = abap_true.
            EXIT.
          ENDIF.

          READ TABLE lt_eban ASSIGNING FIELD-SYMBOL(<fs_eban>) WITH KEY  banfn = ls_item_data-banfn
                                                                         bnfpo = ls_item_data-bnfpo BINARY SEARCH.

          IF <fs_eban> IS ASSIGNED.
            mmpur_message_forced 'E' 'ZMM_SUBCONTRTC' '049' ls_item_data-ebelp ls_item_data-banfn ls_item_data-bnfpo <fs_eban>-ebelp.
            UNASSIGN <fs_eban>.
            ch_failed = abap_true.
            EXIT.
          ENDIF.

        ENDLOOP.
      ENDIF.
    ENDIF.

  ENDMETHOD.


  METHOD if_ex_me_process_po_cust~close.
    RETURN.
  ENDMETHOD.


  METHOD if_ex_me_process_po_cust~fieldselection_header.
    RETURN.
  ENDMETHOD.


  METHOD if_ex_me_process_po_cust~fieldselection_header_refkeys.
    RETURN.
  ENDMETHOD.


  METHOD if_ex_me_process_po_cust~fieldselection_item.
    RETURN.
  ENDMETHOD.


  METHOD if_ex_me_process_po_cust~fieldselection_item_refkeys.
    RETURN.
  ENDMETHOD.


  METHOD if_ex_me_process_po_cust~initialize.
    RETURN.
  ENDMETHOD.


  METHOD if_ex_me_process_po_cust~open.
    RETURN.
  ENDMETHOD.


  METHOD if_ex_me_process_po_cust~post.
***********************************************************************
***                      © 3corações                                ***
***********************************************************************
***                                                                   *
*** DESCRIÇÃO: 489 - Classificação do lote de Compra (Grão Verde)     *
*** AUTOR    : [Denilson Pasini Pina] –[META]                         *
*** FUNCIONAL: [Luis Moraes]                                          *
*** DATA     : [10.10.2021]                                           *
***********************************************************************
*** HISTÓRICO DAS MODIFICAÇÕES                                        *
***-------------------------------------------------------------------*
*** DATA      | AUTOR        | DESCRIÇÃO                              *
***-------------------------------------------------------------------*
***           |              |                                        *
***********************************************************************


    DATA: lt_ztmm_control_cla TYPE TABLE OF ztmm_control_cla.
    DATA: lv_lagmg TYPE ztmm_control_cla-lagmg,
          lv_menge TYPE bstmg.

    DATA(lo_param) = NEW zclca_tabela_parametros( ).

    TRY.
        lo_param->m_get_range( EXPORTING iv_modulo = me->gc_modulo
                                         iv_chave1 = me->gc_chave1
                                         iv_chave2 = me->gc_chave2
                                         iv_chave3 = me->gc_bsart
                               IMPORTING et_range  = gr_tp_ped ).

      CATCH zcxca_tabela_parametros.
    ENDTRY.


    TRY.
        lo_param->m_get_range( EXPORTING iv_modulo = me->gc_modulo
                                         iv_chave1 = me->gc_chave1
                                         iv_chave2 = me->gc_chave2
                                         iv_chave3 = me->gc_procstat
                               IMPORTING et_range  = gr_tp_stat ).

      CATCH zcxca_tabela_parametros.
    ENDTRY.


    TRY.
        lo_param->m_get_range( EXPORTING iv_modulo = me->gc_modulo
                                         iv_chave1 = me->gc_chave1
                                         iv_chave2 = me->gc_chave2
                                         iv_chave3 = me->gc_net_emb
                               IMPORTING et_range  = gr_net_emb ).

      CATCH zcxca_tabela_parametros.
    ENDTRY.

    TRY.
        lo_param->m_get_range( EXPORTING iv_modulo = me->gc_modulo
                                         iv_chave1 = me->gc_chave1
                                         iv_chave2 = me->gc_chave2
                                         iv_chave3 = me->gc_perc_cor
                               IMPORTING et_range  = gr_perc_corr ).

      CATCH zcxca_tabela_parametros.
    ENDTRY.

    TRY.
        DATA(lv_net_emb) = gr_net_emb[ 1 ]-low.
        TRANSLATE lv_net_emb USING '. '.
        TRANSLATE lv_net_emb USING ',.'.
        CONDENSE lv_net_emb NO-GAPS.
      CATCH cx_sy_itab_line_not_found INTO DATA(lo_exception).
    ENDTRY.

    TRY.
        DATA(lv_perc_corretagem) = gr_perc_corr[ 1 ]-low.
        TRANSLATE lv_perc_corretagem USING '. '.
        TRANSLATE lv_perc_corretagem USING ',.'.
        CONDENSE lv_perc_corretagem NO-GAPS.
      CATCH cx_sy_itab_line_not_found INTO lo_exception.
    ENDTRY.

    DATA(ls_header) = im_header->get_data( ).
*      me->get_hardcode( ).

    IF ( gr_tp_ped IS NOT INITIAL AND ls_header-bsart IN gr_tp_ped )
    AND ( gr_tp_stat IS NOT INITIAL AND ls_header-procstat IN gr_tp_stat ).

      CONVERT DATE sy-datlo TIME sy-timlo INTO TIME STAMP DATA(lv_timestamp)
        TIME ZONE sy-zonlo.

      DATA(lt_items) = im_header->get_items( ).

      LOOP AT lt_items ASSIGNING FIELD-SYMBOL(<fs_item>).
        DATA(ls_detail) = <fs_item>-item->get_data( ).

        SELECT SINGLE meins FROM mara
          WHERE matnr EQ @ls_detail-matnr
          INTO @DATA(lv_meins).                      "#EC CI_SEL_NESTED

        lv_menge = ls_detail-menge.

        IF lv_meins NE ls_detail-meins.
          CALL FUNCTION 'MD_CONVERT_MATERIAL_UNIT'
            EXPORTING
              i_matnr              = ls_detail-matnr
              i_in_me              = ls_detail-meins
              i_out_me             = lv_meins
              i_menge              = ls_detail-menge
            IMPORTING
              e_menge              = lv_menge
            EXCEPTIONS
              error_in_application = 1
              error                = 2
              OTHERS               = 3.
          IF sy-subrc <> 0.
            CLEAR lv_menge.
          ENDIF.
        ENDIF.

        TRY.
            lv_lagmg =  lv_menge *  ls_detail-umrez / ls_detail-umrez .
          CATCH cx_sy_zerodivide.
        ENDTRY.

        SELECT SINGLE ebeln, ebelp, status_classific
        FROM ztmm_control_cla
        WHERE ebeln = @ls_detail-ebeln
        AND   ebelp = @ls_detail-ebelp
        AND   status_classific = @gc_status_classif_s
        INTO @DATA(ls_clas).

        IF sy-subrc <> 0 AND
          ls_clas IS INITIAL.

          APPEND VALUE #( mandt = sy-mandt
                          ebeln = ls_detail-ebeln
                          ebelp = ls_detail-ebelp
                          lifnr  = ls_header-lifnr
                          menge  = ls_detail-menge
                          lagmg  = lv_lagmg
                          emlif  = ls_detail-emlif
                          inco1  = COND #( WHEN ls_detail-inco1 IS INITIAL THEN ls_header-inco1 ELSE ls_detail-inco1 )
                          perc_corretagem = lv_perc_corretagem
                          prc_unit_embarcador = lv_net_emb
                          status_classific  = gc_status_classif
                          created_by = sy-uname
                          created_at = lv_timestamp
                          last_changed_by = sy-uname
                          last_changed_at = lv_timestamp
                          local_last_changed_at = lv_timestamp
                        ) TO lt_ztmm_control_cla.
        ENDIF.

        CLEAR: lv_lagmg.

      ENDLOOP.

      IF lt_ztmm_control_cla IS NOT INITIAL.
        MODIFY ztmm_control_cla FROM TABLE lt_ztmm_control_cla .
      ENDIF.

    ENDIF.


    CLEAR :
    lt_ztmm_control_cla,
    lt_items,
    ls_header.

    INCLUDE zmmi_ticketog IF FOUND.
  ENDMETHOD.


  METHOD if_ex_me_process_po_cust~process_account.
    RETURN.
  ENDMETHOD.


  METHOD if_ex_me_process_po_cust~process_header.
    RETURN.
  ENDMETHOD.


  METHOD if_ex_me_process_po_cust~process_item.

    DATA(ls_data) = im_item->get_data( ).

    IF ls_data IS NOT INITIAL.

      SELECT SINGLE * FROM ztpm_desc_ticlog
      INTO @DATA(ls_ticlog)
      WHERE banfn = @ls_data-banfn AND
            bnfpo = @ls_data-ebelp AND
            matnr = @ls_data-matnr.
    ENDIF.

    IF ls_ticlog IS NOT INITIAL.

      im_item->get_conditions( IMPORTING ex_conditions = DATA(lt_po_conditions) ).

      IF lt_po_conditions[] IS NOT INITIAL AND ls_ticlog-desconto IS NOT INITIAL.
        LOOP AT lt_po_conditions ASSIGNING FIELD-SYMBOL(<fs_s_po_cond>).
          IF <fs_s_po_cond>-kschl = 'RA01'.
            <fs_s_po_cond>-kbetr = ( ls_ticlog-desconto * 10 ).
            <fs_s_po_cond>-kmprs = 'X'.
          ENDIF.
        ENDLOOP.

        im_item->set_conditions( EXPORTING im_conditions = lt_po_conditions[] ).

      ENDIF.
    ENDIF.

    INCLUDE zmmi_check_ticketlog IF FOUND.

  ENDMETHOD.


  METHOD if_ex_me_process_po_cust~process_schedule.
    RETURN.
  ENDMETHOD.
ENDCLASS.
