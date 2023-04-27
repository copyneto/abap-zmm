class ZCLMM_GET_PROCESS_CFOP_SUB definition
  public
  final
  create public .

public section.

  interfaces /XNFE/IF_BADI_GET_PROCESS .
  interfaces IF_BADI_INTERFACE .
protected section.
private section.
ENDCLASS.



CLASS ZCLMM_GET_PROCESS_CFOP_SUB IMPLEMENTATION.


  METHOD /xnfe/if_badi_get_process~get_business_process.

    IF line_exists( it_innfeit[  cfop = '6122' ] )
    AND  line_exists( it_innfeit[  cfop = '6124' ] ).

*      ev_proctyp = 'SUBCON1A'.
      ev_proctyp = 'NORMPRCH'.
    ELSE.
      ev_proctyp = iv_proctyp.

    ENDIF.

  ENDMETHOD.
ENDCLASS.
