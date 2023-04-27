@AbapCatalog.sqlViewName: 'ZVMM_ESPSUBC_UNN'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Union Exped. Insumos Especiais-Subcont.'
define view ZI_MM_EXPEDINSUM_SUBC_UNION
  as select from ZI_MM_EXPEDINSUM_SUBC_PENDT
{
  key Rsnum,
  key Rspos,
  key Vbeln,
      Bdart,
      Werks,
      Matnr,
      Ebeln,
      Ebelp,
      Bdter,
      Lifnr,
      Meins,
      DescFornec,
      Status,
      StatusCriticality,
      XmlEntrad,
      Mblnr,
      Docnum,
      Pstdat,
      Nfenum,
      Quantidade,
      XML_Transp,
      Transptdr,
      Incoterms1,
      Incoterms2,
      TRAID
}
where
  Quantidade > 0

union

select from ZI_MM_EXPEDINSUM_SUBC_PROC
{
  key Rsnum,
  key Rspos,
  key Vbeln,
      Bdart,
      Werks,
      Matnr,
      Ebeln,
      Ebelp,
      Bdter,
      Lifnr,
      Meins,
      DescFornec,
      Status,
      StatusCriticality,
      XmlEntrad,
      Mblnr,
      Docnum,
      Pstdat,
      Nfenum,
      Quantidade,
      XML_Transp,
      Transptdr,
      Incoterms1,
      Incoterms2,
      TRAID
}
where
  Status <> 'Pendente'
