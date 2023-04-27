CLASS zclmm_libpg_grvde_disc DEFINITION
  PUBLIC
  INHERITING FROM zclmm_libpg_grvde_op
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES zifmm_lib_pgto_graoverde_desc.

    METHODS zifmm_lib_pgto_graoverde~executar REDEFINITION.

    "! Setup Messages
    "! @parameter p_task              | Task
    METHODS FETCH_TASK_messages
      IMPORTING p_task TYPE    clike.

  PROTECTED SECTION.

    DATA: gs_documentheader TYPE bapiache09,
          gs_fin_group      TYPE zi_fi_fin_group_data.

    DATA: gt_acctpayable    TYPE bapiacap09_tab,
          gt_accountgl      TYPE bapiacgl09_tab,
          gt_extension      TYPE bapiparex_tab,
          gt_currencyamount TYPE bapiaccr09_tab,
          gt_gl_acct_rng    TYPE RANGE OF saknr.

  PRIVATE SECTION.

    CONSTANTS:

      BEGIN OF gc_saknr,
        modulo TYPE ze_param_modulo VALUE 'FI-AP',
        chave1 TYPE ze_param_chave  VALUE 'DESCONTOSGV',
        chave2 TYPE ze_param_chave  VALUE 'CONTACH50',
      END OF gc_saknr,

      BEGIN OF gc_blart,
        modulo TYPE ze_param_modulo VALUE 'FI-AP',
        chave1 TYPE ze_param_chave  VALUE 'DESCONTOSGV',
        chave2 TYPE ze_param_chave  VALUE 'TIPODOC',
      END OF gc_blart.



ENDCLASS.



