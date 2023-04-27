"!<p><h2>Tratamento de Anexos Fiscais</h2></p>
"!<p><strong>Autor:</strong> Anderson Miazato</p>
"!<p><strong>Data:</strong> 12 de abril de 2022</p>
CLASS zclmm_anexo_fiscal DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    "! Inicializa instância
    "! @parameter is_anexo | Anexo Fiscal
    METHODS constructor
      IMPORTING
        !is_anexo TYPE ztmm_anexo_nf .

    "! Insere anexo na tabela de anexos
    "! @parameter et_return | Mensagens de retorno
    METHODS inserir_anexo
      EXPORTING
        !et_return TYPE bapiret2_tab .
  PROTECTED SECTION.
  PRIVATE SECTION.

    DATA:
      "! Dados do anexo
      gs_anexo TYPE ztmm_anexo_nf .
ENDCLASS.



CLASS zclmm_anexo_fiscal IMPLEMENTATION.


  METHOD constructor.
    me->gs_anexo = is_anexo.
  ENDMETHOD.


  METHOD inserir_anexo.

    MODIFY ztmm_anexo_nf FROM me->gs_anexo.

  ENDMETHOD.
ENDCLASS.
