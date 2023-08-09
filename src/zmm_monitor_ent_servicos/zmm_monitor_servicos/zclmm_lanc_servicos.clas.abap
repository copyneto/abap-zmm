CLASS zclmm_lanc_servicos DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    TYPES: BEGIN OF ty_accitem.
             INCLUDE TYPE bseg.
    TYPES:   ktext TYPE rfpsd-ktext,
             kursf TYPE acccr-kursf,
           END   OF ty_accitem,

           ty_t_accitem TYPE TABLE OF ty_accitem WITH DEFAULT KEY,
           ty_t_po_item TYPE TABLE OF zi_mm_monit_serv_po_values WITH DEFAULT KEY.

    CONSTANTS gc_error              TYPE syst_msgty VALUE 'E' ##NO_TEXT.
    CONSTANTS gc_sucess             TYPE syst_msgty VALUE 'S' ##NO_TEXT.
    CONSTANTS gc_msg_id             TYPE syst_msgid VALUE 'ZMM_MONITOR_ENT_SERV' ##NO_TEXT.
    CONSTANTS gc_param_module       TYPE ztca_param_val-modulo VALUE 'MM' ##NO_TEXT.
    CONSTANTS gc_param_monitor      TYPE ztca_param_val-chave1 VALUE 'MONITOR_SERVICOS' ##NO_TEXT.
    CONSTANTS gc_param_lcto_servico TYPE ztca_param_val-chave2 VALUE 'LANCAMENTO_SERVICO' ##NO_TEXT.
    CONSTANTS gc_param_ncms_redbase TYPE ztca_param_val-chave2 VALUE 'NCM_REDUCAO_BASE' ##NO_TEXT.
    CONSTANTS gc_param_ctg_contabil TYPE ztca_param_val-chave2 VALUE 'CATEGORIA_CONTABIL' ##NO_TEXT.
    CONSTANTS gc_a                  TYPE c          VALUE 'A' ##NO_TEXT.
    CONSTANTS gc_p                  TYPE c          VALUE 'P' ##NO_TEXT.

    DATA:
       gv_finished TYPE abap_bool.

    CONSTANTS:
      BEGIN OF gc_log_object,
        cadastro_fiscal TYPE balobj_d VALUE 'ZMM_MONITSERV_CADFIS' ##NO_TEXT,
        monitor_lancto  TYPE balobj_d VALUE 'ZMM_MONITSERV_LANCTO' ##NO_TEXT,
      END OF gc_log_object,

      BEGIN OF gc_log_action,
        liberar_nf      TYPE balsubobj VALUE 'LIBERAR_NF' ##NO_TEXT,
        lancar_fatura   TYPE balsubobj VALUE 'LANCAR_FATURA' ##NO_TEXT,
        simular_fatura  TYPE balsubobj VALUE 'SIMULAR_FATURA' ##NO_TEXT,
        estornar_fatura TYPE balsubobj VALUE 'ESTORNAR_FATURA' ##NO_TEXT,
        anexar_nf       TYPE balsubobj VALUE 'ANEXAR_NF' ##NO_TEXT,
      END OF gc_log_action,

      BEGIN OF gc_status_fiscal,
        erro      TYPE char9 VALUE 'Erro' ##NO_TEXT,
        concluido TYPE char9 VALUE 'Concluído' ##NO_TEXT,
        liberada  TYPE char9 VALUE 'Liberada' ##NO_TEXT,
        pendente  TYPE char9 VALUE 'Pendente' ##NO_TEXT,
      END OF gc_status_fiscal.

    CLASS-METHODS check_invoice_servico
      IMPORTING
        iv_empresa       TYPE mrm_rbkpv-bukrs
        iv_fornecedor    TYPE mrm_rbkpv-lifnr
        iv_numero_nf     TYPE mrm_rbkpv-xblnr
      RETURNING
        VALUE(rv_istrue) TYPE abap_bool.

    CLASS-METHODS get_cfop_invoice_miro
      IMPORTING
        iv_empresa     TYPE mrm_rbkpv-bukrs
        iv_fornecedor  TYPE mrm_rbkpv-lifnr
        iv_numero_nf   TYPE mrm_rbkpv-xblnr
        iv_material    TYPE j_1bnflin-matnr
        iv_centro      TYPE j_1bnflin-werks
      RETURNING
        VALUE(rv_cfop) TYPE j_1bnflin-cfop.

    METHODS liberar_nf
      IMPORTING
        !is_key    TYPE zsmm_mnt_serv_key
      EXPORTING
        !et_return TYPE bapiret2_tab .

    METHODS registrar_fatura
      IMPORTING
        !is_key    TYPE zsmm_mnt_serv_key
        iv_job     TYPE c OPTIONAL
      EXPORTING
        !et_return TYPE bapiret2_t .
    METHODS simular_contabilizacao
      IMPORTING
        !is_key        TYPE zsmm_mnt_serv_key
      EXPORTING
        !et_accounting TYPE zctgmm_invoice_accounting
        !et_return     TYPE bapiret2_t.
    METHODS excluir_fatura
      IMPORTING
        !it_key    TYPE zctgmm_mnt_serv_key
      EXPORTING
        !et_return TYPE bapiret2_t .
    METHODS estornar_fatura
      IMPORTING
        !is_key    TYPE zsmm_mnt_serv_key
      EXPORTING
        !et_return TYPE bapiret2_t .
    METHODS simular_fatura
      IMPORTING
        !is_key        TYPE zsmm_mnt_serv_key
      EXPORTING
        !et_accounting TYPE zctgmm_invoice_accounting
        !et_return     TYPE bapiret2_t.
    METHODS setup_messages
      IMPORTING
        !p_task TYPE clike .

    METHODS get_posting_parameters
      IMPORTING
        iv_pedido            TYPE ekpo-ebeln
        iv_item              TYPE ekpo-ebelp
        iv_is_rpa            TYPE abap_bool
      RETURNING
        VALUE(rs_parameters) TYPE ztmm_param_monse.

    METHODS valida_input_pedido_compras
      IMPORTING
        iv_pedido   TYPE ekko-ebeln
        iv_is_rpa   TYPE abap_bool
        iv_empresa  TYPE ekko-bukrs
        iv_bp       TYPE ekko-lifnr
      EXPORTING
        et_po_items TYPE ty_t_po_item
      CHANGING
        ct_return   TYPE bapiret2_tab.

    METHODS get_duo_date
      IMPORTING
        iv_bline_date      TYPE bapi_incinv_create_header-bline_date
        iv_pedido          TYPE ekko-ebeln
      RETURNING
        VALUE(rv_duo_date) TYPE invfo-netdt.

    METHODS get_cnpj_cpf_bp
      IMPORTING
        iv_fornecedor     TYPE ekko-lifnr
      RETURNING
        VALUE(rv_cnpjcpf) TYPE dfkkbptaxnum-taxnum.

    METHODS save_logs
      IMPORTING
        iv_object     TYPE balobj_d
        iv_subobject  TYPE balsubobj
        iv_externalid TYPE any
        it_return     TYPE bapiret2_t.

    METHODS:
      finished
        IMPORTING
          p_task TYPE char32.

  PROTECTED SECTION.
  PRIVATE SECTION.
    CONSTANTS:
      BEGIN OF gc_irf_code,
        cofins TYPE lfbw-witht VALUE 'C1',
        pcc    TYPE lfbw-witht VALUE 'G1',
        inss   TYPE lfbw-witht VALUE 'IJ',
        iss    TYPE lfbw-witht VALUE 'IW',
        pis    TYPE lfbw-witht VALUE 'P1',
        ir     TYPE lfbw-witht VALUE 'R1',
        csll   TYPE lfbw-witht VALUE 'S1',
      END OF gc_irf_code.

    METHODS valida_dados_pre_registro
      IMPORTING
        !is_key            TYPE zsmm_mnt_serv_key
      EXPORTING
        !ev_step_validacao TYPE abap_bool
        !et_return         TYPE bapiret2_tab .

    METHODS valida_is_step_validacao
      IMPORTING
        !iv_fornecedor   TYPE zi_mm_cadastro_fiscal_cabec-lifnr
        !iv_ncm          TYPE zi_mm_cadastro_fiscal_cabec-lc
      RETURNING
        VALUE(rv_istrue) TYPE abap_bool.

    METHODS valida_total_impostos
      IMPORTING
        !iv_vlr_cofins TYPE zi_mm_cadastro_fiscal_cabec-vlcofins
        !iv_vlr_csll   TYPE zi_mm_cadastro_fiscal_cabec-vlcsll
        !iv_vlr_inss   TYPE zi_mm_cadastro_fiscal_cabec-vlinss
        !iv_vlr_iss    TYPE zi_mm_cadastro_fiscal_cabec-vliss
        !iv_vlr_ir     TYPE zi_mm_cadastro_fiscal_cabec-vlir
        !iv_vlr_pis    TYPE zi_mm_cadastro_fiscal_cabec-vlpis
        it_accounting  TYPE zctgmm_invoice_accounting
      CHANGING
        ct_return      TYPE bapiret2_tab .

    METHODS valida_total_nf
      IMPORTING
        iv_vlr_total  TYPE zi_mm_cadastro_fiscal_cabec-vltotnf
        it_accounting TYPE zctgmm_invoice_accounting
      CHANGING
        ct_return     TYPE bapiret2_tab .

    METHODS valida_estrategia_pedido
      IMPORTING
        iv_pedido TYPE ekko-ebeln
      CHANGING
        ct_return TYPE bapiret2_tab .

    METHODS valida_domicilio_fiscal
      IMPORTING
        is_key       TYPE zsmm_mnt_serv_key
        iv_pedido    TYPE ekko-ebeln
        iv_domicilio TYPE zi_mm_cadastro_fiscal_cabec-domiciliofiscal
      CHANGING
        ct_return    TYPE bapiret2_tab .

    METHODS valida_ncm
      IMPORTING
        is_key    TYPE zsmm_mnt_serv_key
        iv_pedido TYPE ekko-ebeln
        iv_ncm    TYPE zi_mm_cadastro_fiscal_cabec-lc
      CHANGING
        ct_return TYPE bapiret2_tab .

    METHODS valida_anexo
      IMPORTING
        iv_flag_anexo TYPE abap_bool
      CHANGING
        ct_return     TYPE bapiret2_tab .

    METHODS valida_retencao
      IMPORTING
        is_key    TYPE zsmm_mnt_serv_key
      CHANGING
        ct_return TYPE bapiret2_tab .

    METHODS valida_quantidade
      IMPORTING
        is_key        TYPE zsmm_mnt_serv_key
        iv_pedido     TYPE ekko-ebeln
        it_accounting TYPE zctgmm_invoice_accounting
      CHANGING
        ct_return     TYPE bapiret2_tab .

    DATA gt_accounting TYPE zctgmm_invoice_accounting.
    DATA gt_return TYPE bapiret2_t .
    DATA gv_wait_async TYPE abap_bool .
    DATA gv_duo_date   TYPE invfo-netdt.

    CLASS-DATA gs_goodsmvt_headret TYPE bapi2017_gm_head_ret .
    CLASS-DATA gv_materialdocument TYPE bapi2017_gm_head_ret-mat_doc .
    CLASS-DATA gv_matdocumentyear TYPE bapi2017_gm_head_ret-doc_year .
    CLASS-DATA gv_invoicedocnumber TYPE bapi_incinv_fld-inv_doc_no .
    CLASS-DATA gv_fiscalyear TYPE bapi_incinv_fld-fisc_year .
