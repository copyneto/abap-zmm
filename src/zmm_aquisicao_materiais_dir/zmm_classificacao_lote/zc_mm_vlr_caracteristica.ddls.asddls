@EndUserText.label: 'Valor da Característica'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
define view entity ZC_MM_VLR_CARACTERISTICA
  as projection on ZI_MM_VLR_CARACTERISTICA
{
      @EndUserText.label: 'Nº Pedido'
  key Pedido,
      @EndUserText.label: 'Item Pedido'
  key ItemPedido,
      @EndUserText.label: 'Lote'
      @Consumption.valueHelpDefinition: [{ entity: { name: 'I_BatchStdVH', element: 'Batch' }
//                                           additionalBinding: [{ localElement: '_Classif.Centro', element: 'Plant' },
//                                                                { localElement: '_Classif.Material', element: 'Material' }]
      }]
  key Lote,
      @EndUserText.label: 'Categoria do Documento'
      CagetoriaDocumento,
      @EndUserText.label: 'Nº Remessa'
      Remessa,
      @EndUserText.label: 'Item Remessa'
      ItemRemessa,
      @EndUserText.label: 'Peneira 10 (%)'
      @Semantics.quantity.unitOfMeasure: 'Porcentagem'
      Peneira10,
      @EndUserText.label: 'Peneira 11 (%)'
      @Semantics.quantity.unitOfMeasure: 'Porcentagem'
      Peneira11,
      @EndUserText.label: 'Peneira 12 (%)'
      @Semantics.quantity.unitOfMeasure: 'Porcentagem'
      Peneira12,
      @EndUserText.label: 'Peneira 13 (%)'
      @Semantics.quantity.unitOfMeasure: 'Porcentagem'
      Peneira13,
      @EndUserText.label: 'Peneira 14 (%)'
      @Semantics.quantity.unitOfMeasure: 'Porcentagem'
      Peneira14,
      @EndUserText.label: 'Peneira 15 (%)'
      @Semantics.quantity.unitOfMeasure: 'Porcentagem'
      Peneira15,
      @EndUserText.label: 'Peneira 16 (%)'
      @Semantics.quantity.unitOfMeasure: 'Porcentagem'
      Peneira16,
      @EndUserText.label: 'Peneira 17 (%)'
      @Semantics.quantity.unitOfMeasure: 'Porcentagem'
      Peneira17,
      @EndUserText.label: 'Peneira 18 (%)'
      @Semantics.quantity.unitOfMeasure: 'Porcentagem'
      Peneira18,
      @EndUserText.label: 'Peneira 19 (%)'
      @Semantics.quantity.unitOfMeasure: 'Porcentagem'
      Peneira19,
      @EndUserText.label: 'Mk10 (%)'
      @Semantics.quantity.unitOfMeasure: 'Porcentagem'
      Mk10,
      @EndUserText.label: 'Fundo (%)'
      @Semantics.quantity.unitOfMeasure: 'Porcentagem'
      Fundo,
      @EndUserText.label: 'Catação (%)'
      @Semantics.quantity.unitOfMeasure: 'Porcentagem'
      Catacao,
      @EndUserText.label: 'Umidade (%)'
      @Semantics.quantity.unitOfMeasure: 'Porcentagem'
      Umidade,
      @EndUserText.label: 'Impureza (%)'
      @Semantics.quantity.unitOfMeasure: 'Porcentagem'
      Impureza,
      @EndUserText.label: 'Verde (%)'
      @Semantics.quantity.unitOfMeasure: 'Porcentagem'
      Verde,
      @EndUserText.label: 'Preto e Ardido (%)'
      @Semantics.quantity.unitOfMeasure: 'Porcentagem'
      PretoArdido,
      @EndUserText.label: 'Broca (%)'
      @Semantics.quantity.unitOfMeasure: 'Porcentagem'
      Brocado,
      @EndUserText.label: 'Densidade (%)'
      @Semantics.quantity.unitOfMeasure: 'Porcentagem'
      Densidade,
      @EndUserText.label: 'Defeito'
      Defeito,
      @EndUserText.label: 'Safra'
      Safra,
      @EndUserText.label: 'Paladar'
      Paladar,
      @EndUserText.label: 'Percentual'
      @Semantics.unitOfMeasure: true
      Porcentagem,
      @EndUserText.label: 'Observação'
      Observacao,
      @EndUserText.label: 'Criado Por'
      @ObjectModel.text.element: ['NomeCriador']
      CreatedBy,
      @EndUserText.label: 'Nome Criador'
      _CreatedByUser.UserDescription as NomeCriador,
      @EndUserText.label: 'Criado Em'
      CreatedAt,
      @EndUserText.label: 'Modificado Por'
      @ObjectModel.text.element: ['NomeModificador']
      LastChangedBy,
      @EndUserText.label: 'Nome Modificador'
      _ChangedByUser.UserDescription as NomeModificador,
      @EndUserText.label: 'Modificado Em'
      LastChangedAt,
      @EndUserText.label: 'Última Modif.'
      LocalLastChangedAt,

      /* Associations */
      _Classif : redirected to parent ZC_MM_CTRL_CLASSIF,
      _CreatedByUser,
      _ChangedByUser

}
