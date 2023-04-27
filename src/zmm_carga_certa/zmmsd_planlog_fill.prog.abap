*&---------------------------------------------------------------------*
*& Report ZMMSD_PLANLOG_FILL
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zmmsd_planlog_fill.


************************************************************************
*  TYPES
************************************************************************
TYPES: BEGIN OF ty_varid,
         report  TYPE varid-report,
         variant TYPE varid-variant,
       END OF ty_varid,

       BEGIN OF ty_variante,
         posicao TYPE zemm_posicao,
         tcode   TYPE sy-tcode,
         variant TYPE varid-variant,
       END OF ty_variante.

DATA: BEGIN OF v,
        string  TYPE string,
        outfile LIKE rlgrap-filename VALUE 'c:\temp\tempexample.txt',
        n       TYPE i,
        typ(1)  TYPE c,
      END OF v.

************************************************************************
*  CONSTANTES
************************************************************************
DATA: gc_ztranicmsnfe       TYPE sy-cprog   VALUE 'ZTRANSICMS_A',
      gc_mb52               TYPE sy-cprog   VALUE 'RM07MLBS',
      gc_zwmsconfprod       TYPE sy-cprog   VALUE 'ZWMS_CONF_PRODUTOS',
      gc_zsdr319            TYPE sy-cprog   VALUE 'AQICABAP========REL_ESTOQUES==',
      gc_zsdr319_prd        TYPE sy-cprog   VALUE 'AQICSYSTQV000003REL_ESTOQUES==',
      gc_zsdr345            TYPE sy-cprog   VALUE 'ZSDR294',
      gc_tcode_ztranicmsnfe TYPE sy-tcode   VALUE 'ZTRANICMSNFE',
      gc_tcode_mb52         TYPE sy-tcode   VALUE 'MB52',
      gc_tcode_zwmsconfprod TYPE sy-tcode   VALUE 'ZWMSCONFPROD',
      gc_tcode_zsdr319      TYPE sy-tcode   VALUE 'ZSDR319',
      gc_tcode_zsdr345      TYPE sy-tcode   VALUE 'ZSDR345',
      gc_scd                TYPE syst_sysid VALUE 'SCD',
      gc_scq                TYPE syst_sysid VALUE 'SCQ',
      gc_e                  TYPE c          VALUE 'E',
      gc_s                  TYPE c          VALUE 'S',
      gc_eq(2)              TYPE c          VALUE 'EQ',
      gc_i                  TYPE c          VALUE 'I',
      gc_pon_vir            TYPE c          VALUE ';'.

************************************************************************
*  TABELAS
************************************************************************
DATA: gt_varid     TYPE TABLE OF ty_varid,
      gt_variante  TYPE TABLE OF ty_variante,
      gt_return    TYPE TABLE OF ddshretval,
      gt_dyn_table TYPE REF TO data.

************************************************************************
*  ESTRUTURAS
************************************************************************
DATA: gs_variante TYPE ty_variante,
      gs_ref      TYPE REF TO data,
      gs_metadata TYPE cl_salv_bs_runtime_info=>s_type_metadata,
      gs_alv      TYPE REF TO data.

************************************************************************
*  VARIAVEIS
************************************************************************
DATA: gv_soma_pos TYPE i,
      gv_file     TYPE rlgrap-filename,
      gv_prognam  TYPE sy-repid.

************************************************************************
*  RANGES
************************************************************************
DATA: r_transaction  TYPE RANGE OF varid-report,
      rl_transaction LIKE LINE OF r_transaction.

************************************************************************
*  FIELD-SYMBOLS
************************************************************************
FIELD-SYMBOLS: <fs_varid>     TYPE ty_varid,
               <fs_variante>  TYPE ty_variante,
               <fs_field>     TYPE any,
               <fs_deriva>    TYPE any,
               <fs_dyn_table> TYPE STANDARD TABLE,
               <gt_deriva>    TYPE STANDARD TABLE.

rl_transaction-option = gc_eq.
rl_transaction-sign   = gc_i.

rl_transaction-low    =  gc_ztranicmsnfe.
APPEND rl_transaction TO r_transaction.

rl_transaction-low    =  gc_mb52.
APPEND rl_transaction TO r_transaction.

rl_transaction-low    =  gc_zsdr319.
APPEND rl_transaction TO r_transaction.

rl_transaction-low    =  gc_zwmsconfprod.
APPEND rl_transaction TO r_transaction.

rl_transaction-low    =  gc_zsdr345.
APPEND rl_transaction TO r_transaction.

rl_transaction-low = 'ZCO3_MENU'.
APPEND rl_transaction TO r_transaction.


DATA: ls_planlog TYPE ztmmsd_planlog,
      lt_planlog TYPE TABLE OF ztmmsd_planlog.


"Seleciona as variantes
SELECT report variant
  FROM varid
  INTO TABLE gt_varid
  WHERE report IN r_transaction.

IF sy-subrc IS INITIAL .
  SORT gt_varid BY report.

  LOOP AT gt_varid ASSIGNING <fs_varid>.
    ls_planlog-report = <fs_varid>-report.
    ls_planlog-variant = <fs_varid>-variant.
    APPEND ls_planlog TO lt_planlog.


  ENDLOOP.
  DELETE FROM ztmmsd_planlog.
  MODIFY ztmmsd_planlog FROM TABLE lt_planlog.

ENDIF.
