"! <p class="short text synchronized" lang="pt">Exception Class for Query Provider</p>
CLASS zcxmm_download_xml DEFINITION
  PUBLIC
  INHERITING FROM cx_rap_query_provider
  "FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    CONSTANTS:
      BEGIN OF gc_generic_error,
        msgid TYPE symsgid VALUE 'ZMM_MC_DOWNLOAD_XML',
        msgno TYPE symsgno VALUE '000',
        attr1 TYPE scx_attrname VALUE '',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF gc_generic_error .
    CONSTANTS:
      BEGIN OF gc_mandatory,
        msgid TYPE symsgid VALUE 'ZMM_MC_DOWNLOAD_XML',
        msgno TYPE symsgno VALUE '001',
        attr1 TYPE scx_attrname VALUE '',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF gc_mandatory .

    "! <p class="shorttext synchronized" lang="pt">CONSTRUCTOR</p>
    METHODS constructor
      IMPORTING
        !iv_textid   LIKE if_t100_message=>t100key OPTIONAL
        !iv_previous LIKE previous OPTIONAL .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcxmm_download_xml IMPLEMENTATION.


  METHOD constructor ##ADT_SUPPRESS_GENERATION.
    CALL METHOD super->constructor
      EXPORTING
        previous = previous.
    CLEAR me->textid.
    IF textid IS INITIAL.
      if_t100_message~t100key = if_t100_message=>default_textid.
    ELSE.
      if_t100_message~t100key = iv_textid.
    ENDIF.
  ENDMETHOD.
ENDCLASS.
