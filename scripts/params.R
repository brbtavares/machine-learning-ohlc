#' @title Lista de Pacotes Necessários
#' @description Um vetor contendo os nomes dos pacotes necessários para o script.
required_packages <- c(
    "data.table", "dplyr", "quantmod", "TTR", "keras", "tensorflow",
    "xgboost", "yardstick", "recipes", "reticulate", "jsonlite"
)

#' @title Variáveis Globais
#' @description Variáveis globais que definem caminhos e nomes de arquivos utilizados no script.
file_name <- "../data/EURUSD_M15_202401020000_202412310000.csv"
path_models <- "../models/"
path_outputs <- "../outputs/"

seed <- 42
