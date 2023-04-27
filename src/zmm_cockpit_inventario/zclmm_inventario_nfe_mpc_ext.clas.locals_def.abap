*"* use this source file for any type of declarations (class
*"* definitions, interfaces or type declarations) you need for
*"* components in the private section


CONSTANTS: BEGIN OF gc_entity,
             name     TYPE /iwbep/med_external_name VALUE 'ZC_MM_INVENTARIO_NFE_EMISSAOType',
             node     TYPE /iwbep/med_external_name VALUE 'ID',
             parent   TYPE /iwbep/med_external_name VALUE 'ParentID',
             level    TYPE /iwbep/med_external_name VALUE 'HierLevel',
             drill    TYPE /iwbep/med_external_name VALUE 'DrillDownState',
             anno_key TYPE /iwbep/med_annotation_key VALUE 'ID',
           END OF gc_entity.
