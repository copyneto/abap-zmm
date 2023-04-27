*&---------------------------------------------------------------------*
*& Include          ZMMI_JOB_3C_NF_FATURADA_TOP
*&---------------------------------------------------------------------*
TYPES: BEGIN OF ty_tipo,
         doctype     TYPE zi_mm_3c_vh_doc_type-doctype,
         doctypetext TYPE zi_mm_3c_vh_doc_type-doctypetext,
       END OF ty_tipo.

DATA: gt_return TYPE TABLE OF bapiret2,
      gt_tipo   TYPE TABLE OF ty_tipo.


CONSTANTS:
  BEGIN OF gc_upld,
    default_extension TYPE string VALUE '*.txt|*.csv|*.*',
    file_filter       TYPE string VALUE ' TXT (*.txt)|*.txt| CSV(*.csv)|*.csv| Todas(*.*)|*.* ' ##NO_TEXT,
  END OF gc_upld,
  BEGIN OF gc_msg,
    type_e TYPE string VALUE 'E',
    type_i TYPE string VALUE 'I',
    id     TYPE string VALUE 'ZMM_3C_NF_FATURADA',
  END OF gc_msg.
