FUNCTION-POOL ZGFMM_MBAA_MANUAL.                  "MESSAGE-ID ..

* MAA2 : BAdI shows wrong quantity of goods received           "n1788574
* working field deleted which become obsolete                  "n1788574

DATA: gt_accounting_lines        TYPE maa_tt_accounting_02,
      gs_accounting_line         TYPE maa_s_accounting_line_02,

      gt_accounting_lines_back   TYPE maa_tt_accounting_02,

      gv_mseg_erfmg              TYPE erfmg,
      gv_mseg_erfme              TYPE erfme,
      gv_actual_distributed      TYPE erfmg,
      gv_actual_distributed_unit TYPE erfme,
      gv_matnr                   TYPE matnr,
      gv_matnr_short_descr       TYPE maktx,

      gv_ebeln                   TYPE ebeln,
      gv_ebelp                   TYPE ebelp,
      gv_mseg_zeile              TYPE mblpo,
      gv_shkzg                   TYPE shkzg,
      gv_twrkz                   TYPE twrkz,
      gv_bwart                   TYPE bwart,
      gv_bwtxt                   TYPE bwtxt,
      gv_shkzg_migo              TYPE shkzg_migo,
      gv_retpo                   TYPE retpo,

      gt_messages                TYPE bapirettab,
      gs_message                 TYPE bapiret2.


*&SPWIZARD: DECLARATION OF TABLECONTROL 'ACCOUNTING_DATA' ITSELF
CONTROLS: accounting_data TYPE TABLEVIEW USING SCREEN 0100.
FIELD-SYMBOLS: <column> TYPE scxtab_column.

*&SPWIZARD: LINES OF TABLECONTROL 'ACCOUNTING_DATA'
DATA:     g_accounting_data_lines  LIKE sy-loopc.           "#EC NEEDED

DATA:     ok_code LIKE sy-ucomm.
