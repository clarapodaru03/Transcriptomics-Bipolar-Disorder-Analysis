# Transcriptomics-Bipolar-Disorder-Analysis

# Deconvolución celular y mapeo de la expresión génica cerebral en Trastorno Bipolar

Este repositorio contiene el pipeline computacional desarrollado para el análisis de datos de **RNA-seq** de sangre periférica (515 muestras: 424 casos y 91 controles). El proyecto integra técnicas de citometría digital e imputación transcriptómica para estudiar la fisiopatología del Trastorno Bipolar (TB).

## Flujo de Trabajo Técnico

### 1. Preprocesamiento y Cuantificación (HPC)
El procesamiento de las lecturas de ARN se realizó en un entorno de computación de alto rendimiento (HPC) siguiendo este protocolo:
* **Control de Calidad**: Análisis inicial con `FastQC`.
* **Trimeado**: Recorte de adaptadores y filtrado por calidad mediante `Trimmomatic` (modo paired-end).
* **Alineamiento**: Mapeo de lecturas contra el genoma de referencia GRCh38 usando `HISAT2`.
* **Indexación**: Ordenado y compresión a formato BAM con `Samtools`.
* **Cuantificación**: Generación de la matriz de cuentas crudas con el paquete `HTSeq-count`.


### 2. Deconvolución Celular (CIBERSORTx)
Estimación de la abundancia relativa de 22 tipos de células inmunitarias (matriz de firmas LM22):
* **Normalización**: Conversión de cuentas crudas a **TPM** (*Transcripts Per Million*) para garantizar la compatibilidad.
* **Ejecución**: Implementación local mediante **Docker** para asegurar el cumplimiento de la protección de datos.
* **Parámetros**: Configuración de 1000 permutaciones y aplicación de corrección de efecto lote (**B-mode**).

### 3. Imputación Transcriptómica Cerebral (BrainGENIE)
Predicción de niveles de expresión en 13 regiones cerebrales a partir del transcriptoma sanguíneo:
* **Modelo**: Regresión lineal basada en el análisis de componentes principales (**PCA**) de los datos de sangre.
* **Entrenamiento**: Uso de datos pareados sangre-cerebro del consorcio **GTEx (v8)**.
* **Optimización**: Selección de **50 componentes principales (PCs)** para explicar el **74.4% de la varianza**.
* **Validación**: Esquema de validación cruzada en 10 pliegues (*folds*).


## Stack Tecnológico
* **Lenguajes**: R y Bash.
* **Software Clave**: Docker, HISAT2, Samtools, HTSeq, DESeq2.
* **Foco del Análisis**: Caracterización de genes de riesgo de alta confianza, específicamente **FES**, **KCNK4** y **FKBP2**.

---
*Nota: Este proyecto constituye un Trabajo de Fin de Grado (TFG) en Bioinformática. Se han omitido referencias personales e institucionales para garantizar el anonimato en el proceso de selección.*
