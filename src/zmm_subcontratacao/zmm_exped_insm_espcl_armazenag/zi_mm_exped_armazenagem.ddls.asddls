@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Exped. Insumos - Especial - Armazenagem'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZI_MM_EXPED_ARMAZENAGEM
  as select from     j_1bnflin                     as Lin

    left outer join  ZI_MM_CONV_LIN_EKPO           as LinAux      on  LinAux.Docnum = Lin.docnum
                                                                  and LinAux.Itmnum = Lin.itmnum
                                                                  and LinAux.Itmnum is not initial

    right outer join ekpo                                         on  ekpo.ebeln = LinAux.Xped
                                                                  and ekpo.ebelp = LinAux.Nitemped
//                                                                  and ekpo.serru = 'Y'

    left outer join  ZI_MM_FILTRO_ACTIVE           as Active      on Active.Docnum = Lin.docnum

    left outer join  j_1bnfe_active                as Active_Tab  on Active_Tab.docnum = Active.Docnum

    left outer join  ZI_MM_CONV_ACTIVE_NFE         as XNFEAux     on  XNFEAux.Regio   = Active.regio
                                                                  and XNFEAux.NFYEAR  = Active.nfyear
                                                                  and XNFEAux.NFMONTH = Active.nfmonth
                                                                  and XNFEAux.STCD1   = Active.stcd1
                                                                  and XNFEAux.MODEL   = Active.model
                                                                  and XNFEAux.NFNUM9  = Active.nfnum9

    left outer join  /xnfe/innfehd                 as XNFE        on XNFE.guid_header = XNFEAux.guid_header

    left outer join  ZI_MM_FILTRO_LIKP_NFE         as Likp        on Likp.inco3_l = XNFE.nfeid

    left outer join  ZI_MM_FILTRO_mseg_armzngm     as Mseg        on  Mseg.VBELN_IM = Likp.Vbeln
                                                                  and Mseg.Cancelad = ''

    left outer join  ZI_MM_CONCAT_MSEG_REFKEY      as _ConcatMseg on  _ConcatMseg.mblnr = Mseg.Mblnr
                                                                  and _ConcatMseg.mjahr = Mseg.Mjahr
                                                                  and _ConcatMseg.zeile = Mseg.Zeile

    left outer join  ZI_MM_FILTRO_LIN_REFKEY_AMRZN as FltrLin     on FltrLin.refkey = _ConcatMseg.REFKEY

    left outer join  j_1bnfdoc                     as DocAux      on DocAux.docnum = FltrLin.docnum

    left outer join  j_1bnfe_active                as ActiveAux   on ActiveAux.docnum = DocAux.docnum

    left outer join  ZI_MM_FILTRO_LIN_ACTIVE       as _FltLin     on  _FltLin.Docnum = Lin.docnum
                                                                  and _FltLin.Itmnum = Lin.itmnum

    left outer join  ZI_MM_FILTRO_NFE_LIFNR        as Lfa1Aux     on Lfa1Aux.stcd1 = XNFE.cnpj_emit

    left outer join  lfa1                                         on lfa1.lifnr = Lfa1Aux.Lifnr

    left outer join  ZI_MM_FILTRO_NFE_KUNNR        as Kna1Aux     on Kna1Aux.stcd1 = XNFE.cnpj_dest

    left outer join  ekko                                         on ekko.ebeln = ekpo.ebeln

    left outer join  makt                                         on  makt.matnr = ekpo.matnr
                                                                  and makt.spras = $session.system_language
                                                                  
    left outer join j_1bsdica                      as _J_1BSDICA  on  _J_1BSDICA.auart = 'DL'
                                                                  and _J_1BSDICA.pstyv = 'LBN'                                                                    
                                                                  and _J_1BSDICA.itmtyp = '32'

//  association [0..1] to ZC_MM_PARAM_XML_TRANSP     as _Param   on  _Param.Transptdr  = $projection.Transptdr
//                                                               and _Param.Incoterms1 = $projection.Incoterms1
//                                                               and _Param.Incoterms2 = $projection.Incoterms2
//                                                               and _Param.TRAID      = $projection.TRAID

  association [0..1] to ZI_MM_EXPEDARMAZ_URL_ESTRN as _URL     on  _URL.Docnum = $projection.Docnum
                                                               and _URL.Itmnum = $projection.Itmnum

  association [0..1] to t001w                      as _T001wsh on  _T001wsh.werks = $projection.Werks

