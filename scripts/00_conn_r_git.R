# ==============================================================================
# SCRIPT: 00_conn_r_git.R
# ==============================================================================

# 1. Configuración de Identidad
user_name  <- "iviterirambay"
user_email <- "ejemplo"
repo_name  <- "Clustering_Ejercicio_3"

# 2. Inicialización de Git
system("git init")
system(paste0('git config user.name "', user_name, '"'))
system(paste0('git config user.email "', user_email, '"'))

# 3. Optimización para archivos pesados (Buffer de 500MB)
system("git config http.postBuffer 524288000")

# 4. Gestión de .gitignore (Evita subir basura y archivos .txt grandes)
ignore_files <- c(".Rhistory", ".RData", ".Rproj.user", ".DS_Store")
writeLines(ignore_files, ".gitignore")

# 5. Primer Commit
system("git add .")
system('git commit -m "Initial commit: Infraestructura limpia"')
system("git branch -M main")

# 6. Vinculación y Push
remote_url <- paste0("https://github.com/", user_name, "/", repo_name, ".git")
system(paste0("git remote add origin ", remote_url))
system("git push -u origin main")

message("Conexión establecida con éxito.")
# ==============================================================================
# FINAL DEL SCRIPT
# ==============================================================================


