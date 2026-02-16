#####NORMALIZACIÓN DE CONTAJES (TPM)###########

# Nota: Los raw counts no se incluyen por confidencialidad. Se muestra únicamente el flujo de trabajo.

# PASO 1: Configurar el entorno
rm(list = ls())
library(data.table)
library(dplyr)
library(rtracklayer)

# PASO 2: Definir las rutas de entrada y salida de datos

inputF <- file.path("..", "results", "raw_counts_final_all.tsv") #contajes crudos
gtf_file <- file.path("..", "input","Homo_sapiens.GRCh38.107.chr.genes.gtf") 

#Archivo de salida (únicamente para revisar el flujo, no se entregará)
output_file <- file.path("..", "results", "counts_TPM_final.tsv")

# PASO 3: Cargar los contajes crudos
df <- fread(input = inputF, header = TRUE)
colnames(df)[1] <- "GeneID"

# PASO 4: Cargar el GTF y extraer la longitud de los genes
gtf_data <- import(gtf_file)

# Extraer longitud de los genes
genes <- as.data.frame(gtf_data) %>%
  filter(type == "gene") %>%
  mutate(gene_length = (end - start + 1) / 1000) # Convertir a kilobases

# Crear dataframe con longitud de genes
len_df <- data.frame(GeneID = genes$gene_id, Length = genes$gene_length)

# Verificar cuántos genes coinciden entre los contajes y el GTF
num_genes_coinciden <- length(intersect(df$GeneID, len_df$GeneID))
print(paste("Cantidad de genes en los contajes que coinciden con el GTF:", num_genes_coinciden))

# PASO 5: Fusionar los contajes con la longitud de los genes
df_merge <- df %>%
  left_join(len_df, by = "GeneID")

#Eliminar genes sin longitud
num_genes_sin_longitud <- sum(is.na(df_merge$Length))
print(paste("Cantidad de genes sin longitud:", num_genes_sin_longitud))
df_merge <- df_merge %>% filter(!is.na(Length))

# PASO 6: Normalizar a TPM

#Dividir cada cuenta por la longitud del gen
df_step1 <- df_merge %>%
  mutate(across(-c(GeneID, Length), ~ .x / Length))

#Calcular el factor de escalado
scalingfactor <- colSums(df_step1[, -c(1, 2)]) / 1e6
print(scalingfactor)

# Reemplazamos NA o 0 por 1:
scalingfactor[is.na(scalingfactor) | scalingfactor == 0] <- 1

# Calcular TPM dividiendo por el factor de escalado
df_final <- df_step1
for (i in 3:ncol(df_final)) {
  df_final[[i]] <- df_final[[i]] / scalingfactor[i - 2]
}

# PASO 7: Guardar la matriz de TPM
write.table(df_final, file = output_file, sep = "\t", quote = FALSE, row.names = FALSE, col.names = TRUE)
print(paste("File final normalizado en:", output_file))
