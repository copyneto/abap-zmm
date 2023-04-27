INTERFACE zifmm_lib_pgto_graoverde
  PUBLIC .


  TYPES:
    BEGIN OF ty_desc,
      bukrs  TYPE bukrs,
      gjahr  TYPE gjahr,
      belnr  TYPE belnr_d,
      amount TYPE dmbtr,
    END OF ty_desc .
  TYPES:
    tt_desc TYPE TABLE OF ty_desc .

  CONSTANTS:
    BEGIN OF gc_tipo,
      comercial    TYPE char1 VALUE 'C',
      financeiro   TYPE char1 VALUE 'F',
      transferComp TYPE char1 VALUE 'T',
      retiradaBloq TYPE char1 VALUE 'R',
    END OF gc_tipo.

  METHODS executar
    IMPORTING
      !iv_tipo TYPE char1 OPTIONAL .
  METHODS set_properties
    IMPORTING
      !it_properties TYPE data .
ENDINTERFACE.
