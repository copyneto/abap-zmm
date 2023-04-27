@EndUserText.label: 'Registro de movimentações'
@AccessControl.authorizationCheck: #CHECK
@Search.searchable: true
@Metadata.allowExtensions: true
define root view entity ZC_MM_MOV_CNTRL
  as projection on ZI_MM_MOV_CNTRL as _MovCntrl

{
  key     Id,
          @Search.defaultSearchElement: true
          @Consumption.valueHelpDefinition: [ { entity: { name: 'ZI_CA_VH_BUKRS', element: 'Empresa' }  } ]
          Bukrs,
          @Search.defaultSearchElement: true
          @Consumption.valueHelpDefinition: [ { entity: { name: 'ZI_CA_VH_BRANCH', element: 'BusinessPlace' }  } ]
          Branch,
          @EndUserText.label: 'Nº Doc. Material Saída'
          MblnrSai,
          @EndUserText.label: 'Ano D.Mat.'
          Mjahr,
          @EndUserText.label: 'Item D.Mat.'
          Mblpo,
          @EndUserText.label: 'Status Geral'
          @ObjectModel.text.element: ['StatusGeralText']
          StatusGeral,
          _Domain.ddtext          as StatusGeralText,
          StatusGeralCrit,
          @ObjectModel.text.element: ['Status1Text']
          @EndUserText.label: 'Status mov. merc. saida'
          Status1,
          _Domain1.ddtext         as Status1Text,
          Status1Crit,
          @EndUserText.label: 'Nº est. D.Mat saída'
          MblnrEst,
          @EndUserText.label: 'Ano est'
          MjahrEst,
          @EndUserText.label: 'Nº Documento Saída'
          DocnumS,
          _URL.Estornar,
          @ObjectModel: { virtualElement: true,
                              virtualElementCalculatedBy: 'ABAP:ZCLMM_URL_BENS_CONSUMO' }
  virtual URL_est       : eso_longtext,
          @ObjectModel.text.element: ['Status2Text']
          @EndUserText.label: 'Status NF saida.'
          Status2,
          _Domain2.ddtext         as Status2Text,
          Status2Crit,
          @EndUserText.label: 'Doc. Contábil'
          Belnr,
          @EndUserText.label: 'Emp. Cont.'
          BukrsDc,
          @EndUserText.label: 'Ano Doc. Cont.'
          GjahrDc,
          @ObjectModel.text.element: ['Status3Text']
          @EndUserText.label: 'Status contab.'
          Status3,
          _Domain3.ddtext         as Status3Text,
          Status3Crit,
          @EndUserText.label: 'Nº Doc.Mat. entrada'
          MblnrEnt,
          @EndUserText.label: 'Ano D.Mat entrada'
          MjahrEnt,
          @EndUserText.label: 'Item D.Mat ent.'
          MblpoEnt,
          @ObjectModel.text.element: ['Status4Text']
          @EndUserText.label: 'Status NF ent'
          Status4,
          _Domain4.ddtext         as Status4Text,
          Status4Crit,
          @EndUserText.label: 'Est. D.Mat. ent'
          MblnrEstEnt,
          @EndUserText.label: 'Ano est. D.Mat. ent'
          MjahrEstEnt,
          @Search.defaultSearchElement: true
          @EndUserText.label: 'Data entrada em Estoque'
          Bldat,
          @EndUserText.label: 'Nº documento entrada'
          DocnumEnt,
          @Search.defaultSearchElement: true
          @EndUserText.label: 'Data da NFe'
          @Consumption.filter.selectionType: #INTERVAL
          Docdat,
          @ObjectModel.text.element: ['Status5Text']
          @EndUserText.label: 'Status mov. merc. ent'
          Status5,
          _Domain5.ddtext         as Status5Text,
          Status5Crit,
          @EndUserText.label: 'Nº Doc. est entrada'
          DocnumEstEnt,
          @EndUserText.label: 'Nº Doc. est saída'
          DocnumEstSai,
          @EndUserText.label: 'Est. Doc. contab.'
          BelnrEst,
          @EndUserText.label: 'Ano est. Doc. contab.'
          GjahrEst,
          @EndUserText.label: 'Dt est. Doc. contab.'
          BldatEst,
          @EndUserText.label: 'Etapa do processo'
          Etapa,
          @EndUserText.label: 'Material baixado'
          Matnr1,
          @EndUserText.label: 'Material'
          Matnr,
          Menge,
          Meins,
          Werks,
          Lgort,
          @EndUserText.label: 'Elemento PEP'
          Posid,
          Anln1,
          Anln2,
          Invnr,
          @Consumption.valueHelpDefinition: [{
          entity: { name: 'I_BusinessPartner', element: 'BusinessPartner' } }]
          Partner,
          CreatedBy,
          CreatedAt,
          LastChangedBy,
          LastChangedAt,
          LocalLastChangedAt,
          _Simul.Netpr,
          _Simul.TaxtypIcm3,
          @Semantics.amount.currencyCode: 'Currency'
          _Simul.BaseBx13,
          _Simul.RateBx13,
          _Simul.TaxvalBx13,
          _Simul.TaxtypIpi3,
          _Simul.BaseIpva,
          _Simul.RateIpva,
          _Simul.TaxvalBx23,
          _Simul.TaxtypIpis,
          _Simul.BaseBpi1,
          _Simul.RateBx82,
          _Simul.TaxvalBx82,
          _Simul.TaxtypIcof,
          _Simul.BaseBco1,
          _Simul.RateBx72,
          _Simul.TaxvalBx72,
          _Simul.NetprFinal,
          _Simul.Currency,
          _Material.Centro,
          //          _Material.Deposito,
          _Param.low              as Deposito,
          _Material.DescricaoMaterial,
          _Material.UtilizacaoLivre,
          _Material.MeinsUtilizacaoLivre,
          @EndUserText.label: 'NF num. saída'
          _NFSaida.BR_NFeNumber   as NFSaidaNumero,
          @EndUserText.label: 'Data de criação da NF saída'
          _NFSaida.CreationDate   as NFSaidaCriacao,
          @EndUserText.label: 'NF entrada'
          _NFEntrada.BR_NFeNumber as NFEntradaNumero,
          @EndUserText.label: 'Data de criação da NF entrada'
          _NFEntrada.CreationDate as NFEntradaCriacao,
          @ObjectModel: { virtualElement: true,
                          virtualElementCalculatedBy: 'ABAP:ZCLMM_URL_BENS_CONSUMO' }
  virtual URL_DocnumS   : eso_longtext,
          @ObjectModel: { virtualElement: true,
                          virtualElementCalculatedBy: 'ABAP:ZCLMM_URL_BENS_CONSUMO' }
  virtual URL_DocnumEnt : eso_longtext,
          @ObjectModel: { virtualElement: true,
                        virtualElementCalculatedBy: 'ABAP:ZCLMM_URL_BENS_CONSUMO' }
  virtual URL_Belnr     : eso_longtext,
          @ObjectModel: { virtualElement: true,
                      virtualElementCalculatedBy: 'ABAP:ZCLMM_URL_BENS_CONSUMO' }
  virtual URL_MblnrSai  : eso_longtext,
          @ObjectModel: { virtualElement: true,
                    virtualElementCalculatedBy: 'ABAP:ZCLMM_URL_BENS_CONSUMO' }
  virtual URL_MblnrEnt  : eso_longtext,
          //      @ObjectModel: { virtualElement: true,
          //                      virtualElementCalculatedBy: 'ABAP:ZCLMM_URL_BENS_CONSUMO' }
          //      virtual URL_DocnumEnt  : eso_longtext,
          /* Associations */
          _Simul,
          _Material,
          _URL,
          _MatCntrl : redirected to composition child ZC_MM_MAT_CNTRL
          //      _MovSimul
}
