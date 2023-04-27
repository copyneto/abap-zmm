*&---------------------------------------------------------------------*
*& Include          ZMMI_TRATATIVA_CFOP_SERVICO
*&---------------------------------------------------------------------*

  "//Verifica se é uma fatura sendo lançada a partir do monitor de serviço
  "//Caso sim, então definir CFOP de acordo com os parâmetros do cockpit
  IF zclmm_lanc_servicos=>check_invoice_servico(
      iv_empresa    = rbkpv-bukrs
      iv_fornecedor = rbkpv-lifnr
      iv_numero_nf  = rbkpv-xblnr
  ) = abap_true.

    LOOP AT lineitem ASSIGNING FIELD-SYMBOL(<fs_item_servico>).
      <fs_item_servico>-cfop = zclmm_lanc_servicos=>get_cfop_invoice_miro(
        iv_empresa    = rbkpv-bukrs
        iv_fornecedor = rbkpv-lifnr
        iv_numero_nf  = rbkpv-xblnr
        iv_material   = <fs_item_servico>-matnr
        iv_centro     = <fs_item_servico>-werks
      ).
    ENDLOOP.
  ENDIF.
