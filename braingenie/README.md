# BrainGENIE 

Este directorio contiene la organización del material empleado para ejecutar **BrainGENIE** en el TFG

**Nota importante:** Los datos de expresión de sangre en formato de contajess (TPM) **no se incluyen** en esta entrega por razones de confidencialidad. La estructura de carpetas permite al tribunal entender el flujo de trabajo, aunque no se puedan reproducir todos los resultados directamente.

Estructura de las carpetas: 
braingenie/
├── figuras/ # Figuras finales incluidas en la memoria del TFG
├── input/ # Carpeta donde deberían colocarse los datos de entrada
│ ├── counts_TPM_final.tsv # Matriz de expresión de sangre en TPM (no incluida)
│ └── normalized_expression_dat_gtexv8/ # Datos de referencia GTEx necesarios para BrainGENIE
├── scripts/ # Scripts utilizados
│ └── braingenie_pipeline.R #pipeline principal 
    └── braingenie_methods.R #script con las funciones necesarias para correr la herramienta




-Input:
   - counts_TPM_final.tsv: matriz de expresión de sangre en TPM (no incluida).  
   - normalized_expression_dat_gtexv8/: datos de expresión de referencia de GTEx necesarios para entrenar los modelos.  

-Script:
   - braingenie_pipeline.R: contiene todo el pipeline para ejecutar BrainGENIE.  
     - Procesa los datos de sangre.  
     - Entrena modelos con GTEx.  
     - Evalúa parámetros (número de componentes principales y folds).  
     - Imputa la expresión en tejido cerebral.  
     - Guarda resultados y figuras 

   - Las figuras del TFG  se encuentran en figuras/ y están incluidas también en la memoria del TFG.  

