*&---------------------------------------------------------------------*
*& Include ZMME_GR_CUST_DEPOSITO_FECHADO
*&---------------------------------------------------------------------*

 CONSTANTS: lc_bwart TYPE mseg-bwart VALUE '861'.

 IF lv_flag_read_no_po_data = abap_false.                   "n1617736
*   the PO item data have to be read                        "n1617736
*   carry out this function module as usual
   IF l_shkzg IS INITIAL.                                  "2053350   "2055525 ->
     l_shkzg = b_shkzg.                                     "2053350
   ENDIF.                                                  "2053350   "2055525 <-
* Interface with actual data for Service Procurement
   CLEAR ls_imseg.

   IF gt_imseg_srv IS NOT INITIAL.
     READ TABLE gt_imseg_srv INTO ls_imseg
                         WITH KEY line_id = mseg-line_id.
   ENDIF.

*   Add BP for debugging control                                "2520449
   def_break 'ME_READ_ITEM_GOODS_RECEIPT'.                  "#EC *

   CALL FUNCTION 'ME_READ_ITEM_GOODS_RECEIPT'
     EXPORTING
       ebeln              = b_ebeln
       ebelp              = b_ebelp
       i_werks            = b_werks
       kzwes              = b_kzwes
       lfbnr              = b_lfbnr
       lfgja              = b_lfbja
       lfpos              = b_lfpos
*      shkzg              = b_shkzg                                         "2055525 ->
       shkzg              = l_shkzg                         "2053350  "2055525 <-
       i_vbeln            = h_liefk
       i_vbelp            = rm07m-vbelp
       budat              = mkpf-budat
       xebefu_flag        = xebefu_flag
       display            = vw
       xstor              = e_xstor
       xfbcall            = xmbwl
       i_kurstyp          = t003-kurst
       i_smbln            = l_mblnr
       i_smblp            = l_mblpo
       i_sjahr            = l_mjahr
       i_bldat            = mkpf-bldat
       i_pabnum           = wueb-pabnum
       i_pabpos           = wueb-pabpos
       i_pkkey            = wueb-pkkey
* ---Begin Application Component: IS-A, Switch: DIMP-GENERAL General funct. DIMP Industries----*
* Übergabe Anlieferungsposition Für Prüfung Mengenabruf bei WE zu ASN
       i_vbeln_asn        = wueb-vbeln
       i_posnr_asn        = wueb-vbelp
* ---End Application Component: IS-A, Switch: DIMP-GENERAL General funct. DIMP Industries----*
       i_welfbnr          = b_nachl
       i_etens            = vm07m-etens
       i_process          = l_sc_comp
       i_gr_charg         = mseg-charg
       i_gr_erfmg         = mseg-erfmg
       i_gr_erfme         = mseg-erfme
       i_gr_bpmng         = mseg-bpmng
       i_read_for_cancel  = read_for_cancel
       i_gr_line          = mseg-zeile                     "VB
       is_imseg           = ls_imseg
       i_gr_po            = l_gr_po                         "2377796
     IMPORTING
       e_fcode            = i_ok_code
       e_mblmg            = dm07m-mblmg
       e_mblbm            = dm07m-mblbm
     TABLES
       xebefu             = xebefu
       xekbnk             = xekbnk
       xekbnk_kdm         = xekbnk_kdm                     "N1027899
       teksel             = xeksel
       xebefu_cr          = xebefu_cr
       xekbnk_cr          = xekbnk_cr
       xaccounting        = lt_accounting            "MAA-DEV
       xaccounting_dc     = lt_accounting_dc         "MAA-DEV
       xaccounting_cr     = lt_accounting_cr         "MAA-DEV
       xaccounting_dc_cr  = lt_accounting_dc_cr      "MAA-DEV
       xaccounting_srv    = xaccounting_srv                "MAA2
       xaccounting_srv_cr = xaccounting_srv_cr             "MAA2
     CHANGING
       c_conf             = any_confirmation
     EXCEPTIONS
       not_found_any      = 01       "ohne Pos - keinen gefun.
       not_found_one      = 02       "mit Pos - Pos nicht da
       not_valid_any      = 03       "ohne Pos - keine guelt.
       not_valid_one      = 04.      "mit Pos - Pos nicht gültig

*   save SY-SUBRC set by ME_READ_ITEM_GOODS_RECEIPT            "n1617736
   MOVE : sy-subrc          TO  lv_subrc_save.              "n1617736
 ENDIF.                                                     "n1617736

 IF mseg-ebeln IS NOT INITIAL
AND mseg-bwart = lc_bwart.

   SELECT COUNT( * )
     FROM ztmm_his_dep_fec
    WHERE out_sales_order       = mseg-ebeln
      AND out_sales_order_item  = mseg-ebelp
      AND material              = mseg-matnr
      AND plant_dest            = mseg-werks
      AND storage_location_dest = mseg-lgort.            "#EC CI_STDSEQ

   IF sy-subrc IS INITIAL.
     CLEAR xebefu-wabwe.
   ENDIF.

 ENDIF.
