*&---------------------------------------------------------------------*
*& Include          ZMMI_CLMM_RECEBIMENTO_FISICO
*&---------------------------------------------------------------------*

 DATA(lo_receb_fisico) = NEW zclmm_recebimento_fisico( it_mseg = xmseg[] ).

 lo_receb_fisico->process_data( ).
