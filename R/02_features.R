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
