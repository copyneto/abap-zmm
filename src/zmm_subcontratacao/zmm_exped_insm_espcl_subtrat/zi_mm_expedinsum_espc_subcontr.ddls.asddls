@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Exped.Insumos-Especial - Subcontratação'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZI_MM_EXPEDINSUM_ESPC_SUBCONTR
  as select from ZI_MM_EXPEDINSUM_SUBC_UNION as Subc
    left outer join j_1bsdica                   as _J_1BSDICA on  _J_1BSDICA.auart  = 'DL'
                                                              and _J_1BSDICA.pstyv  = 'LBN'
                                                              and _J_1BSDICA.itmtyp = '32'
                                                              
  association [0..1] to makt                       as _Makt    on  _Makt.matnr = $projection.Matnr
                                                               and _Makt.spras = $session.system_language
  association [0..1] to t001w                      as _T001wsh on  _T001wsh.werks = $projection.Werks

  association [0..1] to ZI_MM_EXPEDINSUM_URL_ESTRN as _URL     on  _URL.Rsnum = $projection.Rsnum
                                                               and _URL.Rspos = $projection.Rspos
                                                               and _URL.Vbeln = $projection.Vbeln
                                                               
{

  key Subc.Rsnum                          as Rsnum,
  key Subc.Rspos                          as Rspos,
  key cast(Subc.Vbeln as abap.char( 10 )) as Vbeln,
      Subc.Bdart                          as Bdart,
      @Consumption.valueHelpDefinition:   [{ entity: {name: 'ZI_CA_VH_WERKS', element: 'WerksCode' } }]
      Subc.Werks                          as Werks,
      @Consumption.valueHelpDefinition:   [{ entity: {name: 'ZI_MM_VH_EXPEDIN_MATNR', element: 'Matnr' } }]
      Subc.Matnr                          as Matnr,
      @EndUserText.label: 'Pedido'
      @Consumption.valueHelpDefinition:   [{ entity: {name: 'ZI_MM_VH_EXPEDIN_PED', element: 'Ebeln' } }]
      Subc.Ebeln                          as Ebeln,
      Subc.Ebelp                          as Ebelp,
      @EndUserText.label: 'Data da Necessidade'
      Subc.Bdter                          as Bdter,
      @Consumption.valueHelpDefinition:   [{ entity: {name: 'ZI_MM_VH_EXPEDIN_FORNEC', element: 'Lifnr' } }]
      Subc.Lifnr                          as Lifnr,
      Subc.Meins                          as Meins,
      Subc.DescFornec                     as DescFornec,
      @Consumption.valueHelpDefinition:   [{ entity: {name: 'ZI_MM_VH_EXPEDIN_STATUS', element: 'Status' } }]
      Subc.Status                         as Status,
      Subc.StatusCriticality              as StatusCriticality,
      @EndUserText.label: 'XML Entrada do Insumo'
      @Consumption.valueHelpDefinition:   [{ entity: {name: 'ZI_MM_VH_EXPEDIN_XML_ENTR', element: 'XmlEntrad' } }]
      Subc.XmlEntrad                      as XmlEntrad,
      Subc.Mblnr                          as Mblnr,
      Subc.Docnum                         as Docnum,
      @EndUserText.label: 'Data da Emissão'
      Subc.Pstdat                         as Pstdat,
      @Consumption.valueHelpDefinition:   [{ entity: {name: 'ZI_MM_VH_EXPEDIN_NFE', element: 'Nfenum' } }]
      @EndUserText.label: 'NF-e'
      Subc.Nfenum                         as Nfenum,
      Subc.Quantidade                     as Quantidade,
      @EndUserText.label: 'XML de Entrada de Insumo'
      Subc.XML_Transp                     as XML_Transp,
      @EndUserText.label: 'Transportadora'
      @Consumption.valueHelpDefinition:   [{ entity: {name: 'ZI_CA_VH_LIFNR', element: 'LifnrCode' } }]
      Subc.Transptdr                      as Transptdr,
      @EndUserText.label: 'Incoterms 1'
      Subc.Incoterms1                     as Incoterms1,
      @EndUserText.label: 'Incoterms 2'
      Subc.Incoterms2                     as Incoterms2,
      @EndUserText.label: 'Placa'
      Subc.TRAID                          as TRAID,
      @EndUserText.label: 'Código de imposto SD Padrão'
      @Consumption.valueHelpDefinition:   [{ entity: {name: 'ZI_MM_VH_TXSDC', element: 'taxcode' } }]
      _J_1BSDICA.txsdc,
      
      //  key resb.rsnum                                      as Rsnum,
      //  key resb.rspos                                      as Rspos,
      //      resb.bdart                                      as Bdart,
      //      @Consumption.valueHelpDefinition:   [{ entity: {name: 'ZI_CA_VH_WERKS', element: 'WerksCode' } }]
      //      resb.werks                                      as Werks,
      //      @Consumption.valueHelpDefinition:   [{ entity: {name: 'ZI_MM_VH_EXPEDIN_MATNR', element: 'Matnr' } }]
      //      resb.matnr                                      as Matnr,
      //      @EndUserText.label: 'Pedido'
      //      @Consumption.valueHelpDefinition:   [{ entity: {name: 'ZI_MM_VH_EXPEDIN_PED', element: 'Ebeln' } }]
      //      resb.ebeln                                      as Ebeln,
      //      resb.ebelp                                      as Ebelp,
      //      resb.bdter                                      as Bdter,
      //      @Consumption.valueHelpDefinition:   [{ entity: {name: 'ZI_MM_VH_EXPEDIN_FORNEC', element: 'Lifnr' } }]
      //      resb.lifnr                                      as Lifnr,
      //      //      @Semantics.quantity.unitOfMeasure: 'Meins'
      //      //      resb.bdmng                                      as Menge,
      //      resb.meins                                      as Meins,
      //      _Lfa1.name1                                     as DescFornec,
      //      //*****************************************************
      //      @Consumption.valueHelpDefinition:   [{ entity: {name: 'ZI_MM_VH_EXPEDIN_STATUS', element: 'Status' } }]
      //      case
      //      when _Lips.Vbeln is null
      //        or _Rems.sh_Found is null
      //        or _Active.cancel = 'X'
      //        or ( _LipsCalc.Vgbel is not null and _LipsCalc.LFIMG < resb.bdmng )
      //       then 'Pendente'
      //      when _Rems.sh_Found = 'X' or ( _Active.action_requ = 'C' and _Active.cancel <> 'X' )
      //      then 'Concluído'
      //      when _Active.action_requ <> 'C' and _Active.cancel <> 'X'
      //      then 'Verificar NF-e'
      //      else 'Pendente'
      //      end                                             as Status,
      //
      //      // Criticalidade
      //      case
      //      when _Lips.Vbeln is null
      //        or _Rems.sh_Found is null
      //        or _Active.cancel = 'X'
      //        or ( _LipsCalc.Vgbel is not initial and _LipsCalc.LFIMG < resb.bdmng )
      //       then 2
      //      when _Rems.sh_Found = 'X' or ( _Active.action_requ = 'C' and _Active.cancel <> 'X' )
      //      then 3
      //      when _Active.action_requ <> 'C' and _Active.cancel <> 'X'
      //      then 1
      //      else 2
      //      end                                             as StatusCriticality,
      //
      //      case
      //      when _Active.cancel = 'X' and _Rems.sh_Found is not null
      //        or _LipsCalc.LFIMG > resb.bdmng
      //      then ''
      //      else  _Lips.Vbeln end                           as Vbeln,
      //
      //      @EndUserText.label: 'XML Entrada do Insumo'
      //      @Consumption.valueHelpDefinition:   [{ entity: {name: 'ZI_MM_VH_EXPEDIN_XML_ENTR', element: 'XmlEntrad' } }]
      //      case
      //      when _Active.cancel = 'X' and _Rems.sh_Found is not initial
      //        or _LipsCalc.LFIMG > resb.bdmng
      //      then ''
      //      else  _Lips.XML end                             as XmlEntrad,
      //
      //      case
      //      when _Active.cancel = 'X' and _Rems.sh_Found is not initial
      //        or _LipsCalc.LFIMG > resb.bdmng
      //      then ''
      //      else  _Mseg.Mblnr end                           as Mblnr,
      //
      //      case
      //      when _Rems.sh_Found = 'X' or _Active.cancel = 'X' or _Rems.sh_Found is not initial
      //        or ( _Active.action_requ <> 'C' and _Active.cancel <> 'X' )
      //        or _LipsCalc.LFIMG > resb.bdmng
      //      then '0000000000'
      //      else _Doc.docnum end                            as Docnum,
      //
      //      case
      //      when _Rems.sh_Found = 'X' or _Active.cancel = 'X' or _Rems.sh_Found is not initial
      //        or ( _Active.action_requ <> 'C' and _Active.cancel <> 'X' )
      //        or _LipsCalc.LFIMG > resb.bdmng
      //      then '00000000'
      //      else _Doc.pstdat end                            as Pstdat,
      //
      //      @Consumption.valueHelpDefinition:   [{ entity: {name: 'ZI_MM_VH_EXPEDIN_NFE', element: 'Nfenum' } }]
      //      case
      //      when _Rems.sh_Found = 'X' or _Active.cancel = 'X' or _Rems.sh_Found is not initial
      //        or ( _Active.action_requ <> 'C' and _Active.cancel <> 'X' )
      //        or _LipsCalc.LFIMG > resb.bdmng
      //      then ''
      //      else _Doc.nfenum end                            as Nfenum,
      //
      //      case
      //      when _Rems.sh_Found = 'X' or _Active.cancel = 'X' or _Rems.sh_Found is not initial
      //        or ( _Active.action_requ <> 'C' and _Active.cancel <> 'X' )
      //      then 000
      //      when _LipsCalc.LFIMG < resb.bdmng
      //      then cast(resb.bdmng as abap.dec( 13, 3 ) ) - cast(_LipsCalc.LFIMG as abap.dec( 13, 3 ) )
      //      else cast(resb.bdmng as abap.dec( 13, 3 ) ) end as Quantidade,
      //
      //      // Virtuais
      //      @EndUserText.label: 'XML de Entrada de Insumo'
      //      ''                                              as XML_Transp,
      //      @EndUserText.label: 'Transportadora'
      //      @Consumption.valueHelpDefinition:   [{ entity: {name: 'ZI_CA_VH_LIFNR', element: 'LifnrCode' } }]
      //      ''                                              as Transptdr,
      //      @EndUserText.label: 'Incoterms 1'
      //      ''                                              as Incoterms1,
      //      @EndUserText.label: 'Incoterms 2'
      //      ''                                              as Incoterms2,
      //      @EndUserText.label: 'Placa'
      //      ''                                              as TRAID,

      _Makt,
      _T001wsh,
      _URL

}
