************************************************************************
* Programa  : ZMMSD_PLANLOG
* Título    : Geração de planilha PLANLOG
* Autor     : THAR - Thiago Alonso Rabelo
* Data      : 22.03.2022
* Projeto   : Carga Certa
*----------------------------------------------------------------------
*
*----------------------------------------------------------------------
* HISTÓRICO DAS MODIFICAÇÕES
*----------------------------------------------------------------------
* ID         | Data      | Autor            | Descrição
*----------------------------------------------------------------------
* SCDK971458   22.03.2022  Thiago Alonso      Implementação
***********************************************************************
REPORT zmmsd_planlog.

INCLUDE: zmmsd_planlog_top,
         zmmsd_planlog_scr,
         zmmsd_planlog_f01.

************************************************************************
*  EVENTOS
************************************************************************
AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_vari.
  IF sy-batch IS INITIAL.
    PERFORM f_variant_inputhelp_f14 USING p_vari.
  ENDIF.

START-OF-SELECTION.

  PERFORM: f_executa_transacao.