ENDCLASS.



CLASS ZCLMM_LANC_SERVICOS IMPLEMENTATION.


  METHOD estornar_fatura.
    DATA lt_return  TYPE STANDARD TABLE OF bapiret2.

    DATA: ls_bapi_incinv TYPE bapi_incinv_fld.
    CONSTANTS: lc_reason TYPE char2 VALUE '01'.

    CHECK is_key IS NOT INITIAL.


    SELECT SINGLE
        empresa,
        filial,
        lifnr,
        nrnf,
        miro,
        miroano,
        dtlancto,
        logexternalid
      FROM zi_mm_monit_serv_header
     WHERE empresa = @is_key-empresa
       AND filial  = @is_key-filial
       AND lifnr   = @is_key-lifnr
       AND nrnf    = @is_key-nrnf
      INTO @DATA(is_nfheader).

    ls_bapi_incinv-inv_doc_no = is_nfheader-miro.
    ls_bapi_incinv-fisc_year  = is_nfheader-miroano.
    ls_bapi_incinv-reason_rev = lc_reason.
    ls_bapi_incinv-pstng_date = is_nfheader-dtlancto.

    CALL FUNCTION 'ZFMMM_MONITSERV_INVOICE_CANCEL'
      STARTING NEW TASK 'MM_INVOCMG_CANCEL'
      CALLING setup_messages ON END OF TASK
      EXPORTING
        iv_invoicedocnumber = ls_bapi_incinv-inv_doc_no
        iv_fiscalyear       = ls_bapi_incinv-fisc_year
        iv_reasonreversal   = ls_bapi_incinv-reason_rev
        iv_postingdate      = ls_bapi_incinv-pstng_date.

    WAIT UNTIL gv_wait_async = abap_true.
    et_return = gt_return.

    IF NOT line_exists( gt_return[ type = gc_error ] ).
      UPDATE ztmm_monit_cabec
         SET gjahr   = ''
             belnr   = ''
             erro    = abap_false
       WHERE empresa = is_nfheader-empresa
         AND filial  = is_nfheader-filial
         AND lifnr   = is_nfheader-lifnr
         AND nr_nf   = is_nfheader-nrnf.

      et_return = VALUE #( BASE et_return ( id         = gc_msg_id
                                            type       = gc_sucess
                                            number     = 006
                                            message_v1 = ls_bapi_incinv-inv_doc_no
                                            message_v2 = ls_bapi_incinv-fisc_year ) ).
    ELSE.
      UPDATE ztmm_monit_cabec
         SET erro    = abap_true
       WHERE empresa = is_nfheader-empresa
         AND filial  = is_nfheader-filial
         AND lifnr   = is_nfheader-lifnr
         AND nr_nf   = is_nfheader-nrnf.
    ENDIF.

    CALL METHOD me->save_logs
      EXPORTING
        iv_object     = gc_log_object-monitor_lancto
        iv_subobject  = gc_log_action-estornar_fatura
        iv_externalid = is_nfheader-logexternalid
        it_return     = et_return.
  ENDMETHOD.


  METHOD simular_contabilizacao.

    DATA: lt_gv_item  TYPE STANDARD TABLE OF bapi2017_gm_item_create,
          lt_return   TYPE STANDARD TABLE OF bapiret2,
          lt_icm_item TYPE STANDARD TABLE OF bapi_incinv_create_item.

    DATA: ls_header     TYPE bapi2017_gm_head_01,
          ls_code       TYPE bapi2017_gm_code,
          ls_headerdata TYPE bapi_incinv_create_header.

    CONSTANTS:
    lc_currency TYPE waers VALUE 'BRL'.
