CLASS zclmm_order_simulate DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    "! Processamento principal
    "! @parameter cs_document | Dados de processamento
    "! @parameter et_return| Retorno
    "! @parameter et_taxes | Impostos - exportação
    "! @parameter es_taxes | Impostos - tabela
    METHODS process
      EXPORTING
        !et_return   TYPE bapiret2_tab
        !et_taxes    TYPE ps_bapicond_t
        !es_taxes    TYPE ztmm_mov_simul
      CHANGING
        !cs_document TYPE ztmm_mov_cntrl .
  PROTECTED SECTION.
  PRIVATE SECTION.

    CONSTANTS:
      "! Constantes do processamento
      BEGIN OF gc_data,
        msg_class TYPE arbgb VALUE 'ZMM_BENS_CONSUMO',
        fixo_03   TYPE char2 VALUE '03',
        fixo_221  TYPE char3 VALUE '221',
        ok        TYPE char1 VALUE 'S',
        erro      TYPE char1 VALUE 'E',
        doctype   TYPE char4 VALUE 'Z001',
        org       TYPE char4 VALUE '2000',
        distr     TYPE char2 VALUE '14',
        division  TYPE char2 VALUE '99',
        item      TYPE posnr_va VALUE '000010',
        cond_type TYPE kscha VALUE 'ZPR0',
        part_role TYPE parvw VALUE 'AG',
        tax_bco1  TYPE j_1btaxtyp VALUE 'BCO1',
        tax_bpi1  TYPE j_1btaxtyp VALUE 'BPI1',
        tax_bx13  TYPE j_1btaxtyp VALUE 'BX13',
        tax_bx23  TYPE j_1btaxtyp VALUE 'BX23',
        tax_bx72  TYPE j_1btaxtyp VALUE 'BX72',
        tax_bx82  TYPE j_1btaxtyp VALUE 'BX82',
        tax_icm3  TYPE j_1btaxtyp VALUE 'ICM3',
        tax_icof  TYPE j_1btaxtyp VALUE 'ICOF',
        tax_ipi3  TYPE j_1btaxtyp VALUE 'IPI3',
        tax_ipis  TYPE j_1btaxtyp VALUE 'IPIS',
        tax_ipva  TYPE j_1btaxtyp VALUE 'IPVA',
        tax_zicm  TYPE j_1btaxtyp VALUE 'ZICM',
        c_i       TYPE char1 VALUE 'I',
        c_eq      TYPE char2 VALUE 'EQ',
      END OF gc_data .
    DATA gt_return TYPE bapiret2_tab .

    "! Atribuir cabeçalho
    "! @parameter rs_header | Cabeçalho
    METHODS set_header
      IMPORTING
        !is_document     TYPE ztmm_mov_cntrl
      RETURNING
        VALUE(rs_header) TYPE bapisdhead .
    "! Atribuir item
    "! @parameter is_document | Dados de processamento
    "! @parameter rt_item | Item
    METHODS set_item
      IMPORTING
        !is_document   TYPE ztmm_mov_cntrl
      RETURNING
        VALUE(rt_item) TYPE bapiitemin_tt .

    "! Executar BAPI
    "! @parameter  is_header     | Header
    "! @parameter et_taxes | Impostos - exportação
    "! @parameter es_taxes | Impostos - tabela
    "! @parameter  ct_partner    | Parceiro
    "! @parameter  ct_item       | Item
    "! @parameter  ct_schedule   | Schedule
    "! @parameter  cs_document | Dados de processamento
    METHODS call_bapi
      IMPORTING
        !is_header   TYPE bapisdhead
      EXPORTING
        !et_taxes    TYPE ps_bapicond_t
        !es_taxes    TYPE ztmm_mov_simul
      CHANGING
        !ct_item     TYPE bapiitemin_tt
        !ct_partner  TYPE esales_bapipartnr_tab
        !ct_schedule TYPE ps_bapischdl_t
        !cs_document TYPE ztmm_mov_cntrl .
    "! Atribuir item
    "! @parameter is_doc | Dados de processamento
    "! @parameter is_msg | Mensagem
    METHODS set_message
      IMPORTING
        !is_doc TYPE ztmm_mov_cntrl
        !is_msg TYPE bapiret2 .
    "! Commit
    METHODS commit_work .
    "! Rollback
    METHODS rollback .
    "! Atribuir parceiro
    "! @parameter is_document | Dados de processamento
    "! @parameter rt_partner | Parceiro
    METHODS set_partner
      IMPORTING
        !is_document      TYPE ztmm_mov_cntrl
      RETURNING
        VALUE(rt_partner) TYPE esales_bapipartnr_tab .
    "! Atribuir valor da condition
    "! @parameter is_document | Dados de processamento
    "! @parameter rv_cond_value | Valor da condition
    METHODS set_cond_value
      IMPORTING
        !is_document         TYPE ztmm_mov_cntrl
      RETURNING
        VALUE(rv_cond_value) TYPE kbetr .
    "! Atualizar dados
    "! @parameter is_doc | Dados de processamento
    METHODS update_table
      IMPORTING
        !is_doc TYPE ztmm_mov_cntrl .
    "! Atribuir schedule
    "! @parameter is_document | Dados de processamento
    "! @parameter rt_schedule | Schedule
    METHODS set_schedule
      IMPORTING
        !is_document       TYPE ztmm_mov_cntrl
      RETURNING
        VALUE(rt_schedule) TYPE ps_bapischdl_t .
    "! Atualizar impostos
    "! @parameter is_document | Dados de processamento
    "! @parameter it_taxes | Impostos
    METHODS update_taxes
      IMPORTING
        !is_document TYPE ztmm_mov_cntrl
        !it_taxes    TYPE ps_bapicond_t
      EXPORTING
        !es_taxes    TYPE ztmm_mov_simul .
    "! Atribuir impostos
    "! @parameter rt_taxes | Impostos - retorno
    "! @parameter it_taxes | Impostos
    METHODS set_new_taxes
      IMPORTING
        !it_taxes       TYPE ps_bapicond_t
      RETURNING
        VALUE(rt_taxes) TYPE ps_bapicond_t .

