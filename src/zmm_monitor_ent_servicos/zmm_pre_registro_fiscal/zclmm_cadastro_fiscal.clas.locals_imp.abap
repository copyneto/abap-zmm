CLASS lcl_header DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS authoritycreate FOR VALIDATE ON SAVE
      IMPORTING keys FOR header~authoritycreate.

    METHODS get_authorizations FOR AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR header RESULT result.

    METHODS liberarnf FOR MODIFY
      IMPORTING keys FOR ACTION header~liberarnf.

    METHODS determine_initial_data FOR DETERMINE ON SAVE
      IMPORTING keys FOR header~determine_initial_data.

    METHODS get_features FOR FEATURES
      IMPORTING keys REQUEST requested_features FOR header RESULT result.

    METHODS determine_new_duo_date FOR DETERMINE ON MODIFY
      IMPORTING keys FOR header~determine_new_duo_date.

    METHODS determine_dados_pedido FOR DETERMINE ON SAVE
      IMPORTING keys FOR header~determine_dados_pedido.

    METHODS redeterminepoitens FOR MODIFY
      IMPORTING keys FOR ACTION header~redeterminepoitens.
    METHODS validatenf FOR VALIDATE ON SAVE
      IMPORTING keys FOR header~validatenf.

    METHODS is_required_data_incomplete
      IMPORTING
        is_header       TYPE zi_mm_cadastro_fiscal_cabec
      CHANGING
        ct_return       TYPE bapiret2_tab
      RETURNING
        VALUE(rv_error) TYPE abap_bool.
ENDCLASS.

