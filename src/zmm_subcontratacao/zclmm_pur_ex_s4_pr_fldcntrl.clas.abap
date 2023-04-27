class ZCLMM_PUR_EX_S4_PR_FLDCNTRL definition
  public
  final
  create public .

public section.

  interfaces IF_BADI_INTERFACE .
  interfaces IF_MM_PUR_S4_PR_FLDCNTRL .
protected section.
private section.
ENDCLASS.



CLASS ZCLMM_PUR_EX_S4_PR_FLDCNTRL IMPLEMENTATION.


  method IF_MM_PUR_S4_PR_FLDCNTRL~MODIFY_FIELDCONTROLS.

    LOOP AT FIELDSELECTION_TABLE ASSIGNING FIELD-SYMBOL(<fs_table>).
      CHECK <fs_table>-FIELD = 'SUPPLIER' or <fs_table>-FIELD = 'PURREQNRECEIVINGSUPPLIER'.
      <fs_table>-fieldstatus = '-'.
    ENDLOOP.


  endmethod.
ENDCLASS.
