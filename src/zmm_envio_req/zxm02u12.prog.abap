*"*"Lokale Schnittstelle:
*"  IMPORTING
*"     REFERENCE(IM_REQ_HEADER) TYPE REF TO  IF_PURCHASE_REQUISITION
*"     REFERENCE(IM_T_EBAN) TYPE  MEREQ_T_EBAN
*"     REFERENCE(IM_T_EBKN) TYPE  MEREQ_T_EBKN
*"     REFERENCE(IM_T_EBAN_PERS) TYPE  MEREQ_T_EBAN
*"     REFERENCE(IM_T_EBKN_PERS) TYPE  MEREQ_T_EBKN
*"  EXPORTING
*"     REFERENCE(EX_MESSAGES) TYPE  MEREQ_T_BAPIRET2
*"  EXCEPTIONS
*"      ERROR_MESSAGES

CONSTANTS: BEGIN OF gc_param,
             modulo	TYPE ze_param_modulo VALUE 'MM',
             chave1	TYPE ze_param_chave VALUE 'GAP_292',
             chave2	TYPE ze_param_chave VALUE 'BSART',
             chave3	TYPE ze_param_chave_3 VALUE 'TP_REQ',
           END OF gc_param.

TYPES: BEGIN OF ty_mdpm_key,
         stlty TYPE stlty,
         stlnr TYPE stnum,
         stknr TYPE stlkn,
         stkza TYPE cim_count,
       END OF ty_mdpm_key.
TYPES:
  ty_tt_mdpmx TYPE TABLE OF mdpm_x.
*  ty_ro_bom   TYPE REF TO if_bom_mm.

DATA: lv_zz1_verid TYPE ze_verid_list,
      lv_zz1_matnr TYPE ze_matnr_prd_ind.

DATA: lt_mdpm_key TYPE TABLE OF ty_mdpm_key,
      lt_stb      TYPE TABLE OF stpox,
      lv_matnr    TYPE matnr.
FIELD-SYMBOLS: <fs_xmdpm>     TYPE mdpm_x,
               <fs_tab_xmdpm> TYPE me_mdpm_x_tty,
               <fs_mdpa>      TYPE mdpa.

DATA(ls_header_data) = im_req_header->get_data( ).

SELECT sign, opt, low, high
  FROM ztca_param_val
  WHERE modulo = @gc_param-modulo
    AND chave1 = @gc_param-chave1
    AND chave2 = @gc_param-chave2
    AND chave3 = @gc_param-chave3
  INTO TABLE @DATA(lt_bsart).

IF lt_bsart IS NOT INITIAL AND ls_header_data-bsart IN lt_bsart.

  DATA(lt_itens) = im_req_header->get_items( ).
  DATA lo_itens TYPE REF TO if_purchase_requisition_item.

  LOOP AT lt_itens ASSIGNING FIELD-SYMBOL(<fs_itens>).
    TRY.

        DATA(ls_item_data) = <fs_itens>-item->get_data( ).
      CATCH cx_sy_ref_is_initial.
        EXIT.
    ENDTRY.

    IF ls_item_data-zz1_matnr IS INITIAL.
      APPEND VALUE #( type = 'E' id = 'ZMM_SUBCONTRTC' number = '041' message_v1 = ls_item_data-bnfpo ) TO ex_messages.
      EXIT.
    ENDIF.

    IF ls_item_data-zz1_verid IS INITIAL.
      APPEND VALUE #( type = 'E' id = 'ZMM_SUBCONTRTC' number = '042' message_v1 = ls_item_data-bnfpo ) TO ex_messages.
      EXIT.
    ENDIF.

    IF lv_zz1_verid <> ls_item_data-zz1_verid OR
       lv_zz1_matnr <> ls_item_data-zz1_matnr.
      lv_zz1_verid  = ls_item_data-zz1_verid.
      lv_zz1_matnr = ls_item_data-zz1_matnr.

      SELECT SINGLE matnr, werks, verid, MKSP
        FROM mkal
        WHERE matnr = @lv_zz1_matnr
          AND werks = @ls_item_data-werks
          AND verid = @lv_zz1_verid
        INTO @DATA(ls_mkal)."#EC CI_SEL_NESTED

      IF sy-subrc <> 0.
        APPEND VALUE #( type = 'E' id = 'ZMM_SUBCONTRTC' number = '044' message_v1 = ls_item_data-bnfpo ) TO ex_messages.
        EXIT.
      ENDIF.

      if ls_mkal-MKSP is not INITIAL.
        APPEND VALUE #( type = 'E' id = 'ZMM_SUBCONTRTC' number = '045' message_v1 = ls_item_data-bnfpo ) TO ex_messages.
        EXIT.
      endif.

      CLEAR lt_stb.

      CALL FUNCTION 'CS_BOM_EXPL_MAT_V2'
        EXPORTING
          capid                 = 'PP01'
          datuv                 = sy-datum
          emeng                 = ls_item_data-menge
          mtnrv                 = lv_zz1_matnr
          werks                 = ls_item_data-werks
          verid                 = lv_zz1_verid
        TABLES
          stb                   = lt_stb
        EXCEPTIONS
          alt_not_found         = 1
          call_invalid          = 2
          material_not_found    = 3
          missing_authorization = 4
          no_bom_found          = 5
          no_plant_data         = 6
          no_suitable_bom_found = 7
          conversion_error      = 8
          OTHERS                = 9.

      IF sy-subrc <> 0.
        APPEND VALUE #( type = 'E'
                        id = sy-msgid
                        number = sy-msgno
                        message_v1 = sy-msgv1
                        message_v2 = sy-msgv2
                        message_v3 = sy-msgv3
                        message_v4 = sy-msgv4 ) TO ex_messages.
        EXIT.
      ENDIF.

      SORT lt_stb BY idnrk.
    ENDIF.

    READ TABLE lt_stb TRANSPORTING NO FIELDS WITH KEY idnrk = ls_item_data-matnr. "#EC CI_STDSEQ

    IF sy-subrc <> 0.
      APPEND VALUE #( type = 'E' id = 'ZMM_SUBCONTRTC' number = '043' message_v1 = ls_item_data-bnfpo message_v2 = lv_zz1_matnr ) TO ex_messages.
      EXIT.
    ENDIF.
  ENDLOOP.

ENDIF.