{
  key Lin.docnum            as Docnum,
  key Lin.itmnum            as Itmnum,
      @Consumption.valueHelpDefinition:   [{ entity: {name: 'ZI_CA_VH_WERKS', element: 'WerksCode' } }]
      ekpo.werks            as Werks,
      @Consumption.valueHelpDefinition:   [{ entity: {name: 'ZI_CA_VH_LIFNR', element: 'LifnrCode' } }]
      Active_Tab.parid      as Parid,
      @Consumption.valueHelpDefinition:   [{ entity: {name: 'ZI_CA_VH_MATERIAL', element: 'Material' } }]
      Lin.matnr             as Matnr,
      makt.maktx            as Maktx,
      @Semantics.quantity.unitOfMeasure: 'Meins'
      Lin.menge             as Menge,
      Lin.meins             as Meins,
      Lin.charg             as Charg,
      @Consumption.valueHelpDefinition:   [{ entity: {name: 'ZI_CA_VH_LIFNR', element: 'LifnrCode' } }]
      ekpo.emlif            as Emlif,
      lfa1.name1            as NameFornc,

      case when ActiveAux.cancel is initial
      then Likp.Vbeln
      else '0000000000' end as Vbeln,

      @Consumption.valueHelpDefinition:   [{ entity: {name: 'ZI_MM_VH_EXPEDIN_STATUS', element: 'Status' } }]
      case 
      when Likp.Vbeln is initial
           then 'Pendente'
      when ( ActiveAux.action_requ = 'C' and ActiveAux.cancel <> 'X' )
           then 'Concluído'
      when ActiveAux.action_requ <> 'C' and ActiveAux.cancel <> 'X'
           then 'Verificar NF-e'
      else 'Pendente' end   as Status,

      case 
      when Likp.Vbeln is initial
           then 2
      when ( ActiveAux.action_requ = 'C' and ActiveAux.cancel <> 'X' )
           then 3
      when ActiveAux.action_requ <> 'C' and ActiveAux.cancel <> 'X'
           then 1
      else 2 end            as StatusCriticality,

      @Consumption.valueHelpDefinition:   [{ entity: {name: 'ZI_MM_VH_ARMZ_XML', element: 'XML_EntIns' } }]
      @EndUserText.label: 'XML Entrada do Insumo'
      case when Likp.inco3_l is not initial
      then Likp.inco3_l
      else XNFE.nfeid  end  as XML_EntIns,

      Mseg.Mblnr            as Mblnr,

      case when ActiveAux.cancel is initial and Likp.inco3_l is not initial
      then DocAux.docnum
      else '0000000000' end as DocDocnum,

      @EndUserText.label: 'Data da Emissão'
      case when ActiveAux.cancel is initial and Likp.inco3_l is not initial
      then DocAux.pstdat
      else '00000000' end   as DocPSTDAT,

      @EndUserText.label: 'NF-e'
      @Consumption.valueHelpDefinition:   [{ entity: {name: 'ZI_MM_VH_ARMZ_NFE', element: 'DocNFENUM' } }]
      case when ActiveAux.cancel is initial and Likp.inco3_l is not initial
      then DocAux.nfenum
      else '' end           as DocNFENUM,

      @EndUserText.label: 'Transportadora'
      @Consumption.valueHelpDefinition:   [{ entity: {name: 'ZI_CA_VH_LIFNR', element: 'LifnrCode' } }]
      ''                    as Transptdr,
      @EndUserText.label: 'Incoterms 1'
      ''                    as Incoterms1,
      @EndUserText.label: 'Incoterms 2'
      ''                    as Incoterms2,
      @EndUserText.label: 'Placa'
      ''                    as TRAID,
      @EndUserText.label: 'Código de imposto SD Padrão'
      @Consumption.valueHelpDefinition:   [{ entity: {name: 'ZI_MM_VH_TXSDC', element: 'taxcode' } }]
      _J_1BSDICA.txsdc,
//      _Param,
      _URL,
      _T001wsh
}
where
      Lin.docnum is not initial
  and Lin.itmnum is not initial
