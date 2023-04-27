class ZCLMM_WF_GET_VALUE_RANGE definition
  public
  final
  create public .

public section.

  types:
    BEGIN OF ty_range,
      sign   TYPE ddsign,
      option TYPE  ddoption,
      low    TYPE  char10,
      high   TYPE char10,
    END OF ty_range .
  types:
    tt_range TYPE TABLE OF ty_range .

  methods GET_VALUE
    importing
      !IV_VALUE type STRING
    exporting
      !ET_VALUE type TT_RANGE .
protected section.
private section.
ENDCLASS.



CLASS ZCLMM_WF_GET_VALUE_RANGE IMPLEMENTATION.


  method GET_VALUE.

    SPLIT iv_value AT ';' INTO TABLE DATA(lt_dados).

    et_value = VALUE #( FOR ls_data IN lt_dados
      sign = 'I'
      option = 'EQ'
      ( low = ls_data )
    ).

  endmethod.
ENDCLASS.
