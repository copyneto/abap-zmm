class ZCLMM_MMSRV_APPROVAL_APP definition
  public
  final
  create public .

public section.

  interfaces IF_BADI_INTERFACE .
  interfaces IF_EX_BADI_MMSRV_APPROVAL_APP .
protected section.
private section.
ENDCLASS.



CLASS ZCLMM_MMSRV_APPROVAL_APP IMPLEMENTATION.


  method IF_EX_BADI_MMSRV_APPROVAL_APP~CHANGE_ACCOUNTING.
  endmethod.


  METHOD if_ex_badi_mmsrv_approval_app~change_approve_action.

    IF sy-subrc EQ 0.

    ENDIF.

  ENDMETHOD.


  method IF_EX_BADI_MMSRV_APPROVAL_APP~CHANGE_ATTACHMENTS.
  endmethod.


  method IF_EX_BADI_MMSRV_APPROVAL_APP~CHANGE_HEADER_DETAIL.
  endmethod.


  method IF_EX_BADI_MMSRV_APPROVAL_APP~CHANGE_NOTES.
  endmethod.


  method IF_EX_BADI_MMSRV_APPROVAL_APP~CHANGE_PACKAGE_HIERARCHY.
  endmethod.


  method IF_EX_BADI_MMSRV_APPROVAL_APP~CHANGE_REJECT_ACTION.
  endmethod.


  METHOD if_ex_badi_mmsrv_approval_app~change_release_codes_for_ses.

    IF sy-subrc EQ 0.

    ENDIF.

  ENDMETHOD.


  method IF_EX_BADI_MMSRV_APPROVAL_APP~CHANGE_SERVICE_LINES_GENERAL.
  endmethod.


  method IF_EX_BADI_MMSRV_APPROVAL_APP~CHANGE_SERVICE_LINE_DETAIL.
  endmethod.


  method IF_EX_BADI_MMSRV_APPROVAL_APP~CHANGE_WORKITEM_INBOX.
  endmethod.


  method IF_EX_BADI_MMSRV_APPROVAL_APP~SELECT_WORKITEM_INBOX.
  endmethod.
ENDCLASS.
