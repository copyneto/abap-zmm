@AbapCatalog.sqlViewName: 'ZIMMALIVIUM'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Fluxo de Documentos Projeto Alivium'
define view ZI_MM_ALIVIUM
  as select from    ztmm_alivium as _Alivium
    left outer join bkpf         as _Bkpf on  _Alivium.bukrs = _Bkpf.bukrs
                                          and _Alivium.belnr = _Bkpf.belnr
                                          and _Alivium.gjahr = _Bkpf.gjahr
{
  key  _Alivium.iblnr          as Iblnr,
  key  _Alivium.gjahr          as Gjahr,
  key  _Alivium.bukrs          as Bukrs,
  key  _Alivium.mblnr          as Mblnr,
       _Alivium.docnum_entrada as DocnumEntrada,
       _Alivium.docnum_saida   as DocnumSaida,
       _Alivium.belnr          as Belnr,
       _Bkpf.stblg             as Belnr_estorn,

       case
         when _Bkpf.stblg is not initial
           then '-1' //'sap-icon://undo' // Estornado
         when _Alivium.belnr is not initial and _Bkpf.stblg is initial 
           then '0' // Contábil criado
         else
           ''
       end                     as Status_belnr,

       _Alivium.last_changed_at,
       _Alivium.last_changed_by,
       _Alivium.created_at,
       _Alivium.created_by,
       _Alivium.local_last_changed_at
}
where
  (
        _Alivium.docnum_entrada is not initial
    and _Alivium.docnum_saida   is not initial
  )
  or    _Alivium.docnum_entrada is initial
  or    _Alivium.docnum_saida   is initial
  or    _Alivium.mblnr          is initial
  or    _Alivium.belnr          is initial;
