@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'CDS Nome do usuário'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_MM_VH_S_DOC as select from 
  ztmm_his_dep_fec as _ztmm_his_dep_fec 
{

 key _ztmm_his_dep_fec.out_material_document,
 key _ztmm_his_dep_fec.out_material_document_year,
 @EndUserText.label    : 'Chave de Busca'
 key concat( _ztmm_his_dep_fec.out_material_document,
              _ztmm_his_dep_fec.out_material_document_year
            )                                  as S_doc_material
}
where _ztmm_his_dep_fec.out_material_document is not initial
   and _ztmm_his_dep_fec.out_material_document_year is not initial
