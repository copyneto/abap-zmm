*"* use this source file for any type of declarations (class
*"* definitions, interfaces or type declarations) you need for
*"* components in the private section

CONSTANTS: BEGIN OF gc_prop,
             inline       TYPE string VALUE 'inline',
             outline      TYPE string VALUE 'outline',
             docnum       TYPE string VALUE 'docnum',
             filepath     TYPE string VALUE 'filepath',
             emissor_nfis TYPE string VALUE 'emissor_nfis',
             emissor_uf   TYPE string VALUE 'emissor_uf',
             recebe_nfis  TYPE string VALUE 'recebe_nfis',
             recebe_uf    TYPE string VALUE 'recebe_uf',
             server       TYPE string VALUE 'server',
           END OF gc_prop,

           BEGIN OF gc_entity,
             nfe TYPE string VALUE 'xmlDownloadNfe',
             cte TYPE string VALUE 'xmlDownloadCte',
           END OF gc_entity,

           gc_filetype   TYPE string VALUE 'ASC',
           gc_codepage   TYPE string VALUE '4110',
           gc_mimetype   TYPE string VALUE 'application/xml',
           gc_headername TYPE string VALUE 'Content-Disposition'.
