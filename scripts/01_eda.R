# ==============================================================================
# SCRIPT: 01_eda.R - Análisis Exploratorio de Datos
# ==============================================================================

# Configuración de rutas
path_data <- "C:/Users/iavit/OneDrive/ESPOL/Maestria en Estadistica Aplicada/Clases Maestria en Estadistica Aplicada/Modulo 9/TEC ESTADIS AVANZ PARA MINERIA DE DATOS/METODOS DE CLASIFICACION/Taller/EJER2/data"
path_output <- "C:/Users/iavit/OneDrive/ESPOL/Maestria en Estadistica Aplicada/Clases Maestria en Estadistica Aplicada/Modulo 9/TEC ESTADIS AVANZ PARA MINERIA DE DATOS/METODOS DE CLASIFICACION/Taller/EJER2/output"

# Carga de librerías
library(tidyverse)
library(corrplot)

# 1. Carga de datos 
# Nota: Se usa check.names=F para mantener nombres originales si es necesario
oil_raw <- read.table(file.path(path_data, "oil.txt"), header = TRUE, row.names = 1)

# 2. Limpieza de datos
# El dataset contiene valores NA en alfatocopherol (SP R2, PO 16) [cite: 2, 6]
# Procedemos a imputar por la mediana del grupo (país) para no perder filas
oil_clean <- oil_raw %>%
  group_by(Origin) %>%
  mutate(across(where(is.numeric), ~ifelse(is.na(.), median(., na.rm = TRUE), .))) %>%
  ungroup()

# 3. Análisis Descriptivo
# Resumen estadístico
stats_summary <- summary(oil_clean)
write.table(stats_summary, file.path(path_output, "desc_stats.txt"))

# Matriz de Correlación (Solo variables numéricas)
# El perfil fenólico incluye 8 compuestos + alfatocopherol [cite: 1, 7]
oil_num <- oil_clean %>% select(hydroxytyrosol:alfatocopherol)
cor_matrix <- cor(oil_num)

png(file.path(path_output, "01_correlation_matrix.png"), width = 800, height = 800)
corrplot(cor_matrix, method = "color", addCoef.col = "black", tl.col = "black")
dev.off()

# Guardar dataset limpio para el siguiente script
saveRDS(oil_clean, file.path(path_output, "oil_clean.rds"))

# ==============================================================================
# FINAL DEL SCRIPT
# ==============================================================================