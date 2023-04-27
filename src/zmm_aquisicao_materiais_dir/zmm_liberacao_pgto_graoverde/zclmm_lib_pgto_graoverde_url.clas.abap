class ZCLMM_LIB_PGTO_GRAOVERDE_URL definition
  public
  final
  create public .

public section.

  interfaces IF_SADL_EXIT .
  interfaces IF_SADL_EXIT_CALC_ELEMENT_READ .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCLMM_LIB_PGTO_GRAOVERDE_URL IMPLEMENTATION.


  METHOD if_sadl_exit_calc_element_read~calculate.

    CONSTANTS: lc_param_doc     TYPE ihttpnam VALUE 'PurchaseOrder',
               lc_object_doc    TYPE char30   VALUE 'PurchaseOrder2',
               lc_action_doc    TYPE char60   VALUE 'display',
               lc_param_nf      TYPE ihttpnam VALUE 'BR_NotaFiscal',
               lc_object_nf     TYPE char30   VALUE 'NotaFiscal',
               lc_action_nf     TYPE char60   VALUE 'display',
               lc_param1_abas   TYPE ihttpnam VALUE 'AccountingDocument',
               lc_param2_abas   TYPE ihttpnam VALUE 'CompanyCode',
               lc_param3_abas   TYPE ihttpnam VALUE 'FiscalYear',
               lc_object_abas   TYPE char30   VALUE 'AccountingDocument',
               lc_action_abas   TYPE char60   VALUE 'manage'.

    CHECK NOT it_original_data IS INITIAL.

    CHECK NOT it_requested_calc_elements IS INITIAL.

    DATA: lt_data TYPE ty_table_data.
    MOVE-CORRESPONDING it_original_data TO lt_data.

    DATA(lt_parameters) = VALUE tihttpnvp( ).

    LOOP AT lt_data ASSIGNING FIELD-SYMBOL(<fs_calculated>).

      FREE: lt_parameters[].

      "Navegação do cabeçalho
      IF <fs_calculated>-numdocumento IS NOT INITIAL AND <fs_calculated>-tipodocumento IS INITIAL AND <fs_calculated>-item IS INITIAL.
          APPEND VALUE #( name  = lc_param_doc value = <fs_calculated>-numdocumento ) TO lt_parameters.
          <fs_calculated>-url_numdocumento = cl_lsapi_manager=>create_flp_url( object = lc_object_doc action = lc_action_doc parameters = lt_parameters ).
      ENDIF.
      "Navegação dos itens/outras abas
      IF <fs_calculated>-numdocumento IS NOT INITIAL AND <fs_calculated>-tipodocumento IS NOT INITIAL AND <fs_calculated>-item IS NOT INITIAL.
          APPEND VALUE #( name = lc_param1_abas value = <fs_calculated>-NumDocumento ) TO lt_parameters.
          APPEND VALUE #( name = lc_param2_abas value = <fs_calculated>-Empresa ) TO lt_parameters.
          APPEND VALUE #( name = lc_param3_abas value = <fs_calculated>-Ano ) TO lt_parameters.
          <fs_calculated>-url_numdocumento = cl_lsapi_manager=>create_flp_url( object = lc_object_abas action = lc_action_abas parameters = lt_parameters ).
      ENDIF.

      IF <fs_calculated>-docnumfinanceiro IS NOT INITIAL.
        APPEND VALUE #( name  = lc_param_nf value = <fs_calculated>-docnumfinanceiro ) TO lt_parameters.
        <fs_calculated>-url_docnumfinanceiro = cl_lsapi_manager=>create_flp_url( object = lc_object_nf action = lc_action_nf parameters = lt_parameters ).
      ENDIF.

      IF <fs_calculated>-docnumcomercial IS NOT INITIAL.
        APPEND VALUE #( name  = lc_param_nf value = <fs_calculated>-docnumcomercial ) TO lt_parameters.
        <fs_calculated>-url_doccontabilcomercial = cl_lsapi_manager=>create_flp_url( object = lc_object_nf action = lc_action_nf parameters = lt_parameters ).
      ENDIF.


    ENDLOOP.


    MOVE-CORRESPONDING lt_data TO ct_calculated_data.

