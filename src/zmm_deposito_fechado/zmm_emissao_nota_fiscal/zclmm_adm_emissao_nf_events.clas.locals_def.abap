*"* use this source file for any type of declarations (class
*"* definitions, interfaces or type declarations) you need for
*"* components in the private section

* ===========================================================================
* CONSTANTES GLOBAIS
* ===========================================================================

CONSTANTS:

  gc_centro_2000 TYPE t001w-werks VALUE '2000', " Centro: Fabrica Eusebio T&M

  BEGIN OF gc_cds,
    emissao TYPE string VALUE 'EMISSAO',    " Emissão
    serie   TYPE string VALUE 'SERIE',      " Série
  END OF gc_cds,

  BEGIN OF gc_tipo_material,
    zcom TYPE mara-mtart VALUE 'ZCOM',  " Tipo de material: Contr. Ativ. Imob. Com.
  END OF gc_tipo_material,

  BEGIN OF gc_dir_movimento,
    entrada     TYPE j_1bnfe_active-direct VALUE '1',   " Entrada
    saida       TYPE j_1bnfe_active-direct VALUE '2',   " Saída
    dev_saida   TYPE j_1bnfe_active-direct VALUE '3',   " Devoluções de saída de transferências de estoque
    dev_entrada TYPE j_1bnfe_active-direct VALUE '4',   " Devoluções de entrada de transferências de estoque
  END OF gc_dir_movimento,

  BEGIN OF gc_status_documento,
    1_tela     TYPE j_1bnfe_active-docsta VALUE ' ',    " 1ª tela
    autorizado TYPE j_1bnfe_active-docsta VALUE '1',    " Autorizado
    recusado   TYPE j_1bnfe_active-docsta VALUE '2',    " Recusado
    rejeitado  TYPE j_1bnfe_active-docsta VALUE '3',    " Rejeitado
  END OF gc_status_documento,

  BEGIN OF gc_bapi_pedido,
    tp_doc_compra_zdf  TYPE ekko-bsart    VALUE 'ZDF',          " Tipo de documento de compras :    Pedido dep. fechado
    chv_cond_pag_0001  TYPE ekko-zterm    VALUE '0001',         " Chave de condições de pagamento:  0001
    org_compras_oc01   TYPE ekko-ekorg    VALUE 'OC01',         " Organização de compras:           3C Org. de Compras
    grupo_compra_310   TYPE ekko-ekgrp    VALUE '310',          " Grupo de compradores:             Produto Acabado
    controle_preco_s   TYPE mbew-vprsv    VALUE 'S',            " Código de controle de preço:      Preço standard
    controle_preco_v   TYPE mbew-vprsv    VALUE 'V',            " Código de controle de preço:      Preço médio móvel/preço interno periódico
    util_material_0    TYPE mbew-mtuse    VALUE '0',            " Utilização de material:           Revenda
    util_material_1    TYPE mbew-mtuse    VALUE '1',            " Utilização de material:           Industrialização
    util_material_2    TYPE mbew-mtuse    VALUE '2',            " Utilização de material:           Consumo
    util_material_3    TYPE mbew-mtuse    VALUE '3',            " Utilização de material:           Imobilizado
    util_material_4    TYPE mbew-mtuse    VALUE '4',            " Utilização de material:           Consumo para atividade principal
    codigo_iva_a0      TYPE ekpo-mwskz    VALUE 'A0',           " Código do IVA:                    Saida Transf.: Sem imposto
    codigo_iva_c0      TYPE ekpo-mwskz    VALUE 'C0',           " Código do IVA:                    Consumo: Sem Impostos
    codigo_iva_y4      TYPE ekpo-mwskz    VALUE 'Y4',           " Código do IVA:                    Deposito fechado - Retorno
    transf_preco_1     TYPE bapi_po_price VALUE '1',            " Transferência do preço:           Como preço bruto
    chv_ctrl_conf_0004 TYPE ekpo-bstae    VALUE '0004',         " Chave de controle de confirmação: Recebimento
    cond_0000000001    TYPE konv-knumv    VALUE '0000000001',   " Nº condição do documento:         0000000001
    tp_cond_p101       TYPE konv-kschl    VALUE 'P101',         " Tipo de condição:                 Preço aval.cen.forn.
    moeda_brl          TYPE konv-waers    VALUE 'BRL',          " Código da moeda:                  BRL
    regra_calc_cond_a  TYPE konv-krech    VALUE 'A',            " Regra de cálculo de condição:     Porcentagem
  END OF gc_bapi_pedido,

  BEGIN OF gc_bapi_entrada_merc,
    tipo_mov_z61 TYPE mseg-bwart VALUE '861',                   " Tipo de movimento (administração de estoques):   Z61
    cod_mov_b    TYPE mseg-kzbew VALUE 'B',                     " Código de movimento:                             Movimento de mercadoria por pedido
  END OF gc_bapi_entrada_merc,

  BEGIN OF gc_bapi_nf_entrada,
    ctg_nf_ic        TYPE j_1bnfdoc-nftype VALUE 'IC',          " Categoria de Nota Fiscal:             NFe Entrada (E1)
    tp_doc_1         TYPE j_1bnfdoc-doctyp VALUE '1',           " Tipo de documento :                   Nota fiscal
    dir_mov_1        TYPE j_1bnfdoc-direct VALUE '1',           " Direção do movimento de mercadorias:  Entrada
    modelo_55        TYPE j_1bnfdoc-model  VALUE '55',          " Modelo da nota fiscal:                Nota fiscal - modelo 55
    moeda_brl        TYPE j_1bnfdoc-waerk  VALUE 'BRL',         " Código da moeda:                      BRL
    func_parceiro_br TYPE j_1bnfdoc-parvw  VALUE 'BR',          " Nota fiscal função parceiro:          Filial
    tp_parc_b        TYPE j_1bnfdoc-partyp VALUE 'B',           " Tipo de parceiro nota fiscal:         Local de negócios
    tp_item_01       TYPE j_1bnflin-itmtyp VALUE '01',          " Tipos de item nota fiscal:            Item normal
    tp_imposto_icm0  TYPE j_1bnfstx-taxtyp VALUE 'ICM0',        " Tipo de imposto:                      ICMS NF linha zero
    tp_imposto_ipi0  TYPE j_1bnfstx-taxtyp VALUE 'IPI0',        " Tipo de imposto:                      IPI NF linha zero
  END OF gc_bapi_nf_entrada,

  BEGIN OF gc_param_cfop_rem_est,
    modulo TYPE ztca_param_val-modulo VALUE 'MM' ##NO_TEXT,
    chave1 TYPE ztca_param_val-chave1 VALUE 'REMESSA_FISICA' ##NO_TEXT,
    chave2 TYPE ztca_param_val-chave2 VALUE 'CFOP' ##NO_TEXT,
    chave3 TYPE ztca_param_val-chave3 VALUE 'ESTADUAL' ##NO_TEXT,
  END OF gc_param_cfop_rem_est,

  BEGIN OF gc_param_cfop_rem_int,
    modulo TYPE ztca_param_val-modulo VALUE 'MM' ##NO_TEXT,
    chave1 TYPE ztca_param_val-chave1 VALUE 'REMESSA_FISICA' ##NO_TEXT,
    chave2 TYPE ztca_param_val-chave2 VALUE 'CFOP' ##NO_TEXT,
    chave3 TYPE ztca_param_val-chave3 VALUE 'INTEREST' ##NO_TEXT,
  END OF gc_param_cfop_rem_int,

  BEGIN OF gc_param_cfop_ent_est,
    modulo TYPE ztca_param_val-modulo VALUE 'MM' ##NO_TEXT,
    chave1 TYPE ztca_param_val-chave1 VALUE 'ENTRADA_FISICA' ##NO_TEXT,
    chave2 TYPE ztca_param_val-chave2 VALUE 'CFOP' ##NO_TEXT,
    chave3 TYPE ztca_param_val-chave3 VALUE 'ESTADUAL' ##NO_TEXT,
  END OF gc_param_cfop_ent_est,

  BEGIN OF gc_param_cfop_ent_int,
    modulo TYPE ztca_param_val-modulo VALUE 'MM' ##NO_TEXT,
    chave1 TYPE ztca_param_val-chave1 VALUE 'ENTRADA_FISICA' ##NO_TEXT,
    chave2 TYPE ztca_param_val-chave2 VALUE 'CFOP' ##NO_TEXT,
    chave3 TYPE ztca_param_val-chave3 VALUE 'INTEREST' ##NO_TEXT,
  END OF gc_param_cfop_ent_int.

