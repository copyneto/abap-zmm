@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'CDS UNITARIO'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}

define view entity ZI_MM_INVENTARIO_ITEM_UNICO 
as select from ZI_MM_INVENTARIO_ITEM
{
    key Documentid as Documentid,
    max(Material) as Material,
    max(NumNF )   as Nf
    
}
group by Documentid