*    DATA lt_calculated_data TYPE STANDARD TABLE OF zc_mm_lib_pgto_app WITH DEFAULT KEY.
*    DATA lt_calculated_data_des_fin_com TYPE STANDARD TABLE OF zc_mm_lib_pgto_des_fin_com WITH DEFAULT KEY.
*    DATA lt_calculated_data_fat TYPE STANDARD TABLE OF zc_mm_lib_pgto_fat WITH DEFAULT KEY.
*    DATA lt_calculated_data_adi TYPE STANDARD TABLE OF zc_mm_lib_pgto_adi WITH DEFAULT KEY.
*    DATA lt_calculated_data_dev TYPE STANDARD TABLE OF zc_mm_lib_pgto_dev WITH DEFAULT KEY.
*    DATA lt_calculated_data_des TYPE STANDARD TABLE OF zc_mm_lib_pgto_des WITH DEFAULT KEY.
*
*    MOVE-CORRESPONDING it_original_data TO lt_calculated_data.
*    MOVE-CORRESPONDING it_original_data TO lt_calculated_data_des_fin_com.
*    MOVE-CORRESPONDING it_original_data TO lt_calculated_data_fat.
*    MOVE-CORRESPONDING it_original_data TO lt_calculated_data_adi.
*    MOVE-CORRESPONDING it_original_data TO lt_calculated_data_dev.
*    MOVE-CORRESPONDING it_original_data TO lt_calculated_data_des.
*
*    DATA(lt_parameters) = VALUE tihttpnvp( ).
*
*    LOOP AT lt_calculated_data ASSIGNING FIELD-SYMBOL(<fs_calculated>) WHERE NumDocumento IS NOT INITIAL.
*
*      FREE: lt_parameters[].
*      APPEND VALUE #( name  = lc_param_doc
*                      value = <fs_calculated>-NumDocumento ) TO lt_parameters.
*      <fs_calculated>-URL_NumDocumento = cl_lsapi_manager=>create_flp_url( object     = lc_object_doc
*                                                                           action     = lc_action_doc
*                                                                           parameters = lt_parameters ).
*
*    ENDLOOP.
*
*
*    LOOP AT lt_calculated_data_des_fin_com ASSIGNING FIELD-SYMBOL(<fs_calculated_des>) WHERE docnumfinanceiro IS NOT INITIAL OR docnumcomercial IS NOT INITIAL.
*
*      FREE: lt_parameters[].
*
*      IF <fs_calculated_des>-docnumfinanceiro IS NOT INITIAL.
*
*        APPEND VALUE #( name  = lc_param_nf
*                        value = <fs_calculated_des>-docnumfinanceiro ) TO lt_parameters.
*
*        <fs_calculated_des>-docnumfinanceiro = cl_lsapi_manager=>create_flp_url( object     = lc_object_nf
*                                                                                 action     = lc_action_nf
*                                                                                 parameters = lt_parameters ).
*      ELSEIF <fs_calculated_des>-docnumcomercial IS NOT INITIAL.
*        APPEND VALUE #( name  = lc_param_nf
*                        value = <fs_calculated_des>-docnumcomercial ) TO lt_parameters.
*
*        <fs_calculated_des>-docnumcomercial = cl_lsapi_manager=>create_flp_url( object      = lc_object_nf
*                                                                                action      = lc_action_nf
*                                                                                parameters  = lt_parameters ).
*      ENDIF.
*
*    ENDLOOP.
*
*    LOOP AT lt_calculated_data_fat ASSIGNING FIELD-SYMBOL(<fs_calculated_fat>) WHERE NumDocumento IS NOT INITIAL.
*
*      FREE: lt_parameters[].
*
*      APPEND VALUE #( name = lc_param1_abas value = <fs_calculated_fat>-NumDocumento ) TO lt_parameters.
*      APPEND VALUE #( name = lc_param2_abas value = <fs_calculated_fat>-Empresa ) TO lt_parameters.
*      APPEND VALUE #( name = lc_param3_abas value = <fs_calculated_fat>-Ano ) TO lt_parameters.
*
*      <fs_calculated_fat>-URL_NumDocumento = cl_lsapi_manager=>create_flp_url( object     = lc_object_abas
*                                                                               action     = lc_action_abas
*                                                                               parameters = lt_parameters ).
*
*    ENDLOOP.
*
*
*    MOVE-CORRESPONDING lt_calculated_data TO ct_calculated_data.
*    MOVE-CORRESPONDING lt_calculated_data_des_fin_com TO ct_calculated_data.

  ENDMETHOD.


  METHOD if_sadl_exit_calc_element_read~get_calculation_info.
    RETURN.
  ENDMETHOD.
ENDCLASS.
