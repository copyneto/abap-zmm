class ZCLMM_INVENTARIO_NFE_MPC definition
  public
  inheriting from /IWBEP/CL_MGW_PUSH_ABS_MODEL
  create public .

public section.

  interfaces IF_SADL_GW_MODEL_EXPOSURE_DATA .

  types:
    begin of TS_ZC_MM_INVENTARIO_NFE_EMISSA.
      include type ZC_MM_INVENTARIO_NFE_EMISSAO.
  types:
    end of TS_ZC_MM_INVENTARIO_NFE_EMISSA .
  types:
   TT_ZC_MM_INVENTARIO_NFE_EMISSA type standard table of TS_ZC_MM_INVENTARIO_NFE_EMISSA .
  types:
    begin of TS_ZI_CA_VH_COMPANYTYPE.
      include type ZI_CA_VH_COMPANY.
  types:
    end of TS_ZI_CA_VH_COMPANYTYPE .
  types:
   TT_ZI_CA_VH_COMPANYTYPE type standard table of TS_ZI_CA_VH_COMPANYTYPE .
  types:
    begin of TS_ZI_CA_VH_DEPOSITOTYPE.
      include type ZI_CA_VH_DEPOSITO.
  types:
    end of TS_ZI_CA_VH_DEPOSITOTYPE .
  types:
   TT_ZI_CA_VH_DEPOSITOTYPE type standard table of TS_ZI_CA_VH_DEPOSITOTYPE .
  types:
    begin of TS_ZI_CA_VH_MATERIALTYPE.
      include type ZI_CA_VH_MATERIAL.
  types:
    end of TS_ZI_CA_VH_MATERIALTYPE .
  types:
   TT_ZI_CA_VH_MATERIALTYPE type standard table of TS_ZI_CA_VH_MATERIALTYPE .
  types:
    begin of TS_ZI_CA_VH_WERKSTYPE.
      include type ZI_CA_VH_WERKS.
  types:
    end of TS_ZI_CA_VH_WERKSTYPE .
  types:
   TT_ZI_CA_VH_WERKSTYPE type standard table of TS_ZI_CA_VH_WERKSTYPE .

  constants GC_ZC_MM_INVENTARIO_NFE_EMISSA type /IWBEP/IF_MGW_MED_ODATA_TYPES=>TY_E_MED_ENTITY_NAME value 'ZC_MM_INVENTARIO_NFE_EMISSAOType' ##NO_TEXT.
  constants GC_ZI_CA_VH_COMPANYTYPE type /IWBEP/IF_MGW_MED_ODATA_TYPES=>TY_E_MED_ENTITY_NAME value 'ZI_CA_VH_COMPANYType' ##NO_TEXT.
  constants GC_ZI_CA_VH_DEPOSITOTYPE type /IWBEP/IF_MGW_MED_ODATA_TYPES=>TY_E_MED_ENTITY_NAME value 'ZI_CA_VH_DEPOSITOType' ##NO_TEXT.
  constants GC_ZI_CA_VH_MATERIALTYPE type /IWBEP/IF_MGW_MED_ODATA_TYPES=>TY_E_MED_ENTITY_NAME value 'ZI_CA_VH_MATERIALType' ##NO_TEXT.
  constants GC_ZI_CA_VH_WERKSTYPE type /IWBEP/IF_MGW_MED_ODATA_TYPES=>TY_E_MED_ENTITY_NAME value 'ZI_CA_VH_WERKSType' ##NO_TEXT.

  methods DEFINE
    redefinition .
  methods GET_LAST_MODIFIED
    redefinition .
protected section.
private section.

  methods DEFINE_RDS_4
    raising
      /IWBEP/CX_MGW_MED_EXCEPTION .
  methods GET_LAST_MODIFIED_RDS_4
    returning
      value(RV_LAST_MODIFIED_RDS) type TIMESTAMP .
ENDCLASS.



CLASS ZCLMM_INVENTARIO_NFE_MPC IMPLEMENTATION.


  method DEFINE.
*&---------------------------------------------------------------------*
*&           Generated code for the MODEL PROVIDER BASE CLASS         &*
*&                                                                     &*
*&  !!!NEVER MODIFY THIS CLASS. IN CASE YOU WANT TO CHANGE THE MODEL  &*
*&        DO THIS IN THE MODEL PROVIDER SUBCLASS!!!                   &*
*&                                                                     &*
*&---------------------------------------------------------------------*

model->set_schema_namespace( 'ZGWMM_INVENTARIO_NFE_SRV' ).

define_rds_4( ).
get_last_modified_rds_4( ).
  endmethod.


  method DEFINE_RDS_4.
*&---------------------------------------------------------------------*
*&           Generated code for the MODEL PROVIDER BASE CLASS          &*
*&                                                                     &*
*&  !!!NEVER MODIFY THIS CLASS. IN CASE YOU WANT TO CHANGE THE MODEL   &*
*&        DO THIS IN THE MODEL PROVIDER SUBCLASS!!!                    &*
*&                                                                     &*
*&---------------------------------------------------------------------*
*   This code is generated for Reference Data Source
*   4
*&---------------------------------------------------------------------*
    TRY.
        if_sadl_gw_model_exposure_data~get_model_exposure( )->expose( model )->expose_vocabulary( vocab_anno_model ).
      CATCH cx_sadl_exposure_error INTO DATA(lx_sadl_exposure_error).
        RAISE EXCEPTION TYPE /iwbep/cx_mgw_med_exception
          EXPORTING
            previous = lx_sadl_exposure_error.
    ENDTRY.
  endmethod.


  method GET_LAST_MODIFIED.
