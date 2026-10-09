# ============================================
# 06. STM POST-ANALYSIS
# ============================================

library(tidyverse)
library(stm)

stm_model <- readRDS("output/stm_model.rds")
out       <- readRDS("output/stm_input.rds")

# ---- Coherence and exclusivity -----------------------------

sem_coherence      <- semanticCoherence(stm_model, out$documents)
exclusivity_scores <- exclusivity(stm_model)

results_df <- data.frame(
  Topic       = 1:15,
  Coherence   = round(sem_coherence, 2),
  Exclusivity = round(exclusivity_scores, 2)
)

write_csv(results_df, "output/tables/coherence_exclusivity.csv")
print(results_df)

cat("Mean coherence:", round(mean(sem_coherence), 2), "\n")
cat("Mean exclusivity:", round(mean(exclusivity_scores), 2), "\n")

# ---- Theta (topic probabilities per document) --------------

theta <- stm_model$theta
colnames(theta) <- paste0("topic_", 1:15)

theta_df <- as.data.frame(theta)
theta_df$name           <- out$meta$name
theta_df$from           <- out$meta$from
theta_df$year           <- out$meta$year
theta_df$dominant_topic <- apply(theta, 1, which.max)

write_csv(theta_df, "output/tables/theta_by_document.csv")

# ---- Macro-themes (15 -> 10) -------------------------------

macro_map <- c(
  "1"  = 1,  "2"  = 2,  "3"  = 3,  "4"  = 4,  "5"  = 2,
  "6"  = 5,  "7"  = 6,  "8"  = 2,  "9"  = 7,  "10" = 8,
  "11" = 6,  "12" = 8,  "13" = 10, "14" = 9,  "15" = 3
)

theta_df$macro_topic <- macro_map[as.character(theta_df$dominant_topic)]

# ---- Topic distribution by channel -------------------------

topic_by_channel <- theta_df %>%
  count(from, dominant_topic) %>%
  group_by(from) %>%
  mutate(percentage = round(n / sum(n) * 100, 2)) %>%
  ungroup()

write_csv(topic_by_channel, "output/tables/topic_by_channel.csv")

# ---- Topic distribution by year ----------------------------

topic_by_year <- theta_df %>%
  count(year, dominant_topic) %>%
  group_by(year) %>%
  mutate(percentage = round(n / sum(n) * 100, 2)) %>%
  ungroup()

write_csv(topic_by_year, "output/tables/topic_by_year.csv")

cat("Saved: coherence_exclusivity.csv, theta_by_document.csv,\n")
cat("       topic_by_channel.csv, topic_by_year.csv\n")
