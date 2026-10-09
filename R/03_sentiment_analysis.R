# ============================================
# 03. SENTIMENT ANALYSIS
# ============================================

library(tidyverse)

topics <- read_tsv(
  "data/corpus.csv",
  locale = locale(encoding = "UTF-8", decimal_mark = ",")
)

# ---- Distribution ------------------------------------------

sentiment_dist <- topics %>%
  count(sentiment_eng) %>%
  mutate(percentage = round(n / sum(n) * 100, 1))

write_csv(sentiment_dist, "output/tables/sentiment_distribution.csv")
print(sentiment_dist)

# ---- Manual comparison (if available) ----------------------

if (file.exists("data/manual_annotation.csv")) {
  manual <- read_csv("data/manual_annotation.csv")

  comparison <- topics %>%
    mutate(name = paste0("post_", row_number())) %>%
    select(name, sentiment_eng) %>%
    inner_join(manual, by = "name")

  cm <- table(Predicted = comparison$sentiment_eng,
              Manual    = comparison$manual_label)
  print(cm)

  write_csv(as.data.frame(cm), "output/tables/confusion_matrix.csv")
  cat("Saved: confusion_matrix.csv\n")
} else {
  cat("Skipping manual comparison: data/manual_annotation.csv not found\n")
}
