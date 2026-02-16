# Archivos guardados en input/
-LM22.txt: La firma original de LM22 (referencia).
-LM22_definitivo.txt : Firma LM22 actualizada con Ensembl IDs (archivo final que se usa en CIBERSORTx).
-Homo_sapiens.GRCh38.107.chr.genes.gtf: Archivo GTF de Ensembl para calcular longitudes de genes (puede descargarse de Ensembl).

#Archivos no incluidos por confidencialidad
-raw_counts_final_all.tsv → Conteos crudos de muestras.
-counts_TPM_final.tsv → Matriz normalizada a TPM.
-config_file.txt → Archivo de configuración de muestras ( contiene datos).

#Estructura del config file:

columnas:   ID		path (relativo)		sex (1 hombre, 2 mujer)		affstatus (1 unaffected, 2 affected)