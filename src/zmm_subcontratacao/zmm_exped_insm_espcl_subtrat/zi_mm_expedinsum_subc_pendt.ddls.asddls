@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Exped. Especiais - Subc. Pendente'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_MM_EXPEDINSUM_SUBC_PENDT
  as select from     resb

    right outer join lfa1                  as _Lfa1     on _Lfa1.lifnr = resb.lifnr
    inner join       I_PurchaseOrderItem   as _POItem   on  _POItem.PurchaseOrder                  = resb.ebeln
                                                        and _POItem.PurchaseOrderItem              = resb.ebelp
                                                        and _POItem.PurchasingDocumentDeletionCode = ''

    left outer join  ZI_MM_FILTRO_VAL_LIPS as _LipsCalc on  _LipsCalc.Vgbel = resb.ebeln
                                                        and _LipsCalc.vGpos = resb.ebelp
                                                        and _LipsCalc.Matnr = resb.matnr

{

  key resb.rsnum                                     as Rsnum,
  key resb.rspos                                     as Rspos,
  key cast('' as abap.char( 10 ))                    as Vbeln,
      resb.bdart                                     as Bdart,
      resb.werks                                     as Werks,
      resb.matnr                                     as Matnr,
      resb.ebeln                                     as Ebeln,
      resb.ebelp                                     as Ebelp,
      resb.bdter                                     as Bdter,
      resb.lifnr                                     as Lifnr,
      resb.meins                                     as Meins,
      _Lfa1.name1                                    as DescFornec,
      cast('Pendente' as abap.char( 17 ))            as Status,
      2                                              as StatusCriticality,
      cast('' as abap.char( 70 ))                    as XmlEntrad,
      cast('' as abap.char( 10 ))                    as Mblnr,
      cast('' as abap.numc( 10 ))                    as Docnum,
      cast('00000000' as abap.dats)                  as Pstdat,
      cast(''  as abap.char( 9 ))                    as Nfenum,

      case
      when _LipsCalc.LFIMG is not null
           then cast(resb.erfmg as abap.dec( 13, 3 )) - cast(_LipsCalc.LFIMG as abap.dec( 13, 3 ))
      else cast(resb.erfmg as abap.dec( 13, 3 )) end as Quantidade,

      // Virtuais
      ''                                             as XML_Transp,
      ''                                             as Transptdr,
      ''                                             as Incoterms1,
      ''                                             as Incoterms2,
      ''                                             as TRAID

}
where
      resb.bdart = 'BB'
  and resb.ebeln is not initial