*               lc_modulo   TYPE ze_param_modulo  VALUE 'MM',
*               lc_chav1    TYPE ze_param_chave   VALUE 'MONITOR_SERVICOS',
*               lc_chav2    TYPE ze_param_chave   VALUE 'RGT_FATURA',
*               lc_mvtyp    TYPE ze_param_chave_3 VALUE 'MOVE_TYP',
*               lc_mvtind   TYPE ze_param_chave_3 VALUE 'MVT_IND',
*               lc_gmcode   TYPE ze_param_chave_3 VALUE 'GM_CODE'.

    CHECK is_key IS NOT INITIAL.

    SELECT SINGLE
        empresa,
        filial,
        nrnf,
        pedido,
        vltotnf,
        cnpjcpf,
        lifnr,
        dtemis,
        dtlancto,
        flagrpa
      FROM zi_mm_cadastro_fiscal_cabec
     WHERE empresa = @is_key-empresa
       AND filial  = @is_key-filial
       AND lifnr   = @is_key-lifnr
       AND nrnf    = @is_key-nrnf
      INTO @DATA(ls_nfheader).

    SELECT
        nrpedido,
        itmpedido,
        iva,
        nftype,
        vlunit,
        qtdade_lcto,
        unid,
        serviceentrysheet,
        serviceentrysheetitem
      FROM zi_mm_cadastro_fiscal_item
     WHERE empresa = @ls_nfheader-empresa
       AND filial  = @ls_nfheader-filial
       AND lifnr   = @ls_nfheader-lifnr
       AND nrnf    = @ls_nfheader-nrnf
       AND qtdade_lcto > 0
      INTO TABLE @DATA(lt_items).

    IF sy-subrc IS INITIAL.

      DATA(lv_nro_item) = CONV rblgp( 0 ).
      LOOP AT lt_items ASSIGNING FIELD-SYMBOL(<fs_item>).
        DATA(lv_nftype) = <fs_item>-nftype.

        lv_nro_item = lv_nro_item + 1.
        lt_icm_item = VALUE #( BASE lt_icm_item ( invoice_doc_item  = lv_nro_item
                                                  po_number         = <fs_item>-nrpedido
                                                  po_item           = <fs_item>-itmpedido
                                                  tax_code          = <fs_item>-iva
                                                  item_amount       = ( <fs_item>-vlunit * <fs_item>-qtdade_lcto )
                                                  quantity          = <fs_item>-qtdade_lcto
                                                  po_unit           = <fs_item>-unid
                                                  sheet_no          = <fs_item>-serviceentrysheet
                                                  sheet_item        = <fs_item>-serviceentrysheetitem
                                              ) ).

      ENDLOOP.

      ls_headerdata-invoice_ind  = abap_true.
      ls_headerdata-doc_date     = ls_nfheader-dtemis.
      ls_headerdata-pstng_date   = sy-datum.
      ls_headerdata-comp_code    = ls_nfheader-empresa.
      ls_headerdata-gross_amount = ls_nfheader-vltotnf.
      ls_headerdata-ref_doc_no   = ls_nfheader-nrnf.
      ls_headerdata-j_1bnftype   = lv_nftype.
      ls_headerdata-currency     = lc_currency.
      ls_headerdata-calc_tax_ind = abap_true.
      ls_headerdata-simulation   = abap_true.

      CLEAR: gt_accounting, gt_return.
      CALL FUNCTION 'ZFMMM_MONITSERV_INVOICE_SIMULA'
        STARTING NEW TASK 'MM_INVOCMG_SIMULATE'
        CALLING setup_messages ON END OF TASK
        EXPORTING
          is_headerdata = ls_headerdata
        TABLES
          ct_itemdata   = lt_icm_item.

      WAIT UNTIL gv_wait_async = abap_true.
      CLEAR gv_wait_async.

      et_accounting = me->gt_accounting.
      et_return     = me->gt_return.
    ENDIF.
  ENDMETHOD.


  METHOD excluir_fatura.
    CHECK it_key[] IS NOT INITIAL.

    SELECT empresa,
           filial,
           lifnr,
           nr_nf,
           pedido,
           cnpj_cpf
      FROM ztmm_monit_cabec
       FOR ALL ENTRIES IN @it_key
     WHERE empresa = @it_key-empresa
       AND filial  = @it_key-filial
       AND lifnr   = @it_key-lifnr
*       AND nr_nf   = @it_key-nrnf
      INTO TABLE @DATA(lt_header).

    IF sy-subrc IS INITIAL.

      DATA(lt_header_fae) = lt_header[].
      SORT lt_header_fae BY nr_nf
                            cnpj_cpf.

      DELETE ADJACENT DUPLICATES FROM lt_header_fae COMPARING nr_nf
                                                              cnpj_cpf.
      IF lt_header_fae[] IS NOT INITIAL.
        SELECT client,
               nr_nf,
               cnpj_cpf,
               linha
          FROM ztmm_anexo_nf
           FOR ALL ENTRIES IN @lt_header_fae
         WHERE nr_nf    = @lt_header_fae-nr_nf
           AND cnpj_cpf = @lt_header_fae-cnpj_cpf
          INTO TABLE @DATA(lt_anexo).

        IF sy-subrc IS INITIAL.
          DELETE ztmm_anexo_nf FROM TABLE lt_anexo.
        ENDIF.
      ENDIF.

      lt_header_fae = lt_header[].
      SORT lt_header_fae BY empresa
                            filial
                            lifnr
                            nr_nf.

      DELETE ADJACENT DUPLICATES FROM lt_header_fae COMPARING empresa
                                                              filial
                                                              lifnr
                                                              nr_nf.
      IF lt_header_fae[] IS NOT INITIAL.
        SELECT client,
               empresa,
               filial,
               lifnr,
               nr_nf,
               nr_pedido,
               itm_pedido
          FROM ztmm_monit_item
           FOR ALL ENTRIES IN @lt_header_fae
         WHERE empresa = @lt_header_fae-empresa
           AND filial  = @lt_header_fae-filial
           AND lifnr   = @lt_header_fae-lifnr
           AND nr_nf   = @lt_header_fae-nr_nf
          INTO TABLE @DATA(lt_item).

        IF sy-subrc IS INITIAL.
          DELETE ztmm_monit_item FROM TABLE lt_item.
        ENDIF.

        SELECT client,
               empresa,
               filial,
               lifnr,
               nr_nf
          FROM ztmm_monit_cabec
           FOR ALL ENTRIES IN @lt_header_fae
         WHERE empresa = @lt_header_fae-empresa
           AND filial  = @lt_header_fae-filial
           AND lifnr   = @lt_header_fae-lifnr
           AND nr_nf   = @lt_header_fae-nr_nf
           INTO TABLE @DATA(lt_cabec).

        IF sy-subrc IS INITIAL.
          DELETE ztmm_monit_cabec FROM TABLE lt_cabec.

          IF sy-subrc IS INITIAL.

            IF lines( lt_header ) = 1.
              et_return = VALUE #( BASE et_return ( id     = gc_msg_id
                                                    number = 002
                                                    type   = gc_sucess ) ).

            ELSE.
              et_return = VALUE #( BASE et_return ( id     = gc_msg_id
                                                    number = 003
                                                    type   = gc_sucess ) ).
            ENDIF.

          ENDIF.
        ENDIF.
      ENDIF.
    ENDIF.

  ENDMETHOD.


  METHOD liberar_nf.
    CALL METHOD me->valida_dados_pre_registro
      EXPORTING
        is_key            = is_key
      IMPORTING
        et_return         = et_return
        ev_step_validacao = DATA(lv_step_validacao).

    CALL FUNCTION 'ZFMMM_UPDATE_CADFISCAL'
      STARTING NEW TASK 'ZTASK'
      CALLING finished ON END OF TASK
      EXPORTING
        is_key    = is_key
        iv_step   = lv_step_validacao
      CHANGING
        ct_return = et_return.

    WAIT FOR ASYNCHRONOUS TASKS UNTIL  gv_finished  = abap_true.

    CALL METHOD me->save_logs
      EXPORTING
        iv_object     = gc_log_object-cadastro_fiscal
        iv_subobject  = gc_log_action-liberar_nf
        iv_externalid = CONV string( is_key )
        it_return     = et_return.

  ENDMETHOD.


  METHOD check_invoice_servico.
