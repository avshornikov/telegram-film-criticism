# Data

## Source

The corpus of Russian-language film criticism on Telegram is publicly
available at Hugging Face:

https://huggingface.co/datasets/ashornikov/Telegram-Film-Criticism

## How to obtain the data

1. Open the Hugging Face link above.
2. Download `corpus.csv`.
3. Place it in `data/corpus.csv`.

## File description

`corpus.csv` contains one row per Telegram post with text (128,613 rows).
Posts without text (135,539 in the raw export) were excluded.

| Column | Description |
|--------|-------------|
| `date` | Publication date (`DD.MM.YYYY`) |
| `from` | Telegram channel name |
| `text` | Original post text (Russian) |
| `text_length` | Number of characters |
| `word_count` | Number of words |
| `sentiment_eng` | RuBERT label (`POSITIVE` / `NEUTRAL` / `NEGATIVE`) |
| `sentiment_ru` | Same label in Russian |
| `sentiment_score` | RuBERT confidence score |
| `prob_neutral` | Probability of `NEUTRAL` |
| `prob_positive` | Probability of `POSITIVE` |
| `prob_negative` | Probability of `NEGATIVE` |
| `text_cleaned` | Text after cleaning |
| `text_lemmatized` | Lemmatized text used for modelling |
