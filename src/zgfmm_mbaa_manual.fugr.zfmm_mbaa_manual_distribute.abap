FUNCTION ZFMM_MBAA_MANUAL_DISTRIBUTE.
*"--------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     REFERENCE(IS_MSEG) TYPE  MSEG
*"     REFERENCE(IS_DM07M) TYPE  DM07M
*"     REFERENCE(IS_VM07M) TYPE  VM07M
*"     REFERENCE(IS_MKPF) TYPE  MKPF
*"     REFERENCE(IT_ACCOUNTING) TYPE  ACCOUNTING_T
*"     REFERENCE(IT_ACCOUNTING_BACK) TYPE  ACCOUNTING_T OPTIONAL
*"  EXPORTING
*"     REFERENCE(ET_ACCOUNTING) TYPE  MAA_TT_ACCOUNTING_02
*"  EXCEPTIONS
*"      BAPI_ACTIVE
*"      NO_MANUAL_DISTRIBUTION
*"      NO_MATCHING_ACCOUNTING_LINES
*"--------------------------------------------------------------------

* MAA2 : BAdI shows wrong quantity of goods received           "n1788574
* working table GT_ACCOUNTING_LINES_LOCK and some fields       "n1788574
* become obsolete because input table IT_ACCOUNTING contains   "n1788574
* the current received quantities before this posting          "n1788574

  DATA: ls_accounting_out        TYPE maa_s_accounting_line_02,
        ls_accounting_in         TYPE accounting,

        ls_makt_help             TYPE makt,
        ls_ekpo_help             TYPE ekpo,
        lv_gr_ir_difference      TYPE menge_d,
        lv_gr_surplus            TYPE menge_d,
        lv_total_open_final_quan TYPE menge_d,

        lv_aa_with_final_flag    TYPE abap_bool,
        lv_raise_no_manual_flag  TYPE abap_bool,
        lv_processing_complete   TYPE abap_bool.

  FIELD-SYMBOLS: <ls_accounting_out>  TYPE maa_s_accounting_line_02,
                 <ls_accounting_lock> TYPE maa_s_accounting_line_02,
                 <back>               TYPE accounting.          "1893687

  CLEAR: gt_accounting_lines,
         gt_accounting_lines_back,
         gv_actual_distributed,
         lv_total_open_final_quan,
         lv_aa_with_final_flag,
         lv_raise_no_manual_flag.


* in case that program has been called in background or by batch-input
* leave this FM with original distribution
  IF sy-batch EQ abap_true
   OR sy-binpt EQ abap_true.
    RAISE no_manual_distribution.
  ENDIF.

* in case BAPI has been used, leave this FM with original distribution
  CALL FUNCTION 'MB_GET_BAPI_FLAG'
    EXCEPTIONS
      bapi_not_active = 1
      OTHERS          = 2.

  IF sy-subrc EQ 0.
    RAISE bapi_active.
  ENDIF.

* in case of amount based distribution no manual distribution is allowed
  IF is_dm07m-mulko = 3.
    RAISE no_manual_distribution.
  ENDIF.

* set global debit/credit-indicator and taking RETPO-flag into consideration, too
  IF is_vm07m-retpo IS INITIAL.
    gv_shkzg = is_mseg-shkzg.
  ELSE. "in case of an RETPO PO-item, debit/credit-indicator has to be switched
    IF is_mseg-shkzg EQ 'S'.
      gv_shkzg = 'H'.
    ELSE.
      gv_shkzg = 'S'.
    ENDIF.
  ENDIF.

* Build up the UI-tables including backup table -> "old" logic
  LOOP AT it_accounting INTO ls_accounting_in
                       WHERE ebeln   = is_mseg-ebeln
                         AND ebelp   = is_mseg-ebelp
                         AND line_id = is_mseg-line_id.

    ls_accounting_out-ebeln = ls_accounting_in-ebeln.
    ls_accounting_out-ebelp = ls_accounting_in-ebelp.
    ls_accounting_out-zekkn = ls_accounting_in-zekkn.
    ls_accounting_out-cost_center = ls_accounting_in-kostl.
    ls_accounting_out-sakto = ls_accounting_in-sakto.
    ls_accounting_out-gsber = ls_accounting_in-gsber.
    ls_accounting_out-funds = ls_accounting_in-geber.
    ls_accounting_out-fistl = ls_accounting_in-fistl.
    ls_accounting_out-fkber = ls_accounting_in-fkber.
    ls_accounting_out-anln1 = ls_accounting_in-anln1.
    ls_accounting_out-anln2 = ls_accounting_in-anln2.
    ls_accounting_out-aufnr = ls_accounting_in-aufnr.
    ls_accounting_out-prctr = ls_accounting_in-prctr.
    ls_accounting_out-ps_psp_pnr = ls_accounting_in-ps_psp_pnr.
    ls_accounting_out-nplnr = ls_accounting_in-nplnr.
    ls_accounting_out-aufpl = ls_accounting_in-aufpl.
    ls_accounting_out-vbeln = ls_accounting_in-vbeln.
    ls_accounting_out-vbelp = ls_accounting_in-vbelp.
    ls_accounting_out-veten = ls_accounting_in-veten.
    ls_accounting_out-fipos = ls_accounting_in-fipos.
    ls_accounting_out-grant_nbr = ls_accounting_in-grant_nbr.
    ls_accounting_out-ordered_quantity = is_dm07m-bsmng * ls_accounting_in-share_f.