*    CHECK iv_numero_nf CS '0123456789-'.
    SELECT COUNT( * )
    FROM ztmm_monit_cabec
   WHERE empresa = iv_empresa
     AND lifnr   = iv_fornecedor
     AND nr_nf   = iv_numero_nf.

    IF sy-subrc IS INITIAL.
      rv_istrue = abap_true.
    ENDIF.

  ENDMETHOD.


  METHOD get_cfop_invoice_miro.
    SELECT SINGLE cfop
      FROM zi_mm_monit_serv_item
     WHERE empresa = @iv_empresa
       AND lifnr   = @iv_fornecedor
       AND nrnf   = @iv_numero_nf
       AND matnr   = @iv_material
       AND werks   = @iv_centro
       INTO @rv_cfop.

    REPLACE ALL OCCURRENCES OF '/' IN rv_cfop WITH ''.
    CONDENSE rv_cfop.
  ENDMETHOD.


  METHOD registrar_fatura.
    CONSTANTS lc_currency TYPE waers VALUE 'BRL'.

    DATA lt_icm_item   TYPE STANDARD TABLE OF bapi_incinv_create_item.
    DATA ls_header     TYPE bapi2017_gm_head_01.
    DATA ls_code       TYPE bapi2017_gm_code.
    DATA ls_headerdata TYPE bapi_incinv_create_header.

    CHECK is_key IS NOT INITIAL.

    SELECT SINGLE
        empresa,
        filial,
        lifnr,
        dtemis,
        dtlancto,
        dtbase,
        nrnf,
        vltotnf,
        logexternalid
      FROM zi_mm_monit_serv_header
     WHERE empresa = @is_key-empresa
       AND filial  = @is_key-filial
       AND lifnr   = @is_key-lifnr
       AND nrnf   = @is_key-nrnf
      INTO @DATA(ls_nfheader).                       "#EC CI_SEL_NESTED

    SELECT
        nrpedido,
        itmpedido,
        iva,
        vlunit,
        qtdade_lcto,
        unid,
        ctgnf,
        cfop,
        serviceentrysheet,
        serviceentrysheetitem
      FROM zi_mm_monit_serv_item
     WHERE empresa = @ls_nfheader-empresa
       AND filial  = @ls_nfheader-filial
       AND lifnr   = @ls_nfheader-lifnr
       AND nrnf    = @ls_nfheader-nrnf
       AND qtdade_lcto > 0
      INTO TABLE @DATA(lt_item).                     "#EC CI_SEL_NESTED

    IF sy-subrc IS INITIAL.

      DATA(lv_nro_item) = CONV rblgp( 0 ).
      LOOP AT lt_item ASSIGNING FIELD-SYMBOL(<fs_item>).
        DATA(lv_nftype) = <fs_item>-ctgnf.

        lv_nro_item = lv_nro_item + 1.
        lt_icm_item = VALUE #( BASE lt_icm_item ( invoice_doc_item  = lv_nro_item
                                                  po_number         = <fs_item>-nrpedido
                                                  po_item           = <fs_item>-itmpedido
                                                  tax_code          = <fs_item>-iva
                                                  item_amount       = ( <fs_item>-vlunit * <fs_item>-qtdade_lcto )
                                                  quantity          = <fs_item>-qtdade_lcto
                                                  po_unit           = <fs_item>-unid
                                                  sheet_no          = <fs_item>-serviceentrysheet
                                                  sheet_item        = <fs_item>-serviceentrysheetitem
                                              ) ).

      ENDLOOP.

      ls_headerdata-invoice_ind  = abap_true.
      ls_headerdata-doc_date     = ls_nfheader-dtemis.
      ls_headerdata-bline_date   = ls_nfheader-dtbase.
      ls_headerdata-pstng_date   = COND #( WHEN ls_nfheader-dtlancto IS INITIAL THEN sy-datum ELSE ls_nfheader-dtlancto ).
*      ls_headerdata-pstng_date   = sy-datum.
      ls_headerdata-ref_doc_no   = ls_nfheader-nrnf.
      ls_headerdata-comp_code    = ls_nfheader-empresa.
      ls_headerdata-gross_amount = ls_nfheader-vltotnf.
      ls_headerdata-currency     = lc_currency.
      ls_headerdata-calc_tax_ind = abap_true.
      ls_headerdata-j_1bnftype   = lv_nftype.

      CLEAR gt_return.
      CALL FUNCTION 'ZFMMM_MONITSERV_INVOICE_CREATE'
        STARTING NEW TASK 'MM_INVOCMG_CREATE'
        CALLING setup_messages ON END OF TASK
        EXPORTING
          is_headerdata = ls_headerdata
        TABLES
          ct_itemdata   = lt_icm_item.

      WAIT UNTIL gv_wait_async = abap_true.
      et_return = me->gt_return.

      IF NOT line_exists( gt_return[ type = gc_error ] ).
        UPDATE ztmm_monit_cabec
          SET belnr = me->gv_invoicedocnumber
              gjahr = me->gv_fiscalyear
              erro  = abap_false
              job   = iv_job
        WHERE empresa = is_key-empresa
          AND filial  = is_key-filial
          AND lifnr   = is_key-lifnr
          AND nr_nf   = is_key-nrnf.                "#EC CI_IMUD_NESTED

        et_return = VALUE #( BASE et_return ( type       = gc_sucess
                                              id         = gc_msg_id
                                              number     = 005
                                              message_v1 = me->gv_invoicedocnumber
                                              message_v2 = me->gv_fiscalyear ) ).
      ELSE.
        UPDATE ztmm_monit_cabec
          SET erro  = abap_true
        WHERE empresa = is_key-empresa
          AND filial  = is_key-filial
          AND lifnr   = is_key-lifnr
          AND nr_nf   = is_key-nrnf.                "#EC CI_IMUD_NESTED
      ENDIF.
    ENDIF.

    CALL METHOD me->save_logs
      EXPORTING
        iv_object     = gc_log_object-monitor_lancto
        iv_subobject  = COND #( WHEN iv_job = abap_true THEN gc_log_action-lancar_fatura ELSE gc_log_action-lancar_fatura )
        iv_externalid = ls_nfheader-logexternalid
        it_return     = et_return.
  ENDMETHOD.


  METHOD setup_messages.

    DATA: lt_return       TYPE STANDARD TABLE OF bapiret2,
          lt_goodsmv_item TYPE STANDARD TABLE OF bapi2017_gm_item_create.

    CASE p_task.
      WHEN 'MM_INVOCMG_CANCEL'.

        RECEIVE RESULTS FROM FUNCTION 'ZFMMM_MONITSERV_INVOICE_CANCEL'
         IMPORTING
           et_return = gt_return.

        me->gv_wait_async = abap_true.

      WHEN 'MM_INVOCMG_CREATE'.

        RECEIVE RESULTS FROM FUNCTION 'ZFMMM_MONITSERV_INVOICE_CREATE'
         IMPORTING
           ev_invoicedocnumber = gv_invoicedocnumber
           ev_fiscalyear       = gv_fiscalyear
         TABLES
           ct_return           = me->gt_return.

        me->gv_wait_async = abap_true.

      WHEN 'MM_INVOCMG_SIMULATE'.

        RECEIVE RESULTS FROM FUNCTION 'ZFMMM_MONITSERV_INVOICE_SIMULA'
         IMPORTING
           et_accounting = me->gt_accounting
           et_return     = me->gt_return.

        me->gv_wait_async = abap_true.

      WHEN 'MM_CALC_DUO_DATE'.

        CLEAR me->gv_duo_date.
        RECEIVE RESULTS FROM FUNCTION 'ZFMMM_CALCULATE_DUO_DATE_MIRO'
         IMPORTING
           ev_duo_date = me->gv_duo_date.

        me->gv_wait_async = abap_true.

      WHEN OTHERS.
    ENDCASE.

  ENDMETHOD.


  METHOD valida_dados_pre_registro.

    SELECT SINGLE
           pedido,
           vltotnf,
           cnpjcpf,
           lifnr,
           vlcofins,
           vlcsll,
           vlinss,
           vlir,
           vliss,
           vlpis,
           domiciliofiscal,
           lc,
           nrnf,
           flaghasanexo
      FROM zi_mm_cadastro_fiscal_cabec
     WHERE empresa = @is_key-empresa
       AND filial  = @is_key-filial
       AND lifnr   = @is_key-lifnr
       AND nrnf    = @is_key-nrnf
      INTO @DATA(ls_nfheader).

    me->simular_contabilizacao( EXPORTING is_key = is_key
                                IMPORTING et_accounting = DATA(lt_accounting)
                                          et_return     = DATA(lt_return) ).

