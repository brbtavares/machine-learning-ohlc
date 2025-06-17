
# machine-learning-ohlc

This repository is an early-stage, modular framework for applying machine learning techniques to OHLCV (Open, High, Low, Close, Volume) financial data. The goal is to create a clean, extensible codebase for experimenting with models, features, and evaluation metrics in quantitative finance.

⚠️ **Note:** This project is in its initial phase. So far, it includes a minimal viable implementation (MVP) with two model prototypes:

- XGBoost (for supervised learning tasks)
- LSTM-CNN hybrid (for sequence modeling)

Contributions and collaboration are highly encouraged — whether for new models, improved feature engineering, documentation, or testing.


## ⚡ Features (Planned + MVP)

- ✅ XGBoost and LSTM-CNN examples
- ⚙️ Modular structure for future models and components
- ⚙️ Placeholder for data preprocessing and feature engineering utilities
- ⚙️ Evaluation pipeline for trading-relevant metrics (to be expanded)

## 🗂 Project Structure

```
.
├── data/               # Example datasets, raw and processed
├── models/             # Current model implementations (MVP: XGBoost, LSTM-CNN)
├── features/           # Feature engineering modules (to be expanded)
├── notebooks/          # Example notebooks demonstrating usage
├── utils/              # Utility functions (e.g., loaders, transformers)
├── tests/              # Unit tests for the modules
├── README.md           # This file
└── requirements.txt    # Project dependencies
```

## 🚀 Getting Started

### Prerequisites

- Python 3.9+
- Recommended to use a virtual environment (e.g. `venv`, `conda`)

### Installation

```bash
git clone https://github.com/brbtavares/machine-learning-ohlc.git
cd machine-learning-ohlc
pip install -r requirements.txt
```

## 📊 Usage

Check the `notebooks/` directory for initial examples. Typical workflow:

1️⃣ Load and preprocess your OHLCV data  
2️⃣ Generate features (planned: technical indicators, rolling stats, etc.)  
3️⃣ Train machine learning models (MVP: XGBoost, LSTM-CNN)  
4️⃣ Evaluate predictions (custom metrics coming soon)  

## 🙌 Invitation to Collaborate

This project is at an early stage and open for contributors. Ideas for improvement include:

- Adding more models (e.g., transformers, random forests, SVM)
- Implementing robust feature engineering modules
- Building evaluation dashboards or backtest integration
- Writing unit tests and CI pipelines
- Enhancing documentation and usage examples

If you're interested, feel free to fork the repo, open an issue, or submit a pull request!

## 📄 License

[MIT License](LICENSE)

---

**Disclaimer**: This project is for research and educational purposes. It is not intended for live trading or investment advice.
