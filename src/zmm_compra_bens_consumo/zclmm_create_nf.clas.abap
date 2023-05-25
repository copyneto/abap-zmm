class ZCLMM_CREATE_NF definition
  public
  final
  create public .

public section.

    "! Processamento principal
    "! @parameter ev_docnum | Docnum
    "! @parameter cs_document | Dados de processamento
  methods PROCESS
    importing
      !IV_NFE_ENTRADA type BOOLEAN optional
    exporting
      !EV_DOCNUM type J_1BNFDOC-DOCNUM
      !ET_RETURN type BAPIRET2_TAB
    changing
      !CS_DOCUMENT type ZTMM_MOV_CNTRL .
PROTECTED SECTION.
PRIVATE SECTION.

  TYPES:
    BEGIN OF ty_material,
      matnr TYPE mara-matnr,
      matkl TYPE mara-matkl,
      maktx TYPE makt-maktx,
      steuc TYPE marc-steuc,
      mtorg TYPE mbew-mtorg,
      mtuse TYPE mbew-mtuse,
      meins TYPE mara-meins,
    END OF ty_material .
  TYPES:
    BEGIN OF ty_lei_fiscal_2,
      taxlaw TYPE j_1btaxlw2,
      taxsit TYPE j_1btaxsi2in,
    END OF ty_lei_fiscal_2 .
  TYPES:
    BEGIN OF ty_lei_fiscal_4,
      taxlaw TYPE j_1btaxlw5,
      taxsit TYPE j_1btaxsi4in,
    END OF ty_lei_fiscal_4 .
  TYPES:
    BEGIN OF ty_lei_fiscal_5,
      taxlaw TYPE j_1btaxsi5in,
      taxsit TYPE j_1btaxsi5in,
    END OF ty_lei_fiscal_5 .

  CONSTANTS:
    "! Constantes do processamento
    BEGIN OF gc_data,
      fixo_03              TYPE char2 VALUE '03',
      fixo_01              TYPE char2 VALUE '01',
      fixo_221             TYPE char3 VALUE '221',
      ok                   TYPE char1 VALUE 'S',
      erro                 TYPE char1 VALUE 'E',
      doctyp_1             TYPE j_1bnfdoc-doctyp   VALUE '1',
      direct_2             TYPE j_1bnfdoc-direct   VALUE '2',
      direct_1             TYPE j_1bnfdoc-direct   VALUE '1',
      model                TYPE j_1bnfdoc-model    VALUE '55',
      waerk                TYPE j_1bnfdoc-waerk    VALUE 'BRL',
      parvw                TYPE j_1bnfdoc-parvw    VALUE 'AG',
      partyp               TYPE j_1bnfdoc-partyp   VALUE 'C',
      inco_srf             TYPE j_1bnfdoc-inco1    VALUE 'SRF',
      inco_sfr             TYPE j_1bnfdoc-inco2    VALUE 'SFR',
      fixo_2               TYPE char1              VALUE '2',
      fixo_1               TYPE char1              VALUE '1',
      vazio                TYPE char1              VALUE '',
      item                 TYPE bapi_j_1bnflin-itmnum VALUE '000010',
      tax_bco1             TYPE j_1btaxtyp VALUE 'BCO1',
      tax_bpi1             TYPE j_1btaxtyp VALUE 'BPI1',
      tax_bx13             TYPE j_1btaxtyp VALUE 'BX13',
      tax_bx23             TYPE j_1btaxtyp VALUE 'BX23',
      tax_bx72             TYPE j_1btaxtyp VALUE 'BX72',
      tax_bx82             TYPE j_1btaxtyp VALUE 'BX82',
      tax_icm3             TYPE j_1btaxtyp VALUE 'ICM3',
      tax_icof             TYPE j_1btaxtyp VALUE 'ICOF',
      tax_ipi3             TYPE j_1btaxtyp VALUE 'IPI3',
      tax_ipis             TYPE j_1btaxtyp VALUE 'IPIS',
      tax_ipva             TYPE j_1btaxtyp VALUE 'IPVA',
      tax_zicm             TYPE j_1btaxtyp VALUE 'ZICM',
      pag_90               TYPE j_1bnfe_tpag VALUE '90',
      nf55                 TYPE j_1bform     VALUE 'NF55',
      etapa_3_nf_sai       TYPE ze_etapa   VALUE 3,
      etapa_5_nf_ent       TYPE ze_etapa   VALUE 5,
      modulo               TYPE ztca_param_par-modulo VALUE 'MM',
      chave1               TYPE ztca_param_par-chave1 VALUE 'MONITOR_IMOBILIZACAO',
      chave2               TYPE ztca_param_par-chave2 VALUE 'CTG_NF',
      chave3_saida         TYPE ztca_param_par-chave3 VALUE 'SAIDA',
      chave3_entrada       TYPE ztca_param_par-chave3 VALUE 'ENTRADA',
      chave2_icms_recolher TYPE ztca_param_par-chave2 VALUE 'ICMS_RECOLHER',
      chave3_cond_icms     TYPE ztca_param_par-chave3 VALUE 'COND_ICM',
      chave2_pis_recuperar TYPE ztca_param_par-chave2 VALUE 'PIS_RECUPERAR',
      chave3_cond_pis      TYPE ztca_param_par-chave3 VALUE 'COND_PIS',
      chave2_cof_recuperar TYPE ztca_param_par-chave2 VALUE 'COFINS_RECUPERAR',
      chave3_cond_cof      TYPE ztca_param_par-chave3 VALUE 'COND_COF',
      chave2_ipi_recolher  TYPE ztca_param_par-chave2 VALUE 'IPI_RECOLHER',
      chave3_cond_ipi      TYPE ztca_param_par-chave3 VALUE 'COND_IPI',
    END OF gc_data .
  "! Tabela de retorno
  DATA gt_return TYPE bapiret2_tab .
  DATA:
  "! Parametros
    gt_param  TYPE TABLE OF ztmm_mov_param .
  DATA:
  "! Lei fiscal 2
    gt_lei_2v TYPE TABLE OF ty_lei_fiscal_2 .
  DATA:
  "! Lei fiscal 4
    gt_lei_4v TYPE TABLE OF ty_lei_fiscal_4 .
  DATA:
  "! Lei fiscal 5
    gt_lei_5v TYPE TABLE OF ty_lei_fiscal_5 .
  "! Regio
  DATA gv_regio TYPE regio .
  "! Documento da NF
  DATA gs_nf_doc TYPE i_br_nfdocument .
  DATA gs_nf_active TYPE j_1bnfe_active .
  DATA gs_verifynotafiscal TYPE c_br_verifynotafiscal .
  "! Condition do ICMS
  DATA gv_cond_icms TYPE j_1btaxtyp .
  "! Condition do PIS
  DATA gv_cond_pis TYPE j_1btaxtyp .
  "! Condition do Cofins
  DATA gv_cond_cof TYPE j_1btaxtyp .
  "! Condition do IPI
  DATA gv_cond_ipi TYPE j_1btaxtyp .
  DATA gv_partner TYPE kunnr .
  DATA gv_nfe_entrada TYPE boolean .

  "! Atribuir cabeçalho
  "! @parameter is_document | Dados de processamento
  "! @parameter rs_header | Cabeçalho
  METHODS set_header
    IMPORTING
      !is_document     TYPE ztmm_mov_cntrl
    RETURNING
      VALUE(rs_header) TYPE bapi_j_1bnfdoc .
  "! Atribuir item
  "! @parameter is_document | Dados de processamento
  "! @parameter rt_item | Item
  METHODS set_item
    IMPORTING
      !is_document   TYPE ztmm_mov_cntrl
    RETURNING
      VALUE(rt_item) TYPE bapi_j_1bnflin_tab .
  "! Atribuir lote
  "! @parameter is_document | Dados de processamento
  "! @parameter rv_batch | Lote
  METHODS set_batch
    IMPORTING
      !is_document    TYPE ztmm_mov_cntrl
    RETURNING
      VALUE(rv_batch) TYPE charg_d .
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
  "! Atribuir item
  "! @parameter rs_header_add | Dados adicionais
  METHODS set_header_add
    RETURNING
      VALUE(rs_header_add) TYPE bapi_j_1bnfdoc_add .
  "! Atribuir verificação da NF
  "! @parameter rs_nfcheck | Verificação da NF
  METHODS set_nfcheck
    RETURNING
      VALUE(rs_nfcheck) TYPE bapi_j_1bnfcheck .
  "! Atribuir parceiro
  "! @parameter is_document | Dados de processamento
  "! @parameter rt_partner | Parceiro
  METHODS set_partner
    IMPORTING
      !is_document      TYPE ztmm_mov_cntrl
    RETURNING
      VALUE(rt_partner) TYPE bapi_j_1bnfnad_tab .
  "! Atualizar dados
  "! @parameter is_doc | Dados de processamento
  METHODS update_table
    IMPORTING
      !is_doc TYPE ztmm_mov_cntrl .
  "! Atribuir parceiro
  "! @parameter iv_matnr | Material
  "! @parameter iv_werks | Centro
  METHODS get_material
    IMPORTING
      !iv_matnr          TYPE matnr
      !iv_werks          TYPE werks_d
    RETURNING
      VALUE(rs_material) TYPE ty_material .
  "! Buscar parametros
  "! @parameter iv_matnr | Material
  METHODS get_param
    IMPORTING
      !iv_matnr TYPE matnr .
  "! Buscar parametros
  "! @parameter iv_direcao | Direção - entrada/saída
  METHODS set_cfop_item
    IMPORTING
      !iv_direcao    TYPE j_1bdirect
    RETURNING
      VALUE(rv_cfop) TYPE j_1bcfop .
  "! Buscar região
  "! @parameter iv_matnr | Material
  "! @parameter iv_werks | Centro
  METHODS get_regio
    IMPORTING
      !iv_matnr TYPE ztmm_mov_cntrl-matnr1
      !iv_werks TYPE ztmm_mov_cntrl-werks .
  "! Atribuir parametros
  "! @parameter iv_regio  | Região
  "! @parameter iv_direcao | Direção - entrada/saída
  "! @parameter iv_cfop  | CFOP
  "! @parameter rs_param | Parametros
  METHODS set_param
    IMPORTING
      !iv_regio       TYPE regio
      !iv_direcao     TYPE char1
      !iv_cfop        TYPE j_1bcfop
    RETURNING
      VALUE(rs_param) TYPE ztmm_mov_param .
  "! Buscar lei fiscal 2
  METHODS get_lei_2v .
  "! Atribuir lei fiscal 2
  "! @parameter is_param | Parametros
  "! @parameter rv_tax | Taxa
  METHODS set_lei_2v
    IMPORTING
      !is_param     TYPE ztmm_mov_param
    RETURNING
      VALUE(rv_tax) TYPE j_1btaxsi2in .
  "! Atribuir valor da condition
  "! @parameter is_document | Dados de processamento
  "! @parameter rv_cond_value | Valor da condition
  METHODS set_cond_value
    IMPORTING
      !is_document         TYPE ztmm_mov_cntrl
    RETURNING
      VALUE(rv_cond_value) TYPE kbetr .
  "! Atribuir valor da taxa
  "! @parameter is_document | Dados de processamento
  "! @parameter rt_item_tax | Valor da taxa
  METHODS set_item_tax
    IMPORTING
      !is_document       TYPE ztmm_mov_cntrl
    RETURNING
      VALUE(rt_item_tax) TYPE bapi_j_1bnfstx_tab .
  "! Atribuir valor da condition
  "! @parameter is_document | Dados de processamento
  "! @parameter rt_header_msg | Valor da mensagem
  METHODS set_header_msg
    IMPORTING
      !is_document         TYPE ztmm_mov_cntrl
    RETURNING
      VALUE(rt_header_msg) TYPE bapi_j_1bnfftx_tab .
  "! Atribuir Impostos
  "! @parameter iv_id | ID processamento
  "! @parameter rs_taxes | Valor dos impostos
  METHODS get_taxes
    IMPORTING
      !iv_id          TYPE ztmm_mov_cntrl-id
    RETURNING
      VALUE(rs_taxes) TYPE ztmm_mov_simul .
  "! Atribuir pagamento
  "! @parameter iv_etapa | Etapa processamento
  "! @parameter rt_obj_payment | Pagamento
  METHODS set_obj_payment
    IMPORTING
      !iv_etapa             TYPE ztmm_mov_cntrl-etapa
    RETURNING
      VALUE(rt_obj_payment) TYPE zctgmm_payment .
  "! Executar BAPI
  "! @parameter ev_docnum | Doc. gerado
  "! @parameter et_return | Tabela de retorno
  "! @parameter  cs_header     | Header
  "! @parameter  cs_header_add | Dados adicionais header
  "! @parameter  cs_nfcheck    | Check NF
  "! @parameter  ct_partner    | Parceiro
  "! @parameter  ct_item       | Item
  "! @parameter  ct_item_tax   | Impostos
  "! @parameter  ct_header_msg | Mensagem de header
  "! @parameter  ct_obj_pay    | Pagamento
  "! @parameter  cs_document   | Dados de processamento
  METHODS call_bapi
    EXPORTING
      !ev_docnum     TYPE j_1bnfdoc-docnum
      !et_return     TYPE bapiret2_tab
    CHANGING
      !cs_header     TYPE bapi_j_1bnfdoc
      !cs_header_add TYPE bapi_j_1bnfdoc_add
      !cs_nfcheck    TYPE bapi_j_1bnfcheck
      !ct_partner    TYPE bapi_j_1bnfnad_tab
      !ct_item       TYPE bapi_j_1bnflin_tab
      !ct_item_tax   TYPE bapi_j_1bnfstx_tab
      !ct_header_msg TYPE bapi_j_1bnfftx_tab
      !ct_obj_pay    TYPE zctgmm_payment
      !cs_document   TYPE ztmm_mov_cntrl .
  "! Buscar doc.
  "! @parameter iv_docnum | Doc. gerado
  METHODS get_nf_documetn
    IMPORTING
      !iv_docnum TYPE ztmm_mov_cntrl-docnum_s .
  "! Atribuir direção
  "! @parameter iv_etapa | Etapa
  "! @parameter rv_direcao | Dir.
  METHODS set_direcao
    IMPORTING
      !iv_etapa         TYPE ztmm_mov_cntrl-etapa
    RETURNING
      VALUE(rv_direcao) TYPE j_1bdirect .
  "! Atribuir tipo NF
  "! @parameter iv_etapa | Etapa
  "! @parameter rv_nftype | Tipo NF
  METHODS set_nftype
    IMPORTING
      !iv_etapa        TYPE ztmm_mov_cntrl-etapa
    RETURNING
      VALUE(rv_nftype) TYPE j_1bnfdoc-nftype .
  "! Atribuir parametros das conditions
  METHODS set_param_cond .
  "! Buscar leis fiscais
  METHODS get_leis_fiscais .
  "! Buscar lei fiscal 4
  METHODS get_lei_4v .
  "! Buscar lei fiscal 4
  METHODS get_lei_5v .
  "! Atribuir lei fiscal 4
  "! @parameter is_param | Parametros
  "! @parameter rv_tax| Taxa
  METHODS set_lei_4v
    IMPORTING
      !is_param     TYPE ztmm_mov_param
    RETURNING
      VALUE(rv_tax) TYPE j_1btaxsi4in .
  "! Atribuir lei fiscal 5
  "! @parameter is_param | Parametros
  "! @parameter rv_tax| Taxa
  METHODS set_lei_5v
    IMPORTING
      !is_param     TYPE ztmm_mov_param
    RETURNING
      VALUE(rv_tax) TYPE j_1btaxsi5in .
