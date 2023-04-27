"Name: \PR:SAPLMEPO\FO:DISUB_CHECK_SC_DATA_POI\SE:BEGIN\EI
ENHANCEMENT 0 ZMMEI0020.
*Não consitir pedido de insumo com tipo de subcontratação
  IF EKPO-EMLIF IS NOT INITIAL AND
     EKPO-PSTYP EQ '0' AND
   ( EKPO-SERRU EQ 'X' OR EKPO-SERRU EQ 'Y' ). " 'X - Subcontratação' ou 'Y - Armazenagem'
   EXIT.
 ELSEIF EKPO-PSTYP EQ '3' AND "Se for subcontratação não aceitar tipos abaixo
      ( EKPO-SERRU EQ 'X' OR EKPO-SERRU EQ 'Y' ). " 'X - Subcontratação' ou 'Y - Armazenagem'
         CLEAR EKPO-SERRU.
 ENDIF.
ENDENHANCEMENT.
