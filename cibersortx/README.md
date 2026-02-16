# Carpeta cibersortx

Nota acerca de los datos:

Los datos originales de las muestras de los pacientes con trastorno bipolar y controles no se han incluyen en esta carpeta ni se pueden compartir debido a la ley de protección de datos personales y confidencialidad de los participantes en el estudio. Estos datos pertenecen al Grupo de Psiquiatría Genómica del Centro de Biología Molecular Severo Ochoa, liderado por el Dr. Claudio Toma. Todos los análisis que se han llevado acabo sobre datos completamente anónimos y los códigos fuente hacen posible la reproducibilidad de los resultados.

# Estructura de las carpetas
cibersortx/ # Todo lo relacionado con CIBERSORTx
     ├── README_CIBERSORTx / #instrucciones descargadas de https://cibersortx.stanford.edu/download.php proporcionadas por los autores
│ ├── data/
│ │ ├── input/
│ │ │ ├── LM22.txt # Archivo original de la firma LM22 (referencia)
│ │ │ ├── LM22_definitivo.txt # Firma LM22 actualizada con Ensembl IDs (usa CIBERSORTx)
│ │ │ └── Homo_sapiens.GRCh38.107.chr.genes.gtf
│ │ └── config_file.txt (solo si se tiene acceso a raw counts)
│ ├── results/ # Resultados de scripts y figuras generadas
│ └── scripts/
│ 	├── 01_unir_matriz_contajes.R # Genera raw_counts_final_all.tsv (datos confidenciales)
│ 	├── 02_normalizar_TPM.R # Normaliza raw counts a TPM (flujo revisable)
│ 	├── 03_cambiar_gene_symbol_a_ensembl.R # Conversión LM22 a Ensembl IDs (código reproducible en cualquier entorno)
      └── notebooks/
      	└──04_documentacion_cibersortx.pdf #Guía de ejecución de CIBERSORTx
	└──viñeta_cambio_identificadores_LM22.pdf #Guía de cambio de identificadores de LM22 con el código exacto empleado personalizado a mi entorno.
	└──non_approved_symbols.txt (los gene symbols con un segundo gene symbol que hay que actualizar para poder encontrar un esembl id)



- **01_unir_matriz_contajes.R**: combina conteos crudos → `raw_counts_final_all.tsv`.  
- **02_normalizar_TPM.R**: normaliza los conteos crudos a TPM → `counts_TPM_final.tsv`.  
- **03_cambiar_gene_symbol_a_ensembl.R**: convierte LM22 → `LM22_definitivo.txt` (usable en CIBERSORTx).  
- Los archivos de raw counts y TPM **no se entregan** por confidencialidad.  
- `LM22_definitivo.txt` sí se entrega y se usa en los análisis.  
- **04_documentacion_cibersortx.pdf** : Guía de ejecución de CIBERSORTx usando `LM22_definitivo.txt` y la matriz de expresión normalizada (si se tuviera acceso).
 

## Archivos de entrada

- `LM22.txt` → Firma original (referencia).  
- `LM22_definitivo.txt` → Firma lista para CIBERSORTx.  
- `raw_counts_final_all.tsv` y `config_file.txt` → **No se incluyen**.  
- GTF de Ensembl → Para calcular longitudes de genes. Descargable de [Ensembl FTP](https://www.ensembl.org/info/data/ftp/index.html).

# Deben ejecutarse en orden y los resultados finales se guardan en results/