ENDCLASS.



CLASS ZCLMM_CREATE_NF IMPLEMENTATION.


  METHOD UPDATE_TABLE.

    DATA ls_update TYPE ztmm_mov_cntrl.

    ls_update = CORRESPONDING #( is_doc ).

    MODIFY ztmm_mov_cntrl FROM ls_update.

  ENDMETHOD.


  METHOD set_partner.


    select single kunnr
      from t001w
      into gv_partner
      where werks = is_document-werks.

    check sy-subrc = 0.



      APPEND VALUE #(
        parvw   = gc_data-parvw
        parid   = gv_partner
        partyp  = gc_data-partyp
        xcpdk   = abap_true
        ) TO rt_partner.

  ENDMETHOD.


  METHOD set_param_cond.

     DATA(lo_param) = NEW zclca_tabela_parametros( ).
    TRY.
        lo_param->m_get_single(
          EXPORTING
            iv_modulo = gc_data-modulo
            iv_chave1 = gc_data-chave1
            iv_chave2 = gc_data-chave2_icms_recolher
            iv_chave3 = gc_data-chave3_cond_icms
          IMPORTING
            ev_param  = gv_cond_icms
        ).
      CATCH zcxca_tabela_parametros.

    ENDTRY.

      TRY.
          lo_param->m_get_single(
            EXPORTING
              iv_modulo = gc_data-modulo
              iv_chave1 = gc_data-chave1
              iv_chave2 = gc_data-chave2_pis_recuperar
              iv_chave3 = gc_data-chave3_cond_pis
            IMPORTING
              ev_param  = gv_cond_pis
          ).
        CATCH zcxca_tabela_parametros.

      ENDTRY.


      TRY.
          lo_param->m_get_single(
            EXPORTING
              iv_modulo = gc_data-modulo
              iv_chave1 = gc_data-chave1
              iv_chave2 = gc_data-chave2_cof_recuperar
              iv_chave3 = gc_data-chave3_cond_cof
            IMPORTING
              ev_param  = gv_cond_cof
          ).
        CATCH zcxca_tabela_parametros.


      ENDTRY.

      TRY.
          lo_param->m_get_single(
            EXPORTING
              iv_modulo = gc_data-modulo
              iv_chave1 = gc_data-chave1
              iv_chave2 = gc_data-chave2_ipi_recolher
              iv_chave3 = gc_data-chave3_cond_ipi
            IMPORTING
              ev_param  = gv_cond_ipi
          ).
        CATCH zcxca_tabela_parametros.


      ENDTRY.


  ENDMETHOD.


  METHOD set_param.

    READ TABLE gt_param ASSIGNING FIELD-SYMBOL(<fs_param>)
                        WITH KEY shipfrom   = iv_regio
                                 direcao    = iv_direcao
                                 cfop(4)    = iv_cfop BINARY SEARCH.

    CHECK sy-subrc = 0.

    rs_param = <fs_param>.

  ENDMETHOD.


  METHOD set_obj_payment.

    CASE iv_etapa.

      WHEN gc_data-etapa_3_nf_sai.

        APPEND VALUE #(
           t_pag = gc_data-pag_90
        ) TO rt_obj_payment.

    ENDCASE.

  ENDMETHOD.


  METHOD set_nftype.

    DATA(lv_chave3) = COND #( WHEN iv_etapa = gc_data-etapa_3_nf_sai THEN gc_data-chave3_saida
                              WHEN iv_etapa = gc_data-etapa_5_nf_ent THEN gc_data-chave3_entrada ).

    DATA(lo_param) = NEW zclca_tabela_parametros( ).

    TRY.
        lo_param->m_get_single(
          EXPORTING
            iv_modulo = gc_data-modulo
            iv_chave1 = gc_data-chave1
            iv_chave2 = gc_data-chave2
            iv_chave3 = lv_chave3
          IMPORTING
            ev_param  = rv_nftype
        ).
      CATCH zcxca_tabela_parametros.

    ENDTRY.

  ENDMETHOD.


  METHOD set_nfcheck.

    rs_nfcheck = VALUE #(
                            chekcon = abap_true
                         ).

  ENDMETHOD.


  METHOD SET_MESSAGE.

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


  METHOD set_lei_5v.

    READ TABLE gt_lei_5v ASSIGNING FIELD-SYMBOL(<fs_lei>)
                       WITH KEY taxlaw = is_param-taxlw5 BINARY SEARCH.

    CHECK sy-subrc = 0.

    rv_tax = <fs_lei>-taxsit.

  ENDMETHOD.


  METHOD set_lei_4v.

    READ TABLE gt_lei_4v ASSIGNING FIELD-SYMBOL(<fs_lei>)
                       WITH KEY taxlaw = is_param-taxlw4 BINARY SEARCH.

    CHECK sy-subrc = 0.

    rv_tax = <fs_lei>-taxsit.


  ENDMETHOD.


  METHOD set_lei_2v.

    READ TABLE gt_lei_2v ASSIGNING FIELD-SYMBOL(<fs_lei>)
                         WITH KEY taxlaw = is_param-taxlw2 BINARY SEARCH.

    CHECK sy-subrc = 0.

    rv_tax = <fs_lei>-taxsit.

  ENDMETHOD.


  METHOD set_item_tax.

    DATA(ls_taxes) = get_taxes( is_document-id ).

    CASE is_document-etapa.

      WHEN gc_data-etapa_3_nf_sai.

        APPEND VALUE #(
              itmnum    = gc_data-item
              taxtyp    = gv_cond_icms " gc_data-tax_icm3
              base      = ls_taxes-base_bx13
              rate      = ls_taxes-rate_bx13
              taxval    = ls_taxes-taxval_bx13
          ) TO rt_item_tax.


        APPEND VALUE #(
              itmnum    = gc_data-item
              taxtyp    = gv_cond_ipi "gc_data-tax_ipi3
              base      = ls_taxes-base_ipva
              rate      = ls_taxes-rate_ipva
              taxval    = ls_taxes-taxval_bx23
          ) TO rt_item_tax.

        APPEND VALUE #(
              itmnum    = gc_data-item
              taxtyp    = gv_cond_pis "gc_data-tax_ipis
              base      = ls_taxes-base_bpi1
              rate      = ls_taxes-rate_bx82
              taxval    = ls_taxes-taxval_bx82
          ) TO rt_item_tax.


        APPEND VALUE #(
             itmnum    = gc_data-item
             taxtyp    = gv_cond_cof " gc_data-tax_icof
             base      = ls_taxes-base_bco1
             rate      = ls_taxes-rate_bx72
             taxval    = ls_taxes-taxval_bx72
         ) TO rt_item_tax.


      WHEN gc_data-etapa_5_nf_ent.

        APPEND VALUE #(
              itmnum    = gc_data-item
              taxtyp    = gv_cond_icms
              othbas    = gs_nf_doc-BR_NFTotalAmount

          ) TO rt_item_tax.

        APPEND VALUE #(
            itmnum    = gc_data-item
            taxtyp    = gv_cond_ipi
            othbas    = gs_nf_doc-BR_NFTotalAmount

        ) TO rt_item_tax.

    ENDCASE.

  ENDMETHOD.


  METHOD set_item.

    DATA: lv_cfop   TYPE j_1bcfop,
          lv_cfop_a TYPE j_1bcfop.

    DATA(lv_direcao) = set_direcao( is_document-etapa ).

    IF is_document-etapa EQ '5'. " NFe entrada
      DATA(ls_material) = get_material( iv_matnr = is_document-matnr
                                        iv_werks = |{ is_document-werks ALPHA = IN }| ).
    ELSE.
      ls_material = get_material( iv_matnr = is_document-matnr1
                                  iv_werks = |{ is_document-werks ALPHA = IN }| ).
    ENDIF.

    DATA(lv_cfop_10) = set_cfop_item( lv_direcao ).
    lv_cfop = lv_cfop_10(4).

    DATA(ls_param) = set_param( iv_regio      = gv_regio
                                  iv_direcao    = lv_direcao
                                  iv_cfop       = lv_cfop ).

    DATA(lv_netpr) = set_cond_value( is_document ).

    CALL FUNCTION 'CONVERSION_EXIT_CFOBR_INPUT'
      EXPORTING
        input  = lv_cfop_10
      IMPORTING
        output = lv_cfop_a.

    IF is_document-etapa EQ '5'. " NFe entrada
      DATA(lv_matnr) = is_document-matnr.
    ELSE.
      lv_matnr = is_document-matnr1.
    ENDIF.

    APPEND VALUE #(
            itmnum     = gc_data-item
            matnr      = lv_matnr
            bwkey      = |{ is_document-werks ALPHA = IN }|
            matkl      = ls_material-matkl
            maktx      = ls_material-maktx