*    me->valida_total_impostos(
*      EXPORTING
*        iv_vlr_cofins = ls_nfheader-VlCofins
*        iv_vlr_csll   = ls_nfheader-VlCsll
*        iv_vlr_inss   = ls_nfheader-VlInss
*        iv_vlr_iss    = ls_nfheader-VlIss
*        iv_vlr_ir     = ls_nfheader-VlIr
*        iv_vlr_pis    = ls_nfheader-VlPis
*        it_accounting = lt_accounting
*      CHANGING
*        ct_return     = lt_return
*    ).
    me->valida_is_step_validacao( EXPORTING iv_fornecedor = ls_nfheader-lifnr
                                            iv_ncm        = ls_nfheader-lc
                                  RECEIVING rv_istrue     = ev_step_validacao ).

    me->valida_total_nf( EXPORTING iv_vlr_total = ls_nfheader-vltotnf
                                   it_accounting = lt_accounting
                          CHANGING ct_return     = lt_return ).

    me->valida_estrategia_pedido( EXPORTING iv_pedido = ls_nfheader-pedido
                                   CHANGING ct_return = lt_return ).

*    me->valida_cnpj_danfe_pedido(
*      EXPORTING
*        iv_cnpjcpf    = ls_nfheader-CnpjCpf
*        iv_fornecedor = ls_nfheader-Lifnr
*      CHANGING
*        ct_return     = lt_return
*    ).

    me->valida_domicilio_fiscal( EXPORTING is_key       = is_key
                                           iv_pedido    = ls_nfheader-pedido
                                           iv_domicilio = ls_nfheader-domiciliofiscal
                                  CHANGING ct_return    = lt_return ).

    me->valida_ncm( EXPORTING is_key     = is_key
                              iv_pedido  = ls_nfheader-pedido
                              iv_ncm     = ls_nfheader-lc
                     CHANGING ct_return  = lt_return ).

    me->valida_anexo( EXPORTING iv_flag_anexo = ls_nfheader-flaghasanexo
                       CHANGING ct_return = lt_return ).

    me->valida_retencao( EXPORTING is_key       = is_key
                          CHANGING ct_return = lt_return ).

    me->valida_quantidade( EXPORTING is_key      = is_key
                                   iv_pedido     = ls_nfheader-pedido
                                   it_accounting = lt_accounting
                          CHANGING ct_return     = lt_return ).

    APPEND LINES OF lt_return TO et_return.
*    lv_branch = is_cad_fiscal-cnpjcpf.
*
*    CALL FUNCTION 'J_1BREAD_BRANCH_DATA'
*      EXPORTING
*        branch            = lv_branch
*        bukrs             = is_cad_fiscal-empresa
*      IMPORTING
*        cgc_number        = lv_cgc_number
*      EXCEPTIONS
*        branch_not_found  = 1
*        address_not_found = 2
*        company_not_found = 3
*        OTHERS            = 4.
*
*    IF sy-subrc IS INITIAL.
*      et_return = VALUE #( BASE et_return ( id     = gc_msg_id
*                                            type   = gc_error
*                                            number = gc_msg_018 ) ).
*      et_return = VALUE #( BASE et_return ( id     = gc_msg_id
*                                            type   = gc_error
*                                            number = gc_msg_019 ) ).
*    ENDIF.
  ENDMETHOD.


  METHOD valida_total_impostos.
    DATA lt_return  TYPE TABLE OF bapiret2.
    DATA lv_msgtype TYPE syst_msgty.

    DATA(lt_accounting) = it_accounting.
    SORT lt_accounting BY qsskz.

    LOOP AT lt_accounting INTO DATA(ls_accounting) WHERE qsskz IS NOT INITIAL.
      DATA(lv_tax_value) = CONV dmbtr( ls_accounting-dmbtr * -1 ).

      CASE ls_accounting-qsskz.
        WHEN gc_irf_code-cofins.
          IF lv_tax_value <> iv_vlr_cofins.
            lv_msgtype = gc_error.
          ELSE.
            lv_msgtype = gc_sucess.
          ENDIF.

          lt_return = VALUE #( BASE lt_return ( id     = gc_msg_id
                                                type   = lv_msgtype
                                                message_v1 = 'COFINS'
                                                message_v2 = |{ lv_tax_value }|
                                                message_v3 = |{ iv_vlr_cofins }|
                                                number = 030 ) ).

        WHEN gc_irf_code-csll.
          IF lv_tax_value <> iv_vlr_csll.
            lv_msgtype = gc_error.
          ELSE.
            lv_msgtype = gc_sucess.
          ENDIF.

          lt_return = VALUE #( BASE lt_return ( id     = gc_msg_id
                                                type   = lv_msgtype
                                                message_v1 = 'CSLL'
                                                message_v2 = |{ lv_tax_value }|
                                                message_v3 = |{ iv_vlr_csll }|
                                                number = 030 ) ).
        WHEN gc_irf_code-inss.
          IF lv_tax_value <> iv_vlr_inss.
            lv_msgtype = gc_error.
          ELSE.
            lv_msgtype = gc_sucess.
          ENDIF.

          lt_return = VALUE #( BASE lt_return ( id     = gc_msg_id
                                                type   = lv_msgtype
                                                message_v1 = 'INSS'
                                                message_v2 = |{ lv_tax_value }|
                                                message_v3 = |{ iv_vlr_inss }|
                                                number = 030 ) ).
        WHEN gc_irf_code-ir.
          IF lv_tax_value <> iv_vlr_ir.
            lv_msgtype = gc_error.
          ELSE.
            lv_msgtype = gc_sucess.
          ENDIF.

          lt_return = VALUE #( BASE lt_return ( id     = gc_msg_id
                                                type   = lv_msgtype
                                                message_v1 = 'IR'
                                                message_v2 = |{ lv_tax_value }|
                                                message_v3 = |{ iv_vlr_ir }|
                                                number = 030 ) ).
        WHEN gc_irf_code-iss.
          IF lv_tax_value <> iv_vlr_iss.
            lv_msgtype = gc_error.
          ELSE.
            lv_msgtype = gc_sucess.
          ENDIF.

          lt_return = VALUE #( BASE lt_return ( id     = gc_msg_id
                                                type   = lv_msgtype
                                                message_v1 = 'ISS'
                                                message_v2 = |{ lv_tax_value }|
                                                message_v3 = |{ iv_vlr_iss }|
                                                number = 030 ) ).
        WHEN gc_irf_code-pcc.
          DATA(lv_vlr_pcc) = CONV j_1btaxval( iv_vlr_pis + iv_vlr_cofins + iv_vlr_csll ).
          IF lv_tax_value <> lv_vlr_pcc.
            lv_msgtype = gc_error.
          ELSE.
            lv_msgtype = gc_sucess.
          ENDIF.

          lt_return = VALUE #( BASE lt_return ( id     = gc_msg_id
                                                type   = lv_msgtype
                                                message_v1 = 'PCC'
                                                message_v2 = |{ lv_tax_value }|
                                                message_v3 = |{ lv_vlr_pcc }|
                                                number = 030 ) ).
        WHEN gc_irf_code-pis.
          IF lv_tax_value <> iv_vlr_pis.
            lv_msgtype = gc_error.
          ELSE.
            lv_msgtype = gc_sucess.
          ENDIF.

          lt_return = VALUE #( BASE lt_return ( id     = gc_msg_id
                                                type   = lv_msgtype
                                                message_v1 = 'PIS'
                                                message_v2 = |{ lv_tax_value }|
                                                message_v3 = |{ iv_vlr_pis }|
                                                number = 030 ) ).
      ENDCASE.

    ENDLOOP.

    IF line_exists( lt_return[ type = gc_error ] ).
      ct_return = VALUE #( ( id = gc_msg_id type = gc_error number = 029 ) ).
      APPEND LINES OF lt_return TO ct_return.
    ENDIF.
  ENDMETHOD.


  METHOD valida_is_step_validacao.
    CONSTANTS lc_regimes_simples TYPE char3 VALUE '124'.
    DATA lt_ncm_redbase TYPE rsis_t_range.

    TRY.
        DATA(lo_param) = zclca_tabela_parametros=>get_instance( ).    " CHANGE - JWSILVA - 21.07.2023
        lo_param->m_get_range(
          EXPORTING
            iv_modulo = gc_param_module
            iv_chave1 = gc_param_monitor
            iv_chave2 = gc_param_ncms_redbase
          IMPORTING
            et_range  = lt_ncm_redbase
        ).
      CATCH zcxca_tabela_parametros.
    ENDTRY.

    "//validar NCM se há redução de base
    IF lt_ncm_redbase IS NOT INITIAL AND iv_ncm IN lt_ncm_redbase.
      rv_istrue = abap_true.
      RETURN.
    ENDIF.

    "//validar regime contribuição do BP
    SELECT SINGLE crtn
      FROM lfa1
      INTO @DATA(lv_tipo_contribuinte)
     WHERE lifnr = @iv_fornecedor.

    IF lc_regimes_simples CS lv_tipo_contribuinte AND lv_tipo_contribuinte IS NOT INITIAL.
      rv_istrue = abap_true.
      RETURN.
    ENDIF.
  ENDMETHOD.


  METHOD valida_total_nf.
    DATA lv_total_sum  TYPE bseg-dmbtr.

