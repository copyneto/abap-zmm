
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Executar ZMMSD_PLANLOG'
@Metadata.allowExtensions: true
@ObjectModel.modelCategory: #BUSINESS_OBJECT
@ObjectModel.compositionRoot: true
@ObjectModel.transactionalProcessingEnabled: true
@ObjectModel.createEnabled: true
@ObjectModel.updateEnabled: true
@ObjectModel.deleteEnabled: true
@OData.publish: true
define root view entity ZI_MM_PLANLOG_EXECUTE_GET as select from ztplanlog_vari
{
    
  key report                               as ztran,
  key    vari                               as zvari
  
 

}
