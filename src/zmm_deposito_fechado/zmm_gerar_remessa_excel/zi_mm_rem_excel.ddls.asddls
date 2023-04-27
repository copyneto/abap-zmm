//@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Geração Remessa - Excel'
//@Metadata.ignorePropagatedAnnotations: true
//@ObjectModel.usageType:{
//    serviceQuality: #X,
//    sizeCategory: #S,
//    dataClass: #MIXED
//}
define root view entity ZI_MM_REM_EXCEL
  as select from ztmm_rem_excel
  association [1..1] to ZI_MM_TIPO_REMESSA as TipoRemessa on TipoRemessa.TipoRemessa = ztmm_rem_excel.tipo_remessa
{
  key guid                            as Guid,
      created_date                    as CreatedDate,
      created_time                    as CreatedTime,
      created_user                    as CreatedUser,
      file_directory                  as FileDirectory,
      centro_origem                   as CentroOrigem,
      deposito_origem                 as DepositoOrigem,
      tipo_estoque                    as TipoEstoque,
      pedido                          as Pedido,
      TipoRemessa.Description         as TipoRemessa
}
