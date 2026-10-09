# Telegram Film Criticism Corpus

Code for the paper: *A Corpus of Russian-Language Film Criticism on Telegram: Structural Topic Modeling and Sentiment Analysis*.

## Data

The corpus is available at Hugging Face:
https://huggingface.co/datasets/ashornikov/Telegram-Film-Criticism

Download `corpus.csv` and place it in `data/` before running the scripts.

See `data/README.md` for the full description of columns.

## Requirements

R packages: tidyverse, tidytext, readxl, stringr, stm, quanteda, writexl, ggplot2.

Install in R:

    install.packages(c("tidyverse", "tidytext", "readxl", "stringr",
                       "stm", "quanteda", "writexl", "ggplot2"))

## Reproducing the analysis

Run scripts in order:

1. `R/01_load_and_preprocess.R`
2. `R/02_frequency_analysis.R`
3. `R/03_sentiment_analysis.R`
4. `R/04_stm_preparation.R`
5. `R/05_stm_estimation.R`
6. `R/06_stm_postanalysis.R`
7. `R/07_visualizations.R`

## Citation

Shornikov, A. (2026). *A Corpus of Russian-Language Film Criticism on Telegram: Structural Topic Modeling and Sentiment Analysis.*

## License

MIT
