# ==============================================================================
# 03_results.R - Visualización Final y Hallazgos
# ==============================================================================

library(tidyverse)
library(factoextra)

path_output <- "C:/Users/iavit/OneDrive/ESPOL/Maestria en Estadistica Aplicada/Clases Maestria en Estadistica Aplicada/Modulo 9/TEC ESTADIS AVANZ PARA MINERIA DE DATOS/METODOS DE CLASIFICACION/Taller/EJER2/output"
oil_final <- readRDS(file.path(path_output, "oil_final_clusters.rds"))

# 1. Visualización en Espacio de Componentes Principales (PCA)
# Permite ver si los grupos químicos coinciden con el origen 
pca_res <- prcomp(oil_final %>% select(hydroxytyrosol:alfatocopherol), scale. = TRUE)

png(file.path(path_output, "04_pca_clusters.png"), width = 800, height = 600)
fviz_pca_ind(pca_res,
             geom.ind = "point",
             col.ind = oil_final$Origin, # Color por país de origen
             palette = "jco",
             addEllipses = TRUE,
             legend.title = "País de Origen") +
  labs(title = "Separación Química por Origen Geográfico")
dev.off()

# 2. Análisis del Hallazgo: alfatocopherol (Vitamina E)
# Túnez presenta niveles muy altos (>270) comparado con el resto 
png(file.path(path_output, "05_boxplot_vitE.png"), width = 800, height = 600)
ggplot(oil_final, aes(x = Origin, y = alfatocopherol, fill = Origin)) +
  geom_boxplot() +
  theme_minimal() +
  labs(title = "Concentración de Alfa-tocoferol por País",
       y = "Vitamina E (mg/kg)")
dev.off()

# 3. Resumen de hallazgos para el reporte
findings <- oil_final %>%
  group_by(cluster_km, Origin) %>%
  tally() %>%
  spread(cluster_km, n, fill = 0)

write.csv(findings, file.path(path_output, "cluster_vs_origin.csv"))

# ==============================================================================
# Sincronización Automática con GitHub
# ==============================================================================

# Cambiar el directorio de trabajo a la raíz del proyecto para que Git funcione
nombre_repo <- "Clustering_Ejercicio_3" 
nombre_user <- "iviterirambay"
remote_url <- paste0("https://github.com/", nombre_user, "/", nombre_repo, ".git")
path_base <- "C:/Users/iavit/OneDrive/ESPOL/Maestria en Estadistica Aplicada/Clases Maestria en Estadistica Aplicada/Modulo 9/TEC ESTADIS AVANZ PARA MINERIA DE DATOS/METODOS DE CLASIFICACION/Taller/EJER2"
setwd(path_base)

# 2. Preparar el mensaje del commit
# Usamos shQuote para que los espacios y caracteres especiales no rompan el comando
fecha_ejecucion <- format(Sys.time(), "%Y-%m-%d %H:%M:%S")
mensaje_texto <- paste0("feat(Rmd): ", fecha_ejecucion, " | Se actualiza con carpeta consolidada con el código . Rmd de consolidación en pdf de los resultados y conclusiones.")
comando_commit <- paste0('git commit -m ', shQuote(mensaje_texto))

# 3. Ejecutar Pipeline de Git
message("Iniciando carga a GitHub...")

# Agregar cambios (Respeta el .gitignore de la configuración en el script 00)
system("git add .")

# Intentar hacer el commit
try(system(comando_commit), silent = TRUE)

# 4. Sincronizar con el servidor
# Hacemos un pull primero por si acaso hubo cambios manuales en el repo de GitHub
system("git pull origin main --rebase")

# Subir los cambios
exit_code <- system("git push origin main")

if(exit_code == 0) {
  message("Sincronización exitosa: Código, datos (.gz) y outputs actualizados.")
} else {
  message("Error en el push. Revisa la consola de Git o tus credenciales.")
}


# ==============================================================================
# FINAL DEL SCRIPT
# ==============================================================================