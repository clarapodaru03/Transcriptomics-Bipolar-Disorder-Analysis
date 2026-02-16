#Unir contajes crudos

# Nota: Este script genera raw_counts_final_all.tsv a partir de HTSeq y config_file.txt.
# No se puede ejecutar con los datos entregados por confidencialidad.

# Cargar librerías
library(DESeq2)

# Definir directorios
workingD <- rstudioapi::getActiveDocumentContext()$path
setwd(dirname(workingD))

# Cargar el archivo de configuración
configFile <- file.path("..", "data", "input", "config_file.txt")

# Leer la tabla de muestras (revisando nombres de columnas)
sampleTable <- read.table(configFile, header=TRUE, 
                          colClasses= c('factor','character', 'factor','factor'))
# Crear el objeto DESeqDataSet
datos <- DESeqDataSetFromHTSeqCount(sampleTable, directory=".", design = ~ status)

# Obtener matrices de conteos crudos
dds_raw <- counts(datos, normalized=FALSE)

# Guardar las cuentas génicas crudas en un archivo .tsv
write.table(dds_raw, file="raw_counts_final_all.tsv", quote=FALSE, 
            sep = "\t", row.names = TRUE, col.names=NA)

