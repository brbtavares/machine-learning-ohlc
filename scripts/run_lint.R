#!/usr/bin/env Rscript

#' Script para executar linting inicial dos arquivos R
#' Este script instala e executa lintr e styler em todos os arquivos R do projeto

# Instalar pacotes necessários se não estiverem instalados
required_packages <- c("lintr", "styler")
for (pkg in required_packages) {
    if (!requireNamespace(pkg, quietly = TRUE)) {
        install.packages(pkg)
    }
}

# Carregar bibliotecas
library(lintr)
library(styler)

cat("=== EXECUTANDO LINTING INICIAL ===\n\n")

# 1. Primeiro, aplicar style_pkg para formatar o código
cat("1. Aplicando formatação automática com styler...\n")
styler::style_pkg(
    indent_by = 4,
    scope = "tokens",
    strict = TRUE
)

cat("✓ Formatação concluída!\n\n")

# 2. Executar lintr para verificar problemas de código
cat("2. Executando verificação de linting...\n")
lint_results <- lintr::lint_package()

if (length(lint_results) == 0) {
    cat("✓ Nenhum problema de linting encontrado!\n")
} else {
    cat("⚠ Problemas de linting encontrados:\n")
    print(lint_results)
}

cat("\n=== LINTING INICIAL CONCLUÍDO ===\n")
