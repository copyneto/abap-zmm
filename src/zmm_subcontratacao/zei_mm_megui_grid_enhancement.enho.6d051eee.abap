"Name: \PR:SAPLMEMFS\FO:BADI_MAPPING\SE:END\EI
ENHANCEMENT 0 ZEI_MM_MEGUI_GRID_ENHANCEMENT.
*
  CONSTANTS:
    LC_application TYPE char16 VALUE 'MMPUR_PO_VIEWS',
    LC_tablename   TYPE char30 VALUE 'MEREQ3211GRID',
    LC_tablename_MEPO1211   TYPE char30 VALUE 'MEPO1211',
    LC_fieldname_zz1_verid   TYPE char30 VALUE 'ZZ1_VERID',
    LC_fieldname_ZZ1_MATNR   TYPE char30 VALUE 'ZZ1_MATNR'.


data: ls_mapping type MEPO_S_METAFIELD_MAPPING.

  ls_mapping-APPLICATION = LC_application.
  ls_mapping-TABNAME = LC_tablename.
  ls_mapping-FIELDNAME = LC_fieldname_zz1_verid.
  ls_mapping-METAFIELD = mmmfd_ZZ1_VERID.
  insert ls_mapping into TABLE ch_mapping.

  ls_mapping-APPLICATION = LC_application.
  ls_mapping-FIELDNAME = LC_fieldname_zz1_verid.
  ls_mapping-METAFIELD = mmmfd_ZZ1_VERID.
  ls_mapping-TABNAME = LC_tablename_MEPO1211.
  insert ls_mapping into TABLE ch_mapping.

  ls_mapping-APPLICATION = LC_application.
  ls_mapping-TABNAME = LC_tablename.
  ls_mapping-FIELDNAME = LC_fieldname_ZZ1_MATNR.
  ls_mapping-METAFIELD = mmmfd_ZZ1_matnr.
  insert ls_mapping into TABLE ch_mapping.

  ls_mapping-APPLICATION = LC_application.
  ls_mapping-TABNAME = LC_tablename_MEPO1211.
  ls_mapping-FIELDNAME = LC_fieldname_ZZ1_MATNR.
  ls_mapping-METAFIELD = mmmfd_ZZ1_matnr.
  insert ls_mapping into TABLE ch_mapping.
ENDENHANCEMENT.