ENDCLASS.



CLASS zclmm_order_simulate IMPLEMENTATION.


  METHOD process.

    DATA(ls_header)     = set_header( cs_document ).

    DATA(lt_item)       = set_item( cs_document ).

    DATA(lt_partner)    = set_partner( cs_document ).

    DATA(lt_schedule)   = set_schedule( cs_document ).


    call_bapi( EXPORTING
                is_header   = ls_header

               IMPORTING
                et_taxes    = et_taxes
                es_taxes    = es_taxes
*                et_retunr    = et_return
       CHANGING
                      ct_item     = lt_item
                ct_partner  = lt_partner
                ct_schedule = lt_schedule
        cs_document = cs_document
    ).

    et_return = gt_return.

  ENDMETHOD.


  METHOD set_header.

    rs_header = VALUE #( doc_type   = gc_data-doctype
*                         sales_org  = is_document-werks
                         sales_org  = is_document-bukrs
                         distr_chan = gc_data-distr
                         division   = gc_data-division
                       ).

  ENDMETHOD.


  METHOD set_item.

    APPEND VALUE #(
        itm_number  = gc_data-item
        material    = |{ is_document-matnr1 ALPHA = IN }|
        plant       = |{ is_document-werks ALPHA = IN }|
        cond_type   = gc_data-cond_type

        cond_value  = set_cond_value( is_document )

        ) TO rt_item.


  ENDMETHOD.


  METHOD call_bapi.

    DATA: lt_return TYPE STANDARD TABLE OF bapiret2.

    CALL FUNCTION 'BAPI_SALESORDER_SIMULATE'
