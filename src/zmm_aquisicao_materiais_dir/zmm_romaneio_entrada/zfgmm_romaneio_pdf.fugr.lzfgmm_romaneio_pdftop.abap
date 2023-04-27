FUNCTION-POOL ZFGMM_ROMANEIO_PDF.           "MESSAGE-ID ..

* INCLUDE LZFGMM_ROMANEIO_PDFD...            " Local class definition
  TYPES: BEGIN OF ty_romaneio,
           doc_uuid_h      TYPE ztmm_romaneio_it-doc_uuid_h,
           sequence        TYPE ztmm_romaneio_in-sequence,
           vbeln           TYPE ztmm_romaneio_it-vbeln,
           ebeln           TYPE ztmm_romaneio_in-ebeln,
           ebelp           TYPE ztmm_romaneio_it-ebelp,
           posnr           TYPE ztmm_romaneio_it-posnr,
           charg           TYPE ztmm_romaneio_it-charg,
           qtde            TYPE ztmm_romaneio_it-qtde,
           qtd_kg_original TYPE ztmm_romaneio_it-qtd_kg_original,
           nfnum           TYPE ztmm_romaneio_in-nfnum,
           placa           TYPE ztmm_romaneio_in-placa,
           motorista       TYPE ztmm_romaneio_in-motorista,
           dt_entrada      TYPE ztmm_romaneio_in-dt_entrada,
           dt_chegada      TYPE ztmm_romaneio_in-dt_chegada,
           corretor        TYPE ztmm_control_cla-corretor,
           nro_contrato    TYPE ztmm_control_cla-nro_contrato,
           observacao      TYPE ztmm_control_cla-observacao,
           xped            TYPE j_1bnflin-xped,
           nitemped        TYPE j_1bnflin-nitemped,
           nitemped_aux    TYPE j_1bnflin-nitemped,
         END OF ty_romaneio.

  CONSTANTS:
    BEGIN OF gc_param,
      modulo TYPE ztca_param_par-modulo VALUE 'MM',
      chave1 TYPE ztca_param_par-chave1 VALUE 'ROMANEIO',
      chave2 TYPE ztca_param_par-chave2 VALUE 'CLASSNUM',
    END OF gc_param,
    gc_name_romaneio TYPE tdsfname       VALUE 'ZSFMM_ROMANEIO',
    gc_code          TYPE j_1bnfdoc-code VALUE '100',
    gc_printer       TYPE rspopname      VALUE 'LOCL'.
