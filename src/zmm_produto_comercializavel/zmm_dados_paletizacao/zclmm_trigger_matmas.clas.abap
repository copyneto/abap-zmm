class ZCLMM_TRIGGER_MATMAS definition
  public
  final
  create public .

public section.

      "! Disparar IDOC MATMAS
  methods EXECUTE
    importing
      !IV_MATNR type MATNR
      !IV_MTART type MTART
      !IV_TCODE type SYST_TCODE optional .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCLMM_TRIGGER_MATMAS IMPLEMENTATION.


  METHOD execute.

    CALL FUNCTION 'ZFMMM_TRIGGER_MATMAS'
      STARTING NEW TASK 'MATMASIDOC'
      EXPORTING
        iv_matnr = iv_matnr
        iv_mtart = iv_mtart
        iv_tcode = iv_tcode.

  ENDMETHOD.
ENDCLASS.
