#' @title Treina Modelo XGBoost
#' @param x_train Matriz de treino.
#' @param y_train Labels de treino.
#' @param x_valid Matriz de validação.
#' @param y_valid Labels de validação.
#' @param num_class Número de classes para classificação.
#' @return Modelo treinado.
train_xgboost <- function(x_train, y_train, x_valid, y_valid, num_class = 3) {
    dtrain <- xgb.DMatrix(data = x_train, label = y_train)
    dvalid <- xgb.DMatrix(data = x_valid, label = y_valid)

    model <- xgb.train(
        data = dtrain,
        watchlist = list(train = dtrain, valid = dvalid),
        booster = "gbtree",
        objective = "multi:softprob",
        num_class = num_class,
        eta = 0.1,
        max_depth = 6,
        eval_metric = "merror",
        nrounds = 500,
        early_stopping_rounds = 30
    )
    return(model)
}

#' @title Exporta Modelo XGBoost para ONNX
#' @param model Modelo XGBoost treinado.
#' @param feature_names Nomes das features do modelo.
#' @param output_onnx_path Caminho para salvar o modelo ONNX.
export_xgboost_onnx <- function(model, feature_names, output_onnx_path) {
    library(reticulate)
    onnxmltools <- import("onnxmltools")
    booster <- xgboost::xgb.save.raw(model)
    onnx_model <- onnxmltools$convert_xgboost(booster, initial_types = list(list("input", onnxmltools$FloatTensorType(shape = list(NULL, length(feature_names))))))
    onnxmltools$save_model(onnx_model, output_onnx_path)
}
