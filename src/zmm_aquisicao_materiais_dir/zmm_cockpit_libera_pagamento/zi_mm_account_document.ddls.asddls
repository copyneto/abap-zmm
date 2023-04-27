@AbapCatalog.sqlViewName: 'ZVIMMACCDOC'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Documentos Contábeis'
define view ZI_MM_ACCOUNT_DOCUMENT
  as select distinct from ZI_MM_DOC_HISTORY     as _History
    inner join            I_AccountingDocument  as _AccDoc on _History.ReferencedDocument = _AccDoc.OriginalReferenceDocument
    left outer join       bsak_view             as _Bsak   on  _AccDoc.CompanyCode        = _Bsak.bukrs
                                                           and _AccDoc.FiscalYear         = _Bsak.gjahr
                                                           and _AccDoc.AccountingDocument = _Bsak.belnr
    left outer join       bseg                  as _Bseg   on  _Bseg.bukrs = _Bsak.bukrs
                                                           and _Bseg.gjahr = _Bsak.gjahr
                                                           and _Bseg.belnr = _Bsak.belnr
                                                           and _Bseg.buzei = _Bsak.buzei
    left outer join       rseg                  as _Rseg   on  _Rseg.belnr = substring(
      _History.ReferencedDocument, 1, 10
    )
                                                           and _Rseg.gjahr = _AccDoc.FiscalYear
                                                           and _Rseg.bukrs = _AccDoc.CompanyCode
  //    left outer join       ekbe                as _Ekbe    on _Ekbe.ebeln  = _Rseg.ebeln
  //                                                          and _Ekbe.vgabe = 'A'
  //    left outer join       bseg                as _BsegA   on  _BsegA.gjahr = _Ekbe.gjahr
  //                                                          and _BsegA.belnr = _Ekbe.belnr
  //                                                          and _BsegA.bukrs = _AccDoc.CompanyCode
  //                                                          and _BsegA.buzei = substring(_Ekbe.buzei, 2, 3 )
    left outer join       ZI_MM_CLA_MONT_ADIANT as _Adiant on  _Adiant.Ebeln = _Rseg.ebeln
                                                           and _Adiant.Ebelp = _Rseg.ebelp
                                                           and _Adiant.Bukrs = _AccDoc.CompanyCode
{
  key PurchaseOrder,
  key PurchaseOrderItem,
  key ReferencedDocument,
      AccountingDocument,
      FiscalYear,
      CompanyCode,
      //      _BsegA.dmbtr as MontanteAdiantamento,
      _Adiant.Waers                as Waers,
      @Semantics.amount.currencyCode: 'Waers'
      _Adiant.MontanteAdiantamento as MontanteAdiantamento,

      cast(
        case
          when _Bsak.augbl is not null or _Bsak.augbl is not initial
            then
              case left( _Bseg.hkont, 6 )
                when '211000'
              then 'X'
                else
                   ''
              end
            else
        ''
        end
      as xfeld )                   as status_compensado

}
