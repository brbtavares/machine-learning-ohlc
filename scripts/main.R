#' @title Training Xgboost and CNN-LSTM Models
#' @author Quantbr
#' @description Este script realiza o treinamento de modelos XgBoost e CNN-LSTM para análise de séries temporais OHLC,
#' incluindo etapas como leitura de dados, preparação de features, treinamento, validação e exportação de modelos em formato ONNX.


# Carregando ambiente necessários
use_virtualenv("r-venv-python310", required = TRUE)

# Definindo semente para reprodutibilidade
set.seed(seed)

# Carregando Pacotes Necessários
load_required_packages(required_packages)

# Lendo e Preparando as features
cat("Lendo os dados...\n")
data <- read_data(file_name)
cat("Preparando as features...\n")
prep <- prepare_features(data)

# Treinamento de Modelos
cat("Treinando modelo ...\n")
model <- train(prep$feature_matrix, prep$labels, prep$feature_matrix, prep$labels)

cat("Exportando modelo para ONNX...\n")
export_onnx(model, colnames(prep$feature_matrix), paste0(path_models, "model.onnx"))