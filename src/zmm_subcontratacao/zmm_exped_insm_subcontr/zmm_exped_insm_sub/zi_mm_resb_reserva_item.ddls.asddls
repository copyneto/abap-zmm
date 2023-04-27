@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Item Reserva - RESB'
@Metadata.ignorePropagatedAnnotations: true
//@ObjectModel.usageType:{
//  serviceQuality: #X,
//  sizeCategory: #S,
//  dataClass: #MIXED
//}
define view entity zi_mm_resb_reserva_item
  as select from    zi_mm_resb_reserva_item_union as _ItemUnion
    left outer join j_1bsdica                     as _J_1BSDICA on  _J_1BSDICA.auart  = 'DL'
                                                                and _J_1BSDICA.pstyv  = 'LBN'
                                                                and _J_1BSDICA.itmtyp = '32'
    left outer join resb                          as _Resb      on  _Resb.rsnum = _ItemUnion.Rsnum
                                                                and _Resb.rspos = _ItemUnion.Rspos
  association to parent zi_mm_rkpf_reserva as _Header on _Header.Rsnum = $projection.Rsnum
//  association [0..1] to ZI_MM_VH_TXSDC      as _VHTxsdc on _VHTxsdc.taxcode = $projection.txsdc
association [0..1] to ZI_MM_VH_ARMZ_TXSDC  as _VHTxsdc on _VHTxsdc.taxcode = $projection.TXSDC

{
  key _ItemUnion.Rsnum,
  key _ItemUnion.Rspos,
  key _ItemUnion.Item,
      _ItemUnion.Charg,
      _ItemUnion.Matnr,
      _ItemUnion.Werks,
      _ItemUnion.Lgort,
      _ItemUnion.Quantidade,
      _ItemUnion.QtdePicking,
      _ItemUnion.Meins,
      _ItemUnion.Bwtar,
      case
        when _ItemUnion.Quantidade = _ItemUnion.QtdePicking
        then 'Concluído'
        else 'Pendente'
      end as Status,
      case
        when _ItemUnion.Quantidade = _ItemUnion.QtdePicking
        then 3
        else 2
      end as StatusCriticality,
      @Consumption.valueHelpDefinition:   [{ entity: {name: 'ZI_CA_VH_LIFNR', element: 'LifnrCode' } }]
      @EndUserText.label: 'Transportadora'
      ''  as Transptdr,
      @Consumption.valueHelpDefinition:   [{ entity: {name: 'ZI_CA_VH_INCO1_VIEW', element: 'inco1' } }]
      @EndUserText.label: 'Incoterms 1'
      ''  as Incoterms1,
      @EndUserText.label: 'Incoterms 2'
      ''  as Incoterms2,
      @EndUserText.label: 'Placa'
      ''  as TRAID,
      @EndUserText.label: 'Código de imposto SD Padrão'
      @Consumption.valueHelpDefinition:   [{ entity: {name: 'ZI_MM_VH_TXSDC', element: 'taxcode' } }]
      _J_1BSDICA.txsdc as TXSDC,
      _Resb.ebeln as Ebeln,
      _Resb.ebelp as Ebelp,
      _Header,
      _VHTxsdc


}