*            cfop       = lv_cfop
            nbm        = ls_material-steuc
            matorg     = ls_material-mtorg
            taxsit     = ls_param-taxsit
            taxsi2     = set_lei_2v( ls_param )
            matuse     = ls_material-mtuse
            menge      = is_document-menge
            meins      = ls_material-meins
            netpr      = lv_netpr
            netwr      = lv_netpr * is_document-menge
            taxlw1     = ls_param-taxlw1
            taxlw2     = ls_param-taxlw2
            itmtyp     = gc_data-fixo_1
            werks      = |{ is_document-werks ALPHA = IN }|
            cfop_10    = lv_cfop_a
            taxlw4     = ls_param-taxlw4
            taxsi4     = set_lei_4v( ls_param )
            taxlw5     = ls_param-taxlw5
            taxsi5     = set_lei_5v( ls_param )
            meins_trib = ls_material-meins ) TO rt_item.


  ENDMETHOD.


  METHOD set_header_msg.


    APPEND VALUE #(
       seqnum = gc_data-fixo_01
       linnum = gc_data-fixo_01
        ) TO rt_header_msg.

  ENDMETHOD.


  METHOD set_header_add.

    rs_header_add = VALUE #(
                                nfdec   = gc_data-fixo_2
                                nftot   = gc_data-vazio

                         ).

  ENDMETHOD.


  METHOD set_header.

    DATA(lv_nftype) = set_nftype( is_document-etapa ).

    SELECT SINGLE kunnr
      FROM t001w
      INTO gv_partner
      WHERE werks = is_document-werks.

    IF gv_nfe_entrada IS NOT INITIAL.

      rs_header = VALUE #(
                          nftype  = lv_nftype
                          doctyp  = gc_data-doctyp_1

                          direct  = COND #( WHEN is_document-etapa = gc_data-etapa_3_nf_sai THEN gc_data-direct_2
                                            WHEN is_document-etapa = gc_data-etapa_5_nf_ent THEN gc_data-direct_1 )

                          docdat  = COND #( WHEN is_document-etapa = gc_data-etapa_3_nf_sai THEN sy-datum
                                            WHEN is_document-etapa = gc_data-etapa_5_nf_ent THEN gs_nf_doc-creationdate )

                          pstdat  = sy-datum
                          model   = gc_data-model
                          entrad  = abap_true
                          manual  = abap_true
                          fatura  = abap_true

                          series  = COND #( WHEN is_document-etapa = gc_data-etapa_5_nf_ent THEN gs_nf_doc-br_nfseries
                                            ELSE gc_data-vazio )

