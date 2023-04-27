@AbapCatalog.sqlViewName: 'ZVMM_NF_FATURADA'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: '3Collaboration - NF Faturada (NFE e CTE)'
define view ZI_MM_3C_NF_FATURADA_U
  as select from ZI_MM_3C_NF_FAT_NFE_CFOP
{
  //key cast('0000000000' as logbr_docnum ) as BR_NotaFiscal,
  key NumNF as NumRegistro,
  key Doctype,
  key Guid,
      AccessKey,
      Cfop,
      TpEvento,
      Filename,
      DtDocumento,
      CNPJEmissor,
      NomeEmissor,
      CNPJDestinatario,
      NomeDestinatario
}
union select from ZI_MM_3C_NF_FAT_NFE_EVENT
{
  //key cast('0000000000' as logbr_docnum ) as BR_NotaFiscal,
  key NumNF as NumRegistro,
  key Doctype,
  key Guid,
      AccessKey,
      Cfop,
      TpEvento,
      Filename,
      DtDocumento,
      CNPJEmissor,
      NomeEmissor,
      CNPJDestinatario,
      NomeDestinatario      
}
union select from ZI_MM_3C_NF_FAT_CTE_CFOP
{  
  //key cast('0000000000' as logbr_docnum ) as BR_NotaFiscal,
  key NumCTe as NumRegistro,
  key Doctype,
  key Guid,
      AccessKey,
      Cfop,
      TpEvento,
      Filename,
      DtDocumento,
      CNPJEmissor,
      NomeEmissor,
      CNPJDestinatario,
      NomeDestinatario      
}
union select from ZI_MM_3C_NF_FAT_CTE_EVENT
{
  //key cast('0000000000' as logbr_docnum ) as BR_NotaFiscal,
  key NumCTe as NumRegistro,
  key Doctype,
  key Guid,
      AccessKey,
      Cfop,
      TpEvento,
      Filename,
      DtDocumento,
      CNPJEmissor,
      NomeEmissor,
      CNPJDestinatario,
      NomeDestinatario      
}
