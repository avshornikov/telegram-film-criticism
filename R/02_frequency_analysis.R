# ============================================
# 02. FREQUENCY ANALYSIS
# ============================================

library(tidyverse)
library(tidytext)

topics_words_clean <- readRDS("output/topics_words_clean.rds")

# ---- Unigrams ----------------------------------------------

word_counts <- topics_words_clean %>%
  count(word, sort = TRUE)

write_csv(word_counts, "output/tables/word_frequencies.csv")
cat("Saved: word_frequencies.csv\n")

# ---- Bigrams -----------------------------------------------

topics_bigrams <- topics_words_clean %>%
  group_by(name) %>%
  summarise(text = paste(word, collapse = " "), .groups = "drop") %>%
  unnest_tokens(bigram, text, token = "ngrams", n = 2)

bigram_counts <- topics_bigrams %>%
  count(bigram, sort = TRUE)

write_csv(bigram_counts, "output/tables/bigram_frequencies.csv")
cat("Saved: bigram_frequencies.csv\n")

# ---- Trigrams ----------------------------------------------

topics_trigrams <- topics_words_clean %>%
  group_by(name) %>%
  summarise(text = paste(word, collapse = " "), .groups = "drop") %>%
  unnest_tokens(trigram, text, token = "ngrams", n = 3)

trigram_counts <- topics_trigrams %>%
  count(trigram, sort = TRUE)

write_csv(trigram_counts, "output/tables/trigram_frequencies.csv")
cat("Saved: trigram_frequencies.csv\n")
