@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Exped. Insumos - Subcontratação'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_MM_RESB_STATUS_PROC
  as select from    resb

    inner join      lfa1                              on lfa1.lifnr = resb.lifnr

    inner join      ZI_MM_FILTRO_LIPS_SUBCTRT as Lips on  Lips.vgbel = resb.ebeln
                                                      and Lips.vgpos = resb.ebelp
                                                      and Lips.Matnr = resb.matnr

    left outer join ZI_MM_FILTRO_MSEG_CALC    as Mseg    on  Mseg.Ebeln    = Lips.vgbel
                                                         and Mseg.Ebelp    = Lips.vgpos
                                                         and Mseg.VBELN_IM = Lips.Vbeln
                                                         and Mseg.VBELP_IM = Lips.Vbelp
                                                         and Mseg.Cancelad = ''

    left outer join j_1bnflin                 as Lin                  on  Lin.refkey   = Mseg.refkey
                                                                      and Lin.refitm   = '000001'
                                                                      and Lin.reftyp   = 'MD'
                                                                      and Lin.xped     = Mseg.Ebeln
                                                                      and ( Lin.nitemped = Mseg.Ebelp or 
                                                                            Lin.nitemped = concat( '00', substring( Mseg.Ebelp, 1, 4 ) ) )
    left outer join j_1bnfdoc                 as Doc                  on Doc.docnum = Lin.docnum

    left outer join j_1bnfe_active            as Active          on Active.docnum = Doc.docnum

{
  key resb.rsnum                                     as Rsnum,
  key resb.rspos                                     as Rspos,
  key Lips.Vbeln                                     as Vbeln,
      resb.ebeln                                     as Ebeln,
      resb.ebelp                                     as Ebelp,
      resb.bdter                                     as BDTER,
      resb.werks                                     as Werks,
      resb.lifnr                                     as Lifnr,
      lfa1.name1                                     as DescForn,
      resb.matnr                                     as Matnr,
      resb.meins                                     as Meins,
      resb.charg                                     as Charg,
      cast(Lips.LFIMG as abap.dec( 13, 3 ))          as Picking,

      // Caso modifique os status, ajustar no domínio ZD_SUBCT_STATUS - Search Help
      case
      when Mseg.Mblnr is not initial and ( Doc.docnum is initial or Doc.docnum is null )
           then 'Concluído'
      when Lips.Vbeln is not initial and Doc.docnum is null
           then 'Verificar Remessa'
      when Active.action_requ = 'C' and Active.cancel <> 'X'
           then 'Concluído'
      when Active.action_requ <> 'C' and Active.cancel <> 'X'
           then 'Verificar NF-e'
      else 'PENDENTE' end                            as Status,

      case
      when Mseg.Mblnr is not initial and ( Doc.docnum is initial or Doc.docnum is null )
           then 3
      when Lips.Vbeln is not initial and Doc.docnum is null
           then 1
      when Active.action_requ = 'C' and Active.cancel <> 'X'
           then 3
      when Active.action_requ <> 'C' and Active.cancel <> 'X'
           then 1
      else 2 end                                     as StatusCriticality,

      Mseg.Mblnr                                     as Mblnr,
      Doc.docnum                                     as BR_NotaFiscal,
      Doc.pstdat                                     as PSTDAT,
      Doc.nfenum                                     as NFENUM,

      case
      when Mseg.Mblnr is not null
           then cast(Lips.LFIMG as abap.dec( 13, 3 ))
      when Lips.LFIMG < resb.bdmng
           then cast(resb.bdmng as abap.dec( 13, 3 )) - cast(Lips.LFIMG as abap.dec( 13, 3 ))
      else cast(resb.bdmng as abap.dec( 13, 3 )) end as Quantidade,

      ''                                             as Transptdr,
      ''                                             as Incoterms1,
      ''                                             as Incoterms2,
      ''                                             as TRAID

}
where
      resb.bdart = 'BB'
  and resb.ebeln is not initial
  and Lips.Vbeln is not initial
