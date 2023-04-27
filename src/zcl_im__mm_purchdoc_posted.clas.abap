class ZCL_IM__MM_PURCHDOC_POSTED definition
  public
  final
  create public .

public section.

  interfaces IF_EX_ME_PURCHDOC_POSTED .
protected section.
private section.
ENDCLASS.



CLASS ZCL_IM__MM_PURCHDOC_POSTED IMPLEMENTATION.


  METHOD if_ex_me_purchdoc_posted~posted.

    INCLUDE zmmi_envio_liberacao_pedido IF FOUND.
    INCLUDE zmmi_wf_statusme IF FOUND.

ENDMETHOD.
ENDCLASS.