CLASS lcl_header IMPLEMENTATION.

  METHOD authoritycreate.
    CONSTANTS lc_area           TYPE string VALUE 'VALIDATE_CREATE'.
    CONSTANTS lc_status_fechado TYPE char7  VALUE 'FECHADO'.

    READ ENTITIES OF zi_mm_cadastro_fiscal_cabec IN LOCAL MODE
     ENTITY header
      ALL FIELDS WITH CORRESPONDING #( keys )
      RESULT DATA(lt_data).

    SELECT SINGLE low
      FROM ztca_param_val
      INTO @DATA(lv_lancamento)
     WHERE modulo = @zclmm_lanc_servicos=>gc_param_module
       AND chave1 = @zclmm_lanc_servicos=>gc_param_monitor
       AND chave2 = @zclmm_lanc_servicos=>gc_param_lcto_servico.

    LOOP AT lt_data ASSIGNING FIELD-SYMBOL(<fs_data>).

      IF zclmm_auth_zmmbukrs=>bukrs_create( <fs_data>-empresa ) EQ abap_false.

        APPEND VALUE #( %tky        = <fs_data>-%tky
                        %state_area = lc_area )
        TO reported-header.

        APPEND VALUE #( %tky = <fs_data>-%tky ) TO failed-header.

        APPEND VALUE #( %tky        = <fs_data>-%tky
                        %state_area = lc_area
                        %msg        = NEW zcxca_authority_check(
                                          severity = if_abap_behv_message=>severity-error
                                          textid   = zcxca_authority_check=>gc_create )
                        %element-empresa = if_abap_behv=>mk-on )
          TO reported-header.

      ELSEIF lv_lancamento = lc_status_fechado.

      ENDIF.

    ENDLOOP.

  ENDMETHOD.

  METHOD get_authorizations.
    RETURN.
  ENDMETHOD.

  METHOD liberarnf.

    CHECK keys IS NOT INITIAL.

    DATA(ls_key) = keys[ 1 ].

    DATA(lo_object) = NEW zclmm_lanc_servicos( ).

    lo_object->liberar_nf(
      EXPORTING
        is_key = CORRESPONDING #( ls_key )
      IMPORTING
        et_return     = DATA(lt_return)
        ).

    LOOP AT lt_return ASSIGNING FIELD-SYMBOL(<fs_return>).
      APPEND VALUE #( empresa = ls_key-empresa
                      filial  = ls_key-filial
                      lifnr   = ls_key-lifnr
                      nrnf    = ls_key-nrnf
                      %msg     = new_message( id       = <fs_return>-id
                                              number   = <fs_return>-number
                                              v1       = <fs_return>-message_v1
                                              v2       = <fs_return>-message_v2
                                              v3       = <fs_return>-message_v3
                                              v4       = <fs_return>-message_v4
                                              severity =  CONV #( <fs_return>-type ) ) ) TO reported-header.
    ENDLOOP.
  ENDMETHOD.

  METHOD determine_initial_data.
    DATA lt_return TYPE bapiret2_tab.
    DATA(lo_lanc_servico) = NEW zclmm_lanc_servicos( ).

    READ ENTITIES OF zi_mm_cadastro_fiscal_cabec
     IN LOCAL MODE ENTITY header
     ALL FIELDS WITH CORRESPONDING #( keys )
     RESULT DATA(lt_dados)
     FAILED DATA(lt_erro).

    READ TABLE lt_dados INTO DATA(ls_data) INDEX 1. "#EC CI_LOOP_INTO_WA
    CHECK sy-subrc IS INITIAL.

    "//validate if initial data is filled
    IF me->is_required_data_incomplete(
        EXPORTING is_header = CORRESPONDING #( ls_data )
        CHANGING  ct_return = lt_return
    ) = abap_true.

      LOOP AT lt_return INTO DATA(ls_return).
        APPEND VALUE #( empresa = ls_data-empresa
                        filial  = ls_data-filial
                        lifnr   = ls_data-lifnr
                        nrnf    = ls_data-nrnf
                        %msg    = new_message( id       = ls_return-id
                                               number   = ls_return-number
                                               v1       = ls_return-message_v1
                                               v2       = ls_return-message_v2
                                               severity = CONV #( ls_return-type )
                      ) ) TO reported-header.
      ENDLOOP.
      RETURN.
    ENDIF.

    "//get payment's duo date
    DATA(lv_duo_date) = lo_lanc_servico->get_duo_date(
      iv_bline_date = COND #(
        WHEN ls_data-dtbase   IS NOT INITIAL THEN ls_data-dtbase
        WHEN ls_data-dtlancto IS NOT INITIAL THEN ls_data-dtlancto
        ELSE ls_data-dtemis
     )
      iv_pedido = ls_data-pedido
    ).

    DATA(lv_cnpj_cpf_bp) = lo_lanc_servico->get_cnpj_cpf_bp( ls_data-lifnr ).


    "//Set calculated fields
    MODIFY ENTITIES OF zi_mm_cadastro_fiscal_cabec IN LOCAL MODE
    ENTITY header
    UPDATE FIELDS ( liberado dtbase dtvenc cnpjcpf dtlancto )
      WITH VALUE #( FOR ls_dados2 IN lt_dados (
                      %key     = ls_data-%key
                      dtbase   = COND #(
                                    WHEN ls_data-dtbase   IS NOT INITIAL THEN ls_data-dtbase
                                    WHEN ls_data-dtlancto IS NOT INITIAL THEN ls_data-dtlancto
                                    ELSE ls_data-dtemis
                                 )
                      dtlancto = COND #( WHEN ls_data-dtlancto IS INITIAL THEN sy-datum ELSE ls_data-dtlancto )
                      dtvenc   = lv_duo_date
                      cnpjcpf  = lv_cnpj_cpf_bp
                      liberado = ''
                ) )
    REPORTED DATA(lt_reported).
