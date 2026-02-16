# Definir el directorio de trabajo
workingD <- rstudioapi::getActiveDocumentContext()$path
setwd(dirname(workingD))

# Cargar paquetes necesarios
library(HGNChelper)
library(biomaRt)
library(dplyr)

##################1. CARGAR DATOS Y CONECTARSE A ENSEMBL#######################

# Cargar datos
fichero_path <- file.path("..", "data", "input", "LM22.txt")
data <- read.table(fichero_path, header = TRUE, sep = "\t", stringsAsFactors = FALSE)

# Conectarse a la base de datos de Ensembl
ensembl <- useMart("ensembl", dataset = "hsapiens_gene_ensembl")

#########################2.OBTENER LOS ENSEMBL IDs#########################

# Extraer los Ensembl IDs para cada Gene Symbol en LM22
gene_symbols <- data$Gene.symbol

tabla_de_conversiones <- getBM(
  attributes = c("hgnc_symbol", "ensembl_gene_id", "chromosome_name"), 
  filters = "hgnc_symbol",
  values = gene_symbols,
  mart = ensembl)

# Filtrar solo cromosomas reales (1-22, X)
tabla_de_conversiones_2 <- tabla_de_conversiones[tabla_de_conversiones$chromosome_name %in% c(as.character(1:22), "X"), ]

# Detectar duplicados
dups <- tabla_de_conversiones_2[duplicated(tabla_de_conversiones_2$hgnc_symbol), ]
print(dups)

# Eliminar duplicados con menos transcritos (ejemplo: GUSBP11)
discard_dups <- c("ENSG00000272578")
tabla_data_ensembl_cleaned <- tabla_de_conversiones_2[!(tabla_de_conversiones_2$ensembl_gene_id %in% discard_dups), ]

#######################3. FUSIONAR LM22 CON LOS ENSEMBL IDs OBTENIDOS #############################

# Fusionar `LM22.txt` con `tabla_data_ensembl_cleaned`
lm22_actualizado <- data %>%
  left_join(tabla_data_ensembl_cleaned %>% select(hgnc_symbol, ensembl_gene_id), 
            by = c("Gene.symbol" = "hgnc_symbol")) %>%
  mutate(Gene.symbol = coalesce(ensembl_gene_id, Gene.symbol)) %>%  # Si hay Ensembl ID, reemplazarlo
  select(-ensembl_gene_id)  # Eliminar la columna extra

# Guardar `LM22_actualizado.txt` con los primeros Ensembl IDs detectados (opcional)
write.table(lm22_actualizado, "LM22_actualizado.txt", sep = "\t", row.names = FALSE, quote = FALSE)


#####################4.DETECTAR GENES SIN ENSEMBL ID##########################
# Buscar genes sin Ensembl ID
genes_sin_ensembl <- data$Gene.symbol[!data$Gene.symbol %in% tabla_de_conversiones_2$hgnc_symbol]
genes_sin_ensembl #imprimir genes

# Guardar los genes sin esembl en un archivo denominado "genes_sin_ensembl" (opcional)
write.table(genes_sin_ensembl, "genes_sin_ensembl_id.txt", sep = "\t", row.names = FALSE, quote = FALSE)

############### 5. CORREGIR NOMBRES DESACTUALIZADOS CON HGNC#############

# Revisar gene symbols desactualizados
corrected_genes <- checkGeneSymbols(genes_sin_ensembl, unmapped.as.na = FALSE)

# Identificar qué genes no tienen equivalencia en HGNC
non_approved_symbols <- corrected_genes[!corrected_genes$Approved, ]
write.table(non_approved_symbols, "non_approved_symbols.txt", sep = "\t", row.names = FALSE, quote = FALSE)

# Obtener los genes aprobados pero sin Ensembl ID
problematic_genes <- corrected_genes[corrected_genes$Approved, ]
colnames(problematic_genes) <- c('gene_symbol', 'status', 'suggestion')

# Obtener Ensembl IDs para nombres actualizados
tabla_de_conversiones_3 <- getBM(
  attributes = c("hgnc_symbol", "ensembl_gene_id", "chromosome_name"), 
  filters = "hgnc_symbol",
  values = non_approved_symbols$Suggested.Symbol,
  mart = ensembl)

# Filtrar cromosomas reales
tabla_de_conversiones_4 <- tabla_de_conversiones_3[tabla_de_conversiones_3$chromosome_name %in% c(as.character(1:22), "X"), ]

# Fusionar 'non_approved_symbols' con Ensembl IDs corregidos
non_approved_symbols_merged <- merge(corrected_genes, tabla_de_conversiones_4, by.x = "Suggested.Symbol", by.y = "hgnc_symbol", all.x = TRUE)

###############6. FUSIONAR LOS 28 GENES PROBLEMÁTICOS CON LM22############


# Anotaciones manuales
'El LOC100120100 no le asignamos ningún Ensembl ID porque no tiene'
new_df <- data.frame(Suggested.Symbol = c("LOC126987", "LOC100130100", "LINC00597", "LILRA3", "GSTT1"),
                     ensembl_gene_id = c("ENSG00000237480", "LOC100130100", "ENSG00000173517", "ENSG00000104974", "ENSG00000277656"))

# Fusionar datos corregidos (data_gmerged) con anotaciones manuales
data_merged <- non_approved_symbols_merged %>%
  left_join(new_df %>% select(Suggested.Symbol, ensembl_gene_id), by = "Suggested.Symbol") %>%
  mutate(ensembl_gene_id = coalesce(ensembl_gene_id.x, ensembl_gene_id.y)) %>%
  select(-ensembl_gene_id.x, -ensembl_gene_id.y)

#########7. APLICAR LAS CORRECCIONES FINALES A LM22###########

# Asegurarse de que los nombres coincidan antes de actualizar los datos
lm22_actualizado$Gene.symbol <- trimws(toupper(lm22_actualizado$Gene.symbol))
data_merged$Suggested.Symbol <- trimws(toupper(data_merged$x))

# Reemplazar los gene.symbol en LM22_actualizado con su ensembl id si está en data_merged
indice <- match(lm22_actualizado$Gene.symbol, data_merged$x)  #buscar coincidencias en 'x'
lm22_actualizado$Gene.symbol[!is.na(indice)] <- data_merged$ensembl_gene_id[indice[!is.na(indice)]]  # Reemplazar solo donde hay coincidencia

#################8. ALMACENAR EL ARCHIVO FINAL CON LOS 547 GENES#####
# Guardar 'LM22_final.txt' con todos los Ensembl IDs corregidos 
write.table(lm22_actualizado, file = file.path("..", "results", "LM22_definitivo.txt"), sep = "\t", row.names = FALSE, quote = FALSE)

# Verificar resultado final
print(length(unique(lm22_actualizado$Gene.symbol)))  # 547 genes




