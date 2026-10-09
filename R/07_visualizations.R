# ============================================
# 07. VISUALIZATIONS
# ============================================

library(tidyverse)

dir.create("output/figures", showWarnings = FALSE, recursive = TRUE)

# ---- Top-20 words ------------------------------------------

word_counts <- read_csv("output/tables/word_frequencies.csv")

p1 <- word_counts %>%
  slice_head(n = 20) %>%
  mutate(word = reorder(word, n)) %>%
  ggplot(aes(x = word, y = n)) +
  geom_col(fill = "steelblue") +
  coord_flip() +
  labs(title = "Top-20 most frequent words",
       x = "Word", y = "Frequency") +
  theme_minimal()

ggsave("output/figures/top20_words.png", p1, width = 8, height = 6, dpi = 300)

# ---- Topic distribution by year ----------------------------

topic_by_year <- read_csv("output/tables/topic_by_year.csv")

p2 <- topic_by_year %>%
  ggplot(aes(x = year, y = percentage,
             color = as.factor(dominant_topic))) +
  geom_line(linewidth = 1) +
  geom_point() +
  labs(title = "Topic distribution by year",
       x = "Year", y = "Percentage", color = "Topic") +
  theme_minimal()

ggsave("output/figures/topics_by_year.png", p2, width = 10, height = 6, dpi = 300)

# ---- Coherence / exclusivity -------------------------------

coherence_df <- read_csv("output/tables/coherence_exclusivity.csv")

p3 <- coherence_df %>%
  pivot_longer(c(Coherence, Exclusivity),
               names_to = "metric", values_to = "value") %>%
  ggplot(aes(x = as.factor(Topic), y = value, fill = metric)) +
  geom_col(position = "dodge") +
  labs(title = "Coherence and exclusivity per topic",
       x = "Topic", y = "Value") +
  theme_minimal()

ggsave("output/figures/coherence_exclusivity.png", p3,
       width = 12, height = 6, dpi = 300)

cat("All figures saved to output/figures/\n")
