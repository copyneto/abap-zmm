CLASS zclmm_cl_si_folha_registro_se1 DEFINITION
  PUBLIC
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES zclmm_ii_si_folha_registro_ser .
  PROTECTED SECTION.
  PRIVATE SECTION.

    CONSTANTS: gc_nao TYPE char1 VALUE 'N',
               gc_sim TYPE char1 VALUE 'S'.

ENDCLASS.



CLASS ZCLMM_CL_SI_FOLHA_REGISTRO_SE1 IMPLEMENTATION.


  METHOD zclmm_ii_si_folha_registro_ser~si_folha_registro_servico_in.

    DATA: ls_frs_create TYPE zsmm_crat_frs,
          ls_frs_change TYPE zsmm_chang_frs.

    DATA: lv_sentrysheet TYPE mmpur_ses_serviceentrysheet.

    DATA(lo_reg_servico) = NEW zclmm_flh_reg_servico( ).

    " Criação da FRS
    IF input-mt_folha_registro_servico-service_sheet_sap IS INITIAL.

      ls_frs_create-serviceentrysheetname  = input-mt_folha_registro_servico-service_entry_sheet_name.
      ls_frs_create-purchaseorder          = input-mt_folha_registro_servico-purchase_order.
      ls_frs_create-postingdate            = input-mt_folha_registro_servico-posting_date.
      ls_frs_create-purchaseorderitem      = input-mt_folha_registro_servico-purchase_order_item.
      ls_frs_create-serviceperformancedate = input-mt_folha_registro_servico-service_performance_date.
      ls_frs_create-confirmedquantity      = input-mt_folha_registro_servico-confirmed_quantity.
      ls_frs_create-serviceentrysheet      = input-mt_folha_registro_servico-service_entry_sheet.
      lo_reg_servico->create_frs( EXPORTING is_frs = ls_frs_create ).

      " Modificação da FRS
    ELSEIF input-mt_folha_registro_servico-service_sheet_sap IS NOT INITIAL
       AND input-mt_folha_registro_servico-deletion_code     EQ gc_nao.

      ls_frs_change-serviceentrysheet      = input-mt_folha_registro_servico-service_sheet_sap."input-mt_folha_registro_servico-service_entry_sheet.
      ls_frs_change-serviceentrysheetname  = input-mt_folha_registro_servico-service_entry_sheet_name.
      ls_frs_change-purchaseorder          = input-mt_folha_registro_servico-purchase_order.
      ls_frs_change-postingdate            = input-mt_folha_registro_servico-posting_date.
      ls_frs_change-purchaseorderitem      = input-mt_folha_registro_servico-purchase_order_item.
      ls_frs_change-serviceperformancedate = input-mt_folha_registro_servico-service_performance_date.
      ls_frs_change-confirmedquantity      = input-mt_folha_registro_servico-confirmed_quantity.

      TRY.
          lo_reg_servico->change_frs( EXPORTING is_frs = ls_frs_change iv_sheet_me = input-mt_folha_registro_servico-service_entry_sheet ) .
        CATCH cx_mmpur_ses_missing_auth.
      ENDTRY.

      " Deletar FRS
    ELSEIF input-mt_folha_registro_servico-service_entry_sheet IS NOT INITIAL
       AND input-mt_folha_registro_servico-deletion_code       EQ gc_sim.

      lv_sentrysheet = input-mt_folha_registro_servico-service_entry_sheet.

      lo_reg_servico->delete_frs( EXPORTING is_sheet = input ).

    ENDIF.

  ENDMETHOD.
ENDCLASS.