*
*    lo_lanc_servico->valida_input_pedido_compras(
*      EXPORTING
*        iv_pedido  = ls_data-Pedido
*        iv_Is_rpa  = ls_data-FlagRpa
*        iv_empresa = ls_data-Empresa
*        iv_bp      = ls_data-Lifnr
*      IMPORTING
*        et_po_items = DATA(lt_po_items)
*      CHANGING
*        ct_return   = lt_return
*    ).
*
*    LOOP AT lt_return INTO ls_return.
*      APPEND VALUE #( empresa = ls_data-empresa
*                      filial  = ls_data-filial
*                      lifnr   = ls_data-lifnr
*                      nrnf    = ls_data-nrnf
*                      %element-Pedido = if_abap_behv=>mk-on
*                      %msg    = new_message( id       = ls_return-id
*                                             number   = ls_return-number
*                                             v1       = ls_return-message_v1
*                                             v2       = ls_return-message_v2
*                                             severity = CONV #( ls_return-type )
*                    ) ) TO reported-header.
*    ENDLOOP.
*
*    IF line_exists( lt_return[ type = zclmm_lanc_servicos=>gc_error ] ). "#EC CI_STDSEQ
*      RETURN.
*    ENDIF.
*
*    DELETE FROM ztmm_monit_item
*     WHERE empresa = ls_data-Empresa
*       AND Filial  = ls_data-Filial
*       AND Lifnr   = ls_data-Lifnr
*       AND nr_nf   = ls_data-NrNf.
*
*    MODIFY ENTITIES OF zi_mm_cadastro_fiscal_cabec IN LOCAL MODE
*    ENTITY Header CREATE BY \_Item
*    FIELDS ( Empresa Filial Lifnr NrNf NrPedido ItmPedido Qtdade Qtdade_Lcto NFType Cfop Iva Unid Descricao )
*    WITH VALUE #( (
*       Empresa   = ls_data-Empresa
*       Filial    = ls_data-Filial
*       Lifnr     = ls_data-Lifnr
*       NrNf      = ls_data-NrNf
*       %target   = VALUE #(
*        FOR ls_po_item IN lt_po_items
*        LET ls_param = NEW zclmm_lanc_servicos( )->get_posting_parameters(
*            iv_pedido = ls_po_item-ebeln
*            iv_item   = ls_po_item-ebelp
*            iv_is_rpa = ls_data-FlagRpa
*        ) IN (
*           Empresa     = ls_data-Empresa
*           Filial      = ls_data-Filial
*           Lifnr       = ls_data-Lifnr
*           NrNf        = ls_data-NrNf
*           NrPedido    = ls_po_item-ebeln
*           ItmPedido   = ls_po_item-ebelp
**           Qtdade      = ls_po_item-QtdadeDisponivel
*           Qtdade_Lcto = 0
*           NFtype      = ls_param-j_1bnftype
*           Cfop        = ls_param-cfop
*           Iva         = ls_param-mwskz
*           Unid        = ls_po_item-meins
*       ) )
*   ) )
*    REPORTED DATA(lt_reported_items).
*
    reported = CORRESPONDING #( DEEP lt_reported ).
  ENDMETHOD.

  METHOD get_features.

    CONSTANTS: lc_pendente TYPE char12 VALUE 'Pendente',
               lc_erro     TYPE char12 VALUE 'Erro'.

    DATA: lt_acessos TYPE RANGE OF ze_created_by.

    READ ENTITIES OF zi_mm_cadastro_fiscal_cabec
    IN LOCAL MODE ENTITY header
    ALL FIELDS WITH
    CORRESPONDING #( keys )
    RESULT DATA(lt_dados)
    FAILED DATA(lt_erro).

    CHECK lt_dados IS NOT INITIAL.

    READ ENTITIES OF zi_mm_cadastro_fiscal_cabec
     IN LOCAL MODE ENTITY header BY \_item
      ALL FIELDS WITH CORRESPONDING #( keys )
      RESULT DATA(lt_items).

    TRY.
        DATA(lo_param) = zclca_tabela_parametros=>get_instance( ).      " CHANGE - JWSILVA - 21.07.2023

        lo_param->m_get_range(                                          " CHANGE - JWSILVA - 21.07.2023
        EXPORTING
        iv_modulo = 'MM'
        iv_chave1 = 'TICKET_LOG'
        iv_chave2 = 'JOB'
        iv_chave3 = 'USER'
        IMPORTING
        et_range  = lt_acessos ).
      CATCH  zcxca_tabela_parametros.
    ENDTRY.

    LOOP AT lt_dados ASSIGNING FIELD-SYMBOL(<fs_data>).

      IF NOT <fs_data>-miro  IS INITIAL
      OR NOT <fs_data>-dtreg IS INITIAL.
        result = VALUE #( BASE result ( empresa = <fs_data>-empresa
                                        filial  = <fs_data>-filial
                                        lifnr   = <fs_data>-lifnr
                                        nrnf   = <fs_data>-nrnf
                                        %update = if_abap_behv=>fc-o-disabled
                                        %delete = if_abap_behv=>fc-o-disabled
                                        %features-%action-liberarnf = if_abap_behv=>fc-o-disabled
                                    ) ).
      ELSE.
        result = VALUE #( BASE result ( empresa = <fs_data>-empresa
                                        filial  = <fs_data>-filial
                                        lifnr   = <fs_data>-lifnr
                                        nrnf   = <fs_data>-nrnf
                                        %update = COND #(
                                          WHEN ( <fs_data>-statusfiscal = lc_pendente
                                            OR   <fs_data>-statusfiscal = lc_erro )
                                           AND ( sy-uname IN lt_acessos
                                            OR   <fs_data>-createdby = sy-uname )
                                          THEN if_abap_behv=>fc-o-enabled
                                          ELSE if_abap_behv=>fc-o-disabled
                                        )
                                        %delete = COND #(
                                          WHEN ( <fs_data>-statusfiscal = lc_pendente
                                            OR   <fs_data>-statusfiscal = lc_erro )
                                           AND ( sy-uname IN lt_acessos
                                            OR   <fs_data>-createdby = sy-uname )
                                          THEN if_abap_behv=>fc-o-enabled
                                          ELSE if_abap_behv=>fc-o-disabled
                                        )
                                        %features-%action-liberarnf = COND #(
                                          WHEN ( <fs_data>-statusfiscal = lc_pendente
                                            OR   <fs_data>-statusfiscal = lc_erro )
                                           AND ( sy-uname IN lt_acessos
                                            OR   <fs_data>-createdby = sy-uname )
                                          THEN if_abap_behv=>fc-o-enabled
                                          ELSE if_abap_behv=>fc-o-disabled
                                        )
                                    ) ).
      ENDIF.

    ENDLOOP.
  ENDMETHOD.

  METHOD determine_new_duo_date.
    DATA(lo_lanc_servico) = NEW zclmm_lanc_servicos( ).

    READ ENTITIES OF zi_mm_cadastro_fiscal_cabec
     IN LOCAL MODE ENTITY header
     ALL FIELDS WITH CORRESPONDING #( keys )
     RESULT DATA(lt_dados)
     FAILED DATA(lt_erro).

    READ TABLE lt_dados INTO DATA(ls_data) INDEX 1. "#EC CI_LOOP_INTO_WA

    IF sy-subrc IS INITIAL.
      DATA(lv_duo_date) = lo_lanc_servico->get_duo_date(
        iv_bline_date = ls_data-dtbase
        iv_pedido = ls_data-pedido
      ).

      MODIFY ENTITIES OF zi_mm_cadastro_fiscal_cabec IN LOCAL MODE
       ENTITY header
        UPDATE FIELDS ( dtvenc )
         WITH VALUE #( (
                        %key     = ls_data-%key
                        dtvenc   = lv_duo_date
                        liberado = ''
                     ) )
         REPORTED DATA(lt_reported).
    ENDIF.
  ENDMETHOD.

  METHOD is_required_data_incomplete.
    IF is_header-empresa IS INITIAL
    OR is_header-filial  IS INITIAL
    OR is_header-lifnr   IS INITIAL
    OR is_header-nrnf    IS INITIAL
    OR is_header-pedido  IS INITIAL
    OR is_header-dtemis  IS INITIAL
    OR is_header-domiciliofiscal IS INITIAL
    OR is_header-lc      IS INITIAL
    OR is_header-vltotnf IS INITIAL.
      ct_return = VALUE #( BASE ct_return (
          id = zclmm_lanc_servicos=>gc_msg_id
          type = zclmm_lanc_servicos=>gc_error
          number = 050
       ) ).
      rv_error = abap_true.
    ENDIF.

    IF is_header-dtlancto IS NOT INITIAL
   AND is_header-dtlancto < is_header-dtemis.
      ct_return = VALUE #( BASE ct_return (
          id = zclmm_lanc_servicos=>gc_msg_id
          type = zclmm_lanc_servicos=>gc_error
          number = 053
       ) ).
      rv_error = abap_true.
    ENDIF.
  ENDMETHOD.

