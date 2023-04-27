class ZCLMM_CL_SI_PROCESSAR_RECEBIME definition
  public
  create public .

public section.

  interfaces ZCLMM_II_SI_PROCESSAR_RECEBIME .
protected section.
private section.
ENDCLASS.



CLASS ZCLMM_CL_SI_PROCESSAR_RECEBIME IMPLEMENTATION.


  METHOD zclmm_ii_si_processar_recebime~si_processar_recebimento_quant.

    DATA(lo_object) = NEW zclmm_conf_dados_recebmnt( ).

    lo_object->grava_receb( EXPORTING is_receb = input
                           EXCEPTIONS
                              raise_error = 1
                              OTHERS      = 2 ).

    IF sy-subrc <> 0.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
        WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDIF.

  ENDMETHOD.
ENDCLASS.