CLASS ZCLMM_LIBPG_GRVDE_DISC IMPLEMENTATION.


  METHOD zifmm_lib_pgto_graoverde_desc~build.

    me->get_parameter( EXPORTING iv_modulo = me->gc_blart-modulo
                                 iv_chave1 = me->gc_blart-chave1
                                 iv_chave2 = me->gc_blart-chave2
                       IMPORTING et_param  = me->gt_tipodoc_rng ).

    me->get_parameter( EXPORTING iv_modulo = me->gc_saknr-modulo
                                 iv_chave1 = me->gc_saknr-chave1
                                 iv_chave2 = me->gc_saknr-chave2
                       IMPORTING et_param  = me->gt_gl_acct_rng ).

    SELECT *
      FROM zi_fi_fin_group_data
       FOR ALL ENTRIES IN @me->gt_properties
     WHERE CostClass   IN @me->gt_gl_acct_rng
       AND CompanyCode EQ @me->gt_properties-Empresa
      INTO @me->gs_fin_group
      UP TO 1 ROWS.
    ENDSELECT.

    data(ls_prop) = value #( me->gt_properties[ 1 ] OPTIONAL ).

    IF iv_tipo = 'F'.

      "SELECT empresa as bukrs, ano as gjahr, numdocumento as belnr, SUM( VlrDescontoFin ) AS amount
      SELECT empresa as bukrs, ano as gjahr, numdocumento as belnr, VlrDescontoFin AS amount
        FROM zi_mm_lib_pgto_des_fin_com
       WHERE Empresa = @ls_prop-Empresa
         AND ano = @ls_prop-ano
         AND NumDocumento = @ls_prop-NumDocumentoRef
         AND guid = @gv_guid
       "GROUP BY Empresa, Ano, NumDocumento
        INTO TABLE @gt_descontos.

    ELSEIF iv_tipo = 'C'.

      "SELECT empresa as bukrs, ano as gjahr, numdocumento as belnr, SUM( VlrDescontoCom ) AS amount
      SELECT empresa as bukrs, ano as gjahr, numdocumento as belnr, VlrDescontoCom AS amount
        FROM zi_mm_lib_pgto_des_fin_com
       WHERE Empresa = @ls_prop-Empresa
         AND ano = @ls_prop-ano
         AND NumDocumento = @ls_prop-NumDocumentoRef
         AND guid = @gv_guid
       "GROUP BY Empresa, Ano, NumDocumento
        INTO TABLE @gt_descontos.
    ENDIF.


  ENDMETHOD.


  METHOD zifmm_lib_pgto_graoverde~executar.

    DATA lt_return TYPE bapiret2_tab.
    DATA(ls_prop) = VALUE #( me->gt_properties[ 1 ] OPTIONAL ).
    DATA: ls_desconto_fin_com TYPE ztmm_pag_gv_desc.

    SELECT _desc~*
    FROM ztmm_pag_gv_desc as _desc
    INNER JOIN ztmm_pag_gv_cab as _cab on  _desc~ebeln = _cab~ebeln
                                       and _desc~bukrs = _cab~bukrs
    WHERE _desc~bukrs = @ls_prop-empresa
    AND _cab~gjahr = @ls_prop-ano
    AND _desc~ebeln = @ls_prop-numdocumentoref
    AND ( _desc~doccont_fin IS INITIAL OR _desc~doccont_com IS INITIAL )
    INTO TABLE @DATA(lt_dados).

    LOOP AT lt_dados INTO DATA(ls_data).

      CLEAR: me->gs_documentheader.
      CLEAR: me->gt_accountgl.
      CLEAR: me->gt_acctpayable.
      CLEAR: me->gt_currencyamount.
      CLEAR: me->gt_extension.
      CLEAR: me->gt_return.

      CLEAR: me->gt_descontos.
      CLEAR: me->gv_guid.
      CLEAR: me->gv_nfenum.
      CLEAR: ls_desconto_fin_com.

      IF iv_tipo = 'F' AND ( ls_data-vlr_desconto_fin IS INITIAL OR ls_data-doccont_fin IS NOT INITIAL ) .
        CONTINUE.
      ENDIF.

      IF iv_tipo = 'C' AND ( ls_data-vlr_desconto_com IS INITIAL OR  ls_data-doccont_com IS NOT INITIAL ).
        CONTINUE.
      ENDIF.

      me->gv_guid = ls_data-guid.

      IF iv_tipo = 'F'.
        SELECT SINGLE nfenum
        FROM j_1bnfdoc
        WHERE docnum = @ls_data-docnum_fin
        INTO @me->gv_nfenum.

      ELSEIF iv_tipo = 'C'.
        SELECT SINGLE nfenum
        FROM j_1bnfdoc
        WHERE docnum = @ls_data-docnum_com
        INTO @me->gv_nfenum.
      ENDIF.

      me->zifmm_lib_pgto_graoverde_desc~build( iv_tipo = iv_tipo ).

      CALL FUNCTION 'ZFMFI_EXEC_ACC_DOC_POST'
        STARTING NEW TASK 'EXEC_ACC_DOC_POST'
        CALLING fetch_task_messages ON END OF TASK
        EXPORTING
          is_docheader      = me->gs_documentheader
          it_accountgl      = me->gt_accountgl
          it_accountpayable = me->gt_acctpayable
          it_currencyamount = me->gt_currencyamount
          it_extension2     = me->gt_extension.

      WAIT UNTIL gv_wait = abap_true.

      IF NOT line_exists( me->gt_return[ type = 'E ' ] ).
        CLEAR: me->gt_return.
        me->gt_return = VALUE #( BASE me->gt_return ( type = 'S' id = 'ZMM_LIB_PGTO_GV' number = '005' message_v1 = gv_key(10) message_v2 = gv_key+10(4) message_v3 = gv_key+14(4) ) ).

        MOVE-CORRESPONDING ls_data TO ls_desconto_fin_com.

        IF iv_tipo = 'F'.
          ls_desconto_fin_com-doccont_fin = gv_key(10).
        ELSEIF iv_tipo = 'C'.
          ls_desconto_fin_com-doccont_com = gv_key(10).
        ENDIF.


        MODIFY ztmm_pag_gv_desc FROM ls_desconto_fin_com.

      ELSE.
        me->gt_return = VALUE #( BASE me->gt_return ( type = 'E' id = 'ZMM_LIB_PGTO_GV' number = '006' ) ).
      ENDIF.

      APPEND LINES OF me->gt_return TO lt_return.

    ENDLOOP.

    CLEAR: me->gt_return.
    APPEND LINES OF lt_return TO me->gt_return.



*    CALL FUNCTION 'BAPI_ACC_DOCUMENT_POST'
*      EXPORTING
*        documentheader =
*      TABLES
*        accountgl      =
*        accountpayable =
*        currencyamount =
*        extension2     =
*        return         = .

    super->zifmm_lib_pgto_graoverde~executar( ).

  ENDMETHOD.


  METHOD zifmm_lib_pgto_graoverde_desc~create.

    CASE iv_tipo.
      WHEN zifmm_lib_pgto_graoverde=>gc_tipo-comercial.
        ro_ref ?= NEW zclmm_lib_pgt_grverde_desc_com( ).
      WHEN zifmm_lib_pgto_graoverde=>gc_tipo-financeiro.
        ro_ref ?= NEW zclmm_lib_pgt_grverde_desc_fin( ).
    ENDCASE.

  ENDMETHOD.


  METHOD fetch_task_messages.

    RECEIVE RESULTS FROM FUNCTION 'ZFMFI_EXEC_ACC_DOC_POST'
      IMPORTING
    ev_type     = gv_type
    ev_key      = gv_key
    ev_sys      = gv_sys
    et_return   = gt_return.

  ENDMETHOD.
ENDCLASS.
