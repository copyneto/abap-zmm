*&---------------------------------------------------------------------*
*& Include          ZMMI_COCKPIT_TRANSF
*&---------------------------------------------------------------------*


    TYPES:
      BEGIN OF ty_purchaseorder,
        ebeln TYPE rseg-ebeln,
      END OF ty_purchaseorder,
      ty_tt_purchaseorder TYPE SORTED TABLE OF ty_purchaseorder WITH NON-UNIQUE KEY ebeln.

    FIELD-SYMBOLS:
      <fs_nfheader>  TYPE j_1bnfdoc,
      <fs_wk_active> TYPE j_1bnfe_active.

    DATA(lv_pedidos_intercompany) = abap_false.
    DATA(lt_stack_cockpit) = cl_abap_get_call_stack=>get_call_stack( ).
    LOOP AT lt_stack_cockpit INTO DATA(ls_stack_cockpit).
      IF ls_stack_cockpit-program_info CS 'ZFGMM_COCKPIT_TRANSF'.
        lv_pedidos_intercompany = abap_true.
        EXIT.
      ENDIF.
    ENDLOOP.
    IF lv_pedidos_intercompany = abap_true.
      DATA(lt_pedidos) = CORRESPONDING ty_tt_purchaseorder( it_rseg ).
      SELECT br_notafiscal
        FROM zc_sd_01_cockpit AS _cockpit
        INNER JOIN @lt_pedidos AS _rseg
        ON _rseg~ebeln = _cockpit~purchaseorder
        WHERE tipooperacao = 'INT4'
          AND br_notafiscal IS NOT INITIAL
        INTO @DATA(lv_nota_fiscal)
        UP TO 1 ROWS.
      ENDSELECT.
      IF sy-subrc = 0.
        SELECT SINGLE authdate, authtime, cdv, docnum9, authcod
          FROM j_1bnfe_active
          WHERE docnum = @lv_nota_fiscal
          INTO @DATA(ls_active_cockpit).
        IF sy-subrc = 0.
          ASSIGN ('(SAPLJ1BI)NFHEADER') TO <fs_nfheader>.
          IF sy-subrc = 0.
            <fs_nfheader>-authdate = ls_active_cockpit-authdate.
            <fs_nfheader>-authtime = ls_active_cockpit-authtime.
            <fs_nfheader>-authcod  = ls_active_cockpit-authcod.
          ENDIF.
          ASSIGN ('(SAPLJ_1B_NFE)WK_ACTIVE') TO <fs_wk_active>.
          IF sy-subrc = 0.
            <fs_wk_active>-authdate = ls_active_cockpit-authdate.
            <fs_wk_active>-authtime = ls_active_cockpit-authtime.
            <fs_wk_active>-cdv = ls_active_cockpit-cdv.
            <fs_wk_active>-docnum9 = ls_active_cockpit-docnum9.
            <fs_wk_active>-authcod = ls_active_cockpit-authcod.
          ENDIF.
        ENDIF.
      ENDIF.
    ENDIF.