*    DESTINATION ' '
      EXPORTING
        order_header_in    = is_header
      TABLES
        order_items_in     = ct_item
        order_partners     = ct_partner
        order_schedule_in  = ct_schedule
        order_condition_ex = et_taxes
        messagetable       = lt_return.

    IF lines( et_taxes ) > 0.

      set_message( is_doc   = cs_document
                   is_msg   = VALUE #( type       = gc_data-ok
                                       id         = gc_data-msg_class " 'ZMM_BENS_CONSUMO'
                                       number     = '004'
                                        ) ).

      update_taxes(
        EXPORTING
          is_document = cs_document
          it_taxes    = et_taxes
        IMPORTING
          es_taxes    = es_taxes
      ).
      .
      update_table( cs_document ).

      commit_work( ).

    ELSE.

      set_message( is_doc   = cs_document
           is_msg   = VALUE #( type       = gc_data-erro
                               id         = gc_data-msg_class
                               number     = '005'
                                ) ).

      LOOP AT lt_return ASSIGNING FIELD-SYMBOL(<fs_return>).
        set_message( is_doc   = cs_document
             is_msg   = VALUE #( type       = <fs_return>-type
                                 id         = <fs_return>-id
                                 number     = <fs_return>-number
                                 message_v1 = <fs_return>-message_v1
                                 message_v2 = <fs_return>-message_v2
                                 message_v3 = <fs_return>-message_v3
                                 message_v4 = <fs_return>-message_v4
                                  ) ).
      ENDLOOP.

      rollback( ).

    ENDIF.

  ENDMETHOD.


  METHOD set_message.

    DATA ls_message TYPE bapiret2.

    ls_message-type        = is_msg-type.
    ls_message-id          = is_msg-id.
    ls_message-number      = is_msg-number.
    ls_message-message_v1  = is_msg-message_v1.
    ls_message-message_v2  = is_msg-message_v2.
    ls_message-message_v3  = is_msg-message_v3.
    ls_message-message_v4  = is_msg-message_v4.

    MESSAGE   ID        ls_message-id
              TYPE      ls_message-type
              NUMBER    ls_message-number
              WITH      ls_message-message_v1
                        ls_message-message_v2
                        ls_message-message_v3
                        ls_message-message_v4
              INTO      ls_message-message.

    APPEND ls_message TO gt_return.

  ENDMETHOD.


  METHOD commit_work.

    CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
      EXPORTING
        wait = abap_true.


  ENDMETHOD.


  METHOD rollback.

    CALL FUNCTION 'BAPI_TRANSACTION_ROLLBACK'.

  ENDMETHOD.


  METHOD set_partner.

    APPEND VALUE #(

      partn_role  = |{ gc_data-part_role ALPHA = IN }|
      partn_numb  = |{ is_document-partner ALPHA = IN }|

      ) TO rt_partner.

  ENDMETHOD.


  METHOD set_cond_value.


    SELECT SINGLE lppnet
     FROM j_1blpp
     INTO @DATA(lv_valor)
    WHERE matnr = @is_document-matnr1
      AND bwkey = @is_document-werks.

    MOVE lv_valor TO rv_cond_value.

    "???
    IF rv_cond_value IS INITIAL.

      MOVE 200 TO rv_cond_value.

    ENDIF.


  ENDMETHOD.


  METHOD set_schedule.

    APPEND VALUE #(

      itm_number  = gc_data-item
      req_date    = sy-datum
      req_qty     = is_document-menge

      ) TO rt_schedule.

  ENDMETHOD.


  METHOD update_taxes.


    DATA(lt_new_taxes) = set_new_taxes( it_taxes ).

    LOOP AT lt_new_taxes ASSIGNING FIELD-SYMBOL(<fs_line>).

      "???


      CASE <fs_line>-cond_type.

*       ======== icms ==================
        WHEN gc_data-tax_icm3.
          es_taxes-taxtyp_icm3 = <fs_line>-cond_type.
        WHEN gc_data-tax_bx13.

          es_taxes-base_bx13 = <fs_line>-conbaseval / 10.
          es_taxes-rate_bx13 = <fs_line>-cond_value.
          es_taxes-taxval_bx13 = <fs_line>-condvalue / 10.

*       ======== icms ==================




