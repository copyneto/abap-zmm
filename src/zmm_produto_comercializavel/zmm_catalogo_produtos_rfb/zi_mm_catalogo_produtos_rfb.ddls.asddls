@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CDS View para Catálogo de Produtos RFB'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel: { usageType:{ serviceQuality: #X,
                            sizeCategory: #S,
                            dataClass: #MIXED },
                semanticKey: ['Idrfb'],
                modelCategory: #BUSINESS_OBJECT
}
define root view entity ZI_MM_CATALOGO_PRODUTOS_RFB
  as select from ztmm_catalogorfb as CatalogoRFB
  association [0..1] to I_Material          as _Material         on  $projection.Material = _Material.Material
  association [0..*] to I_MaterialText      as _MaterialText     on  $projection.Material = _MaterialText.Material
  association [0..1] to I_MaterialType      as _MaterialType     on  $projection.Materialtype = _MaterialType.MaterialType
  association [0..1] to I_MaterialTypeText  as _MaterialTypeText on  $projection.Materialtype   = _MaterialTypeText.MaterialType
                                                                 and _MaterialTypeText.Language = $session.system_language
  association [0..1] to I_Supplier          as _Supplier         on  $projection.Supplier = _Supplier.Supplier
  association [0..1] to ZI_MM_VH_STATUS_RFB as _StatusText       on  $projection.Status   = _StatusText.StatusId
                                                                 and _StatusText.Language = $session.system_language
{
      @EndUserText.label: 'ID RFB'
  key idrfb                  as Idrfb,

      @EndUserText.label: 'Nº Material'
      @ObjectModel.foreignKey.association: '_Material'
      material               as Material,

      @EndUserText.label: 'Tipo de Material'
      @ObjectModel.foreignKey.association: '_Material'
      _Material.MaterialType as Materialtype,

      @EndUserText.label: 'Nº Fornecedor'
      @ObjectModel.foreignKey.association: '_Supplier'
      supplier               as Supplier,

      @EndUserText.label: 'Status RFB'
      @ObjectModel.foreignKey.association: '_StatusText'
      status                 as Status,

      case status
        when 'A' then 3 -- Ativado    | 3: green colour
        when 'D' then 0 -- Desativado | 0: unknown
        when 'R' then 2 -- Rascunho   | 2: yellow colour
        else 0          --            | 0: unknown
      end                    as StatusCriticality,

      @EndUserText.label: 'Data início da vigência'
      datefrom               as Datefrom,

      @EndUserText.label: 'Data fim da vigência'
      dateto                 as Dateto,

      @Semantics.user.createdBy: true
      created_by             as CreatedBy,
      @Semantics.systemDateTime.createdAt: true
      created_at             as CreatedAt,
      @Semantics.user.lastChangedBy: true
      last_changed_by        as LastChangedBy,
      @Semantics.systemDateTime.lastChangedAt: true
      last_changed_at        as LastChangedAt,
      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      local_last_changed_at  as LocalLastChangedAt,

      /* Associations */
      _Material,
      _MaterialText,
      _MaterialType,
      _MaterialTypeText,
      _Supplier,
      _StatusText

}
