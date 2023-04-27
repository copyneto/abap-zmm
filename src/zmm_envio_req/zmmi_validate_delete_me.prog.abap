*&---------------------------------------------------------------------*
*& Include ZMMI_VALIDATE_DELETE_ME
*&---------------------------------------------------------------------*
CONSTANTS lc_m TYPE c VALUE 'M'.

IF sy-ucomm EQ lc_parametros-ucomm.

  IF ls_mereq_item-zz1_statu EQ lc_m AND
     ls_mereq_item-loekz     EQ abap_true.
    MESSAGE e005(zmm_req_compras) WITH ls_mereq_item-bnfpo.
  ELSE.

    cl_message_handler_mm=>get_handler(
      IMPORTING
        ex_handler = DATA(lo_msg_handler) ).

    lo_msg_handler->getlist(
       IMPORTING
         ex_events = DATA(lt_event_list) ).

    DATA(lv_conf) = lo_msg_handler->get_configuration( ).

    lv_conf-keep_deleted_events = space.

    lo_msg_handler->set_configuration( lv_conf ).

  ENDIF.

  TRY.

      NEW zclca_tabela_parametros( )->m_get_range(
        EXPORTING
          iv_modulo = lc_parametros-modulo
          iv_chave1 = lc_parametros-chave1
          iv_chave2 = lc_parametros-chave2_me
          iv_chave3 = lc_parametros-chave3_me
        IMPORTING
          et_range  = lr_me ).

    CATCH zcxca_tabela_parametros.
      EXIT.
  ENDTRY.

  IF line_exists( lr_me[ low = ls_mereq_item-zz1_statu ] ).
    MESSAGE e004(zmm_req_compras) WITH ls_mereq_item-bnfpo.
  ENDIF.

  ls_mereq_item-zz1_statu = space.

  im_item->set_data( ls_mereq_item ).

  CLEAR: lr_me[].

ENDIF.


IF ls_header-banfn_ext  IS INITIAL.

  CLEAR: ls_mereq_item-zz1_statu.

  im_item->set_data( ls_mereq_item ).

ENDIF.