*                          docnum9  = COND #( WHEN is_document-etapa = gc_data-etapa_5_nf_ent THEN gs_verifynotafiscal-br_nferandomnumber
*                                             ELSE gc_data-vazio )
*
*                          tpemis  = COND #( WHEN is_document-etapa = gc_data-etapa_5_nf_ent THEN gs_verifynotafiscal-issuingtype
*                                            ELSE gc_data-vazio )

                          access_key  = COND #( WHEN is_document-etapa = gc_data-etapa_5_nf_ent THEN gs_verifynotafiscal-br_nfeaccesskey
                                                ELSE gc_data-vazio )

                          waerk   = gc_data-waerk
                          bukrs   = is_document-bukrs
                          branch  = is_document-branch
                          parvw   = |{ gc_data-parvw ALPHA = IN }|
                          parid   = gv_partner
                          partyp  = gc_data-partyp
                          form    = gc_data-nf55

                          inco1   = COND #( WHEN is_document-etapa = gc_data-etapa_3_nf_sai THEN gc_data-inco_srf
                                            WHEN is_document-etapa = gc_data-etapa_5_nf_ent THEN gc_data-inco_sfr )

                          inco2   = COND #( WHEN is_document-etapa = gc_data-etapa_3_nf_sai THEN gc_data-inco_srf
                                            WHEN is_document-etapa = gc_data-etapa_5_nf_ent THEN gc_data-inco_sfr )
                          nfe     = abap_true