* ===========================================================================
* TIPOS GLOBAIS
* ===========================================================================

TYPES:
  BEGIN OF ty_t001k,
    bwkey  TYPE t001k-bwkey,
    bukrs  TYPE t001k-bukrs,
    branch TYPE t001w-j_1bbranch,
  END OF ty_t001k,

  ty_t_t001k TYPE SORTED TABLE OF ty_t001k
             WITH NON-UNIQUE KEY bwkey,

  BEGIN OF ty_mbew,
    matnr TYPE mbew-matnr,
    bwkey TYPE mbew-bwkey,
    bwtar TYPE mbew-bwtar,
    vprsv TYPE mbew-vprsv,
    stprs TYPE mbew-stprs,
    verpr TYPE mbew-verpr,
    peinh TYPE mbew-peinh,
    mtuse TYPE mbew-mtuse,
    mtorg TYPE mbew-mtorg,
  END OF ty_mbew,

  ty_t_mbew TYPE SORTED TABLE OF ty_mbew
            WITH NON-UNIQUE KEY matnr bwkey,

  BEGIN OF ty_mara,
    matnr TYPE mara-matnr,
    mtart TYPE mara-mtart,
    matkl TYPE mara-matkl,
    maktx TYPE makt-maktx,
  END OF ty_mara,

  ty_t_mara TYPE SORTED TABLE OF ty_mara
            WITH NON-UNIQUE KEY matnr,

  BEGIN OF ty_marc,
    matnr TYPE marc-matnr,
    werks TYPE marc-werks,
    steuc TYPE marc-steuc,
  END OF ty_marc,

  ty_t_marc TYPE SORTED TABLE OF ty_marc
            WITH NON-UNIQUE KEY matnr werks,

  BEGIN OF ty_equi,
    equnr TYPE equi-equnr,
    matnr TYPE equi-matnr,
    werk  TYPE equi-werk,
    lager TYPE equi-lager,
    sernr TYPE equi-sernr,
  END OF ty_equi,

  ty_t_equi TYPE SORTED TABLE OF ty_equi
            WITH NON-UNIQUE KEY matnr werk lager,

  BEGIN OF ty_eket,
    ebeln TYPE eket-ebeln,
    ebelp TYPE eket-ebelp,
    etenr TYPE eket-etenr,
    eindt TYPE eket-eindt,

    " Utilizados no enhancement
    charg TYPE eket-charg,
    lifnr TYPE ekko-lifnr,
    inco1 TYPE ekko-inco1,
    inco2 TYPE ekko-inco2,
    matnr TYPE ekpo-matnr,
    werks TYPE ekpo-werks,
    menge TYPE ekpo-menge,
    meins TYPE ekpo-meins,
    netpr TYPE ekpo-netpr,
    peinh TYPE ekpo-peinh,

  END OF ty_eket,

  ty_t_eket TYPE SORTED TABLE OF ty_eket
            WITH NON-UNIQUE KEY ebeln ebelp,

  BEGIN OF ty_lips,
    vbeln  TYPE lips-vbeln,
    posnr  TYPE lips-posnr,
    vgbel  TYPE lips-vgbel,
    vgpos  TYPE lips-vgpos,
    matnr  TYPE lips-matnr,
    meins  TYPE lips-meins,
    charg  TYPE lips-charg,
    cfop   TYPE lips-j_1bcfop,
    taxlw1 TYPE lips-j_1btaxlw1,
    taxlw2 TYPE lips-j_1btaxlw2,
    taxlw4 TYPE lips-j_1btaxlw4,
    taxsi4 TYPE j_1batl4a-taxsit,
    taxlw5 TYPE lips-j_1btaxlw5,
    taxsi5 TYPE j_1batl5-taxsit,
    wadat  TYPE likp-wadat,
    bwtar  TYPE lips-bwtar,
  END OF ty_lips,

  ty_t_lips TYPE SORTED TABLE OF ty_lips
            WITH NON-UNIQUE KEY vbeln posnr,

  BEGIN OF ty_mseg,
    mblnr    TYPE mseg-mblnr,
    mjahr    TYPE mseg-mjahr,
    zeile    TYPE mseg-zeile,
    vbeln_im TYPE mseg-vbeln_im,
    vbelp_im TYPE mseg-vbelp_im,
    ebeln    TYPE mseg-ebeln,
    ebelp    TYPE mseg-ebelp,
  END OF ty_mseg,

  ty_t_mseg TYPE SORTED TABLE OF ty_mseg
            WITH NON-UNIQUE KEY mblnr mjahr zeile
            WITH NON-UNIQUE SORTED KEY remessa
            COMPONENTS vbeln_im vbelp_im
            WITH NON-UNIQUE SORTED KEY pedido
            COMPONENTS ebeln ebelp,

  BEGIN OF ty_lin,
    xped     TYPE j_1bnflin-xped,
    nitemped TYPE j_1bnflin-nitemped,
    refkey   TYPE j_1bnflin-refkey,
    refitm   TYPE j_1bnflin-refitm,
    docnum   TYPE j_1bnflin-docnum,
    itmnum   TYPE j_1bnflin-itmnum,
    nfnett   TYPE j_1bnflin-nfnett,
    matnr    TYPE j_1bnflin-matnr,
    docdat   TYPE j_1bnfdoc-docdat,
    nfnum    TYPE j_1bnfdoc-nfnum,
    direct   TYPE j_1bnfe_active-direct,
    docsta   TYPE j_1bnfe_active-docsta,
  END OF ty_lin,

  ty_t_lin TYPE TABLE OF ty_lin,

  BEGIN OF ty_ekbe,
    bwart TYPE bwart,
    ebeln TYPE ebeln,
    ebelp TYPE ebelp,
    vgabe TYPE vgabe,
    belnr TYPE mblnr,
    gjahr TYPE mjahr,
    buzei TYPE buzei,
  END OF ty_ekbe,

  ty_t_ekbe TYPE TABLE OF ty_ekbe.