*&---------------------------------------------------------------------*
*&           Generated code for the MODEL PROVIDER BASE CLASS         &*
*&                                                                     &*
*&  !!!NEVER MODIFY THIS CLASS. IN CASE YOU WANT TO CHANGE THE MODEL  &*
*&        DO THIS IN THE MODEL PROVIDER SUBCLASS!!!                   &*
*&                                                                     &*
*&---------------------------------------------------------------------*


  CONSTANTS: lc_gen_date_time TYPE timestamp VALUE '20211205223842'.                  "#EC NOTEXT
 DATA: lv_rds_last_modified TYPE timestamp .
  rv_last_modified = super->get_last_modified( ).
  IF rv_last_modified LT lc_gen_date_time.
    rv_last_modified = lc_gen_date_time.
  ENDIF.
 lv_rds_last_modified =  GET_LAST_MODIFIED_RDS_4( ).
 IF rv_last_modified LT lv_rds_last_modified.
 rv_last_modified  = lv_rds_last_modified .
 ENDIF .
  endmethod.


  method GET_LAST_MODIFIED_RDS_4.
*&---------------------------------------------------------------------*
*&           Generated code for the MODEL PROVIDER BASE CLASS          &*
*&                                                                     &*
*&  !!!NEVER MODIFY THIS CLASS. IN CASE YOU WANT TO CHANGE THE MODEL   &*
*&        DO THIS IN THE MODEL PROVIDER SUBCLASS!!!                    &*
*&                                                                     &*
*&---------------------------------------------------------------------*
*   This code is generated for Reference Data Source
*   4
*&---------------------------------------------------------------------*
*    @@TYPE_SWITCH:
    CONSTANTS: co_gen_date_time TYPE timestamp VALUE '20211205223842'.
    TRY.
        rv_last_modified_rds = CAST cl_sadl_gw_model_exposure( if_sadl_gw_model_exposure_data~get_model_exposure( ) )->get_last_modified( ).
      CATCH cx_root ##CATCH_ALL.
        rv_last_modified_rds = co_gen_date_time.
    ENDTRY.
    IF rv_last_modified_rds < co_gen_date_time.
      rv_last_modified_rds = co_gen_date_time.
    ENDIF.
  endmethod.


  method IF_SADL_GW_MODEL_EXPOSURE_DATA~GET_MODEL_EXPOSURE.
    CONSTANTS: co_gen_timestamp TYPE timestamp VALUE '20211205223842'.
    DATA(lv_sadl_xml) =
               |<?xml version="1.0" encoding="utf-16"?>|  &
               |<sadl:definition xmlns:sadl="http://sap.com/sap.nw.f.sadl" syntaxVersion="" >|  &
               | <sadl:dataSource type="CDS" name="ZC_MM_INVENTARIO_NFE_EMISSAO" binding="ZC_MM_INVENTARIO_NFE_EMISSAO" />|  &
               | <sadl:dataSource type="CDS" name="ZI_CA_VH_COMPANY" binding="ZI_CA_VH_COMPANY" />|  &
               | <sadl:dataSource type="CDS" name="ZI_CA_VH_DEPOSITO" binding="ZI_CA_VH_DEPOSITO" />|  &
               | <sadl:dataSource type="CDS" name="ZI_CA_VH_MATERIAL" binding="ZI_CA_VH_MATERIAL" />|  &
               | <sadl:dataSource type="CDS" name="ZI_CA_VH_WERKS" binding="ZI_CA_VH_WERKS" />|  &
               |<sadl:resultSet>|  &
               |<sadl:structure name="ZC_MM_INVENTARIO_NFE_EMISSAO" dataSource="ZC_MM_INVENTARIO_NFE_EMISSAO" maxEditMode="RO" exposure="TRUE" >|  &
               | <sadl:query name="SADL_QUERY">|  &
               | </sadl:query>|  &
               |</sadl:structure>|  &
               |<sadl:structure name="ZI_CA_VH_COMPANY" dataSource="ZI_CA_VH_COMPANY" maxEditMode="RO" exposure="TRUE" >|  &
               | <sadl:query name="SADL_QUERY">|  &
               | </sadl:query>|  &
               |</sadl:structure>|  &
               |<sadl:structure name="ZI_CA_VH_DEPOSITO" dataSource="ZI_CA_VH_DEPOSITO" maxEditMode="RO" exposure="TRUE" >|  &
               | <sadl:query name="SADL_QUERY">|  &
               | </sadl:query>|  &
               |</sadl:structure>|  &
               |<sadl:structure name="ZI_CA_VH_MATERIAL" dataSource="ZI_CA_VH_MATERIAL" maxEditMode="RO" exposure="TRUE" >|  &
               | <sadl:query name="SADL_QUERY">|  &
               | </sadl:query>|  &
               |</sadl:structure>|  &
               |<sadl:structure name="ZI_CA_VH_WERKS" dataSource="ZI_CA_VH_WERKS" maxEditMode="RO" exposure="TRUE" >|  &
               | <sadl:query name="SADL_QUERY">|  &
               | </sadl:query>|  &
               |</sadl:structure>|  &
               |</sadl:resultSet>|  &
               |</sadl:definition>| .

   ro_model_exposure = cl_sadl_gw_model_exposure=>get_exposure_xml( iv_uuid      = CONV #( 'ZGW_MM_INVENTARIO_NFE' )
                                                                    iv_timestamp = co_gen_timestamp
                                                                    iv_sadl_xml  = lv_sadl_xml ).
  endmethod.
ENDCLASS.
