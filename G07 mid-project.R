required_pkgs <- c("readr", "dplyr", "ggplot2", "stringr", "tidyr", "tibble")
to_install <- setdiff(required_pkgs, rownames(installed.packages()))
if (length(to_install)) {
  install.packages(to_install, repos = "https://cloud.r-project.org", dependencies = TRUE)
}

invisible(lapply(required_pkgs, library, character.only = TRUE))
imdb_url <- "https://raw.githubusercontent.com/Nafis-Rohan/imdb-5000-data/refs/heads/main/movie_metadata.csv" 





movies_raw <- read_csv(imdb_url, show_col_types = FALSE)    
head(movies_raw)    
cat("Loaded rows:", nrow(movies_raw), " | columns:", ncol(movies_raw), "\n\n")    
str(movies_raw)    
summary(movies_raw)    
glimpse(movies_raw)    





   
missing_summary <- sapply(movies_raw, function(x) sum(is.na(x)))    
missing_df <- tibble(column = names(missing_summary), n_missing = as.integer(missing_summary))    
print(missing_df)    
dup_idx <- duplicated(movies_raw[c("movie_title", "title_year")])    
cat("\nPossible duplicate rows:", sum(dup_idx), "\n")





   
movies <- movies_raw %>%
  mutate(
    movie_title = str_trim(movie_title),
    budget = na_if(budget, 0),
    gross  = na_if(gross, 0),
    budget_million = budget / 1e6,
    gross_million  = gross  / 1e6,
    primary_genre = str_extract(genres, "^[^|]+")
  )    
cat("Rows after Step 4 (pre-dedup):", nrow(movies), "\n")    





 
n_before <- nrow(movies)    
movies_keydedup <- movies %>%
  distinct(movie_title, title_year, .keep_all = TRUE)    
dup_removed_key <- n_before - nrow(movies_keydedup)    
movies_nodup <- movies_keydedup %>% distinct()    
dup_removed_exact <- nrow(movies_keydedup) - nrow(movies_nodup)    

movies_key <- movies_nodup %>%
  filter(!is.na(imdb_score), !is.na(duration))    

movies_qc <- movies_key %>%
  mutate(
    budget_million_imp = if_else(is.na(budget_million), median(budget_million, na.rm = TRUE), budget_million),
    gross_million_imp = if_else(is.na(gross_million), median(gross_million, na.rm = TRUE), gross_million),
    roi_imp = if_else(!is.na(budget_million_imp) & budget_million_imp > 0, (gross_million_imp - budget_million_imp) / budget_million_imp, NA_real_),
    decade = if_else(!is.na(title_year), paste0(floor(title_year / 10) * 10, "s"), NA_character_)
  )    
n_after <- nrow(movies_qc)    
rows_removed_total <- n_before - n_after    
cat("Key-level duplicates removed:", dup_removed_key, "\n")    
cat("Exact duplicates removed:", dup_removed_exact, "\n")    
cat("Total rows removed:", rows_removed_total, "\n")    
cat("Rows remaining for EDA:", n_after, "\n")   









 
num_cols_clean <- c("imdb_score", "duration", "budget_million_imp", "gross_million_imp", "num_voted_users", "num_critic_for_reviews", "num_user_for_reviews")    
desc_stats_clean <- movies_qc %>%
  select(all_of(num_cols_clean)) %>%
  summarise(
    across(
      everything(),
      list(
        n = ~sum(!is.na(.)),
        mean = ~mean(., na.rm = TRUE),
        median = ~median(., na.rm = TRUE),
        min = ~min(., na.rm = TRUE),
        max = ~max(., na.rm = TRUE)
      ),
      .names = "{.col}__{.fn}"
    )
  ) %>%
  pivot_longer(everything(), names_to = c("variable", ".value"), names_sep = "__")    
print(desc_stats_clean)    







 
outlier_flags <- movies_qc %>%
  select(all_of(num_cols_clean)) %>%
  pivot_longer(everything(), names_to = "variable", values_to = "value") %>%
  group_by(variable) %>%
  mutate(
    Q1 = quantile(value, 0.25, na.rm = TRUE),
    Q3 = quantile(value, 0.75, na.rm = TRUE),
    IQR = Q3 - Q1,
    lower = Q1 - 1.5 * IQR,
    upper = Q3 + 1.5 * IQR,
    is_outlier = if_else(value < lower | value > upper, TRUE, FALSE)
  ) %>%
  filter(is_outlier == TRUE)    
cat("Outlier counts per variable:\n")    
print(outlier_flags %>% count(variable, sort = TRUE))    








 
ggplot(movies_qc, aes(x = imdb_score, fill = ..count..)) +
  geom_histogram(binwidth = 0.5, color = "black") +
  scale_fill_viridis_c() +
  labs(title = "Distribution of IMDB Scores", x = "IMDB score", y = "Count")    

ggplot(movies_qc, aes(x = duration, fill = ..count..)) +
  geom_histogram(binwidth = 10, color = "black") +
  scale_fill_viridis_c() +
  labs(title = "Distribution of Movie Duration", x = "Duration (minutes)", y = "Count")   






ggplot(movies_qc, aes(x = budget_million_imp, y = gross_million_imp, color = gross_million_imp)) +
  geom_point(alpha = 0.6) +
  geom_smooth(method = "lm", se = TRUE, color = "red") +
  scale_color_viridis_c() +
  labs(title = "Budget vs Gross (USD, millions) — Cleaned", x = "Budget (millions, imputed)", y = "Gross (millions, imputed)")    




common_genres <- movies_qc %>%
  filter(!is.na(primary_genre)) %>%
  count(primary_genre, sort = TRUE) %>%
  slice_head(n = 10) %>%
  pull(primary_genre)    

movies_qc %>%
  filter(primary_genre %in% common_genres, !is.na(roi_imp)) %>%
  ggplot(aes(x = primary_genre, y = roi_imp, fill = primary_genre)) +
  geom_boxplot(outlier.alpha = 0.3) +
  coord_flip() +
  scale_fill_viridis_d() +
  labs(title = "ROI by Genre (Top 10 Genres) — Cleaned", x = "Genre", y = "ROI ((Gross−Budget)/Budget, imputed)")    






yearly_scores_clean <- movies_qc %>%
  filter(!is.na(title_year)) %>%
  group_by(title_year) %>%
  summarise(avg_score = mean(imdb_score, na.rm = TRUE), .groups = "drop")    

ggplot(yearly_scores_clean, aes(x = title_year, y = avg_score, color = avg_score)) +
  geom_point(alpha = 0.6) +
  geom_smooth(se = TRUE, color = "red") +
  scale_color_viridis_c() +
  labs(title = "Average IMDB Score by Release Year — Cleaned", x = "Year", y = "Average IMDB score")    

