@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'CDS Local e Centro Destino'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_MM_LC_DEST 
as select from I_BR_NFItem as _NFItem
join I_MaterialDocumentItem as _MatDocIte on   _MatDocIte.MaterialDocument      = substring(_NFItem.BR_NFSourceDocumentNumber, 1, 10) and 
                                               _MatDocIte.MaterialDocumentYear  = substring(_NFItem.BR_NFSourceDocumentNumber, 11, 14) and 
                                               _MatDocIte.DebitCreditCode       = 'H' 
{
    key _NFItem.BR_NotaFiscal,
    key _NFItem.BR_NotaFiscalItem,    
    _MatDocIte.IssuingOrReceivingPlant 
}

where
    _NFItem.BR_NFSourceDocumentType = 'MD'
group by
    _NFItem.BR_NotaFiscal,        
    _NFItem.BR_NotaFiscalItem,
    _MatDocIte.IssuingOrReceivingPlant