*    DATA(lt_return) = ct_return.
*    CLEAR ct_return.

    IF NOT line_exists( ct_return[ type = gc_error ] ).

      "Somar linha de fornecedor + retidos
      LOOP AT it_accounting INTO DATA(ls_accounting) WHERE shkzg = 'K' OR qsskz IS NOT INITIAL.
        lv_total_sum = lv_total_sum + ( ls_accounting-dmbtr * -1 ).
      ENDLOOP.

      "Total da NF diferente do valor total calculado na contrapartida do fornecedor
      IF iv_vlr_total NE lv_total_sum.
        ct_return = VALUE #( BASE ct_return ( id     = gc_msg_id
                                              type   = gc_error
                                              number = 009 ) ).
        ct_return = VALUE #( BASE ct_return ( id     = gc_msg_id
                                              type   = gc_error
                                              number = 010 ) ).
        ct_return = VALUE #( BASE ct_return ( id     = gc_msg_id
                                              type   = gc_error
                                              number = 011 ) ).
      ENDIF.

      "Saldo não é igual a zero
    ELSEIF line_exists( ct_return[ id = 'M8' number = 534 ] ).
      ct_return = VALUE #( BASE ct_return ( id     = gc_msg_id
                                            type   = gc_error
                                            number = 009 ) ).
      ct_return = VALUE #( BASE ct_return ( id     = gc_msg_id
                                            type   = gc_error
                                            number = 010 ) ).
      ct_return = VALUE #( BASE ct_return ( id     = gc_msg_id
                                            type   = gc_error
                                            number = 011 ) ).
    ELSE.
      ct_return = VALUE #( BASE ct_return ( id     = gc_msg_id
                                            type   = gc_error
                                            number = 054 ) ).
    ENDIF.
  ENDMETHOD.


  METHOD valida_estrategia_pedido.
    SELECT SINGLE
        frggr
      FROM ekko
     WHERE ebeln = @iv_pedido
      INTO @DATA(lv_status_estrategia).

    IF sy-subrc IS INITIAL.
      IF lv_status_estrategia EQ 'B'. " Bloqueado, modificável c/valor
        ct_return = VALUE #( BASE ct_return ( id     = gc_msg_id
                                              type   = gc_error
                                              number = 012 ) ).
        ct_return = VALUE #( BASE ct_return ( id     = gc_msg_id
                                              type   = gc_error
                                              number = 013 ) ).
      ENDIF.
    ENDIF.
  ENDMETHOD.


  METHOD valida_domicilio_fiscal.
    SELECT domiciliofiscalpo,
           domiciliofiscalnf,
           itmpedido
      FROM zi_mm_cadastro_fiscal_item
     WHERE nrpedido = @iv_pedido
       AND empresa  = @is_key-empresa
       AND filial   = @is_key-filial
       AND lifnr    = @is_key-lifnr
       AND nrnf     = @is_key-nrnf
       AND qtdade_lcto > 0
      INTO TABLE @DATA(lt_po_items).

    LOOP AT lt_po_items ASSIGNING FIELD-SYMBOL(<fs_item>).
      IF <fs_item>-domiciliofiscalpo <> <fs_item>-domiciliofiscalnf.
        ct_return = VALUE #( BASE ct_return ( id     = gc_msg_id
                                              type   = gc_error
                                              number = 031
                                              message_v1 = <fs_item>-domiciliofiscalnf
                                              message_v2 = <fs_item>-itmpedido
                                              message_v3 = <fs_item>-domiciliofiscalpo
                           ) ).
      ENDIF.
    ENDLOOP.
  ENDMETHOD.


  METHOD valida_ncm.
    SELECT lcpo,
           lcnf,
           itmpedido
      FROM zi_mm_cadastro_fiscal_item
     WHERE nrpedido = @iv_pedido
       AND empresa  = @is_key-empresa
       AND filial   = @is_key-filial
       AND lifnr    = @is_key-lifnr
       AND nrnf     = @is_key-nrnf
       AND qtdade_lcto > 0
      INTO TABLE @DATA(lt_po_items).

    LOOP AT lt_po_items ASSIGNING FIELD-SYMBOL(<fs_item>).
      IF <fs_item>-lcnf <> <fs_item>-lcpo.
        ct_return = VALUE #( BASE ct_return ( id     = gc_msg_id
                                              type   = gc_error
                                              number = 032
                                              message_v1 = <fs_item>-lcnf
                                              message_v2 = <fs_item>-itmpedido
                                              message_v3 = <fs_item>-lcpo
                           ) ).
      ENDIF.
    ENDLOOP.
  ENDMETHOD.


  METHOD valida_anexo.
    IF iv_flag_anexo IS INITIAL.
      ct_return = VALUE #( BASE ct_return ( id     = gc_msg_id
                                            type   = gc_error
                                            number = 015
                                        ) ).
    ENDIF.
  ENDMETHOD.


  METHOD get_posting_parameters.
    CONSTANTS:
      lc_ativo_cls TYPE char2 VALUE 'AP',
      lc_servico   TYPE char1 VALUE 'S',
      lc_ativo     TYPE char1 VALUE 'I',
      lc_rpa       TYPE char1 VALUE 'R'.

    SELECT SINGLE
        _item~werks,
        _item~matnr,
        _item~matkl,
        _ekkn~sakto,
        _item~knttp,
        _loc~j_1bbranch AS branch
    FROM ekpo AS _item
   INNER JOIN t001w AS _loc ON _loc~werks = _item~werks
   INNER JOIN ekkn  AS _ekkn ON _item~ebeln = _ekkn~ebeln AND _item~ebelp = _ekkn~ebelp
    INTO @DATA(ls_po_item)
   WHERE _item~ebeln = @iv_pedido
     AND _item~ebelp = @iv_item.                       "#EC CI_BUFFJOIN

    IF iv_is_rpa = abap_true.
      SELECT SINGLE *
        FROM ztmm_param_monse
        INTO rs_parameters
       WHERE z_op = lc_rpa.

      RETURN.
    ENDIF.

    DATA(lv_operacao) = COND #( WHEN lc_ativo_cls CS ls_po_item-knttp THEN lc_ativo ELSE '' ).

    "//Specific rules for plant
    SELECT SINGLE *
      FROM ztmm_param_monse
      INTO rs_parameters
     WHERE werks = ls_po_item-werks
       AND matnr = ls_po_item-matnr
       AND hkont = ls_po_item-sakto
       AND z_op  = lv_operacao.

    IF sy-subrc IS INITIAL.
      RETURN.
    ENDIF.

    SELECT SINGLE *
      FROM ztmm_param_monse
      INTO rs_parameters
     WHERE werks = ls_po_item-werks
       AND matnr = ls_po_item-matnr
       AND z_op  = lv_operacao.

    IF sy-subrc IS INITIAL.
      RETURN.
    ENDIF.

    SELECT SINGLE *
      FROM ztmm_param_monse
      INTO rs_parameters
     WHERE werks = ls_po_item-werks
       AND matkl = ls_po_item-matkl
       AND z_op  = lv_operacao.

    IF sy-subrc IS INITIAL.
      RETURN.
    ENDIF.

    SELECT SINGLE *
     FROM ztmm_param_monse
     INTO rs_parameters
    WHERE werks = ls_po_item-werks
      AND hkont = ls_po_item-sakto
      AND z_op  = lv_operacao.

    IF sy-subrc IS INITIAL.
      RETURN.
    ENDIF.

    SELECT SINGLE *
     FROM ztmm_param_monse
     INTO rs_parameters
    WHERE werks = ls_po_item-werks
      AND z_op  = lv_operacao.

    IF sy-subrc IS INITIAL.
      RETURN.
    ENDIF.

    "//Specific rules for branch
    SELECT SINGLE *
      FROM ztmm_param_monse
      INTO rs_parameters
     WHERE branch = ls_po_item-branch
       AND matnr  = ls_po_item-matnr
       AND hkont  = ls_po_item-sakto
       AND z_op   = lv_operacao.

    IF sy-subrc IS INITIAL.
      RETURN.
    ENDIF.

    SELECT SINGLE *
      FROM ztmm_param_monse
      INTO rs_parameters
     WHERE branch = ls_po_item-branch
       AND matnr  = ls_po_item-matnr
       AND z_op   = lv_operacao.

    IF sy-subrc IS INITIAL.
      RETURN.
    ENDIF.

    SELECT SINGLE *
      FROM ztmm_param_monse
      INTO rs_parameters
     WHERE branch = ls_po_item-branch
       AND matkl  = ls_po_item-matkl
       AND z_op   = lv_operacao.

    IF sy-subrc IS INITIAL.
      RETURN.
    ENDIF.

    SELECT SINGLE *
      FROM ztmm_param_monse
      INTO rs_parameters
     WHERE branch = ls_po_item-branch
       AND hkont  = ls_po_item-sakto
       AND z_op   = lv_operacao.

    IF sy-subrc IS INITIAL.
      RETURN.
    ENDIF.

    "//Generic rules
    SELECT SINGLE *
      FROM ztmm_param_monse
      INTO rs_parameters
     WHERE matnr  = ls_po_item-matnr
       AND werks  = space
       AND branch = space
       AND hkont  = space
       AND z_op   = lv_operacao.

    IF sy-subrc IS INITIAL.
      RETURN.
    ENDIF.

    SELECT SINGLE *
      FROM ztmm_param_monse
      INTO rs_parameters
     WHERE branch = ls_po_item-branch
       AND werks  = space
       AND matnr  = space
       AND hkont  = space
       AND z_op   = lv_operacao.

    IF sy-subrc IS INITIAL.
      RETURN.
    ENDIF.

    SELECT SINGLE *
      FROM ztmm_param_monse
      INTO rs_parameters
     WHERE matkl  = ls_po_item-matkl
       AND branch = space
       AND werks  = space
       AND matnr  = space
       AND z_op   = lv_operacao.

    IF sy-subrc IS INITIAL.
      RETURN.
    ENDIF.

    SELECT SINGLE *
      FROM ztmm_param_monse
      INTO rs_parameters
     WHERE hkont  = ls_po_item-sakto
       AND branch = space
       AND werks  = space
       AND matnr  = space
       AND z_op   = lv_operacao.

    IF sy-subrc IS INITIAL.
      RETURN.
    ENDIF.

    IF ( lc_ativo_cls CS ls_po_item-knttp ).
      SELECT SINGLE *
        FROM ztmm_param_monse
        INTO rs_parameters
       WHERE z_op = lc_ativo.

      IF sy-subrc IS INITIAL.
        RETURN.
      ENDIF.
    ELSE.
      SELECT SINGLE *
        FROM ztmm_param_monse
        INTO rs_parameters
       WHERE z_op = lc_servico.

      IF sy-subrc IS INITIAL.
        RETURN.
      ENDIF.
    ENDIF.
  ENDMETHOD.


  METHOD simular_fatura.
    SELECT SINGLE logexternalid
      FROM zi_mm_cadastro_fiscal_cabec
     WHERE empresa = @is_key-empresa
       AND filial  = @is_key-filial
       AND lifnr   = @is_key-lifnr
       AND nrnf    = @is_key-nrnf
      INTO @DATA(lv_logid).

    me->simular_contabilizacao(
      EXPORTING
        is_key    = VALUE #(
            empresa = is_key-empresa
            filial  = is_key-filial
            lifnr   = is_key-lifnr
            nrnf    = is_key-nrnf
        )
      IMPORTING
        et_accounting = et_accounting
        et_return     = et_return
    ).

    IF NOT line_exists( et_return[ type = gc_error ] ).
      et_return = VALUE #( BASE et_return ( id     = gc_msg_id
                                            type   = gc_sucess
                                            number = 008 ) ).
    ENDIF.

    CALL METHOD me->save_logs
      EXPORTING
        iv_object     = gc_log_object-monitor_lancto
        iv_subobject  = gc_log_action-simular_fatura
        iv_externalid = lv_logid
        it_return     = et_return.
  ENDMETHOD.


  METHOD valida_input_pedido_compras.
    SELECT
         _po~ebeln,
         _po~ebelp,
         _po~meins,
         _po~qtdadepedido,
         _po~qtdadelancada,
         _po~qtdadedisponivel,
         _poitm~webre AS flagem,
         _sh~approvalstatus,
         _si~serviceentrysheet,
         _si~serviceentrysheetitem,
         _cb~bukrs,
         _cb~lifnr,
         _poitm~matnr
      FROM zi_mm_monit_serv_po_values AS _po
      INNER JOIN ekpo AS _poitm ON _poitm~ebeln = _po~ebeln AND _poitm~ebelp = _po~ebelp
      LEFT JOIN i_serviceentrysheetitem AS _si ON _si~purchaseorder = _po~ebeln AND _si~purchaseorderitem = _po~ebelp
      LEFT JOIN i_serviceentrysheet AS _sh ON _sh~purchaseorder = _si~purchaseorder
      LEFT JOIN ekko                AS _cb ON _cb~ebeln         = _po~ebeln
     WHERE _po~ebeln = @iv_pedido