*       ======== ipi ==================
        WHEN gc_data-tax_ipi3.
          es_taxes-taxtyp_ipi3 = <fs_line>-cond_type.
        WHEN gc_data-tax_ipva.

          es_taxes-rate_ipva    = <fs_line>-cond_value.

        WHEN gc_data-tax_bx23.
          es_taxes-taxval_bx23  = <fs_line>-condvalue / 10.

*       ======== ipi ==================

*       ======== PIS ==================
        WHEN gc_data-tax_ipis.

          es_taxes-taxtyp_ipi3 = <fs_line>-cond_type.

        WHEN gc_data-tax_bpi1.
          es_taxes-rate_bx82 = <fs_line>-cond_value.

*       ======== PIS ==================

*       ======== Cofins ==================
        WHEN gc_data-tax_icof.

          es_taxes-taxtyp_ipi3 = <fs_line>-cond_type.

        WHEN gc_data-tax_bco1.
          es_taxes-rate_bx72 = <fs_line>-cond_value.

*        WHEN gc_data-tax_BX72.
*
*          es_taxes-rate_bx72 = <fs_line>-cond_value.
*          es_taxes-taxval_bx72 = <fs_line>-condvalue / 10.

*       ======== Cofins ==================

*       ========  base igua pra todos ======
        WHEN gc_data-tax_zicm.

          es_taxes-base_bco1 = es_taxes-base_bpi1 = es_taxes-base_bx13 = es_taxes-base_ipva = <fs_line>-conbaseval / 10.

*       ========  base igua pra todos ======

      ENDCASE.

    ENDLOOP.

    es_taxes-taxval_bx72 = es_taxes-base_bco1 * ( es_taxes-rate_bx72 / 100 ).
    es_taxes-taxval_bx82 = es_taxes-base_bco1 * ( es_taxes-rate_bx82 / 100 ).

*      NETPR
    es_taxes-netpr  = set_cond_value( is_document ).
    es_taxes-id     = is_document-id.

    TRY.

        es_taxes-netpr_final  = es_taxes-netpr
                              /
                              ( ( (
                              es_taxes-rate_bx13
                              +
                              es_taxes-taxtyp_ipi3
                              +
                              es_taxes-rate_bx72
                               )
                               / 100 )
                              * -1
                              ).
      CATCH cx_root.

*      ??? tratar

    ENDTRY.

    IF es_taxes IS NOT INITIAL.

      MODIFY ztmm_mov_simul FROM es_taxes.

    ENDIF.

  ENDMETHOD.


  METHOD set_new_taxes.
    DATA lr_cond TYPE RANGE OF j_1btaxtyp.

    DATA(lt_taxes) = it_taxes.

    SORT lt_taxes BY cond_type.

    lr_cond =  VALUE #( sign = gc_data-c_i  option = gc_data-c_eq ( low = gc_data-tax_bco1 )
                                                                  ( low = gc_data-tax_bpi1 )
                                                                  ( low = gc_data-tax_bx13 )
                                                                  ( low = gc_data-tax_bx23 )
                                                                  ( low = gc_data-tax_bx72 )
                                                                  ( low = gc_data-tax_bx82 )
                                                                  ( low = gc_data-tax_icm3 )
                                                                  ( low = gc_data-tax_icof )
                                                                  ( low = gc_data-tax_ipi3 )
                                                                  ( low = gc_data-tax_ipis )
                                                                  ( low = gc_data-tax_ipva )
                                                                  ( low = gc_data-tax_zicm )
                      ).

    LOOP AT lt_taxes ASSIGNING FIELD-SYMBOL(<fs_line>).

      CHECK <fs_line>-cond_type NOT IN lr_cond.

      DELETE lt_taxes INDEX sy-tabix.

    ENDLOOP.

    rt_taxes = lt_taxes.

  ENDMETHOD.


  METHOD update_table.

    DATA ls_update TYPE ztmm_mov_cntrl.

    ls_update = CORRESPONDING #( is_doc ).

    MODIFY ztmm_mov_cntrl FROM ls_update.

  ENDMETHOD.
ENDCLASS.
