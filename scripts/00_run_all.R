# main.R

# Carregar pacotes

# 1. Carregar dados brutos
source("R/carregar_dados.R")
dados_brutos <- carregar_dados("data/raw/meus_dados.csv")

# 2. Limpeza e pré-processamento dos dados
source("R/limpar_dados.R")
dados_limpos <- limpar_dados(dados_brutos)

# 3. Cálculo de indicadores técnicos
source("R/calcular_indicadores.R")
dados_com_indicadores <- calcular_indicadores(dados_limpos)

# 4. Análise e modelagem
source("R/modelar_dados.R")
modelo_final <- modelar_dados(dados_com_indicadores)

# 5. Geração de relatórios e gráficos
source("R/gerar_saidas.R")
gerar_graficos(dados_com_indicadores, "output/figures/")
gerar_relatorio(modelo_final, "output/docs/relatorio_final.html")

# Mensagem de conclusão
message("Análise concluída com sucesso!")