*    ls_accounting_out-invoiced_quantity = is_dm07m-remng * ls_accounting_in-share_f_ir.
*   GR-Based Invoice Verification: for GR do not consider "over"-invoiced quantities
    IF is_vm07m-webre IS NOT INITIAL
     AND is_mseg-lfbnr IS INITIAL.
      ls_accounting_out-invoiced_quantity = 0.
    ELSE.
      ls_accounting_out-invoiced_quantity = ls_accounting_in-remng.
    ENDIF.

    ls_accounting_out-final_indicator = ls_accounting_in-aa_final_ind.

    IF ls_accounting_in-aa_final_ind EQ abap_true.
      ls_accounting_out-final_quantity = ls_accounting_in-aa_final_qty.
    ELSE.
      CLEAR ls_accounting_out-final_quantity.
    ENDIF.
    ls_accounting_out-quantity = is_mseg-erfmg * ls_accounting_in-share_prop.

*   field LS_ACCOUNTING_IN-WEMNG contains the current received    "n1788574
*   quantities before this posting                                "n1788574
    ls_accounting_out-received_quantity = ls_accounting_in-wemng. "n1788574

    ls_accounting_out-zeile = is_mseg-zeile.
    ls_accounting_out-line_id = ls_accounting_in-line_id.

*   calculate IR-surplus on accounting line level for later check
*   - during a goods receipt, a open IR-surplus has to be reduced first, so this open IR-surplus'
*     have to be summed up and a possible GR-surplus is allowed to be re-distributed!
*   - during a goods issue, the GR-surplus has to be reduced first before already invoiced GRs are
*     reduced. Only if the GR-surplus is not reduced completely by the posting quantity, it can be
*     re-distributed but not more than GR-surplus on AA-level!
    lv_gr_ir_difference =  ls_accounting_out-received_quantity - ls_accounting_out-invoiced_quantity.

    IF lv_gr_ir_difference LE 0 "goods receipt
     AND gv_shkzg EQ 'S'.
      lv_gr_surplus = lv_gr_surplus + lv_gr_ir_difference. "lv_gr_surplus becomes negative in case of IR-surplus
    ELSEIF lv_gr_ir_difference GE 0 "goods issue / return delivery
     AND gv_shkzg EQ 'H'.
      lv_gr_surplus = lv_gr_surplus + lv_gr_ir_difference. "lv_gr_surplus becomes positiv in case of GR-surplus
    ENDIF.

    APPEND ls_accounting_out TO gt_accounting_lines.
    IF NOT it_accounting_back[] IS INITIAL.                     "1893687
*   for RESET we need the automatic distribution                "1893687
       READ TABLE it_accounting_back ASSIGNING <back>           "1893687
        INDEX sy-tabix.
       ls_accounting_out-quantity = is_mseg-erfmg * <back>-share_prop.
    ENDIF.                                                      "1893687
    APPEND ls_accounting_out TO gt_accounting_lines_back.

    IF ls_accounting_in-aa_final_ind EQ abap_true.
      lv_total_open_final_quan = lv_total_open_final_quan + ( ls_accounting_in-aa_final_qty - ls_accounting_out-received_quantity ).
      lv_aa_with_final_flag = abap_true.
    ENDIF.

    CLEAR ls_accounting_out.
  ENDLOOP.

  IF sy-subrc NE 0.
    RAISE no_matching_accounting_lines.
  ENDIF.

  IF gv_shkzg EQ 'S'.
*   check, if there is a GR-surplus on position level, if only IR surplus no manual distribution allowed
    lv_gr_surplus = lv_gr_surplus + is_mseg-erfmg.
    IF lv_gr_surplus LE 0.
