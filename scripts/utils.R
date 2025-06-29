#' @title Função para carregar pacotes
#' @description Carrega e instala pacotes necessários se não estiverem instalados.
#' @param packages Vetor de strings contendo os nomes dos pacotes.
load_required_packages <- function(packages) {
    for (pkg in packages) {
        if (!requireNamespace(pkg, quietly = TRUE)) {
            install.packages(pkg)
        }
        library(pkg, character.only = TRUE)
    }
}

#' @title Leitura de Dados OHLC
#' @param file_path Caminho para o arquivo CSV contendo os dados.
#' @return Dataframe com colunas Datetime, Open, High, Low e Close.
read_data <- function(file_path) {
    df <- fread(file_path, dec = ",", sep = ";", header = TRUE)

    cat("Colunas detectadas no arquivo:\n")
    print(names(df))

    # Limpeza e processamento de dados
    df <- df %>%
        filter(!is.na(Data), !is.na(Hora), Data != "", Hora != "") %>%
        mutate(
            Data = trimws(Data),
            Hora = trimws(Hora),
            Datetime = as.POSIXct(paste(Data, Hora), format = "%Y.%m.%d %H:%M:%S", tz = "UTC")
        ) %>%
        filter(!is.na(Datetime)) %>%
        filter(
            !is.na(Open) & !is.na(High) & !is.na(Low) & !is.na(Close),
            !is.infinite(Open) & !is.infinite(High) & !is.infinite(Low) & !is.infinite(Close)
        ) %>%
        select(Datetime, Open, High, Low, Close) %>%
        arrange(Datetime)

    return(df)
}

#' @title Calcula Volatilidade Yang-Zhang
#' @param ohlc Dataframe com colunas Open, High, Low, Close.
#' @param window Tamanho da janela para cálculo.
#' @return Vetor com a volatilidade calculada.
calc_yang_zhang_vol <- function(ohlc, window = 14) {
    open <- ohlc$Open
    high <- ohlc$High
    low <- ohlc$Low
    close <- ohlc$Close

    log_open_close <- log(open / close)
    log_close_open <- log(close / open)
    rs <- (log(high / low))^2

    sigma_oc2 <- runMean(log_open_close^2, n = window)
    sigma_co2 <- runMean(log_close_open^2, n = window)
    sigma_rs2 <- runMean(rs, n = window)

    k <- 0.34 / (1.34 + (window + 1) / (window - 1))
    vol_yz <- sqrt(sigma_oc2 + k * sigma_rs2 + (1 - k) * sigma_co2)

    return(vol_yz)
}
