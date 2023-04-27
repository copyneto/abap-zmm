@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Relatório Quantitativo de Notas Fiscais'
define root view entity ZI_MM_RELAT_QUANT_NF

  as select from I_BR_NFDocument as Doc

    inner join   I_BR_NFItem     as _Lin on _Lin.BR_NotaFiscal = Doc.BR_NotaFiscal

  association [0..1] to j_1baat                    as _NFType        on  _NFType.spras  = $session.system_language
                                                                     and _NFType.nftype = $projection.BR_NFType

  association [0..1] to j_1bbrancht                as _Branch        on  _Branch.bukrs      = $projection.CompanyCode
                                                                     and _Branch.branch     = $projection.BusinessPlace
                                                                     and _Branch.bupla_type = ''
                                                                     and _Branch.language   = $session.system_language

  association [0..1] to I_BR_NFeDocumentStatusText as _NFStatus      on  _NFStatus.Language             = $session.system_language
                                                                     and _NFStatus.BR_NFeDocumentStatus = $projection.BR_NFeDocumentStatus

  association [0..1] to j_1bdoctypest              as _DocType       on  _DocType.spras  = $session.system_language
                                                                     and _DocType.doctyp = $projection.BR_NFDocumentType

  association [0..1] to P_USER_ADDR                as _User          on  _User.bname = $projection.CreatedByUser

  association [0..1] to ZI_CA_VH_PARID             as _BR_NFPartner  on  _BR_NFPartner.BR_NFPartner = $projection.BR_NFPartner
  //  association [0..1] to I_BR_NFPartner             as _BR_NFPartner  on  _BR_NFPartner.BR_NotaFiscal        = $projection.BR_NotaFiscal
  //                                                                     and _BR_NFPartner.BR_NFPartnerFunction = $projection.BR_NFPartnerFunction

  association [0..1] to I_BR_NFPartnerTypeText     as _NFPartnerType on  _NFPartnerType.Language         = $session.system_language
                                                                     and _NFPartnerType.BR_NFPartnerType = $projection.BR_NFPartnerType

  association [0..1] to ZI_CA_VH_CFOP              as _CFOP          on  _CFOP.Cfop = $projection.BR_CFOPCode
{

  key Doc.BR_NotaFiscal                                        as BR_NotaFiscal,
  key _Lin.BR_NotaFiscalItem                                   as BR_NotaFiscalItem,
      Doc.BR_NFDirection                                       as BR_NFDirection,
      Doc._BR_NFDirection._Text
      [1:Language=$session.system_language].BR_NFDirectionDesc as BR_NFDirectionDesc, 

      case Doc.BR_NFDirection
      when '1' then 3 -- Entrada
      when '2' then 2 -- Saída
      when '3' then 2 -- Devoluções de saída de transferências de estoque
      when '4' then 3 -- Devoluções de entrada de transferências de estoque
               else 0 end                                      as BR_NFDirectionCrit,

      Doc.BR_NFDocumentType                                    as BR_NFDocumentType,
      Doc.BR_NFIssueDate                                       as BR_NFIssueDate,
      cast( substring(Doc.BR_NFIssueDate,5,2) as monat )       as BR_NFIssueMonth,
      Doc.CompanyCode                                          as CompanyCode,
      Doc.CompanyCodeName                                      as CompanyCodeName,
      Doc.BusinessPlace                                        as BusinessPlace,
      Doc.BR_NFeDocumentStatus                                 as BR_NFeDocumentStatus,
      _NFStatus.BR_NFeDocumentStatusDesc                       as BR_NFeDocumentStatusDesc,

      case Doc.BR_NFeDocumentStatus
      when ' ' then 0 -- 1ª tela
      when '1' then 3 -- Autorizado
      when '2' then 1 -- Recusado
      when '3' then 1 -- Rejeitado
               else 0 end                                      as BR_NFeDocumentStatusCrit,

      Doc.BR_NFPostingDate                                     as BR_NFPostingDate,
      Doc.CreationTime                                         as CreationTime,
      Doc.BR_NFType                                            as BR_NFType,
      Doc.CreatedByUser                                        as CreatedByUser,

      case when Doc.CreatedByUser = $session.user
           then 3
           else 0 end                                          as CreatedByUserCrit,

      Doc.BR_NFPartnerFunction                                 as BR_NFPartnerFunction,
      Doc.BR_NFPartner                                         as BR_NFPartner,
      Doc.BR_NFPartnerType                                     as BR_NFPartnerType,
      Doc.BR_NFeNumber                                         as BR_NFeNumber,
      Doc.BR_UtilsNFNumber                                     as BR_UtilsNFNumber,
      cast ( _Lin.BR_CFOPCode as abap.char( 10 ) )             as BR_CFOPCode,

      cast( case when _Lin.BR_CFOPCode is not initial
           then concat(
                substring( _Lin.BR_CFOPCode, 1, 4),
                concat('/',
                substring( _Lin.BR_CFOPCode, 5, 6) ) )
           else '' end as abap.char(10) )                      as BR_CFOPCodeMask,

      //      @ObjectModel.virtualElement: true
      //      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLCA_EXIT_CONV_CFOBR'
      //      cast ( _Lin.BR_CFOPCode as abap.char( 10 ) )             as BR_CFOPCode,
      //      cast ( _Lin.BR_CFOPCode as abap.char( 10) )              as BR_CFOPCodeCV,
      Doc.BR_NFIsCanceled                                      as BR_NFIsCanceled,

      /* Associations */
      _NFType,
      _Branch,
      _NFStatus,
      _DocType,
      _User,
      _BR_NFPartner,
      _NFPartnerType,
      _CFOP
}
