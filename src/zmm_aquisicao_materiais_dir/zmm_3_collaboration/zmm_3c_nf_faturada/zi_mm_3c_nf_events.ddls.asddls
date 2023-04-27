@AbapCatalog.sqlViewName: 'ZV_NF_EVENTS'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Eventos'
define view ZI_MM_3C_NF_EVENTS as select from /xnfe/events 
{    
    key mandt as Mandt,
    key guid as Guid,
    chnfe as Chnfe,
    tpevento as Tpevento,
    nseqevento_int as NseqeventoInt,
    nseqevento as Nseqevento,
    cuf as Cuf,
    tpemis as Tpemis,
    tpamb as Tpamb,
    cnpj as Cnpj,
    cpf as Cpf,
    cstat as Cstat,
    xmotivo as Xmotivo,
    dhevento as Dhevento,
    dhregevento as Dhregevento,
    nprot as Nprot,
    current_status as CurrentStatus,
    is_current as IsCurrent,
    createtime as Createtime,
    proctyp as Proctyp,
    last_step as LastStep,
    last_step_status as LastStepStatus,
    batch_guid as BatchGuid,
    batchid as Batchid,
    dh_evento_int as DhEventoInt,
    dh_regevento_int as DhRegeventoInt,
    digval as Digval,
    xmlversion as Xmlversion,
    xmlversion_det as XmlversionDet,
    xmlversion_rdoc as XmlversionRdoc,
    b2b_proctyp as B2bProctyp,
    b2b_actstat as B2bActstat,
    b2b_last_step as B2bLastStep,
    b2b_last_step_st as B2bLastStepSt    
}
