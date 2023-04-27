@AbapCatalog.sqlViewName: 'ZIMMINVNFDOC'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Notas Fiscais - Alivium'
define view ZI_MM_ALIVIUM_NFEDOC
  as select from j_1bnfdoc      as _Doc
    inner join   j_1bnflin      as _Item   on _Doc.docnum = _Item.docnum
    inner join   j_1bnfe_active as _Active on _Doc.docnum = _Active.docnum
{
  key _Doc.docnum,
      _Doc.nfenum,
      _Doc.docstat,
      _Item.cfop,
     cast( 
      case substring(cfop, 1, 1) 
          when '1'
           then '1'
          when '2'
           then '1'
          when '3'
           then '1'
          else
                '2'
      end as j_1bdirect ) as direct,
      
      _Active.code,
      _Active.cancel,
      _Active.action_requ
}
//where _Active.code <> '100'
