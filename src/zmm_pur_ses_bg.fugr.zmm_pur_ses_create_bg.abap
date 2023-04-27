FUNCTION zmm_pur_ses_create_bg.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(IS_DATA_FIELDS) TYPE  MMPUR_SES_UPL_ADDITIONAL_DATA
*"       OPTIONAL
*"  EXPORTING
*"     VALUE(EV_SES) TYPE  MMPUR_SES_SERVICEENTRYSHEET
*"  TABLES
*"      IT_HEADER TYPE  MMPUR_SES_UPL_HEADER_TTY
*"      IT_ITEM TYPE  MMPUR_SES_UPL_ITEM_TTY
*"      IT_ACCOUNT_ASSIGNMENT TYPE  MMPUR_SES_UPL_ACC_ASS_TTY
*"----------------------------------------------------------------------

  DATA: lt_header             TYPE cl_mm_pur_ses_upload=>ty_t_header,
        lt_item               TYPE cl_mm_pur_ses_upload=>ty_t_item,
        lt_account_assignment TYPE cl_mm_pur_ses_upload=>ty_t_account_assignment,
        lv_only_create(1).


  INSERT LINES OF it_header             INTO TABLE lt_header.
  INSERT LINES OF it_item               INTO TABLE lt_item.
  INSERT LINES OF it_account_assignment INTO TABLE lt_account_assignment.

  lv_only_create = 'X'.

  EXPORT lv_only_create FROM lv_only_create TO MEMORY ID 'ZMM_ONLY_CREATE'. "IMPORT Classe CL_MM_PUR_SES_UPLOAD, Método SUBMIT_FOR_APPROVAL

  TRY.
      cl_mm_pur_ses_upload=>create_ses( EXPORTING it_header             = lt_header
                                                  it_items              = lt_item
                                                  it_account_assignment = lt_account_assignment
                                                  is_data_fields        = is_data_fields ).

      IMPORT IV_SES TO EV_SES FROM MEMORY ID 'ZMM_SES'. "EXPORT Classe CL_MM_PUR_SES_UPLOAD, Método SUBMIT_FOR_APPROVAL

    CATCH cx_mm_pur_ses_upload INTO DATA(lo_exc).
      RAISE SHORTDUMP lo_exc. "should never happen
  ENDTRY.

  FREE MEMORY ID: 'ZMM_ONLY_CREATE',
                  'ZMM_SES'.
ENDFUNCTION.
