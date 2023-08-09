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


DATA: lv_acckey             TYPE j_1b_nfe_access_key_dtel44,
      lv_authcode           TYPE j_1bnfeauthcode,
      ls_lanca_conhecimento TYPE ztmm_lanca_con.

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

* BEGIN OF INSERT - JWSILVA -02.08.2023
      " Tratativa para hora em branco
      ls_gkot001-hremi = COND #( WHEN ls_gkot001-hremi NE '000000'
                                 THEN ls_gkot001-hremi
                                 ELSE '000001').
* END OF INSERT - JWSILVA -02.08.2023

      TRY.
          DATA(lo_gko_process) = NEW zcltm_gko_process( iv_acckey        = lv_acckey
                                                        iv_tpprocess     = zcltm_gko_process=>gc_tpprocess-automatico
                                                        iv_locked_in_tab = abap_true
                                                        iv_min_data_load = abap_false ).
        CATCH cx_root.
      ENDTRY.

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

      TRY.
          lv_authcode = COND #( WHEN lv_xml_ref IS NOT INITIAL
                                THEN lo_gko_process->get_value_from_xml( iv_xml        = lv_xml_ref
                                                                         iv_expression = '//*:nProt' )
                                ELSE '000000000000000' ).
        CATCH cx_root.
      ENDTRY.

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

  IF ls_gkot001 IS INITIAL.
    SELECT SINGLE * FROM ztmm_lanca_con
      INTO @ls_lanca_conhecimento
      WHERE acckey EQ @lv_acckey.
    IF ls_lanca_conhecimento IS NOT INITIAL.
      gbobj_header-authdate = ls_lanca_conhecimento-authdate.
      gbobj_header-authtime = ls_lanca_conhecimento-authtime.
      gbobj_header-authcod  = ls_lanca_conhecimento-authcod.

      gbobj_header[ 1 ]-authdate = ls_lanca_conhecimento-authdate.
      gbobj_header[ 1 ]-authtime = ls_lanca_conhecimento-authtime.
      gbobj_header[ 1 ]-authcod  = ls_lanca_conhecimento-authcod.

      ls_active-authdate = ls_lanca_conhecimento-authdate.
      ls_active-authtime = ls_lanca_conhecimento-authtime.
      ls_active-authcod  = ls_lanca_conhecimento-authcod.

      ls_active-cdv     = ls_access_key-cdv.
      ls_active-docnum9 = ls_access_key-docnum9.
      ls_active-tpemis  = 1 .
    ENDIF.
  ENDIF.

  CALL FUNCTION 'J_1B_NFE_DATA_TRANSFER'
    EXPORTING
      is_active = ls_active.

ENDIF.