*       AND _po~qtdadedisponivel > 0
      INTO TABLE @DATA(lt_po_items).

    IF lt_po_items IS INITIAL.
      ct_return = VALUE #( BASE ct_return (
        id = zclmm_lanc_servicos=>gc_msg_id
        number = 024
        message_v1 = iv_pedido
        type = zclmm_lanc_servicos=>gc_error
      ) ).
    ENDIF.

    CHECK lt_po_items IS NOT INITIAL.

    LOOP AT lt_po_items ASSIGNING FIELD-SYMBOL(<fs_po_item>).
      DATA(ls_param) = me->get_posting_parameters( iv_pedido = <fs_po_item>-ebeln iv_item = <fs_po_item>-ebelp iv_is_rpa = iv_is_rpa ).

      IF ls_param IS INITIAL.
        ct_return = VALUE #( BASE ct_return (
          id = zclmm_lanc_servicos=>gc_msg_id
          number = 033
          message_v1 = <fs_po_item>-ebeln
          message_v2 = <fs_po_item>-ebelp
          type = zclmm_lanc_servicos=>gc_error
        ) ).
      ENDIF.

      DATA(lv_matnr) =  |{ <fs_po_item>-matnr ALPHA = OUT }|.

      IF lv_matnr(1) = '5' AND
        <fs_po_item>-serviceentrysheet IS INITIAL AND <fs_po_item>-flagem = abap_true.
        ct_return = VALUE #( BASE ct_return (
          id = zclmm_lanc_servicos=>gc_msg_id
          number = 034
          message_v1 = <fs_po_item>-ebeln
          message_v2 = <fs_po_item>-ebelp
          type = zclmm_lanc_servicos=>gc_error
        ) ).
      ENDIF.

      IF <fs_po_item>-serviceentrysheet IS NOT INITIAL
     AND <fs_po_item>-approvalstatus    NE '30'.
        ct_return = VALUE #( BASE ct_return (
          id = zclmm_lanc_servicos=>gc_msg_id
          number = 035
          message_v1 = <fs_po_item>-ebeln
          message_v2 = <fs_po_item>-ebelp
          type = zclmm_lanc_servicos=>gc_error
        ) ).
      ENDIF.
    ENDLOOP.

    IF ( <fs_po_item> IS ASSIGNED ).
      IF iv_empresa <> <fs_po_item>-bukrs.
        ct_return = VALUE #( BASE ct_return (
          id = zclmm_lanc_servicos=>gc_msg_id
          number = 051
          message_v1 = iv_empresa
          message_v2 = <fs_po_item>-bukrs
          type = zclmm_lanc_servicos=>gc_error
        ) ).
      ENDIF.

      IF iv_bp <> <fs_po_item>-lifnr.
        ct_return = VALUE #( BASE ct_return (
          id = zclmm_lanc_servicos=>gc_msg_id
          number = 052
          message_v1 = iv_bp
          message_v2 = <fs_po_item>-lifnr
          type = zclmm_lanc_servicos=>gc_error
        ) ).
      ENDIF.
    ENDIF.

    et_po_items = CORRESPONDING #( lt_po_items ).
  ENDMETHOD.


  METHOD get_duo_date.

    SELECT SINGLE zterm
      FROM ekko
     WHERE ebeln = @iv_pedido
      INTO @DATA(lv_payment_cond).

    CALL FUNCTION 'ZFMMM_CALCULATE_DUO_DATE_MIRO'
      STARTING NEW TASK 'MM_CALC_DUO_DATE'
      CALLING setup_messages ON END OF TASK
      EXPORTING
        iv_bline_date = iv_bline_date
        iv_paym_cond  = lv_payment_cond.

    WAIT UNTIL gv_wait_async = abap_true.
    rv_duo_date = me->gv_duo_date.
  ENDMETHOD.


  METHOD get_cnpj_cpf_bp.
    SELECT SINGLE
        taxnum
      FROM dfkkbptaxnum
     WHERE partner EQ @iv_fornecedor
       AND taxtype IN ( 'BR1', 'BR2' )
      INTO @rv_cnpjcpf.

