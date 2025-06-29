#' @title Prepara Features para Modelagem
#' @param data Dataframe de entrada com OHLC.
#' @param window_lstm Janela temporal para treinamento LSTM.
#' @return Lista com dados normalizados, matrizes de features e labels.
prepare_features <- function(data, window_lstm = 10) {
    data <- data %>%
        mutate(
            RET_1 = (Close / lag(Close) - 1),
            RET_5 = (Close / lag(Close, 5) - 1),
            RET_15 = (Close / lag(Close, 15) - 1),
            EMA_10 = EMA(Close, 10),
            EMA_50 = EMA(Close, 50),
            RSI_5 = RSI(Close, 5),
            RSI_10 = RSI(Close, 10),
            YangZhangVol_5 = calc_yang_zhang_vol(data, 5)
        ) %>%
        na.omit() %>%
        mutate(
            future_return = (lead(Close) / Close) - 1,
            target = case_when(
                future_return > 0.0002 ~ 1,
                future_return < -0.0002 ~ -1,
                TRUE ~ 0
            )
        ) %>%
        na.omit()

    feature_cols <- c("RET_1", "RET_5", "EMA_10", "RSI_5", "YangZhangVol_5")
    x_lstm <- array(0, dim = c(nrow(data) - window_lstm, window_lstm, length(feature_cols)))
    y_lstm <- vector(mode = "integer", length = nrow(data) - window_lstm)

    for (i in 1:(nrow(data) - window_lstm)) {
        window_rows <- i:(i + window_lstm - 1)
        x_lstm[i, , ] <- as.matrix(data[window_rows, feature_cols])
        y_lstm[i] <- data$target[i + window_lstm]
    }

    list(
        full_data = data,
        x_lstm = x_lstm,
        y_lstm = y_lstm,
        feature_matrix = as.matrix(data[, feature_cols]),
        labels = data$target
    )
}
