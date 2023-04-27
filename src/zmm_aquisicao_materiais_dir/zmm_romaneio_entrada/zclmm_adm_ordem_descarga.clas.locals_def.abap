*"* use this source file for any type of declarations (class
*"* definitions, interfaces or type declarations) you need for
*"* components in the private section
TYPES:
    BEGIN OF ty_adm_ordem_descarga.
    include TYPE zi_mm_adm_ordem_descarga.
    TYPES: xblnr TYPE xblnr_long,
    END OF   ty_adm_ordem_descarga.
