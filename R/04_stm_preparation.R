# ============================================
# 04. STM PREPARATION
# ============================================

library(tidyverse)
library(stm)

topics             <- readRDS("output/topics.rds")
topics_words_clean <- readRDS("output/topics_words_clean.rds")

texts_for_stm <- topics_words_clean %>%
  group_by(name) %>%
  summarise(text = paste(word, collapse = " "), .groups = "drop") %>%
  left_join(
    topics %>% mutate(name = paste0("post_", row_number())) %>%
      select(name, from, date),
    by = "name"
  ) %>%
  mutate(
    year = as.numeric(format(date, "%Y")),
    from = as.factor(from)
  ) %>%
  filter(!is.na(year), !is.na(from))

cat("Documents for STM:", nrow(texts_for_stm), "\n")

processed <- textProcessor(
  documents         = texts_for_stm$text,
  metadata          = texts_for_stm[, c("name", "from", "year")],
  wordLengths       = c(2, Inf),
  removestopwords   = FALSE,
  lowercase         = FALSE,
  stem              = FALSE,
  removepunctuation = FALSE,
  removenumbers     = TRUE
)

cat("Vocabulary:", length(processed$vocab), "\n")
cat("Documents:", length(processed$documents), "\n")

out <- prepDocuments(processed$documents, processed$vocab, processed$meta)

valid_meta <- !is.na(out$meta$year) & !is.na(out$meta$from)
out$documents <- out$documents[valid_meta]
out$meta      <- out$meta[valid_meta, ]

cat("After sync:\n")
cat("  Documents:", length(out$documents), "\n")
cat("  meta rows:", nrow(out$meta), "\n")

saveRDS(out, "output/stm_input.rds")
cat("Saved: output/stm_input.rds\n")
