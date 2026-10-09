# ============================================
# 01. LOAD AND PREPROCESS CORPUS
# ============================================
# Input:  data/corpus.csv, data/swl.txt
# Output: output/topics.rds, output/topics_words_clean.rds
# ============================================

library(tidyverse)
library(tidytext)
library(stringr)

source("R/00_stopwords.R")

# ---- 1. Load corpus ----------------------------------------

topics <- read_tsv(
  "data/corpus.csv",
  locale = locale(encoding = "UTF-8", decimal_mark = ",")
)

topics <- topics %>%
  mutate(
    date = as.Date(date, format = "%d.%m.%Y"),
    across(
      c(sentiment_score, prob_neutral, prob_positive, prob_negative,
        text_length, word_count),
      ~ as.numeric(gsub(",", ".", .))
    )
  )

cat("Loaded posts:", nrow(topics), "\n")

# ---- 2. Stop words -----------------------------------------

stop_words_final <- load_stopwords("data/swl.txt")
cat("Stop words loaded:", length(stop_words_final), "\n")

# ---- 3. Tokenization ---------------------------------------

topics_words <- topics %>%
  mutate(name = paste0("post_", row_number())) %>%
  select(name, from, date, text_lemmatized) %>%
  unnest_tokens(word, text_lemmatized)

cat("Total tokens:", nrow(topics_words), "\n")

# ---- 4. Remove stop words, numbers, single chars -----------

topics_words_clean <- topics_words %>%
  filter(!word %in% stop_words_final) %>%
  filter(nchar(word) > 1) %>%
  filter(!str_detect(word, "^[0-9]+$"))

cat("After cleaning:", nrow(topics_words_clean), "tokens\n")

# ---- 5. Save -----------------------------------------------

dir.create("output/tables", showWarnings = FALSE, recursive = TRUE)
saveRDS(topics, "output/topics.rds")
saveRDS(topics_words_clean, "output/topics_words_clean.rds")

cat("Saved: output/topics.rds, output/topics_words_clean.rds\n")
