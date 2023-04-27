@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Exped. Insumos Especiais - Subc. Proc.'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_MM_EXPEDINSUM_SUBC_PROC
  as select from     resb

    right outer join lfa1                   as Lfa1     on lfa1.lifnr = resb.lifnr
    inner join       I_PurchaseOrderItem    as _POItem  on  _POItem.PurchaseOrder                  = resb.ebeln
                                                        and _POItem.PurchaseOrderItem              = resb.ebelp
                                                        and _POItem.PurchasingDocumentDeletionCode = ''
    
    inner join       ZI_MM_EXPED_FILTR_LIPS as Lips     on  Lips.vgbel = resb.ebeln
                                                        and Lips.vgpos = resb.ebelp
                                                        and Lips.Matnr = resb.matnr

    left outer join  ZI_MM_FILTRO_MSEG_CALC as Mseg     on  Mseg.Ebeln    = Lips.vgbel
                                                        and Mseg.Ebelp    = Lips.vgpos
                                                        and Mseg.VBELN_IM = Lips.Vbeln
                                                        and Mseg.VBELP_IM = Lips.Posnr
                                                        and Mseg.Cancelad = ''

    left outer join  j_1bnflin              as Lin      on  Lin.refkey   = Mseg.refkey
    //                                                        and Lin.refitm   = '000001'
                                                        and Lin.reftyp   = 'MD'
                                                        and Lin.xped     = Mseg.Ebeln
//                                                        and Lin.nitemped = Mseg.Ebelp 
                                                        and Lin.matnr    = resb.matnr


    left outer join  j_1bnfdoc              as Doc      on Doc.docnum = Lin.docnum

    left outer join  j_1bnfe_active         as Active   on Active.docnum = Doc.docnum

    left outer join  t001w                  as T001W    on t001w.werks = resb.werks

    left outer join  ZI_MM_FILTRO_SHIPPING  as Rems     on  Rems.Shipfrom = t001w.regio
                                                        and Rems.Shipto   = lfa1.regio

    left outer join  ZI_MM_FILTRO_VAL_LIPS  as LipsCalc on  LipsCalc.Vgbel = resb.ebeln
                                                        and LipsCalc.vGpos = resb.ebelp
                                                        and LipsCalc.Matnr = resb.matnr

{

  key resb.rsnum                                 as Rsnum,
  key resb.rspos                                 as Rspos,
  key Lips.Vbeln                                 as Vbeln,
      resb.bdart                                 as Bdart,
      resb.werks                                 as Werks,
      resb.matnr                                 as Matnr,
      resb.ebeln                                 as Ebeln,
      resb.ebelp                                 as Ebelp,
      resb.bdter                                 as Bdter,
      resb.lifnr                                 as Lifnr,
      resb.meins                                 as Meins,
      lfa1.name1                                 as DescFornec,

      case
      when Mseg.Mblnr is not initial and ( Doc.docnum is initial or Doc.docnum is null )
           then 'Concluído'
      when Rems.sh_Found = 'X' or ( Active.action_requ = 'C' and Active.cancel <> 'X' )
           then 'Concluído'
      when Lips.Vbeln is not initial and Doc.docnum is null
           then 'Verificar Remessa'
      when Active.action_requ <> 'C' and Active.cancel <> 'X'
           then 'Verificar NF-e'
      else 'Pendente' end                        as Status,

      // Criticalidade
      case
      when Mseg.Mblnr is not initial and ( Doc.docnum is initial or Doc.docnum is null )
           then 3
      when Rems.sh_Found = 'X' or ( Active.action_requ = 'C' and Active.cancel <> 'X' )
           then 3
      when Lips.Vbeln is not initial and Doc.docnum is null
           then 1
      when Active.action_requ <> 'C' and Active.cancel <> 'X'
           then 1
      else 2 end                                 as StatusCriticality,

      //      concat( Active.regio,
      //      concat( Active.nfyear,
      //      concat( Active.nfmonth,
      //      concat( Active.stcd1,
      //      concat( Active.model,
      //      concat( Active.serie,
      //      concat( Active.nfnum9,
      //      concat( Active.docnum9, Active.cdv )
      //      ) ) ) ) ) ) )                              as XmlEntrad,

      //Active.regio
      //Active.nfyear
      //Active.nfmonth
      //Active.stcd1
      //Active.model
      //Active.serie
      //Active.nfnum9
      //Active.docnum9
      //Active.cdv
      Lips.XML                                   as XmlEntrad,
      Mseg.Mblnr                                 as Mblnr,
      Doc.docnum                                 as Docnum,
      Doc.pstdat                                 as Pstdat,
      Doc.nfenum                                 as Nfenum,

      //      case
      //      when LipsCalc.LFIMG < resb.bdmng
      //      then cast(resb.bdmng as abap.dec( 13, 3 ) ) - cast(LipsCalc.LFIMG as abap.dec( 13, 3 ) )
      //      else cast(resb.bdmng as abap.dec( 13, 3 ) ) end as Quantidade,
      cast(LipsCalc.LFIMG as abap.dec( 13, 3 ) ) as Quantidade,

      // Virtuais
      ''                                         as XML_Transp,
      ''                                         as Transptdr,
      ''                                         as Incoterms1,
      ''                                         as Incoterms2,
      ''                                         as TRAID
}
where
      resb.bdart = 'BB'
  and resb.ebeln is not initial
