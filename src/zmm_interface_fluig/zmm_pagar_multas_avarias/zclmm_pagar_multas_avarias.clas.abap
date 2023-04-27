CLASS zclmm_pagar_multas_avarias DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.

    DATA: gv_lifnr TYPE lifnr.
    CLASS-DATA: gv_lifnr2 TYPE lifnr.

    METHODS:
      get_data
        IMPORTING
          is_input  TYPE zclmm_mt_pagamento
        EXPORTING
          es_output TYPE zclmm_mt_pagamento_resp.

  PROTECTED SECTION.
  PRIVATE SECTION.

    DATA gs_input    TYPE zclmm_mt_pagamento.
    DATA gs_output   TYPE zclmm_mt_pagamento_resp.
    DATA gs_header   TYPE bapiache09.
    DATA gt_acc_gl   TYPE bapiacgl09_tab.
    DATA gt_acc_able TYPE bapiacap09_tab.
    DATA gt_acc_rec  TYPE bapiacar09_tab.
    DATA gt_currency TYPE bapiaccr09_tab.
    DATA gt_return   TYPE bapiret2_t.

    METHODS:
      process_data,
      bapi_post.

ENDCLASS.

CLASS zclmm_pagar_multas_avarias IMPLEMENTATION.

  METHOD process_data.

    TYPES: BEGIN OF ty_param_val,
             modulo TYPE ze_param_modulo,
             chave1 TYPE  ze_param_chave,
             low    TYPE ze_param_low,
             high   TYPE ze_param_high,
           END OF ty_param_val.

    DATA: ls_acc_gl         TYPE bapiacgl09,
          ls_acc_able       TYPE bapiacap09,
          ls_acc_rec        TYPE bapiacar09,
          ls_currency       TYPE bapiaccr09,
          lv_cnpj_fmt       TYPE pbr99_cgc,
          lv_cgc_number_raw TYPE pbr99_cgc,
          lt_param_val      TYPE TABLE OF ty_param_val,
          lv_cont           TYPE i VALUE 1.
    CONSTANTS: lc_zeros(9) TYPE c VALUE '000000000'.

    SELECT modulo
           chave1
           low
           high
      INTO TABLE lt_param_val
      FROM ztca_param_val
      WHERE modulo = 'FI-AP'
      AND   chave1 = 'FLEG_FLUIG'.

    FIELD-SYMBOLS: <fs_param_val> LIKE LINE OF lt_param_val.

    SELECT SINGLE party
        INTO @DATA(lv_party)
        FROM p_companycodeaddl
        WHERE companycode = @gs_input-mt_pagamento-comp_code
        AND   party = 'J_1BCG'.
    IF sy-subrc = 0.

      SELECT SINGLE kostl, gsber
          INTO (@DATA(lv_kostl),
                @DATA(lv_gsber))
          FROM vfco_csks_shv_no_auth
          WHERE kokrs = 'AC3C'.
      IF sy-subrc = 0.

        DATA(lv_comp_code_length) = strlen( gs_input-mt_pagamento-comp_code ).
        IF lv_comp_code_length = 18.

          lv_cnpj_fmt = gs_input-mt_pagamento-comp_code.
          CALL FUNCTION 'HR_BR_CHECK_CGC_FORMAT' "
            EXPORTING
              cgc_number               = lv_cnpj_fmt
            IMPORTING
