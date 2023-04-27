@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'CDS Filtro para tabela /XNFE/INNFEIT'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_MM_FILTRO_INNFEIT 
as select from /xnfe/innfeit as _ItemNF
left outer join ekpo as _ItemPedido on _ItemPedido.ebeln =  _ItemNF.ponumber
                                   and _ItemPedido.ebelp =  _ItemNF.poitem 
{
    key _ItemNF.guid_header as GuidHeader,
    _ItemNF.cfop as Cfop,
    _ItemPedido.werks
}
group by _ItemNF.guid_header,  _ItemNF.cfop, _ItemPedido.werks
