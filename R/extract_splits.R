# Extract and clean split times data from PDFs

# Load libraries ---------------------------------------------------------------

library(here)
library(tabulizer)
library(dplyr)
library(stringr)

# Extract tables from PDF ------------------------------------------------------

source_pdf <- here("pdfs/20180914_2018_Worlds_LM1x_Final_A_Splits.pdf")

# Interactively locate table areas to extract
# locate_areas(source_pdf, 1)

extracted_data <- as.data.frame(extract_tables(
  source_pdf, pages = 1, area = list(c(248, 38, 522, 577)),
  guess = FALSE, output = "data.frame"))

# Tidy the data ----------------------------------------------------------------

tidy_data <- extracted_data

# Rename columns
colnames(tidy_data) <- c(
  "rank_final", "lane", "country_code", "seat", "crew_names", "time_500m",
  "rank_500m", "time_1000m", "rank_1000m", "time_1500m", "rank_1500m",
  "time_2000m", "rank_2000m", "dropvar")

# Remove unneeded column
tidy_data <- tidy_data %>%
  select(-dropvar)

# Replace empty strings with NA
tidy_data[tidy_data == ""] <- NA

# Remove parentheses from rank values
tidy_data <- tidy_data %>%
  mutate(
    rank_500m = gsub("\\D", "", rank_500m),
    rank_1000m = gsub("\\D", "", rank_1000m),
    rank_1500m = gsub("\\D", "", rank_1500m),
    rank_2000m = gsub("\\D", "", rank_2000m))

# Wrangle the data -------------------------------------------------------------

# Create row-wise meta-data about type of split time
split_time_type <- c(
  "cumulative", "split",
  rep(c("cumulative", "split", "gap_to_first"),
      times = sum(!is.na(tidy_data$lane)) - 1))

# Create row-wise meta-data about type of split rank
split_rank_type <- c(
  "race", "split",
  rep(c("race", "split", NA),
      times = sum(!is.na(tidy_data$lane)) - 1))

# Add row-wise meta-data into tidy data set
tidy_data <- tidy_data %>%
  mutate(
    split_time_type = split_time_type,
    split_rank_type = split_rank_type) %>%
  select(rank_final, lane, country_code, seat, crew_names, split_time_type,
         split_rank_type, everything()) %>%
  mutate(
    rank_final = zoo::na.locf(rank_final, na.rm = FALSE),
    lane = zoo::na.locf(lane, na.rm = FALSE),
    country_code = zoo::na.locf(country_code, na.rm = FALSE),
    crew_names = zoo::na.locf(crew_names, na.rm = FALSE))

# Subset the data --------------------------------------------------------------

tidy_data_race <- tidy_data %>%
  select(rank_final, lane, country_code, seat, crew_names, split_time_type,
         split_rank_type, time_500m, time_1000m, time_1500m, time_2000m,
         rank_500m, rank_1000m, rank_1500m, rank_2000m) %>%
  filter(split_time_type == "cumulative")

tidy_data_splits <- tidy_data %>%
  select(rank_final, lane, country_code, seat, crew_names, split_time_type,
         split_rank_type, time_500m, time_1000m, time_1500m, time_2000m,
         rank_500m, rank_1000m, rank_1500m, rank_2000m) %>%
  filter(split_time_type != "cumulative")

# ------------------------------------------------------------------------------

# TODO: Create boat-class-specific functions for extracting data from PDFs?