*             cgc_number_formatted     =      " pbr99_cgc
              cgc_number_raw           = lv_cgc_number_raw
            EXCEPTIONS
              cgc_format_not_supported = 1
              cgc_check_digit          = 2.
          IF sy-subrc = 0.
            gs_input-mt_pagamento-comp_code = lv_cgc_number_raw.
          ENDIF.

        ENDIF.

        SELECT SINGLE lifnr
            INTO @gv_lifnr
            FROM lfa1
            WHERE stcd1 = @gs_input-mt_pagamento-comp_code.

        me->gs_header-obj_type    = 'BKPFF'.
        me->gs_header-username    = sy-uname.
        me->gs_header-header_txt  = 'FROTA'.
        me->gs_header-comp_code   = gs_input-mt_pagamento-comp_code.
        me->gs_header-doc_date    = gs_input-mt_pagamento-doc_date.
        me->gs_header-pstng_date  = sy-datum.
        me->gs_header-fis_period  = sy-datum+4(2).
        me->gs_header-doc_type    = 'FL'.
        me->gs_header-ref_doc_no  = gs_input-mt_pagamento-ref_doc_no.

        gt_acc_able = VALUE #( ( itemno_acc = '0000000001'
                  vendor_no     = gv_lifnr
                  gl_account    = <fs_param_val>-high
                  comp_code     = gs_input-mt_pagamento-comp_code
                  bus_area      = lv_gsber
                  pmnttrms      = '1001'
                  bline_date    = gs_input-mt_pagamento-bline_date
                  item_text     = 'VR. REF. MULTA'
                  businessplace = gs_input-mt_pagamento-comp_code+8(4)
        ) ).

        gt_currency = VALUE #( (
            itemno_acc = '0000000001'
            currency = 'BRL'
            amt_doccur = gs_input-mt_pagamento-amt_doccur_valor

        ) ).

        SORT lt_param_val BY low.
        LOOP AT gs_input-mt_pagamento-gl_account ASSIGNING FIELD-SYMBOL(<fs_account>).

          IF <fs_account>-desconto_colaborador IS NOT INITIAL.
            lv_cont = lv_cont + 1.
            READ TABLE lt_param_val ASSIGNING <fs_param_val> WITH KEY low = <fs_account>-desconto_colaborador BINARY SEARCH.
            IF sy-subrc = 0.

              gt_acc_gl = VALUE #( ( itemno_acc = lc_zeros && lv_cont
                                gl_account = <fs_param_val>-high
                                item_text  = 'VR. REF. MULTA'
                                comp_code  = gs_input-mt_pagamento-comp_code
                                bus_area   = lv_gsber
                                fis_period = sy-datum+4(2)
                                pstng_date = sy-datum
              ) ).

              gt_currency = VALUE #( (
                  itemno_acc = lc_zeros && lv_cont
                  currency = 'BRL'
                  amt_doccur = gs_input-mt_pagamento-amt_doccur_desc_colaborador

              ) ).

            ENDIF.
          ENDIF.

          IF <fs_account>-sinistros_eavarias IS NOT INITIAL.
            lv_cont = lv_cont + 1.
            READ TABLE lt_param_val ASSIGNING <fs_param_val> WITH KEY low = <fs_account>-sinistros_eavarias BINARY SEARCH.
            IF sy-subrc = 0.

              gt_acc_gl = VALUE #( ( itemno_acc = lc_zeros && lv_cont
                                gl_account = <fs_param_val>-high
                                item_text  = 'VR. REF. MULTA'
                                comp_code  = gs_input-mt_pagamento-comp_code
                                bus_area   = lv_gsber
                                fis_period = sy-datum+4(2)
                                pstng_date = sy-datum
              ) ).

              gt_currency = VALUE #( (
                  itemno_acc = lc_zeros && lv_cont
                  currency = 'BRL'
                  amt_doccur = gs_input-mt_pagamento-amt_doccur_sinistro_avarias

              ) ).

            ENDIF.
          ENDIF.

          IF <fs_account>-deducoes IS NOT INITIAL.
            lv_cont = lv_cont + 1.
            READ TABLE lt_param_val ASSIGNING <fs_param_val> WITH KEY low = <fs_account>-deducoes BINARY SEARCH.
            IF sy-subrc = 0.

              gt_acc_gl = VALUE #( ( itemno_acc = lc_zeros && lv_cont
                                gl_account = <fs_param_val>-high
                                item_text  = 'VR. REF. MULTA'
                                comp_code  = gs_input-mt_pagamento-comp_code
                                bus_area   = lv_gsber
                                fis_period = sy-datum+4(2)
                                pstng_date = sy-datum
              ) ).

              gt_currency = VALUE #( (
                  itemno_acc = lc_zeros && lv_cont
                  currency = 'BRL'
                  amt_doccur = gs_input-mt_pagamento-amt_doccur_deducoes

              ) ).

            ENDIF.
          ENDIF.

          IF <fs_account>-taxa_administrativa IS NOT INITIAL.
            lv_cont = lv_cont + 1.
            READ TABLE lt_param_val ASSIGNING <fs_param_val> WITH KEY low = <fs_account>-taxa_administrativa BINARY SEARCH.
            IF sy-subrc = 0.

              gt_acc_gl = VALUE #( ( itemno_acc = lc_zeros && lv_cont
                                gl_account = <fs_param_val>-high
                                item_text = 'VR. REF. MULTA'
                                comp_code  = gs_input-mt_pagamento-comp_code
                                bus_area    = lv_gsber
                                fis_period = sy-datum+4(2)
                                pstng_date = sy-datum
              ) ).

              gt_currency = VALUE #( (
                  itemno_acc = lc_zeros && lv_cont
                  currency = 'BRL'
                  amt_doccur = gs_input-mt_pagamento-amt_doccur_taxa_adm

              ) ).

            ENDIF.
          ENDIF.

        ENDLOOP.

      ENDIF.
    ENDIF.

    me->bapi_post( ).

  ENDMETHOD.

  METHOD bapi_post.

    DATA: lv_obj_key TYPE bapiache09-obj_key.

    CALL FUNCTION 'BAPI_ACC_DOCUMENT_POST'
      EXPORTING
        documentheader = me->gs_header
      IMPORTING
        obj_key        = lv_obj_key
      TABLES
        accountgl      = me->gt_acc_gl
        accountpayable = me->gt_acc_able
        currencyamount = me->gt_currency
        return         = me->gt_return.

    IF line_exists( me->gt_return[ type = 'E' ] ). "#EC CI_STDSEQ

      CALL FUNCTION 'BAPI_TRANSACTION_ROLLBACK'.
      RETURN.
    ELSE.

    "Retorno Interface
    gs_output-mt_pagamento_resp-burks = me->gs_header-comp_code.
    gs_output-mt_pagamento_resp-belnr = lv_obj_key(10).
    gs_output-mt_pagamento_resp-lifnr = gv_lifnr.
    gs_output-mt_pagamento_resp-wrbtr = gs_input-mt_pagamento-amt_doccur_valor.

    ENDIF.

  ENDMETHOD.

  METHOD get_data.
    MOVE-CORRESPONDING is_input TO gs_input.
    me->process_data( ).
    MOVE-CORRESPONDING gs_output TO es_output.
  ENDMETHOD.

ENDCLASS.
