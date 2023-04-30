***********************************************************************
***                      © 3corações                                ***
***********************************************************************
***                                                                   *
*** DESCRIÇÃO:                                                        *
*** AUTOR    : Willian Hazor  – META                                  *
*** FUNCIONAL: Leandro – META                                      	  *
*** DATA     : 06/03/2023                                             *
***********************************************************************
*** HISTÓRICO DAS MODIFICAÇÕES                                        *
***-------------------------------------------------------------------*
*** DATA      | AUTOR        | DESCRIÇÃO                              *
***-------------------------------------------------------------------*
***           |              |                                        *
***********************************************************************
*&---------------------------------------------------------------------*
*& Include ZMMI_ESCRT_NFE_GRAOVERDE
*&---------------------------------------------------------------------*


DATA: lv_acckey   TYPE j_1b_nfe_access_key_dtel44,
      lv_authcode TYPE j_1bnfeauthcode.

IMPORT gko_acckey TO lv_acckey FROM MEMORY ID zcltm_gko_process=>gc_memory_id-acckey.

IF sy-subrc IS INITIAL.

  CALL FUNCTION 'J_1B_NFE_DATA_READ'
    IMPORTING
      es_active = ls_active.

  DATA(ls_access_key) = CONV j_1b_nfe_access_key( lv_acckey ).
  MOVE-CORRESPONDING ls_access_key TO ls_active.

  IF gbobj_header[] IS NOT INITIAL.

    SELECT SINGLE tpdoc,
                  bukrs,
                  branch,
                  dtemi,
                  hremi
      FROM zttm_gkot001
     WHERE acckey = @lv_acckey
      INTO @DATA(ls_gkot001).

    IF sy-subrc IS INITIAL.

      DATA(lo_gko_process) = NEW zcltm_gko_process( iv_acckey        = lv_acckey
                                                    iv_tpprocess     = zcltm_gko_process=>gc_tpprocess-automatico
                                                    iv_locked_in_tab = abap_true
                                                    iv_min_data_load = abap_false ).

      CASE ls_gkot001-tpdoc.
        WHEN 'CTE'.
          TRY.
              DATA(lv_xml_ref) = lo_gko_process->get_xml_from_ref_nf( iv_bukrs     = ls_gkot001-bukrs
                                                                      iv_branch    = ls_gkot001-branch
                                                                      iv_acckey    = lv_acckey
                                                                      iv_direction = 'INBD'
                                                                      iv_doctype   = CONV #( ls_gkot001-tpdoc ) ).
            CATCH cx_root.
          ENDTRY.

        WHEN 'NFE'.
          TRY.
              lv_xml_ref = lo_gko_process->get_xml_from_ref_nf( iv_bukrs     = ls_gkot001-bukrs
                                                                iv_branch    = ls_gkot001-branch
                                                                iv_acckey    = lv_acckey
                                                                iv_direction = 'OUTB'
                                                                iv_doctype   = CONV #( ls_gkot001-tpdoc ) ).
            CATCH cx_root.
          ENDTRY.

          IF lv_xml_ref IS INITIAL.
            TRY.
                lv_xml_ref = lo_gko_process->get_xml_from_ref_nf( iv_bukrs     = ls_gkot001-bukrs
                                                                  iv_branch    = ls_gkot001-branch
                                                                  iv_acckey    = lv_acckey
                                                                  iv_direction = 'INBD'
                                                                  iv_doctype   = CONV #( ls_gkot001-tpdoc ) ).
              CATCH cx_root.
            ENDTRY.
          ENDIF.

        WHEN OTHERS.
          CLEAR lv_xml_ref.

      ENDCASE.

      lv_authcode = COND #( WHEN lv_xml_ref IS NOT INITIAL
                              THEN lo_gko_process->get_value_from_xml( iv_xml        = lv_xml_ref
                                                                       iv_expression = '//*:nProt' )
                            ELSE '000000000000000' ).

      gbobj_header-authdate = ls_gkot001-dtemi.
      gbobj_header-authtime = ls_gkot001-hremi.
      gbobj_header-authcod  = lv_authcode.

      gbobj_header[ 1 ]-authdate = ls_gkot001-dtemi.
      gbobj_header[ 1 ]-authtime = ls_gkot001-hremi.
      gbobj_header[ 1 ]-authcod  = lv_authcode.

      ls_active-authdate = ls_gkot001-dtemi.
      ls_active-authtime = ls_gkot001-hremi.
      ls_active-authcod  = lv_authcode.

    ENDIF.
  ENDIF.

  ls_active-cdv     = lv_acckey+43(1).
  ls_active-docnum9 = ls_access_key-nfnum9.
  ls_active-tpemis  = ls_access_key-model.

  CALL FUNCTION 'J_1B_NFE_DATA_TRANSFER'
    EXPORTING
      is_active = ls_active.

ENDIF.
