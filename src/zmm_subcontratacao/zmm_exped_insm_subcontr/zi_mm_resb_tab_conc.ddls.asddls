@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Filtro Exped. Insumos Subcontrat Conc'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_MM_RESB_TAB_CONC
  as select from    zi_mm_resb_tab         as _Resb_Tab

    left outer join resb                   as _Resb on  _Resb.rsnum = _Resb_Tab.Rsnum
                                                    and _Resb.rspos = _Resb_Tab.Rspos

    left outer join ZI_MM_RESB_STATUS_PROC as Proc  on  Proc.Rsnum  = _Resb_Tab.Rsnum
                                                    and Proc.Rspos  = _Resb_Tab.Rspos
                                                    and Proc.Status = 'Concluído'
{
  key _Resb_Tab.Rsnum,
  key _Resb_Tab.Rspos,
  key _Resb_Tab.Item,

      case when Proc.Quantidade is not null
             then _Resb_Tab.Quantidade - Proc.Quantidade
             else _Resb_Tab.Quantidade end as Qtd_Pen
}