*                          docstat = COND #( WHEN is_document-etapa = gc_data-etapa_5_nf_ent THEN '1'
*                                            ELSE gc_data-vazio )
                                            ).

    ELSE.

      rs_header = VALUE #(
                              nftype  = lv_nftype
                              doctyp  = gc_data-doctyp_1

                              direct  = COND #( WHEN is_document-etapa = gc_data-etapa_3_nf_sai THEN gc_data-direct_2
                                                WHEN is_document-etapa = gc_data-etapa_5_nf_ent THEN gc_data-direct_1 )

                              docdat  = COND #( WHEN is_document-etapa = gc_data-etapa_3_nf_sai THEN sy-datum
                                                WHEN is_document-etapa = gc_data-etapa_5_nf_ent THEN gs_nf_doc-creationdate )

                              pstdat  = sy-datum
                              model   = gc_data-model
                              manual  = abap_true
                              fatura  = abap_true

                              series  = COND #( WHEN is_document-etapa = gc_data-etapa_5_nf_ent THEN gs_nf_doc-br_nfseries
                                                ELSE gc_data-vazio )

                              docnum9 = COND #( WHEN is_document-etapa = gc_data-etapa_5_nf_ent THEN gs_verifynotafiscal-br_nferandomnumber
                                                ELSE gc_data-vazio )

                              tpemis  = COND #( WHEN is_document-etapa = gc_data-etapa_5_nf_ent THEN gs_verifynotafiscal-issuingtype
                                                ELSE gc_data-vazio )

                              access_key = COND #( WHEN is_document-etapa = gc_data-etapa_5_nf_ent THEN gs_verifynotafiscal-br_nfeaccesskey
                                                   ELSE gc_data-vazio )

                              waerk   = gc_data-waerk
                              bukrs   = is_document-bukrs
                              branch  = is_document-branch
                              parvw   = |{ gc_data-parvw ALPHA = IN }|
                              parid   = gv_partner
                              partyp  = gc_data-partyp

                              inco1   = COND #( WHEN is_document-etapa = gc_data-etapa_3_nf_sai THEN gc_data-inco_srf
                                                WHEN is_document-etapa = gc_data-etapa_5_nf_ent THEN gc_data-inco_sfr )

                              inco2   = COND #( WHEN is_document-etapa = gc_data-etapa_3_nf_sai THEN gc_data-inco_srf
                                                WHEN is_document-etapa = gc_data-etapa_5_nf_ent THEN gc_data-inco_sfr )

                              nfe     = abap_true

                              nfenum  = COND #( WHEN is_document-etapa = gc_data-etapa_5_nf_ent THEN gs_nf_doc-br_nfenumber
                                                ELSE gc_data-vazio )

                              authcod = COND #( WHEN is_document-etapa = gc_data-etapa_5_nf_ent THEN gs_nf_doc-br_nfauthznprotocolnumber
                                                ELSE gc_data-vazio )

                              authdate = COND #( WHEN is_document-etapa = gc_data-etapa_5_nf_ent THEN gs_nf_doc-br_nfauthenticationdate
                                                 ELSE gc_data-vazio )

                              authtime = COND #( WHEN is_document-etapa = gc_data-etapa_5_nf_ent THEN gs_nf_doc-br_nfauthenticationtime
                                                 ELSE gc_data-vazio )

                              docstat = COND #( WHEN is_document-etapa = gc_data-etapa_5_nf_ent THEN '1'
                                                ELSE gc_data-vazio ) ).
    ENDIF.

  ENDMETHOD.


  METHOD set_direcao.

    rv_direcao = COND #( WHEN iv_etapa = gc_data-etapa_3_nf_sai THEN gc_data-fixo_2
                                 WHEN iv_etapa = gc_data-etapa_5_nf_ent THEN gc_data-fixo_1 ).

  ENDMETHOD.


  METHOD set_cond_value.

    CASE is_document-etapa.

      WHEN gc_data-etapa_3_nf_sai.

        SELECT SINGLE lppnet
       FROM j_1blpp
       INTO @DATA(lv_valor)
      WHERE matnr = @is_document-matnr1
        AND bwkey = @is_document-werks.

        MOVE lv_valor TO rv_cond_value.

      WHEN gc_data-etapa_5_nf_ent.

        rv_cond_value = gs_nf_doc-BR_NFTotalAmount.

    ENDCASE.

    "???teste
    IF rv_cond_value IS INITIAL.

     select SINGLE STPRS
      from mbew
      into @data(lv_stprs)
      where matnr = @is_document-matnr1
      AND bwkey = @is_document-werks.

      if sy-subrc = 0.
       MOVE lv_stprs TO rv_cond_value.
      endif.

    ENDIF.

  ENDMETHOD.


  METHOD set_cfop_item.

    DATA(lt_param) = gt_param[].

    SORT lt_param BY shipfrom
                     direcao.

    READ TABLE lt_param ASSIGNING FIELD-SYMBOL(<fs_line>)
                                      WITH KEY shipfrom = gv_regio
                                               direcao  = iv_direcao
                                               BINARY SEARCH.

    CHECK sy-subrc = 0.

    rv_cfop = <fs_line>-cfop.

  ENDMETHOD.


  METHOD SET_BATCH.

    SELECT SINGLE charg_sid
     FROM P_StockBatchInfo
     INTO @rv_batch
    WHERE matnr = @is_document-matnr1
      AND werks = @is_document-werks
      AND mng01 > 0.


  ENDMETHOD.


  METHOD ROLLBACK.

    CALL FUNCTION 'BAPI_TRANSACTION_ROLLBACK'.

  ENDMETHOD.


  METHOD process.

    gv_nfe_entrada = iv_nfe_entrada.

    IF gv_nfe_entrada IS NOT INITIAL.
      get_param( cs_document-matnr ).
    ELSE.
      get_param( cs_document-matnr1 ).
    ENDIF.

    get_regio( iv_matnr = cs_document-matnr
               iv_werks = cs_document-werks ).
    get_nf_documetn( cs_document-docnum_s ).

    get_leis_fiscais( ).

    set_param_cond( ).

    DATA(ls_header)         = set_header( cs_document ).

    DATA(ls_header_add)     = set_header_add( ).

    DATA(ls_nfcheck)        = set_nfcheck( ).

    DATA(lt_partner)        = set_partner( cs_document ).

    DATA(lt_item)           = set_item( cs_document ).

    DATA(lt_item_tax)       = set_item_tax( cs_document ).

    DATA(lt_header_msg)     = set_header_msg( cs_document ).

    DATA(lt_obj_payment)    = set_obj_payment( cs_document-etapa ).


    call_bapi(
       IMPORTING
        ev_docnum   = ev_docnum
        et_return    = et_return
       CHANGING
        cs_header       = ls_header
        cs_header_add   = ls_header_add
        cs_nfcheck      = ls_nfcheck
        ct_partner      = lt_partner
        ct_item         = lt_item
        ct_item_tax     = lt_item_tax
        ct_header_msg   = lt_header_msg
        ct_obj_pay      = lt_obj_payment
        cs_document     = cs_document
    ).

  ENDMETHOD.


  METHOD get_taxes.

    SELECT SINGLE *
    FROM ztmm_mov_simul
    INTO rs_taxes
    WHERE id = iv_id.

  ENDMETHOD.


  METHOD get_regio.

    SELECT SINGLE regio
      FROM t001w
      INTO gv_regio
     WHERE werks = iv_werks.

  ENDMETHOD.


  METHOD get_param.

    SELECT *
      FROM ztmm_mov_param
      INTO TABLE gt_param
     WHERE matnr = iv_matnr
       AND ativo = abap_true.

    SORT gt_param BY shipfrom direcao cfop.


  ENDMETHOD.


  METHOD get_nf_documetn.

    SELECT SINGLE *
    FROM i_br_nfdocument
    INTO @gs_nf_doc
    WHERE br_notafiscal = @iv_docnum.


    SELECT SINGLE *
    FROM j_1bnfe_active
    INTO @gs_nf_active
    WHERE docnum = @iv_docnum.

    SELECT SINGLE *
    FROM c_br_verifynotafiscal
    INTO @gs_verifynotafiscal
    WHERE br_notafiscal = @iv_docnum.


  ENDMETHOD.


  METHOD get_material.

