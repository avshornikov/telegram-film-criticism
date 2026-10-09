# ============================================
# 05. STM ESTIMATION (K = 15)
# ============================================

library(stm)
library(tidyverse)

out <- readRDS("output/stm_input.rds")

cat("Documents:", length(out$documents), "\n")
cat("Vocabulary:", length(out$vocab), "\n")

set.seed(123)

stm_model <- stm(
  documents  = out$documents,
  vocab      = out$vocab,
  data       = out$meta,
  prevalence = ~ from,
  K          = 15,
  seed       = 123,
  verbose    = TRUE,
  max.em.its = 75
)

topic_words <- labelTopics(stm_model, c(1:15), n = 10)
print(topic_words)

topics_df <- data.frame(
  topic = 1:15,
  prob  = apply(topic_words$prob,  1, function(x) paste(x, collapse = ", ")),
  frex  = apply(topic_words$frex,  1, function(x) paste(x, collapse = ", ")),
  lift  = apply(topic_words$lift,  1, function(x) paste(x, collapse = ", ")),
  score = apply(topic_words$score, 1, function(x) paste(x, collapse = ", "))
)

write_csv(topics_df, "output/tables/stm_topics.csv")
saveRDS(stm_model, "output/stm_model.rds")

cat("Saved: stm_topics.csv, stm_model.rds\n")
