@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'teste'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity zi_valida 
  as select from    /xnfe/innfehd          as _ehd

    inner join      ZI_MM_FILTRO_ITEMS_GV  as _eit  on _ehd.guid_header = _eit.GuidHeader
    inner join      /xnfe/innfeit          as _eit2 on _eit.GuidHeader  = _eit2.guid_header
   inner join      ZI_MM_FILTRO_LIFNR_GV  as _lif  on _ehd.cnpj_emit = _lif.Stcd1
       inner join      ZI_MM_FILTRO_KUNNR_GV  as _kun  on _ehd.cnpj_dest = _kun.Stcd1
    inner join      ZI_MM_FILTRO_WERKS_GV  as _wer  on _kun.Kunnr = _wer.Kunnr
    inner join      ZI_MM_FILTRO_DEMI_GV   as _dem  on _ehd.guid_header = _dem.GuidHeader
        inner join j_1bnfe_active         as _act  on  _dem.NFYEAR    = _act.nfyear
                                                   and _dem.NFMONTH   = _act.nfmonth
                                                   and _ehd.cnpj_emit = _act.stcd1
                                                   and _ehd.mod       = _act.model
                                                   and _ehd.nnf       = _act.nfnum9
   left outer join     ZI_MM_AGRUPA_JFLIN              as _fli on _act.docnum = _fli.docnum
 //     inner join      ZI_MM_FILTRO_REFKEY_GV as _ref on  _fli.docnum = _ref.Docnum
//                                                   and _fli.itmnum = _ref.Itmnum
{
    key _ehd.guid_header
}