*
    SELECT SINGLE
        a~matnr
        a~matkl
        b~maktx
        c~steuc
        d~mtorg
        d~mtuse
        a~meins
      FROM mara AS a
      INNER JOIN makt AS b
      ON a~matnr = b~matnr
      AND b~spras = sy-langu
      INNER JOIN marc AS c
      ON a~matnr = c~matnr
      INNER JOIN mbew AS d
      ON a~matnr = d~matnr
      AND c~werks = d~bwkey
      INTO rs_material
     WHERE a~matnr = iv_matnr
       AND c~werks = iv_werks.


  ENDMETHOD.


  METHOD get_lei_5v.

    DATA(lt_param) = gt_param.

    SORT lt_param BY taxlw5.

    DELETE ADJACENT DUPLICATES FROM lt_param.

    CHECK lines( lt_param ) > 0.

    SELECT taxlaw taxsit
      FROM j_1batl5
      INTO TABLE gt_lei_5v
       FOR ALL ENTRIES IN lt_param
     WHERE taxlaw = lt_param-taxlw5.
     SORT gt_lei_5v BY taxlaw.

  ENDMETHOD.


  METHOD get_lei_4v.

    DATA(lt_param) = gt_param.

    SORT lt_param BY taxlw4.

    DELETE ADJACENT DUPLICATES FROM lt_param.

    CHECK lines( lt_param ) > 0.

    SELECT taxlaw taxsit
      FROM j_1batl4a
      INTO TABLE gt_lei_4v
       FOR ALL ENTRIES IN lt_param
     WHERE taxlaw = lt_param-taxlw4.
    SORT gt_lei_4v BY taxlaw.

  ENDMETHOD.


  METHOD get_lei_2v.

    DATA(lt_param) = gt_param.

    SORT lt_param BY taxlw2.

    DELETE ADJACENT DUPLICATES FROM lt_param.

    CHECK lines( lt_param ) > 0.

    SELECT taxlaw taxsit
      FROM j_1batl2
      INTO TABLE gt_lei_2v
       FOR ALL ENTRIES IN lt_param
     WHERE taxlaw = lt_param-taxlw2.
    SORT gt_lei_2v BY taxlaw.

  ENDMETHOD.


  METHOD get_leis_fiscais.

      get_lei_2v( ).

      get_lei_4v( ).

      get_lei_5v( ).

  ENDMETHOD.


  METHOD COMMIT_WORK.

    CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
      EXPORTING
        wait = abap_true.


  ENDMETHOD.


  METHOD call_bapi.

    CALL FUNCTION 'BAPI_J_1B_NF_CREATEFROMDATA'
      EXPORTING
        obj_header     = cs_header
        obj_header_add = cs_header_add
        nfcheck        = cs_nfcheck
      IMPORTING
        e_docnum       = ev_docnum
      TABLES
        obj_partner    = ct_partner
        obj_item       = ct_item
        obj_item_tax   = ct_item_tax
        obj_header_msg = ct_header_msg
        return         = gt_return
        obj_payment    = ct_obj_pay.


    IF ev_docnum IS NOT INITIAL.

      SELECT SINGLE *
        INTO @DATA(ls_active)
        FROM j_1bnfe_active
        WHERE docnum = @ev_docnum.

      IF sy-subrc IS INITIAL.
        CALL FUNCTION 'J_1BDFE_SET_TPEMIS'
          EXPORTING
            iv_tpemis = '6'
          CHANGING
            cs_acttab = ls_active.
      ENDIF.

      CASE cs_document-etapa.
        WHEN 3.
          cs_document-docnum_s          = ev_docnum.

        WHEN 5.
          cs_document-docnum_ent      = ev_docnum.
          CLEAR: cs_document-docnum_est_ent.

      ENDCASE.

      cs_document-docdat      = sy-datum.
      CLEAR: cs_document-docnum_est_sai.

      set_message( is_doc   = cs_document
                   is_msg   = VALUE #( type       = gc_data-ok
                                       id         = 'ZMM_BENS_CONSUMO'
                                       number     = '006'
                                       message_v1 = cs_document-mblnr_ent
                                       message_v2 = cs_document-mjahr_ent ) ).

      update_table( cs_document ).

      commit_work( ).

    ELSE.

      set_message( is_doc   = cs_document
               is_msg   = VALUE #( type       = gc_data-erro
                                   id         = 'ZMM_BENS_CONSUMO'
                                   number     = '007'
                                    ) ).
      rollback( ).

    ENDIF.

    et_return = gt_return.


  ENDMETHOD.
ENDCLASS.