*    IF lv_id_fiscal_fornecedor NE iv_cnpjcpf.
*      ct_return = VALUE #( BASE ct_return ( id     = gc_msg_id
*                                            type   = gc_error
*                                            number = 016 ) ).
*    ENDIF.
  ENDMETHOD.


  METHOD save_logs.
    DATA ls_log TYPE bal_s_log.

    ls_log-aluser    = sy-uname.
    ls_log-alprog    = sy-repid.
    ls_log-object    = iv_object.
    ls_log-subobject = iv_subobject.
    ls_log-extnumber = iv_externalid.

    CALL FUNCTION 'ZFMCA_LOG_MSG_ADD'
      STARTING NEW TASK 'SAVE_LOG'
      EXPORTING
        is_log  = ls_log
        it_msgs = it_return.

  ENDMETHOD.


  METHOD valida_retencao.

    SELECT SINGLE lifnr, bukrs
    FROM lfbw
    INTO @DATA(ls_lfbw)
    WHERE lifnr = @is_key-lifnr
    AND   bukrs = @is_key-empresa.

    IF sy-subrc IS NOT INITIAL.

      SELECT SINGLE lifnr, crtn
      FROM lfa1
        INTO @DATA(ls_lfa1)
        WHERE lifnr = @is_key-lifnr.

      IF sy-subrc IS INITIAL.

        IF   ls_lfa1-crtn = '3'
             OR ls_lfa1-crtn = ''.

          ct_return = VALUE #( BASE ct_return (
           id = zclmm_lanc_servicos=>gc_msg_id
           number = 055
           type = zclmm_lanc_servicos=>gc_error
         ) ).

        ENDIF.

      ENDIF.

    ENDIF.

  ENDMETHOD.


  METHOD valida_quantidade.
    DATA lr_ctg_classif TYPE RANGE OF knttp.
    DATA lv_qtdade_lcto TYPE j_1bnetqty.
    DATA lv_quatity     TYPE menge_d.

    SELECT purchaseorder,
           accountassignmentcategory
      FROM i_purchaseorderitem
     WHERE purchaseorder = @iv_pedido
      INTO TABLE @DATA(lt_category).

    TRY.
        DATA(lo_param) = zclca_tabela_parametros=>get_instance( ).    " CHANGE - JWSILVA - 21.07.2023
        lo_param->m_get_range(
          EXPORTING
            iv_modulo = gc_param_module
            iv_chave1 = gc_param_monitor
            iv_chave2 = gc_param_ctg_contabil
          IMPORTING
            et_range  = lr_ctg_classif
        ).
      CATCH zcxca_tabela_parametros.
    ENDTRY.

    DELETE lt_category WHERE accountassignmentcategory NOT IN lr_ctg_classif. "#EC CI_SEL_DEL
    CHECK lt_category IS NOT INITIAL.

    SELECT SINGLE client,
           empresa,
           filial,
           lifnr,
           nr_nf
      FROM ztmm_monit_cabec
     WHERE empresa = @is_key-empresa
       AND filial  = @is_key-filial
       AND lifnr   = @is_key-lifnr
       AND nr_nf    = @is_key-nrnf
      INTO @DATA(ls_cabec).

    IF sy-subrc IS INITIAL.
      SELECT client,
             empresa,
             filial,
             lifnr,
             nr_nf,
             nr_pedido,
             itm_pedido,
             qtdade_lcto
        FROM ztmm_monit_item
       WHERE empresa = @ls_cabec-empresa
         AND filial  = @ls_cabec-filial
         AND lifnr   = @ls_cabec-lifnr
         AND nr_nf   = @ls_cabec-nr_nf
        INTO TABLE @DATA(lt_item).

      IF sy-subrc IS INITIAL.

        IF NOT line_exists( ct_return[ type = gc_error ] ).

          LOOP AT lt_item INTO DATA(ls_item_s).
            lv_qtdade_lcto = lv_qtdade_lcto + ls_item_s-qtdade_lcto .
          ENDLOOP.

          LOOP AT it_accounting INTO DATA(ls_accounting) WHERE shkzg = 'K' OR qsskz IS NOT INITIAL.
            lv_quatity = lv_quatity + ls_accounting-menge .
          ENDLOOP.
        ENDIF.

        " Total da NF diferente do valor total calculado na contrapartida do fornecedor
*        IF lv_qtdade_lcto NE lv_quatity.
*          ct_return = VALUE #( BASE ct_return ( id     = gc_msg_id
*                                                type   = gc_error
*                                                number = 056 ) ).
*        ENDIF.
      ENDIF.
    ENDIF.

  ENDMETHOD.


  METHOD finished.
    gv_finished = abap_true.
  ENDMETHOD.
ENDCLASS.
