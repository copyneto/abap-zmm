@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'CDS de Interface - Parceiro'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_MM_PARCEIRO
  as select from I_BR_NFDocument as NFHeader
  association [0..1] to kna1            as _Cliente       on  _Cliente.kunnr = NFHeader.BR_NFPartner
  association [0..1] to lfa1            as _Fornecedor    on  _Fornecedor.lifnr = NFHeader.BR_NFPartner
  association [0..1] to P_BusinessPlace as _BusinessPlace on  _BusinessPlace.bukrs  = NFHeader.CompanyCode
                                                          and _BusinessPlace.branch = NFHeader.BusinessPlace

{
  key BR_NotaFiscal,
  key BR_NFPartnerType,
      case NFHeader.BR_NFPartnerType
        when 'C' then NFHeader.BR_NFPartner
        when 'V' then NFHeader.BR_NFPartner
        when 'B' then NFHeader.CompanyCode
        else ''
      end as Parceiro,

      case NFHeader.BR_NFPartnerType
        when 'C' then BR_NFPartnerName1
        when 'V' then BR_NFPartnerName1
        when 'B' then CompanyCodeName
        else ''
      end as NomeParceiro,

      case NFHeader.BR_NFPartnerType
        when 'C' then BR_NFPartnerTaxRegimenCode
        when 'V' then BR_NFPartnerTaxRegimenCode
        when 'B' then BusinessPlaceTaxRegimenCode
        else ''
      end as crtn,

      case NFHeader.BR_NFPartnerType
        when 'C' then _Cliente.icmstaxpay
        when 'V' then _Fornecedor.icmstaxpay
        when 'B' then _BusinessPlace.icmstaxpay
        else ''
      end as icmstaxpay,

      case NFHeader.BR_NFPartnerType
        when 'C' then _Cliente.indtyp
        when 'V' then _Fornecedor.indtyp
        when 'B' then _BusinessPlace.indtyp
        else ''
      end as indtyp,

      case NFHeader.BR_NFPartnerType
        when 'C' then _Cliente.brsch
        when 'V' then _Fornecedor.brsch
        when 'B' then _BusinessPlace.kr_indtype
        else ''
      end as BRSCH,

      case NFHeader.BR_NFPartnerType
        when 'C' then _Cliente.tdt
        when 'V' then _Fornecedor.tdt
        when 'B' then _BusinessPlace.tdt
        else ''
      end as TDT

}
where
  NFHeader.BR_NFPartner <> ''
