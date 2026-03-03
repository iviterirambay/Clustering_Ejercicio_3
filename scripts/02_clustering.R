# ==============================================================================
# 02_clustering.R - Análisis de Agrupamiento
# ==============================================================================

library(tidyverse)
library(cluster)
library(factoextra)

# Cargar datos limpios
path_output <- "C:/Users/iavit/OneDrive/ESPOL/Maestria en Estadistica Aplicada/Clases Maestria en Estadistica Aplicada/Modulo 9/TEC ESTADIS AVANZ PARA MINERIA DE DATOS/METODOS DE CLASIFICACION/Taller/EJER2/output"
oil_clean <- readRDS(file.path(path_output, "oil_clean.rds"))

# Seleccionar variables químicas y escalar (Indispensable para clustering)
oil_scale <- oil_clean %>% 
  select(hydroxytyrosol:alfatocopherol) %>% 
  scale()

# 1. Determinar número óptimo de clústeres (Método del Codo y Silueta)
p1 <- fviz_nbclust(oil_scale, kmeans, method = "wss") + labs(title = "Método del Codo")
p2 <- fviz_nbclust(oil_scale, kmeans, method = "silhouette") + labs(title = "Método de Silueta")

png(file.path(path_output, "02_optimal_clusters.png"), width = 1000, height = 500)
print(gridExtra::grid.arrange(p1, p2, ncol=2))
dev.off()

# 2. Ejecución de K-means (K=3 parece óptimo según datos de Túnez y Europa)
set.seed(123)
km_res <- kmeans(oil_scale, centers = 3, nstart = 25)

# 3. Clustering Jerárquico
dist_mat <- dist(oil_scale, method = "euclidean")
hc_res <- hclust(dist_mat, method = "ward.D2")

png(file.path(path_output, "03_dendrogram.png"), width = 1000, height = 600)
fviz_dend(hc_res, k = 3, rect = TRUE, main = "Dendrograma de Aceites de Oliva")
dev.off()

# Guardar asignaciones
oil_results <- oil_clean %>%
  mutate(cluster_km = as.factor(km_res$cluster))

saveRDS(oil_results, file.path(path_output, "oil_final_clusters.rds"))

# ==============================================================================
# FINAL DEL SCRIPT
# ==============================================================================
