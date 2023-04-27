*&---------------------------------------------------------------------*
*& Include          ZMMI_INTEGRACAO_ME_ADDRESS
*&---------------------------------------------------------------------*

DATA: lo_pr_item      TYPE REF TO if_purchase_requisition_item,
      ls_pr_item_data TYPE mereq_item.

mmpur_dynamic_cast lo_pr_item my_model.
IF NOT lo_pr_item IS INITIAL.
  ls_pr_item_data = lo_pr_item->get_data( ).

  CHECK ls_pr_item_data-zz1_statu = 'M'.

  l_dialog_mode = 'DISPLAY'.

  CALL FUNCTION 'MM_DELIVERY_ADDRESS_MAINTAIN'
    EXPORTING
      i_dialog         = 'X'
      i_dialog_mode    = l_dialog_mode
      i_fs_adrnr       = l_fs_adrnr
      i_fs_adrn2       = l_fs_adrn2
      i_fs_kunnr       = l_fs_kunnr
      i_fs_emlif       = l_fs_emlif
      i_fs_lblkz       = l_fs_lblkz
      i_subscreen_mode = 'PBO'
      i_cursor_field   = l_cursor_field
    CHANGING
      p_cmmda          = l_cmmda.

ENDIF.
