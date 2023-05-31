*&---------------------------------------------------------------------*
*& Report YPOC_PR_MASSUPD
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zmm_massupd.

TABLES: eban.

TYPES: BEGIN OF ty_eban,
         banfn        TYPE banfn,
         bnfpo        TYPE bnfpo,
         estkz        TYPE estkz,
         frgzu        TYPE frgzu,
         loekz        TYPE loekz,
         banpr        TYPE banpr,
         lfdat        TYPE lfdat,
         creationdate TYPE creationdate,
       END OF ty_eban.

DATA: wa_eban TYPE ty_eban,
      it_eban TYPE TABLE OF ty_eban.

SELECT-OPTIONS: s_banfn FOR wa_eban-banfn,
s_crtdat FOR wa_eban-creationdate.
PARAMETERS: p_teste TYPE testrun DEFAULT abap_true.

* SELECT * FROM eban
* INTO CORRESPONDING FIELDS OF TABLE it_eban
* WHERE banfn IN s_banfn.

SELECT * FROM eban
 INTO CORRESPONDING FIELDS OF TABLE it_eban
 WHERE ( estkz = 'B' OR estkz = 'U' )
 AND frgzu = ''
 AND loekz = ''
 AND banpr = '02'
 AND banfn IN s_banfn
 AND creationdate IN s_crtdat.

IF p_teste = abap_true.

  PERFORM f_exibir_tabela USING it_eban.

ELSE.

  PERFORM atualizar_dados.

ENDIF.

*&---------------------------------------------------------------------*
*&      Form ATUALIZAR_DADOS
*&---------------------------------------------------------------------*
FORM atualizar_dados.
  LOOP AT it_eban INTO wa_eban.
    DATA: ls_start_info TYPE cl_apj_rt_job_scheduling_api=>ty_start_info.

    DATA: ls_parameters TYPE if_apj_rt_types=>tt_job_parameter_value.
    DATA: wa_parameter TYPE if_apj_rt_types=>ty_job_parameter_value.

*  DATA: ls_range TYPE if_apj_rt_types=>tt_value_range.

    DATA: r_xis TYPE  if_apj_rt_types=>tt_value_range.
    DATA: r_inclsn TYPE  if_apj_rt_types=>tt_value_range.
    DATA: r_select TYPE  if_apj_rt_types=>tt_value_range.
    DATA: r_comm TYPE  if_apj_rt_types=>tt_value_range.
    DATA: r_lfdat TYPE  if_apj_rt_types=>tt_value_range.
    DATA: lv_aux TYPE lfdat.

    ls_start_info-start_immediately = abap_true.
*  ls_range = VALUE #( ( sign = 'I' option = 'EQ' low = '321' high = '' ) ).


    r_xis    = VALUE #( ( sign = 'I' option = 'EQ' low = 'X' high = '' ) ).
    r_inclsn = VALUE #( ( sign = 'I' option = 'EQ' low = |{ wa_eban-banfn }/{ wa_eban-bnfpo }| ) ).
    r_select = VALUE #( ( sign = 'I' option = 'EQ' low = ' ' ) ).
    r_comm   = VALUE #( ( sign = 'I' option = 'EQ' low = 'Job modificação em massa' ) ).
    lv_aux = wa_eban-lfdat - 1.
    r_lfdat  = VALUE #( ( sign = 'I' option = 'EQ' low = lv_aux ) ).

    ls_parameters = VALUE #(
     ( name = 'S_INCLSN' t_value = r_inclsn )
     ( name = 'P_SELECT' t_value = r_select )
     ( name = 'P_COMM'   t_value = r_comm )
     ( name = 'P_COMMX'  t_value = r_xis )
     ( name = 'P_LFDAT'  t_value = r_lfdat )
     ( name = 'P_LFDATX'  t_value = r_xis )
    ).

    TRY.
        CALL METHOD cl_apj_rt_job_scheduling_api=>schedule_job
          EXPORTING
            iv_job_template_name   = 'SAP_MM_PUR_MASSPRBG_T'
            iv_job_text            = |Modificação na RC { wa_eban-banfn } no item { wa_eban-bnfpo }|
            is_start_info          = ls_start_info
*           is_end_info            =
*           is_scheduling_info     =
            it_job_parameter_value = ls_parameters
*           iv_adjust_start_info   =
            iv_username            = sy-uname
*           iv_test_mode           =
          IMPORTING
            et_message             = DATA(lt_messages)
            es_job_details         = DATA(ts_job_details).


*        cl_demo_output=>write( lt_messages ).
*        cl_demo_output=>write( ts_job_details ).
*        cl_demo_output=>display( ).
        WRITE:/ |Modificação na RC { wa_eban-banfn } no item { wa_eban-bnfpo }|.

      CATCH cm_apj_base.
*        cl_demo_output=>write( 'Catch' ).
*        cl_demo_output=>display( ).
    ENDTRY.
  ENDLOOP.
ENDFORM.

*&---------------------------------------------------------------------*
*&      Form EXIBIR_TABELA
*&---------------------------------------------------------------------*
FORM f_exibir_tabela USING ut_tabela TYPE any .
  DATA: lr_table     TYPE REF TO cl_salv_table.

  TRY.
      cl_salv_table=>factory( IMPORTING r_salv_table = lr_table
                              CHANGING t_table = ut_tabela ).
    CATCH cx_salv_msg  ##NO_HANDLER.
  ENDTRY.

  DATA: lr_functions  TYPE REF TO cl_salv_functions_list,
        lr_display    TYPE REF TO cl_salv_display_settings,
        lr_selections TYPE REF TO cl_salv_selections.

  lr_functions = lr_table->get_functions( ).
  lr_functions->set_all( abap_true ).

  lr_display = lr_table->get_display_settings( ).
  lr_display->set_striped_pattern( abap_true ).

  lr_selections = lr_table->get_selections( ).
  lr_selections->set_selection_mode( if_salv_c_selection_mode=>cell ).

*... §4 set layout
  DATA: lr_layout TYPE REF TO cl_salv_layout,
        ls_key    TYPE salv_s_layout_key.

  lr_layout = lr_table->get_layout( ).

*... §4.1 set the Layout Key
  ls_key-report = sy-repid.
  lr_layout->set_key( ls_key ).


*... §4.2 set usage of default Layouts
*  lr_layout->set_default( gs_test-default ).

*... §4.3 set Layout save restriction
  lr_layout->set_save_restriction( cl_salv_layout=>restrict_none ).

*  lr_sel_mult  = lr_table->get_selections( ).
*  lr_sel_mult->set_selection_mode( if_salv_c_selection_mode=>row_column ).

  lr_table->display( ).

ENDFORM.
