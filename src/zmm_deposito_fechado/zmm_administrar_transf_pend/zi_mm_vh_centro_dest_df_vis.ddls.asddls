@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Ajuda pesq. Centro Destino - Dep.Fechado'
define root view entity ZI_MM_VH_CENTRO_DEST_DF_VIS
  as select from ZI_MM_VH_CENTRO            as ValueHelpCentro
    inner join   ZI_MM_PARA_DEP_FECHADO_APP as ParamDepFechado on ValueHelpCentro.Plant = ParamDepFechado.DestinyPlant
{

  key ValueHelpCentro.Plant,
      ValueHelpCentro.PlantName,
      ValueHelpCentro.ValuationArea,
      ValueHelpCentro.PlantCustomer,
      ValueHelpCentro.PlantSupplier,
      ValueHelpCentro.FactoryCalendar,
      ValueHelpCentro.DefaultPurchasingOrganization,
      ValueHelpCentro.SalesOrganization,
      ValueHelpCentro.AddressID,
      ValueHelpCentro.PlantCategory,
      ValueHelpCentro.DistributionChannel,
      ValueHelpCentro.Division,
      ValueHelpCentro.Language,
      ValueHelpCentro.IsMarkedForArchiving

}
group by
  ValueHelpCentro.Plant,
  ValueHelpCentro.PlantName,
  ValueHelpCentro.ValuationArea,
  ValueHelpCentro.PlantCustomer,
  ValueHelpCentro.PlantSupplier,
  ValueHelpCentro.FactoryCalendar,
  ValueHelpCentro.DefaultPurchasingOrganization,
  ValueHelpCentro.SalesOrganization,
  ValueHelpCentro.AddressID,
  ValueHelpCentro.PlantCategory,
  ValueHelpCentro.DistributionChannel,
  ValueHelpCentro.Division,
  ValueHelpCentro.Language,
  ValueHelpCentro.IsMarkedForArchiving