*      lv_raise_no_manual_flag = abap_true.
    ENDIF.

*   No manual distribution if the entry quantity is completely used for filling up the final flagged AA-lines
    IF lv_aa_with_final_flag EQ abap_true
     AND is_mseg-erfmg LE lv_total_open_final_quan.
*      lv_raise_no_manual_flag = abap_true.
    ENDIF.
  ELSE.
*   check, if there is a remaining GR-surplus on position level,
*   if IR surplus will occur, no manual distribution allowed
    lv_gr_surplus = lv_gr_surplus - is_mseg-erfmg.
    IF lv_gr_surplus LE 0.
*      lv_raise_no_manual_flag = abap_true.
    ENDIF.
  ENDIF.

* only if no error shall be risen, call the dynpro
  IF lv_raise_no_manual_flag EQ abap_false.
    gv_ebeln = is_mseg-ebeln.
    gv_ebelp = is_mseg-ebelp.
    gv_mseg_zeile = is_mseg-zeile.
    IF gv_mseg_zeile IS INITIAL.                                "1893687
      MOVE is_mseg-line_id TO gv_mseg_zeile.                    "1893687
    ENDIF.                                                      "1893687
    gv_twrkz = is_dm07m-twrkz.
    gv_bwart = is_mseg-bwart.
    gv_retpo = is_vm07m-retpo.

    CALL FUNCTION 'MICK_MOVE_TEXT_READ'
      EXPORTING
        i_move_type = gv_bwart
      IMPORTING
        e_move_text = gv_bwtxt.

    IF is_mseg-shkzg EQ 'S'.
      gv_shkzg_migo = '+'.
    ELSE.
      gv_shkzg_migo = '-'.
    ENDIF.

    gv_mseg_erfmg = gv_actual_distributed = is_mseg-erfmg.
    gv_actual_distributed_unit = gv_mseg_erfme = is_mseg-erfme.
    gv_matnr = is_mseg-matnr.

*   get material desription
    IF gv_matnr IS NOT INITIAL.
*     use material number in order get the description
      CALL FUNCTION 'MAKT_SINGLE_READ'
        EXPORTING
          matnr      = gv_matnr
          spras      = sy-langu
        IMPORTING
          wmakt      = ls_makt_help
        EXCEPTIONS
          wrong_call = 1
          not_found  = 2
          OTHERS     = 3.

      IF sy-subrc <> 0.
        CLEAR gv_matnr_short_descr.
      ELSE.
        gv_matnr_short_descr = ls_makt_help-maktx.
      ENDIF.
    ELSE.
*     no material number in purchase order, so get the text form the corresponding purchase order item
      CALL FUNCTION 'ME_EKPO_SINGLE_READ'
        EXPORTING
          pi_ebeln         = gv_ebeln
          pi_ebelp         = gv_ebelp
        IMPORTING
          po_ekpo          = ls_ekpo_help
        EXCEPTIONS
          no_records_found = 1
          OTHERS           = 2.

      IF sy-subrc EQ 0.
        gv_matnr_short_descr = ls_ekpo_help-txz01.
      ELSE.
        CLEAR gv_matnr_short_descr.
      ENDIF.
    ENDIF.

*   due to certain system messages during standard field import validation it's necessary to put the
*   the Dynpro-call into a function module so that it can be caught and brought onto the Dynpro
    WHILE lv_processing_complete EQ abap_false.
      CALL FUNCTION 'ZFMM_MBAA_MANUAL_DISTR_CALL_SC'
        EXCEPTIONS
          error_message = 1
          OTHERS        = 2.

      IF sy-subrc EQ 0.
        lv_processing_complete = abap_true.
      ELSE.
        CLEAR gt_messages.
        gs_message-id   = sy-msgid.
        gs_message-type = sy-msgty.
        gs_message-number = sy-msgno.
        gs_message-message_v1 = sy-msgv1.
        gs_message-message_v2 = sy-msgv2.
        gs_message-message_v3 = sy-msgv3.
        gs_message-message_v4 = sy-msgv4.

        APPEND gs_message TO gt_messages.
        CLEAR: gs_message.
      ENDIF.
    ENDWHILE.

  ENDIF. "no error shall be risen before dynpro call

* update of internal lock table GT_ACCOUNTING_LINES_LOCK obselete "n1788574

  IF lv_raise_no_manual_flag EQ abap_true.
    RAISE no_manual_distribution.
  ENDIF.

  et_accounting = gt_accounting_lines.

ENDFUNCTION.