*  METHOD validate_dtlcto.
*    READ ENTITIES OF zi_mm_cadastro_fiscal_cabec
*     IN LOCAL MODE ENTITY Header
*     ALL FIELDS WITH CORRESPONDING #( keys )
*     RESULT DATA(lt_data)
*     FAILED DATA(lt_erro).
*
*    DATA(ls_data) = lt_data[ 1 ].
*
*    IF ls_data-DtLancto < ls_data-DtEmis.
*      APPEND VALUE #( empresa = ls_data-empresa
*                      filial  = ls_data-filial
*                      lifnr   = ls_data-lifnr
*                      nrnf    = ls_data-nrnf
*                      %element-DtLancto = if_abap_behv=>mk-on
*                      %msg    = new_message( id       = zclmm_lanc_servicos=>gc_msg_id
*                                             number   = 053
*                                             severity = CONV #( zclmm_lanc_servicos=>gc_error )
*                    ) ) TO reported-header.
**    ENDIF.
*  ENDMETHOD.

  METHOD determine_dados_pedido.
    DATA lt_return TYPE bapiret2_tab.
    DATA(lo_lanc_servico) = NEW zclmm_lanc_servicos( ).

    READ ENTITIES OF zi_mm_cadastro_fiscal_cabec
     IN LOCAL MODE ENTITY header
     ALL FIELDS WITH CORRESPONDING #( keys )
     RESULT DATA(lt_dados)
     FAILED DATA(lt_erro).

    READ TABLE lt_dados INTO DATA(ls_data) INDEX 1. "#EC CI_LOOP_INTO_WA
    CHECK sy-subrc IS INITIAL.

    CALL METHOD lo_lanc_servico->valida_input_pedido_compras
      EXPORTING
        iv_pedido   = ls_data-pedido
        iv_is_rpa   = ls_data-flagrpa
        iv_empresa  = ls_data-empresa
        iv_bp       = ls_data-lifnr
      IMPORTING
        et_po_items = DATA(lt_po_items)
      CHANGING
        ct_return   = lt_return.

    LOOP AT lt_return INTO DATA(ls_return).
      APPEND VALUE #( empresa = ls_data-empresa
                      filial  = ls_data-filial
                      lifnr   = ls_data-lifnr
                      nrnf    = ls_data-nrnf
                      %element-pedido = if_abap_behv=>mk-on
                      %msg    = new_message( id       = ls_return-id
                                             number   = ls_return-number
                                             v1       = ls_return-message_v1
                                             v2       = ls_return-message_v2
                                             severity = CONV #( ls_return-type )
                    ) ) TO reported-header.
    ENDLOOP.

    IF line_exists( lt_return[ type = zclmm_lanc_servicos=>gc_error ] ). "#EC CI_STDSEQ
      RETURN.
    ENDIF.

    DELETE FROM ztmm_monit_item
     WHERE empresa = ls_data-empresa
       AND filial  = ls_data-filial
       AND lifnr   = ls_data-lifnr
       AND nr_nf   = ls_data-nrnf.

    MODIFY ENTITIES OF zi_mm_cadastro_fiscal_cabec IN LOCAL MODE
    ENTITY header CREATE BY \_item
    FIELDS ( empresa filial lifnr nrnf nrpedido itmpedido qtdade qtdade_lcto nftype cfop iva unid descricao )
    WITH VALUE #( (
       empresa   = ls_data-empresa
       filial    = ls_data-filial
       lifnr     = ls_data-lifnr
       nrnf     = ls_data-nrnf
       %target   = VALUE #(
        FOR ls_po_item IN lt_po_items
        LET ls_param = NEW zclmm_lanc_servicos( )->get_posting_parameters(
            iv_pedido = ls_po_item-ebeln
            iv_item   = ls_po_item-ebelp
            iv_is_rpa = ls_data-flagrpa
        ) IN (
           empresa     = ls_data-empresa
           filial      = ls_data-filial
           lifnr       = ls_data-lifnr
           nrnf        = ls_data-nrnf
           nrpedido    = ls_po_item-ebeln
           itmpedido   = ls_po_item-ebelp
           qtdade_lcto = 0
           nftype      = ls_param-j_1bnftype
           cfop        = ls_param-cfop
           iva         = ls_param-mwskz
           unid        = ls_po_item-meins
       ) )
    ) )
    REPORTED DATA(lt_reported_items).

    reported = CORRESPONDING #( DEEP lt_reported_items ).
  ENDMETHOD.

  METHOD redeterminepoitens.
    DATA lt_return TYPE bapiret2_tab.
    DATA(lo_lanc_servico) = NEW zclmm_lanc_servicos( ).

    READ ENTITIES OF zi_mm_cadastro_fiscal_cabec
     IN LOCAL MODE ENTITY header
     ALL FIELDS WITH CORRESPONDING #( keys )
     RESULT DATA(lt_dados)
     FAILED DATA(lt_erro).

    READ TABLE lt_dados INTO DATA(ls_data) INDEX 1. "#EC CI_LOOP_INTO_WA
    CHECK sy-subrc IS INITIAL.

    CALL METHOD lo_lanc_servico->valida_input_pedido_compras
      EXPORTING
        iv_pedido   = ls_data-pedido
        iv_is_rpa   = ls_data-flagrpa
        iv_empresa  = ls_data-empresa
        iv_bp       = ls_data-lifnr
      IMPORTING
        et_po_items = DATA(lt_po_items)
      CHANGING
        ct_return   = lt_return.

    LOOP AT lt_return INTO DATA(ls_return).
      APPEND VALUE #( empresa = ls_data-empresa
                      filial  = ls_data-filial
                      lifnr   = ls_data-lifnr
                      nrnf    = ls_data-nrnf
                      %element-pedido = if_abap_behv=>mk-on
                      %msg    = new_message( id       = ls_return-id
                                             number   = ls_return-number
                                             v1       = ls_return-message_v1
                                             v2       = ls_return-message_v2
                                             severity = CONV #( ls_return-type )
                    ) ) TO reported-header.
    ENDLOOP.

    IF line_exists( lt_return[ type = zclmm_lanc_servicos=>gc_error ] ). "#EC CI_STDSEQ
      RETURN.
    ENDIF.

    DELETE FROM ztmm_monit_item
     WHERE empresa = ls_data-empresa
       AND filial  = ls_data-filial
       AND lifnr   = ls_data-lifnr
       AND nr_nf   = ls_data-nrnf.

    MODIFY ENTITIES OF zi_mm_cadastro_fiscal_cabec IN LOCAL MODE
    ENTITY header CREATE BY \_item
    FIELDS ( empresa filial lifnr nrnf nrpedido itmpedido qtdade qtdade_lcto nftype cfop iva unid descricao )
    WITH VALUE #( (
       empresa   = ls_data-empresa
       filial    = ls_data-filial
       lifnr     = ls_data-lifnr
       nrnf     = ls_data-nrnf
       %target   = VALUE #(
        FOR ls_po_item IN lt_po_items
        LET ls_param = NEW zclmm_lanc_servicos( )->get_posting_parameters(
            iv_pedido = ls_po_item-ebeln
            iv_item   = ls_po_item-ebelp
            iv_is_rpa = ls_data-flagrpa
        ) IN (
           empresa     = ls_data-empresa
           filial      = ls_data-filial
           lifnr       = ls_data-lifnr
           nrnf        = ls_data-nrnf
           nrpedido    = ls_po_item-ebeln
           itmpedido   = ls_po_item-ebelp
           qtdade_lcto = 0
           nftype      = ls_param-j_1bnftype
           cfop        = ls_param-cfop
           iva         = ls_param-mwskz
           unid        = ls_po_item-meins
       ) )
    ) )
    REPORTED DATA(lt_reported_items).

    reported = CORRESPONDING #( DEEP lt_reported_items ).
  ENDMETHOD.

  METHOD validatenf.

    READ ENTITIES OF zi_mm_cadastro_fiscal_cabec
     IN LOCAL MODE ENTITY header
     ALL FIELDS WITH CORRESPONDING #( keys )
     RESULT DATA(lt_dadosnf)
     FAILED DATA(lt_erronf).

    READ TABLE lt_dadosnf INTO DATA(ls_datanf) INDEX 1. "#EC CI_LOOP_INTO_WA

    IF sy-subrc IS INITIAL.
      DATA(lv_posi) = strlen( ls_datanf-nrnf ).

      IF lv_posi > 16.

        APPEND VALUE #( %msg        = new_message( id       = zclmm_lanc_servicos=>gc_msg_id
                                                   number   = '058'
                                                   severity = CONV #( 'E')

                      ) ) TO reported-header.

      ENDIF.
    ENDIF.

  ENDMETHOD.

