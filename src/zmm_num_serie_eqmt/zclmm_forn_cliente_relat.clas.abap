"!<p>Habilita colunas de Fornecedor/Cliente no report de números de série IQ09 <br/>
"! Esta classe é utilizada na exit <em>EXIT_SAPLIREP1_001</em> <br/> <br/>
"!<p><strong>Autor:</strong> Anderson Miazato - Meta</p>
"!<p><strong>Data:</strong> 07/jun/2022</p>
CLASS zclmm_forn_cliente_relat DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    METHODS:
      "! Habilita colunas no report de número de série
      "! @parameter ct_fieldcat | Colunas do ALV
      habilita_colunas CHANGING ct_fieldcat TYPE slis_t_fieldcat_alv.

    CONSTANTS:
      "! Nomes das colunas do relatório ALV
      BEGIN OF gc_fieldname,
        num_fornecedor   TYPE slis_fieldcat_alv-fieldname VALUE 'ELIEF',
        conta_fornecedor TYPE slis_fieldcat_alv-fieldname VALUE 'LIFNR',
      END OF gc_fieldname.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCLMM_FORN_CLIENTE_RELAT IMPLEMENTATION.


  METHOD habilita_colunas.

    SORT ct_fieldcat BY fieldname.

    READ TABLE ct_fieldcat ASSIGNING FIELD-SYMBOL(<fs_change_fieldcat>)
    WITH KEY fieldname = gc_fieldname-num_fornecedor
    BINARY SEARCH.

    IF sy-subrc EQ 0.
      <fs_change_fieldcat>-tech = abap_false.
    ENDIF.

    READ TABLE ct_fieldcat ASSIGNING <fs_change_fieldcat>
    WITH KEY fieldname = gc_fieldname-conta_fornecedor
    BINARY SEARCH.

    IF sy-subrc EQ 0.
      <fs_change_fieldcat>-tech = abap_false.
    ENDIF.


  ENDMETHOD.
ENDCLASS.
