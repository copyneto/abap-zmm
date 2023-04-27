@EndUserText.label: 'Geração Remessa - Excel'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZC_MM_REM_EXCEL
  as projection on ZI_MM_REM_EXCEL
{
  key     Guid,
          @Consumption.filter.mandatory: true
          CreatedDate,
          CreatedTime,
          CreatedUser,
          FileDirectory,
          @Consumption.valueHelpDefinition: [{ entity:{ name: 'Zi_ca_vh_werks', element : 'WerksCode' }}]
          CentroOrigem,
          DepositoOrigem,
          TipoEstoque,
          Pedido,
          TipoRemessa
}