ENDCLASS.

CLASS lcl_item DEFINITION INHERITING FROM cl_abap_behavior_handler.

  PRIVATE SECTION.

    METHODS validate_qtdade_lcto FOR VALIDATE ON SAVE
      IMPORTING keys FOR item~validate_qtdade_lcto.

ENDCLASS.

CLASS lcl_item IMPLEMENTATION.

  METHOD validate_qtdade_lcto.
    READ ENTITIES OF zi_mm_cadastro_fiscal_cabec
     IN LOCAL MODE ENTITY item
     ALL FIELDS WITH CORRESPONDING #( keys )
     RESULT DATA(lt_item_data)
     FAILED DATA(lt_erro).

    CHECK keys IS NOT INITIAL.

    SELECT nr_pedido,
           itm_pedido,
           qtdade_lcto
      FROM ztmm_monit_item
      INTO TABLE @DATA(lt_old_items)
      FOR ALL ENTRIES IN @keys
     WHERE empresa    = @keys-empresa
       AND filial     = @keys-filial
       AND lifnr      = @keys-lifnr
       AND nr_nf      = @keys-nrnf
       AND nr_pedido  = @keys-nrpedido
       AND itm_pedido = @keys-itmpedido.

    CHECK sy-subrc IS INITIAL.

    LOOP AT lt_item_data ASSIGNING FIELD-SYMBOL(<fs_data>).
      READ TABLE lt_old_items ASSIGNING FIELD-SYMBOL(<fs_old_item>)
        WITH KEY
          nr_pedido  = <fs_data>-nrpedido
          itm_pedido = <fs_data>-itmpedido.              "#EC CI_STDSEQ

      DATA(lv_qty) = COND #(
        WHEN sy-subrc IS INITIAL
            THEN CONV ekpo-menge( <fs_data>-qtdade - ( <fs_data>-qtdadeutilizada - <fs_old_item>-qtdade_lcto ) )
            ELSE <fs_data>-qtdade_lcto
      ).

      IF <fs_data>-qtdade_lcto > lv_qty.
        APPEND VALUE #( empresa = <fs_data>-empresa
                        filial  = <fs_data>-filial
                        lifnr   = <fs_data>-lifnr
                        nrnf    = <fs_data>-nrnf
                        nrpedido = <fs_data>-nrpedido
                        itmpedido = <fs_data>-itmpedido
                        %element-qtdade_lcto = if_abap_behv=>mk-on
                        %msg     = new_message( id       = zclmm_lanc_servicos=>gc_msg_id
                                                number   = 036
                                                v1       = <fs_data>-itmpedido
                                                severity = CONV #( zclmm_lanc_servicos=>gc_error )
                    ) ) TO reported-item.
      ENDIF.

    ENDLOOP.
  ENDMETHOD.

ENDCLASS.
