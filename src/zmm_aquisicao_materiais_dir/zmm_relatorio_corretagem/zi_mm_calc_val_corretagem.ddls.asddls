@AbapCatalog.sqlViewName: 'ZVMM_CALCCORRETA'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'CDS Interface Calcular Vlrs Corretagem'
@ObjectModel.usageType.serviceQuality: #C
@ObjectModel.usageType.sizeCategory: #L
@ObjectModel.usageType.dataClass: #TRANSACTIONAL
//@ObjectModel.semanticKey: 'CalcularCorretagem'
//@ObjectModel.representativeKey: 'CalcularCorretagem'
define view ZI_MM_CALC_VAL_CORRETAGEM
  as select from    ztmm_control_cla
    inner join      ZI_MM_PurgDocHistory           as _purgdoc    on ebeln = _purgdoc.DocumentoCompra

    inner join      I_BR_NFItemDocumentFlowFirst_C as _NFITEMDOC  on _purgdoc.ReferenceDocument = _NFITEMDOC.ReferenceDocument

    inner join      ZI_MM_SOMA_ITENS_NF            as _somitensnf on _NFITEMDOC.BR_NotaFiscal = _somitensnf.BR_NotaFiscal

    left outer join I_Material                     as _material   on _material.Material = _somitensnf.Material

  association [1..1] to ztmm_corretagem      as _Corretagem on  $projection.DocumentoCompra = _Corretagem.ebeln
                                                            and $projection.Docnum          = _Corretagem.docnum
  association [1..1] to ZI_MM_NFS_DEVOLVIDAS as _nfdevol    on  $projection.Docnum = _nfdevol.BR_ReferenceNFNumber

{
  key ebeln                                                                                   as DocumentoCompra,
  key _NFITEMDOC.BR_NotaFiscal                                                                as Docnum,

      cast( perc_corretagem as float ) *
      cast( _somitensnf.NetValueAmount as float )                                             as ValorCorretagem,

      //      cast(_Corretagem.vlr_desconto as ze_vldesc preserving type) as ValorDesconto,

      case
          when _Corretagem.vlr_desconto is null then cast( 0 as ze_vldesc )
          else cast(_Corretagem.vlr_desconto as ze_vldesc preserving type )
      end                                                                                     as ValorDesconto,

      case
          when _nfdevol.ValorDevolucao is null then cast( 0 as abap.fltp )
          else
              cast( abs(_nfdevol.ValorDevolucao) as  abap.fltp ) *
            ( cast( perc_corretagem as abap.fltp ) / cast( 100 as abap.fltp ) )
      end                                                                                     as ValorDevCorretagem,


      case _material.MaterialBaseUnit
        when _somitensnf.BaseUnit then ( cast( prc_unit_embarcador as float ) *
                                       ( cast( _somitensnf.QuantityInBaseUnit as float ) / cast( 60 as abap.fltp ) ) )
                                  else
                                       ( cast( prc_unit_embarcador as float ) *
                                         cast( _somitensnf.QuantityInBaseUnit as float )) end as ValorEmbarcador,
      _Corretagem,
      _nfdevol

}
